﻿using System;
using System.Collections.Generic;
using System.Text;
using System.IO;
using System.Threading;
using System.Xml;
using NFe.Components;
using NFe.Settings;

namespace NFe.Service
{
    /// <summary>
    /// Classe abstrata para gerar os XML´s da nota fiscal eletrônica
    /// </summary>
    public class GerarXML
    {
        #region Atributos
        /// <summary>
        /// Index da empresa selecionada
        /// </summary>
        protected int EmpIndex { get; set; }
        /// <summary>
        /// Atributo que vai receber a string do XML de lote de NFe´s para que este conteúdo seja gravado após finalizado em arquivo físico no HD
        /// </summary>
        protected string strXMLLoteNfe;
        /// <summary>     
        /// Nome do arquivo para controle da numeração sequencial do lote.
        /// </summary>
        protected string NomeArqXmlLote;
        /// <summary>
        /// Nome do arquivo 1 de backup de segurança do arquivo de controle da numeração sequencial do lote
        /// </summary>
        protected string Bkp1NomeArqXmlLote;
        /// <summary>
        /// Nome do arquivo 2 de backup de segurança do arquivo de controle da numeração sequencial do lote
        /// </summary>
        protected string Bkp2NomeArqXmlLote;
        /// <summary>
        /// Nome do arquivo 3 de backup de segurança do arquivo de controle da numeração sequencial do lote
        /// </summary>
        protected string Bkp3NomeArqXmlLote;
        #endregion

        #region Propriedades
        /// <summary>
        /// Nome do arquivo XML que está sendo enviado para os webservices
        /// </summary>
        public string NomeXMLDadosMsg { get; set; }
        /// <summary>
        /// Serviço que está sendo executado (Envio de NFE, Cancelamento, consultas, etc...)
        /// </summary>
        public Servicos Servico { get; set; }
        /// <summary>
        /// Nome do arquivo XML gerado
        /// </summary>
        public string NomeArqGerado { get; private set; }
        #endregion

        #region Objetos
        protected Auxiliar oAux = new Auxiliar();
        #endregion

        #region Construtures
        public GerarXML(int empIndex)
        {
            EmpIndex = empIndex;
        }
        #endregion

        #region Métodos

        #region Métodos para gerar o Lote de Notas Fiscais Eletrônicas

        #region LoteNfe()
        /// <summary>
        /// Gera o Lote das Notas Fiscais passada por parâmetro na pasta de envio
        /// </summary>
        /// <param name="arquivosNFe">Lista dos XML´s de Notas Fiscais a serem gerados os lotes</param>
        /// <by>Wandrey Mundin Ferreira</by>
        /// <date>15/04/2009</date>
        public void LoteNfe(List<string> arquivosNFe)
        {
            bool excluirFluxo = true;

            try
            {
                //Buscar o número do lote a ser utilizado
                Int32 numeroLote = 0;

                long TamArqLote = 0;
                bool IniciouLote = false;
                int ContaNfe = 0;
                List<string> arquivosInseridoLote = new List<string>();

                for (int i = 0; i < arquivosNFe.Count; i++)
                {
                    //Encerra o lote se o tamanho do arquivo de lote for maior ou igual a 450000 bytes (450 kbytes)
                    if (IniciouLote && TamArqLote >= 450000)
                    {
                        EncerrarLoteNfe(numeroLote);
                        FinalizacaoLote(numeroLote, arquivosInseridoLote);

                        //Limpar as variáveis, atributos depois de totalmente finalizado o lote, pois o conteúdo
                        //de aglumas variáveis são utilizados na finalização.
                        arquivosInseridoLote.Clear();
                        ContaNfe = 0;
                        TamArqLote = 0;
                        IniciouLote = false;
                    }

                    //Iniciar o Lote de NFe
                    if (!IniciouLote)
                    {
                        numeroLote = ProximoNumeroLote();

                        IniciarLoteNfe(numeroLote);

                        IniciouLote = true;
                    }

                    //Inserir o arquivo de XML da NFe na string do lote
                    InserirNFeLote(arquivosNFe[i]);
                    arquivosInseridoLote.Add(arquivosNFe[i]);
                    ContaNfe++;
                    FileInfo oArq = new FileInfo(arquivosNFe[i]);
                    TamArqLote += oArq.Length;

                    //Encerrar o Lote se já passou por todas as notas
                    //Encerrar o lote se já tiver incluido 50 notas (Quantidade máxima permitida pelo SEFAZ)
                    if ((i + 1) == arquivosNFe.Count || ContaNfe == 50)
                    {
                        //Encerra o lote
                        EncerrarLoteNfe(numeroLote);

                        //Se já encerrou o lote não pode mais tirar do fluxo se der erro daqui para baixo
                        excluirFluxo = false;

                        //Finalizar o lote gerando retornos para o ERP.
                        FinalizacaoLote(numeroLote, arquivosInseridoLote);

                        //Limpar as variáveis, atributos depois de totalmente finalizado o lote, pois o conteúdo
                        //de aglumas variáveis são utilizados na finalização.
                        arquivosInseridoLote.Clear();
                        ContaNfe = 0;
                        TamArqLote = 0;
                        IniciouLote = false;
                    }
                }
            }
            catch (Exception ex)
            {
                if (excluirFluxo)
                {
                    for (int i = 0; i < arquivosNFe.Count; i++)
                    {
                        //Efetua a leitura do XML da NFe
                        DadosNFeClass oDadosNfe = this.LerXMLNFe(arquivosNFe[i]);

                        //Excluir a nota fiscal do fluxo pois deu algum erro neste ponto
                        FluxoNfe oFluxoNfe = new FluxoNfe();
                        oFluxoNfe.ExcluirNfeFluxo(oDadosNfe.chavenfe);
                    }
                }

                throw (ex);
            }
        }
        #endregion

        #region FinalizacaoLote()
        /// <summary>
        /// Executa alguns procedimentos para finalizar o processo de montagem de 1 lote de notas
        /// </summary>
        /// <by>Wandrey Mundin Ferreira</by>
        private void FinalizacaoLote(int numeroLote, List<string> arquivosNFe)
        {
            int emp = new FindEmpresaThread(Thread.CurrentThread).Index;

            try
            {
                //Vou atualizar os lotes das NFE´s no fluxo de envio somente depois de encerrado o lote onde eu 
                //tenho certeza que ele foi gerado e que nenhum erro aconteceu, pois desta forma, se falhar somente na 
                //atualização eu tenho como fazer o UniNFe se recuperar de um erro. Assim sendo não mude de ponto.

                FluxoNfe oFluxoNfe = new FluxoNfe();
                for (int i = 0; i < arquivosNFe.Count; i++)
                {
                    //Efetua a leitura do XML, tem que acontecer antes de mover o arquivo
                    DadosNFeClass oDadosNfe = this.LerXMLNFe(arquivosNFe[i]);

                    //Mover o XML da NFE para a pasta de enviados em processamento
                    TFunctions.MoverArquivo(arquivosNFe[i], PastaEnviados.EmProcessamento);

                    //Atualiza o arquivo de controle de fluxo
                    oFluxoNfe.AtualizarTag(oDadosNfe.chavenfe, FluxoNfe.ElementoEditavel.idLote, numeroLote.ToString("000000000000000"));

                    //Gravar o XML de retorno do número do lote para o ERP
                    GravarXMLLoteRetERP(numeroLote, arquivosNFe[i]);
                }

                #region Move o arquivo de lote que a principio foi gerado na pasta temp para a pasta de envio. Wandrey 14/09/2011
                string nomeArqLoteNfe = Empresa.Configuracoes[emp].PastaEnvio + "\\" +
                                        numeroLote.ToString("000000000000000") +
                                        Propriedade.ExtEnvio.EnvLot;

                string nomeArqLoteNfeTemp = Empresa.Configuracoes[emp].PastaEnvio + "\\Temp\\" +
                                            numeroLote.ToString("000000000000000") +
                                            Propriedade.ExtEnvio.EnvLot;

                Functions.Move(nomeArqLoteNfeTemp, nomeArqLoteNfe);
                #endregion
            }
            catch (IOException ex)
            {
                throw (ex);
            }
            catch (Exception ex)
            {
                throw (ex);
            }
        }
        #endregion

        #region LoteNfe() - Sobrecarga
        /// <summary>
        /// Gera lote da nota fiscal eletrônica com somente uma nota fiscal
        /// </summary>
        /// <param name="arquivoNfe">Nome do arquivo XML da Nota Fiscal</param>
        /// <by>Wandrey Mundin Ferreira</by>
        /// <date>15/04/2009</date>
        public void LoteNfe(string arquivoNfe)
        {
            List<string> arquivos = new List<string>();

            arquivos.Add(arquivoNfe);

            try
            {
                LoteNfe(arquivos);
            }
            catch (Exception ex)
            {
                throw (ex);
            }
        }
        #endregion

        #region IniciarLoteNfe()
        /// <summary>
        /// Inicia a string do XML do Lote de notas fiscais
        /// </summary>
        /// <param name="intNumeroLote">Número do lote que será enviado</param>
        /// <by>Wandrey Mundin Ferreira</by>
        /// <date>15/04/2009</date>
        protected void IniciarLoteNfe(Int32 intNumeroLote)
        {
            strXMLLoteNfe = "<?xml version=\"1.0\" encoding=\"UTF-8\"?>";

            switch (Propriedade.TipoAplicativo)
            {
                case TipoAplicativo.Cte:
                    strXMLLoteNfe += "<enviCTe xmlns=\"http://www.portalfiscal.inf.br/cte\" versao=\"" + "1.04" + "\">";
                    break;

                case TipoAplicativo.Nfe:
                    strXMLLoteNfe += "<enviNFe xmlns=\"http://www.portalfiscal.inf.br/nfe\" versao=\"" + "2.00" + "\">";
                    break;

                default:
                    break;
            }

            strXMLLoteNfe += "<idLote>" + intNumeroLote.ToString("000000000000000") + "</idLote>";
        }

        #endregion

        #region InserirNFeLote()
        /// <summary>
        /// Insere o XML de Nota Fiscal passado por parâmetro na string do XML de Lote de NFe
        /// </summary>
        /// <param name="strArquivoNfe">Nome do arquivo XML de nota fiscal eletrônica a ser inserido no lote</param>
        /// <by>Wandrey Mundin Ferreira</by>
        /// <date>15/04/2009</date>
        protected void InserirNFeLote(string strArquivoNfe)
        {
            try
            {
                string vNfeDadosMsg = Functions.XmlToString(strArquivoNfe);

                string tipo = string.Empty;
                switch (Propriedade.TipoAplicativo)
                {
                    case TipoAplicativo.Cte:
                        tipo = "<CTe";
                        break;

                    case TipoAplicativo.Nfe:
                        tipo = "<NFe";
                        break;

                    default:
                        break;
                }

                //Separar somente o conteúdo a partir da tag <NFe> até </NFe>
                Int32 nPosI = vNfeDadosMsg.IndexOf(tipo);
                Int32 nPosF = vNfeDadosMsg.Length - nPosI;
                strXMLLoteNfe += vNfeDadosMsg.Substring(nPosI, nPosF);
            }
            catch (Exception ex)
            {
                throw (ex);
            }
        }
        #endregion

        #region EncerrarLoteNfe()
        /// <summary>
        /// Encerra a string do XML de lote de notas fiscais eletrônicas
        /// </summary>
        /// <param name="intNumeroLote">Número do lote que será enviado</param>
        /// <by>Wandrey Mundin Ferreira</by>
        /// <date>15/04/2009</date>
        protected void EncerrarLoteNfe(Int32 intNumeroLote)
        {
            switch (Propriedade.TipoAplicativo)
            {
                case TipoAplicativo.Cte:
                    strXMLLoteNfe += "</enviCTe>";
                    break;

                case TipoAplicativo.Nfe:
                    strXMLLoteNfe += "</enviNFe>";
                    break;

                default:
                    break;
            }

            try
            {
                GerarXMLLote(intNumeroLote);
            }
            catch (IOException ex)
            {
                throw (ex);
            }
            catch (Exception ex)
            {
                throw (ex);
            }
        }
        #endregion

        #region GerarXMLLote()
        /// <summary>
        /// Grava o XML de lote de notas fiscais eletrônicas fisicamente no HD na pasta de envio
        /// </summary>
        /// <param name="intNumeroLote">Número do lote que será enviado</param>
        /// <date>15/04/2009</date>
        /// <by>Wandrey Mundin Ferreira</by>
        protected void GerarXMLLote(Int32 intNumeroLote)
        {
            int emp = new FindEmpresaThread(Thread.CurrentThread).Index;

            //Gravar o XML do lote das notas fiscais
            string nomeArqLoteNfeTemp = Empresa.Configuracoes[emp].PastaEnvio + "\\Temp\\" +
                                        intNumeroLote.ToString("000000000000000") +
                                        Propriedade.ExtEnvio.EnvLot;

            StreamWriter SW_2 = null;

            try
            {
                SW_2 = File.CreateText(nomeArqLoteNfeTemp);
                SW_2.Write(strXMLLoteNfe);
                SW_2.Close();
            }
            catch (IOException ex)
            {
                throw (ex);
            }
            catch (Exception ex)
            {
                throw (ex);
            }
            finally
            {
                SW_2.Close();
            }
        }
        #endregion

        #region PopulateNomeArqLote()
        /// <summary>
        /// Popular a propriedade do nome do arquivo de controle da numeração do lote
        /// </summary>
        /// <remarks>
        /// Autor: Wandrey Mundin Ferreira
        /// Data: 20/08/2010
        /// </remarks>
        private void PopulateNomeArqLote()
        {
            int emp = new FindEmpresaThread(Thread.CurrentThread).Index;

            NomeArqXmlLote = Empresa.Configuracoes[emp].PastaEmpresa + "\\UniNfeLote.xml";
            Bkp1NomeArqXmlLote = Empresa.Configuracoes[emp].PastaEmpresa + "\\Bkp1_UniNfeLote.xml";
            Bkp2NomeArqXmlLote = Empresa.Configuracoes[emp].PastaEmpresa + "\\Bkp2_UniNfeLote.xml";
            Bkp3NomeArqXmlLote = Empresa.Configuracoes[emp].PastaEmpresa + "\\Bkp3_UniNfeLote.xml";
        }
        #endregion

        #region ProximoNumeroLote()
        /// <summary>
        /// Pega o ultimo número de lote utilizado e acrescenta mais 1 para novo envio
        /// </summary>
        /// <returns>Retorna o um novo número de lote a ser utilizado nos envios das notas fiscais</returns>
        /// <by>Wandrey Mundin Ferreira</by>
        /// <date>15/04/2009</date>
        private Int32 ProximoNumeroLote()
        {
            PopulateNomeArqLote();

            Int32 numeroLote = 1;
            bool deuErro = false;

            DateTime startTime;
            DateTime stopTime;
            TimeSpan elapsedTime;

            long elapsedMillieconds;
            startTime = DateTime.Now;

            while (true)
            {
                stopTime = DateTime.Now;
                elapsedTime = stopTime.Subtract(startTime);
                elapsedMillieconds = (int)elapsedTime.TotalMilliseconds;

                FileStream fsArquivo = null;

                try
                {
                    lock (Smf.NumLote)
                    {
                        //Vou fazer quatro tentativas de leitura do arquivo XML, se falhar, vou tentando restaurar o backup 
                        //do arquivo, pois pode estar com a estrutura do XML danificada. Wandrey 04/10/2011
                        for (int i = 0; i < 4; i++)
                        {
                            if (!File.Exists(NomeArqXmlLote))
                            {
                                SalvarNumeroLoteUtilizado(numeroLote, null);
                                break;
                            }
                            else
                            {
                                XmlDocument xmlNumLote = new XmlDocument();
                                fsArquivo = new FileStream(NomeArqXmlLote, FileMode.Open, FileAccess.ReadWrite, FileShare.Read);

                                try
                                {
                                    xmlNumLote.Load(fsArquivo);
                                    XmlNodeList list = xmlNumLote.GetElementsByTagName("DadosLoteNfe");
                                    XmlElement elem = (XmlElement)(XmlNode)list[0];
                                    numeroLote = Convert.ToInt32(elem.GetElementsByTagName("UltimoLoteEnviado")[0].InnerText) + 1;

                                    //Vou somar uns 3 números para frente para evitar repetir os números.
                                    if (deuErro)
                                        numeroLote += 3;

                                    SalvarNumeroLoteUtilizado(numeroLote, fsArquivo);

                                    break;
                                }
                                catch
                                {
                                    deuErro = true;

                                    fsArquivo.Close();
                                    switch (i)
                                    {
                                        case 0:
                                            if (File.Exists(Bkp1NomeArqXmlLote))
                                                File.Copy(Bkp1NomeArqXmlLote, NomeArqXmlLote, true);
                                            break;

                                        case 1:
                                            if (File.Exists(Bkp2NomeArqXmlLote))
                                                File.Copy(Bkp2NomeArqXmlLote, NomeArqXmlLote, true);
                                            break;

                                        case 2:
                                            if (File.Exists(Bkp3NomeArqXmlLote))
                                                File.Copy(Bkp3NomeArqXmlLote, NomeArqXmlLote, true);
                                            break;

                                        case 3:
                                            throw new Exception("Não foi possível efetuar a leitura do arquivo " + NomeArqXmlLote + ". Verifique se o mesmo não está com sua estrutura de XML danificada."); //Se tentou 4 vezes e deu errado, vamos retornar o erro e não tem o que ser feito.                                            

                                        default:
                                            break;
                                    }
                                }
                                finally
                                {
                                }
                            }
                        }

                        break;
                    }
                }
                catch (Exception ex)
                {
                    if (fsArquivo != null)
                    {
                        fsArquivo.Close();
                    }

                    if (elapsedMillieconds >= 120000) //120.000 ms que corresponde á 120 segundos que corresponde a 2 minuto
                    {
                        throw (ex);
                    }
                }

                Thread.Sleep(1000);
            }

            return numeroLote;
        }
        #endregion

        #region SalvarNumeroLoteUtilizado()
        /// <summary>
        /// Salva em XML o número do ultimo lote utilizado para envio
        /// </summary>
        /// <param name="intNumeroLote">Numero do lote a ser salvo</param>
        /// <by>Wandrey Mundin Ferreira</by>
        /// <date>15/04/2009</date>
        private void SalvarNumeroLoteUtilizado(Int32 intNumeroLote, FileStream fsArq)
        {
            XmlWriterSettings oSettings = new XmlWriterSettings();
            UTF8Encoding c = new UTF8Encoding(false);

            oSettings.Encoding = c;
            oSettings.Indent = true;
            oSettings.IndentChars = "";
            oSettings.NewLineOnAttributes = false;
            oSettings.OmitXmlDeclaration = false;
            XmlWriter oXmlGravar = null;

            try
            {
                if (fsArq != null)
                    fsArq.Close();

                oXmlGravar = XmlWriter.Create(NomeArqXmlLote, oSettings);
                oXmlGravar.WriteStartDocument();
                oXmlGravar.WriteStartElement("DadosLoteNfe");
                oXmlGravar.WriteElementString("UltimoLoteEnviado", intNumeroLote.ToString());
                oXmlGravar.WriteEndElement(); //DadosLoteNfe
                oXmlGravar.WriteEndDocument();
                oXmlGravar.Flush();
                oXmlGravar.Close();

                //Criar 3 copias de segurança deste XML para voltar ele caso de algum problema com o mesmo.
                File.Copy(NomeArqXmlLote, Bkp1NomeArqXmlLote, true);
                File.Copy(NomeArqXmlLote, Bkp2NomeArqXmlLote, true);
                File.Copy(NomeArqXmlLote, Bkp3NomeArqXmlLote, true);
            }
            catch (XmlException ex)
            {
                throw (ex);
            }
            catch (Exception ex)
            {
                throw (ex);
            }
            finally
            {
                //Fechar o arquivo se o mesmo ainda estiver aberto - Wandrey 20/04/2010
                if (oXmlGravar != null)
                    if (oXmlGravar.WriteState != WriteState.Closed)
                        oXmlGravar.Close();
            }
        }
        #endregion

        #region GravarXMLLoteRetERP()
        /// <summary>
        /// Grava um XML com o número de lote utilizado na pasta de retorno para que o ERP possa pegar este número
        /// </summary>
        /// <param name="intNumeroLote">Número do lote a ser gravado no retorno para o ERP</param>
        /// <by>Wandrey Mundin Ferreira</by>
        /// <date>15/04/2009</date>
        private void GravarXMLLoteRetERP(Int32 intNumeroLote, string NomeArquivoXML)
        {
            XmlWriterSettings oSettings = new XmlWriterSettings();
            UTF8Encoding c = new UTF8Encoding(false);

            oSettings.Encoding = c;
            oSettings.Indent = true;
            oSettings.IndentChars = "";
            oSettings.NewLineOnAttributes = false;
            oSettings.OmitXmlDeclaration = false;
            oSettings.Encoding = Encoding.UTF8;
            XmlWriter oXmlLoteERP = null;

            string cArqLoteRetorno = this.NomeArqLoteRetERP(NomeArquivoXML);

            try
            {
                oXmlLoteERP = XmlWriter.Create(cArqLoteRetorno, oSettings);

                oXmlLoteERP.WriteStartDocument();
                oXmlLoteERP.WriteStartElement("DadosLoteNfe");
                oXmlLoteERP.WriteElementString("NumeroLoteGerado", intNumeroLote.ToString());
                oXmlLoteERP.WriteEndElement(); //DadosLoteNfe
                oXmlLoteERP.WriteEndDocument();
                oXmlLoteERP.Flush();
                oXmlLoteERP.Close();
            }
            catch (XmlException ex)
            {
                throw (ex);
            }
            catch (Exception ex)
            {
                throw (ex);
            }
            finally
            {
                //Fechar o arquivo se o mesmo ainda estiver aberto - Wandrey 20/04/2010
                if (oXmlLoteERP != null)
                    if (oXmlLoteERP.WriteState != WriteState.Closed)
                        oXmlLoteERP.Close();
            }
        }
        #endregion

        #endregion

        #region Métodos para gerar o XML´s diversos

        #region Cancelamento()
        /// <summary>
        /// 
        /// </summary>
        /// <param name="pFinalArqEnvio"></param>
        /// <param name="tpAmb"></param>
        /// <param name="tpEmis"></param>
        /// <param name=pcnConstantes.chNFe.ToString()></param>
        /// <param name="nProt"></param>
        /// <param name="xJust"></param>
        public void Cancelamento(string pFinalArqEnvio, int tpAmb, int tpEmis, string chNFe, string nProt, string xJust)
        {
            string tipo = string.Empty;
            switch (Propriedade.TipoAplicativo)
            {
                case TipoAplicativo.Cte:
                    tipo = "CT";
                    break;

                case TipoAplicativo.Nfe:
                    tipo = "NF";
                    break;

                default:
                    break;
            }

            StringBuilder aXML = new StringBuilder();
            aXML.Append("<?xml version=\"1.0\" encoding=\"UTF-8\"?>");
            aXML.Append("<canc" + tipo + "e xmlns=\"" + Propriedade.nsURI + "\" versao=\"" + ConfiguracaoApp.VersaoXMLCanc + "\">");
            aXML.AppendFormat("<infCanc Id=\"ID{0}\">", chNFe);
            aXML.AppendFormat("<tpAmb>{0}</tpAmb>", tpAmb);
            aXML.Append("<xServ>CANCELAR</xServ>");
            aXML.AppendFormat("<ch" + tipo + "e>{0}</ch" + tipo + "e>", chNFe);
            aXML.AppendFormat("<nProt>{0}</nProt>", nProt);
            aXML.AppendFormat("<xJust>{0}</xJust>", xJust);
            aXML.AppendFormat("<tpEmis>{0}</tpEmis>", tpEmis);
            aXML.Append("</infCanc>");
            aXML.Append("</canc" + tipo + "e>");

            try
            {
                GravarArquivoParaEnvio(pFinalArqEnvio, aXML.ToString());
            }
            catch (XmlException ex)
            {
                throw (ex);
            }
            catch (Exception ex)
            {
                throw (ex);
            }
        }
        #endregion

        #region Consulta
        public void Consulta(string pFinalArqEnvio, int tpAmb, int tpEmis, string chNFe)
        {
            string tipo = string.Empty;
            switch (Propriedade.TipoAplicativo)
            {
                case TipoAplicativo.Cte:
                    tipo = "CT";
                    break;

                case TipoAplicativo.Nfe:
                    tipo = "NF";
                    break;

                default:
                    break;
            }

            #region Código temporário
            //TODO Wandrey: Código temporário até que todos os estados tenham o serviço de CCe (Carta de correção eletrônica). Futuramente vou retirar isso
            var versao = ConfiguracaoApp.VersaoXMLPedSit;
            if (ConfiguracaoApp.TemCCe(chNFe.Substring(0, 2), tpAmb, tpEmis))
            {
                versao = "2.01";
            }
            #endregion

            StringBuilder aXML = new StringBuilder();
            aXML.Append("<?xml version=\"1.0\" encoding=\"UTF-8\"?>");
            aXML.Append("<consSit" + tipo + "e xmlns=\"" + Propriedade.nsURI + "\" versao=\"" + versao + "\">");
            aXML.AppendFormat("<tpAmb>{0}</tpAmb>", tpAmb);
            aXML.AppendFormat("<tpEmis>{0}</tpEmis>", tpEmis);  //<<< opcional >>>
            aXML.Append("<xServ>CONSULTAR</xServ>");
            aXML.AppendFormat("<ch" + tipo + "e>{0}</ch" + tipo + "e>", chNFe);
            aXML.Append("</consSit" + tipo + "e>");

            GravarArquivoParaEnvio(pFinalArqEnvio, aXML.ToString());
        }
        #endregion

        #region ConsultaCadastro()
        /// <summary>
        /// Cria um arquivo XML com a estrutura necessária para consultar um cadastro
        /// Voce deve preencher o estado e mais um dos tres itens: CPNJ, IE ou CPF
        /// </summary>
        /// <param name="uf">Sigla do UF do cadastro a ser consultado. Tem que ter duas letras. SU para suframa.</param>
        /// <param name="cnpj"></param>
        /// <param name="ie"></param>
        /// <param name="cpf"></param>
        /// <returns>Retorna o caminho e nome do arquivo criado</returns>
        /// <by>Marcos Diez</by>
        /// <date>29/08/2009</date>
        public string ConsultaCadastro(string pArquivo, string uf, string cnpj, string ie, string cpf)
        {
            int emp = EmpIndex;

            string header = "<?xml version=\"1.0\" encoding=\"UTF-8\" ?>" +
                "<ConsCad xmlns=\"http://www.portalfiscal.inf.br/nfe" +
                "\" versao=\"" + ConfiguracaoApp.VersaoXMLConsCad + "\"><infCons><xServ>CONS-CAD</xServ>";

            cnpj = OnlyNumbers(cnpj);
            ie = OnlyNumbers(ie);
            cpf = OnlyNumbers(cpf);

            StringBuilder saida = new StringBuilder();
            saida.Append(header);
            saida.AppendFormat("<UF>{0}</UF>", uf);
            if (!string.IsNullOrEmpty(cnpj))
            {
                saida.AppendFormat("<CNPJ>{0}</CNPJ>", cnpj);
            }
            else
                if (!string.IsNullOrEmpty(ie))
                {
                    saida.AppendFormat("<IE>{0}</IE>", ie);
                }
                else
                    if (!string.IsNullOrEmpty(cpf))
                    {
                        saida.AppendFormat("<CPF>{0}</CPF>", cpf);
                    }
            saida.Append("</infCons></ConsCad>");

            string _arquivo_saida = (string.IsNullOrEmpty(pArquivo) ? DateTime.Now.ToString("yyyyMMddTHHmmss") + Propriedade.ExtEnvio.ConsCad_XML : pArquivo);

            GravarArquivoParaEnvio(_arquivo_saida, saida.ToString());

            return Empresa.Configuracoes[emp].PastaEnvio + "\\" + _arquivo_saida;
        }

        /// <summary>
        /// retorna uma string contendo apenas os digitos da entrada
        /// </summary>
        /// <by>Marcos Diez</by>
        /// <date>29/08/2009</date>
        private static string OnlyNumbers(string entrada)
        {
            if (string.IsNullOrEmpty(entrada)) return null;
            StringBuilder saida = new StringBuilder(entrada.Length);
            foreach (char c in entrada)
            {
                if (char.IsDigit(c))
                {
                    saida.Append(c);
                }
            }
            return saida.ToString();
        }
        #endregion

        #region Inutilizacao
        public void Inutilizacao(string pFinalArqEnvio, int tpAmb, int tpEmis, int cUF, int ano, string CNPJ, int mod, int serie, int nNFIni, int nNFFin, string xJust)
        {
            string tipo = string.Empty;

            switch (Propriedade.TipoAplicativo)
            {
                case TipoAplicativo.Cte:
                    tipo = "CT";
                    break;
                case TipoAplicativo.Nfe:
                    tipo = "NF";
                    break;
                default:
                    break;
            }

            StringBuilder aXML = new StringBuilder();
            aXML.Append("<?xml version=\"1.0\" encoding=\"UTF-8\" ?>");
            aXML.Append("<inut" + tipo + "e xmlns=\"" + Propriedade.nsURI + "\" versao=\"" + ConfiguracaoApp.VersaoXMLInut + "\">");
            aXML.AppendFormat("<infInut Id=\"ID{0}{1}{2}{3}{4}{5}{6}\">", cUF.ToString("00"), ano.ToString("00"), CNPJ, mod.ToString("00"), serie.ToString("000"), nNFIni.ToString("000000000"), nNFFin.ToString("000000000"));
            aXML.AppendFormat("<tpAmb>{0}</tpAmb>", tpAmb);
            aXML.AppendFormat("<tpEmis>{0}</tpEmis>", tpEmis);
            aXML.Append("<xServ>INUTILIZAR</xServ>");
            aXML.AppendFormat("<cUF>{0}</cUF>", cUF.ToString("00"));
            aXML.AppendFormat("<ano>{0}</ano>", ano.ToString("00"));
            aXML.AppendFormat("<CNPJ>{0}</CNPJ>", CNPJ);
            aXML.AppendFormat("<mod>{0}</mod>", mod.ToString("00"));
            aXML.AppendFormat("<serie>{0}</serie>", serie);
            aXML.AppendFormat("<n" + tipo + "Ini>{0}</n" + tipo + "Ini>", nNFIni);
            aXML.AppendFormat("<n" + tipo + "Fin>{0}</n" + tipo + "Fin>", nNFFin);
            aXML.AppendFormat("<xJust>{0}</xJust>", xJust);
            aXML.Append("</infInut>");
            aXML.Append("</inut" + tipo + "e>");

            GravarArquivoParaEnvio(pFinalArqEnvio, aXML.ToString());
        }
        #endregion

        #region StatusServico() - Sobrecarga
        /// <summary>
        /// 
        /// </summary>
        /// <param name="tpEmis"></param>
        /// <param name="cUF"></param>
        /// <returns></returns>
        public string StatusServico(int tpEmis, int cUF, int amb)
        {
            string _arquivo_saida = DateTime.Now.ToString("yyyyMMddTHHmmss") + Propriedade.ExtEnvio.PedSta_XML;

            this.StatusServico(_arquivo_saida, amb, tpEmis, cUF);

            return _arquivo_saida;
        }
        #endregion

        #region StatusServico() - Sobrecarga
        /// <summary>
        /// Gera o XML de consulta status do serviço da NFe
        /// </summary>
        /// <param name="pArquivo">Caminho e nome do arquivo que é para ser gerado</param>
        /// <param name="tpAmb">Ambiente da consulta</param>
        /// <param name="tpEmis">Tipo de emissão da consulta</param>
        /// <param name="cUF">Estado para a consulta</param>
        public void StatusServico(string pArquivo, int tpAmb, int tpEmis, int cUF)
        {
            string tipo = string.Empty;
            switch (Propriedade.TipoAplicativo)
            {
                case TipoAplicativo.Cte:
                    tipo = "Cte";
                    break;
                case TipoAplicativo.Nfe:
                    tipo = "";
                    break;

                default:
                    break;
            }

            StringBuilder vDadosMsg = new StringBuilder();
            vDadosMsg.Append("<?xml version=\"1.0\" encoding=\"UTF-8\"?>");
            vDadosMsg.Append("<consStatServ" + tipo + " versao=\"" + ConfiguracaoApp.VersaoXMLStatusServico + "\" xmlns=\"" + Propriedade.nsURI + "\">");
            vDadosMsg.AppendFormat("<tpAmb>{0}</tpAmb>", tpAmb);
            vDadosMsg.AppendFormat("<cUF>{0}</cUF>", cUF);
            vDadosMsg.AppendFormat("<tpEmis>{0}</tpEmis>", tpEmis);
            vDadosMsg.Append("<xServ>STATUS</xServ>");
            vDadosMsg.Append("</consStatServ" + tipo + ">");

            try
            {
                GravarArquivoParaEnvio(pArquivo, vDadosMsg.ToString());
            }
            catch (XmlException ex)
            {
                throw (ex);
            }
            catch (Exception ex)
            {
                throw (ex);
            }
        }
        #endregion

        #region ConsultaDPEC
        /// <summary>
        /// ConsultaDPEC
        /// </summary>
        /// <param name="pArquivo"></param>
        /// <param name="dadosConsDPEC"></param>
        public void ConsultaDPEC(string pArquivo, DadosConsDPEC dadosConsDPEC)
        {
            StringBuilder vDadosMsg = new StringBuilder();
            vDadosMsg.Append("<?xml version=\"1.0\" encoding=\"UTF-8\"?>");
            vDadosMsg.Append("<consDPEC versao=\"" + ConfiguracaoApp.VersaoXMLConsDPEC + "\" xmlns=\"" + Propriedade.nsURI + "\">");
            vDadosMsg.AppendFormat("<tpAmb>{0}</tpAmb>", dadosConsDPEC.tpAmb);
            vDadosMsg.AppendFormat("<verAplic>{0}</verAplic>", dadosConsDPEC.verAplic);
            if (!string.IsNullOrEmpty(dadosConsDPEC.chNFe))
                vDadosMsg.AppendFormat("<chNFe>{0}</chNFe>", dadosConsDPEC.chNFe);
            else
                vDadosMsg.AppendFormat("<nRegDPEC>{0}</nRegDPEC>", dadosConsDPEC.nRegDPEC);
            vDadosMsg.Append("</consDPEC>");

            try
            {
                GravarArquivoParaEnvio(pArquivo, vDadosMsg.ToString());
            }
            catch (XmlException ex)
            {
                throw (ex);
            }
            catch (Exception ex)
            {
                throw (ex);
            }
        }
        #endregion

        #region EnvioDPEC
        /// <summary>
        /// EnvioDPEC
        /// </summary>
        /// <param name="pArquivo"></param>
        /// <param name="dadosEnvDPEC"></param>
        public void EnvioDPEC(string pArquivo, DadosEnvDPEC dadosEnvDPEC)
        {
            StringBuilder vDadosMsg = new StringBuilder();
            vDadosMsg.Append("<?xml version=\"1.0\" encoding=\"UTF-8\"?>");
            vDadosMsg.Append("<envDPEC versao=\"" + ConfiguracaoApp.VersaoXMLEnvDPEC + "\" xmlns=\"" + Propriedade.nsURI + "\">");
            vDadosMsg.AppendFormat("<infDPEC Id=\"DPEC{0}\">", dadosEnvDPEC.CNPJ);
            vDadosMsg.Append("<ideDec>");
            vDadosMsg.AppendFormat("<cUF>{0}</cUF>", dadosEnvDPEC.cUF);
            vDadosMsg.AppendFormat("<tpAmb>{0}</tpAmb>", dadosEnvDPEC.tpAmb);
            vDadosMsg.AppendFormat("<verProc>{0}</verProc>", dadosEnvDPEC.verProc);
            vDadosMsg.AppendFormat("<CNPJ>{0}</CNPJ>", dadosEnvDPEC.CNPJ);
            vDadosMsg.AppendFormat("<IE>{0}</IE>", dadosEnvDPEC.IE);
            vDadosMsg.Append("</ideDec>");
            vDadosMsg.Append("<resNFe>");
            vDadosMsg.AppendFormat("<chNFe>{0}</chNFe>", dadosEnvDPEC.chNFe);
            if (dadosEnvDPEC.UF == "EX" || dadosEnvDPEC.CNPJCPF.Length == 0)
                vDadosMsg.Append("<CNPJ />");
            else
                if (dadosEnvDPEC.CNPJCPF.Length == 14)
                    vDadosMsg.AppendFormat("<CNPJ>{0}</CNPJ>", dadosEnvDPEC.CNPJCPF);
                else
                    vDadosMsg.AppendFormat("<CPF>{0}</CPF>", dadosEnvDPEC.CNPJCPF);
            vDadosMsg.AppendFormat("<UF>{0}</UF>", dadosEnvDPEC.UF);
            vDadosMsg.AppendFormat("<vNF>{0}</vNF>", dadosEnvDPEC.vNF);
            vDadosMsg.AppendFormat("<vICMS>{0}</vICMS>", dadosEnvDPEC.vICMS);
            vDadosMsg.AppendFormat("<vST>{0}</vST>", dadosEnvDPEC.vST);
            vDadosMsg.Append("</resNFe>");
            vDadosMsg.Append("</infDPEC>");
            vDadosMsg.Append("</envDPEC>");

            try
            {
                GravarArquivoParaEnvio(pArquivo, vDadosMsg.ToString());
            }
            catch (XmlException ex)
            {
                throw (ex);
            }
            catch (Exception ex)
            {
                throw (ex);
            }
        }
        #endregion

        #region XmlRetorno()
        /// <summary>
        /// Grava o XML com os dados do retorno dos webservices e deleta o XML de solicitação do serviço.
        /// </summary>
        /// <param name="finalArqEnvio">Final do nome do arquivo de solicitação do serviço.</param>
        /// <param name="finalArqRetorno">Final do nome do arquivo que é para ser gravado o retorno.</param>
        /// <param name="conteudoXMLRetorno">Conteúdo do XML a ser gerado</param>
        /// <example>
        /// // Arquivo de envio: 20080619T19113320-ped-sta.xml
        /// // Arquivo de retorno que vai ser gravado: 20080619T19113320-sta.xml
        /// this.GravarXmlRetorno("-ped-sta.xml", "-sta.xml");
        /// </example>
        /// <remarks>
        /// Autor: Wandrey Mundin Ferreira
        /// </remarks>        
        public void XmlRetorno(string finalArqEnvio, string finalArqRetorno, string conteudoXMLRetorno)
        {
            int emp = new FindEmpresaThread(Thread.CurrentThread).Index;

            try
            {
                XmlRetorno(finalArqEnvio, finalArqRetorno, conteudoXMLRetorno, Empresa.Configuracoes[emp].PastaRetorno);
            }
            catch (Exception ex)
            {
                throw (ex);
            }
        }
        #endregion

        #region XmlRetorno()
        /// <summary>
        /// Grava o XML com os dados do retorno dos webservices e deleta o XML de solicitação do serviço.
        /// </summary>
        /// <param name="finalArqEnvio">Final do nome do arquivo de solicitação do serviço.</param>
        /// <param name="finalArqRetorno">Final do nome do arquivo que é para ser gravado o retorno.</param>
        /// <param name="conteudoXMLRetorno">Conteúdo do XML a ser gerado</param>
        /// <param name="pastaGravar">Pasta onde é para ser gravado o XML de Retorno</param>
        /// <example>
        /// // Arquivo de envio: 20080619T19113320-ped-sta.xml
        /// // Arquivo de retorno que vai ser gravado: 20080619T19113320-sta.xml
        /// this.GravarXmlRetorno("-ped-sta.xml", "-sta.xml");
        /// </example>
        /// <remarks>
        /// Autor: Wandrey Mundin Ferreira
        /// Data: 25/11/2010
        /// </remarks>        
        public void XmlRetorno(string finalArqEnvio, string finalArqRetorno, string conteudoXMLRetorno, string pastaGravar)
        {
            int emp = new FindEmpresaThread(Thread.CurrentThread).Index;

            StreamWriter SW = null;

            try
            {
                //Deletar o arquivo XML da pasta de temporários de XML´s com erros se 
                //o mesmo existir
                Functions.DeletarArquivo(Empresa.Configuracoes[emp].PastaErro + "\\" + Functions.ExtrairNomeArq(this.NomeXMLDadosMsg, ".xml") + ".xml");

                //Gravar o arquivo XML de retorno
                string ArqXMLRetorno = pastaGravar + "\\" +
                                       Functions.ExtrairNomeArq(this.NomeXMLDadosMsg, finalArqEnvio) +
                                       finalArqRetorno;
                SW = File.CreateText(ArqXMLRetorno);
                SW.Write(conteudoXMLRetorno);
                SW.Close();
                SW = null;

                //gravar o conteudo no FTP
                if (Empresa.Configuracoes[emp].FTPIsAlive)
                    this.XmlParaFTP(emp, ArqXMLRetorno);
            }
            catch (Exception ex)
            {
                throw (ex);
            }
            finally
            {
                if (SW != null)
                {
                    SW.Close();
                    SW = null;
                }
            }

            //Gravar o XML de retorno também no formato TXT
            if (Empresa.Configuracoes[emp].GravarRetornoTXTNFe)
            {
                try
                {
                    this.TXTRetorno(finalArqEnvio, finalArqRetorno, conteudoXMLRetorno);
                }
                catch (Exception ex)
                {
                    throw (ex);
                }
            }
        }
        #endregion

        #region GravarRetornoEmTXT()
        //TODO: Documentar este método
        protected void TXTRetorno(string pFinalArqEnvio, string pFinalArqRetorno, string ConteudoXMLRetorno)
        {
            if (Propriedade.TipoAplicativo == TipoAplicativo.Cte)
                return;

            int emp = EmpIndex;
            bool temEvento = false;
            string ConteudoRetorno = string.Empty;

            MemoryStream msXml;
            if (Servico == Servicos.PedidoConsultaSituacaoNFe)
                msXml = Functions.StringXmlToStreamUTF8(ConteudoXMLRetorno);
            else
                msXml = Functions.StringXmlToStream(ConteudoXMLRetorno);
            try
            {
                switch (Servico)
                {
                    case Servicos.EnviarLoteNfe:
                        {
                            #region Servicos.EnviarLoteNfe
                            XmlDocument docRec = new XmlDocument();
                            docRec.Load(msXml);

                            XmlNodeList retEnviNFeList = docRec.GetElementsByTagName("retEnviNFe");
                            if (retEnviNFeList != null) //danasa 23-9-2009
                            {
                                if (retEnviNFeList.Count > 0)   //danasa 23-9-2009
                                {
                                    XmlElement retEnviNFeElemento = (XmlElement)retEnviNFeList.Item(0);
                                    if (retEnviNFeElemento != null)   //danasa 23-9-2009
                                    {
                                        ConteudoRetorno += Functions.LerTag(retEnviNFeElemento, "cStat");
                                        ConteudoRetorno += Functions.LerTag(retEnviNFeElemento, "xMotivo");

                                        XmlNodeList infRecList = retEnviNFeElemento.GetElementsByTagName("infRec");
                                        if (infRecList != null)
                                        {
                                            if (infRecList.Count > 0)   //danasa 23-9-2009
                                            {
                                                XmlElement infRecElemento = (XmlElement)infRecList.Item(0);
                                                if (infRecElemento != null)   //danasa 23-9-2009
                                                {
                                                    ConteudoRetorno += Functions.LerTag(infRecElemento, "nRec");
                                                    ConteudoRetorno += Functions.LerTag(infRecElemento, "dhRecbto");
                                                    ConteudoRetorno += Functions.LerTag(infRecElemento, "tMed");
                                                }
                                            }
                                        }
                                    }
                                }
                            }

                            #endregion
                        }
                        break;

                    case Servicos.PedidoSituacaoLoteNFe:
                        {
                            #region Servicos.PedidoSituacaoLoteNFe
                            XmlDocument docProRec = new XmlDocument();
                            docProRec.Load(msXml);

                            XmlNodeList retConsReciNFeList = docProRec.GetElementsByTagName("retConsReciNFe");
                            if (retConsReciNFeList != null) //danasa 23-9-2009
                            {
                                if (retConsReciNFeList.Count > 0)   //danasa 23-9-2009
                                {
                                    XmlElement retConsReciNFeElemento = (XmlElement)retConsReciNFeList.Item(0);
                                    if (retConsReciNFeElemento != null)   //danasa 23-9-2009
                                    {
                                        ConteudoRetorno += Functions.LerTag(retConsReciNFeElemento, "nRec");
                                        ConteudoRetorno += Functions.LerTag(retConsReciNFeElemento, "cStat");
                                        ConteudoRetorno += Functions.LerTag(retConsReciNFeElemento, "xMotivo");
                                        ConteudoRetorno += "\r\n";

                                        XmlNodeList protNFeList = retConsReciNFeElemento.GetElementsByTagName("protNFe");
                                        if (protNFeList != null)    //danasa 23-9-2009
                                        {
                                            if (protNFeList.Count > 0)   //danasa 23-9-2009
                                            {
                                                XmlElement protNFeElemento = (XmlElement)protNFeList.Item(0);
                                                if (protNFeElemento != null)
                                                {
                                                    if (protNFeElemento.ChildNodes.Count > 0)
                                                    {
                                                        XmlNodeList infProtList = protNFeElemento.GetElementsByTagName("infProt");

                                                        foreach (XmlNode infProtNode in infProtList)
                                                        {
                                                            XmlElement infProtElemento = (XmlElement)infProtNode;
                                                            string chNFe = Functions.LerTag(infProtElemento, "chNFe");

                                                            ConteudoRetorno += chNFe.Substring(6, 14) + ";";
                                                            ConteudoRetorno += chNFe.Substring(25, 9) + ";";
                                                            ConteudoRetorno += chNFe;
                                                            ConteudoRetorno += Functions.LerTag(infProtElemento, "dhRecbto");
                                                            ConteudoRetorno += Functions.LerTag(infProtElemento, "nProt");
                                                            ConteudoRetorno += Functions.LerTag(infProtElemento, "digVal");
                                                            ConteudoRetorno += Functions.LerTag(infProtElemento, "cStat");
                                                            ConteudoRetorno += Functions.LerTag(infProtElemento, "xMotivo");
                                                            ConteudoRetorno += "\r\n";
                                                        }
                                                    }
                                                }
                                            }
                                        }
                                    }
                                }
                            }
                            #endregion
                        }
                        break;

                    case Servicos.CancelarNFe:  //danasa 19-9-2009
                        {
                            #region Servicos.CancelarNFe
                            XmlDocument docretCanc = new XmlDocument();
                            docretCanc.Load(msXml);

                            XmlNodeList retCancList = docretCanc.GetElementsByTagName("retCancNFe");
                            if (retCancList != null)
                            {
                                if (retCancList.Count > 0)
                                {
                                    XmlElement retCancElemento = (XmlElement)retCancList.Item(0);
                                    if (retCancElemento != null)
                                    {
                                        if (retCancElemento.ChildNodes.Count > 0)
                                        {
                                            XmlNodeList infCancList = retCancElemento.GetElementsByTagName("infCanc");
                                            if (infCancList != null)
                                            {
                                                foreach (XmlNode infCancNode in infCancList)
                                                {
                                                    XmlElement infCancElemento = (XmlElement)infCancNode;

                                                    ConteudoRetorno += Functions.LerTag(infCancElemento, "tpAmb");
                                                    ConteudoRetorno += Functions.LerTag(infCancElemento, "cStat");
                                                    ConteudoRetorno += Functions.LerTag(infCancElemento, "xMotivo");
                                                    ConteudoRetorno += "\r\n";
                                                }
                                            }
                                        }
                                    }
                                }
                            }
                            #endregion
                        }
                        break;

                    case Servicos.InutilizarNumerosNFe: //danasa 19-9-2009
                        {
                            #region Servicos.InutilizarNumerosNFe
                            XmlDocument docretInut = new XmlDocument();
                            docretInut.Load(msXml);

                            XmlNodeList retInutList = docretInut.GetElementsByTagName("retInutNFe");
                            if (retInutList != null)
                            {
                                if (retInutList.Count > 0)
                                {
                                    XmlElement retInutElemento = (XmlElement)retInutList.Item(0);
                                    if (retInutElemento != null)
                                    {
                                        if (retInutElemento.ChildNodes.Count > 0)
                                        {
                                            XmlNodeList infInutList = retInutElemento.GetElementsByTagName("infInut");
                                            if (infInutList != null)
                                            {
                                                foreach (XmlNode infInutNode in infInutList)
                                                {
                                                    XmlElement infInutElemento = (XmlElement)infInutNode;

                                                    ConteudoRetorno += Functions.LerTag(infInutElemento, "tpAmb");
                                                    ConteudoRetorno += Functions.LerTag(infInutElemento, "cStat");
                                                    ConteudoRetorno += Functions.LerTag(infInutElemento, "xMotivo");
                                                    ConteudoRetorno += Functions.LerTag(infInutElemento, "cUF");
                                                    ConteudoRetorno += "\r\n";
                                                }
                                            }
                                        }
                                    }
                                }
                            }
                            #endregion
                        }
                        break;

                    case Servicos.PedidoConsultaSituacaoNFe:   //danasa 19-9-2009
                        {
                            #region Servicos.PedidoConsultaSituacaoNFe
                            XmlDocument docretConsSit = new XmlDocument();
                            docretConsSit.Load(msXml);

                            XmlNodeList retConsSitList = docretConsSit.GetElementsByTagName("retConsSitNFe");
                            if (retConsSitList != null)
                            {
                                if (retConsSitList.Count > 0)
                                {
                                    XmlElement retConsSitElemento = (XmlElement)retConsSitList.Item(0);
                                    if (retConsSitElemento != null)
                                    {
                                        if (retConsSitElemento.ChildNodes.Count > 0)
                                        {
                                            XmlNodeList infConsSitList = retConsSitElemento.GetElementsByTagName("infProt");
                                            if (infConsSitList != null)
                                            {
                                                foreach (XmlNode infConsSitNode in infConsSitList)
                                                {
                                                    XmlElement infConsSitElemento = (XmlElement)infConsSitNode;

                                                    ConteudoRetorno += Functions.LerTag(infConsSitElemento, "tpAmb");
                                                    ConteudoRetorno += Functions.LerTag(infConsSitElemento, "cStat");
                                                    ConteudoRetorno += Functions.LerTag(infConsSitElemento, "xMotivo");
                                                    ConteudoRetorno += Functions.LerTag(infConsSitElemento, "cUF");
                                                    ConteudoRetorno += Functions.LerTag(infConsSitElemento, "dhRecbto");
                                                    ConteudoRetorno += Functions.LerTag(infConsSitElemento, "nProt");
                                                    ConteudoRetorno += "\r\n";
                                                }
                                            }
                                        }
                                    }
                                }
                            }
                            ///
                            /// grava os eventos
                            /// 
                            XmlNodeList retprocEventoNFeList = docretConsSit.GetElementsByTagName("procEventoNFe");
                            if (retprocEventoNFeList != null)
                            {
                                foreach (XmlNode retConsSitNode1 in retprocEventoNFeList)
                                {
                                    foreach (XmlNode retConsSitNode2 in retConsSitNode1.ChildNodes)
                                    {
                                        if (((XmlElement)retConsSitNode2).Name == "evento" ||
                                            ((XmlElement)retConsSitNode2).Name == "retEvento")
                                        {
                                            foreach (XmlNode retConsSitNode3 in retConsSitNode2.ChildNodes)
                                            {
                                                if (((XmlElement)retConsSitNode3).Name == "infEvento")
                                                {
                                                    string cRetorno = "";
                                                    foreach (XmlNode retConsSitNode4 in retConsSitNode3.ChildNodes)
                                                    {
                                                        switch (((XmlElement)retConsSitNode4).Name)
                                                        {
                                                            case "detEvento":
                                                                foreach (XmlNode retConsSitNode5 in retConsSitNode4.ChildNodes)
                                                                {
                                                                    switch (((XmlElement)retConsSitNode5).Name)
                                                                    {
                                                                        //case "descEvento":
                                                                        case "xCondUso":
                                                                            break;
                                                                        default:
                                                                            cRetorno += Functions.LerTag((XmlElement)retConsSitNode4, ((XmlElement)retConsSitNode5).Name);
                                                                            break;
                                                                    }
                                                                }
                                                                break;
                                                            default:
                                                                cRetorno += Functions.LerTag((XmlElement)retConsSitNode3, ((XmlElement)retConsSitNode4).Name);
                                                                break;
                                                        }
                                                    }
                                                    if (cRetorno != "")
                                                    {
                                                        ConteudoRetorno += "[" + ((XmlElement)retConsSitNode2).Name + "]\r\n";
                                                        ConteudoRetorno += cRetorno + "\r\n";
                                                        temEvento = true;
                                                    }
                                                }
                                            }
                                        }
                                    }
                                }
                            }
                            #endregion
                        }
                        break;

                    case Servicos.PedidoConsultaStatusServicoNFe:   //danasa 19-9-2009
                        {
                            #region Servicos.PedidoConsultaStatusServicoNFe
                            XmlDocument docConsStat = new XmlDocument();
                            docConsStat.Load(msXml);

                            XmlNodeList retConsStatServList = docConsStat.GetElementsByTagName("retConsStatServ");
                            if (retConsStatServList != null)
                            {
                                if (retConsStatServList.Count > 0)
                                {
                                    XmlElement retConsStatServElemento = (XmlElement)retConsStatServList.Item(0);
                                    if (retConsStatServElemento != null)
                                    {
                                        ConteudoRetorno += Functions.LerTag(retConsStatServElemento, "tpAmb");
                                        ConteudoRetorno += Functions.LerTag(retConsStatServElemento, "cStat");
                                        ConteudoRetorno += Functions.LerTag(retConsStatServElemento, "xMotivo");
                                        ConteudoRetorno += Functions.LerTag(retConsStatServElemento, "cUF");
                                        ConteudoRetorno += Functions.LerTag(retConsStatServElemento, "dhRecbto");
                                        ConteudoRetorno += Functions.LerTag(retConsStatServElemento, "tMed");
                                        ConteudoRetorno += "\r\n";
                                    }
                                }
                            }
                            #endregion
                        }
                        break;

                    case Servicos.ConsultaCadastroContribuinte: //danasa 19-9-2009
                        {
                            #region Servicos.ConsultaCadastroContribuinte
                            ///
                            /// Retorna o texto conforme o manual do Sefaz versao 3.0
                            /// 
                            RetConsCad rconscad = ProcessaConsultaCadastro(msXml);
                            if (rconscad != null)
                            {
                                ConteudoRetorno = rconscad.cStat.ToString("000") + ";";
                                ConteudoRetorno += rconscad.xMotivo.Replace(";", " ") + ";";
                                ConteudoRetorno += rconscad.UF + ";";
                                ConteudoRetorno += rconscad.IE + ";";
                                ConteudoRetorno += rconscad.CNPJ + ";";
                                ConteudoRetorno += rconscad.CPF + ";";
                                ConteudoRetorno += rconscad.dhCons + ";";
                                ConteudoRetorno += rconscad.cUF.ToString("00") + ";";
                                ConteudoRetorno += "\r\r";
                                foreach (infCad infCadNode in rconscad.infCad)
                                {
                                    ConteudoRetorno += infCadNode.IE + ";";
                                    ConteudoRetorno += infCadNode.CNPJ + ";";
                                    ConteudoRetorno += infCadNode.CPF + ";";
                                    ConteudoRetorno += infCadNode.UF + ";";
                                    ConteudoRetorno += infCadNode.cSit + ";";
                                    ConteudoRetorno += infCadNode.xNome.Replace(";", " ") + ";";
                                    ConteudoRetorno += infCadNode.xFant.Replace(";", " ") + ";";
                                    ConteudoRetorno += infCadNode.xRegApur.Replace(";", " ") + ";";
                                    ConteudoRetorno += infCadNode.CNAE.ToString() + ";";
                                    ConteudoRetorno += infCadNode.dIniAtiv + ";";
                                    ConteudoRetorno += infCadNode.dUltSit + ";";
                                    ConteudoRetorno += infCadNode.IEUnica.Replace(";", " ") + ";";
                                    ConteudoRetorno += infCadNode.IEAtual.Replace(";", " ") + ";";
                                    ConteudoRetorno += infCadNode.ender.xLgr.Replace(";", " ") + ";";
                                    ConteudoRetorno += infCadNode.ender.nro.Replace(";", " ") + ";";
                                    ConteudoRetorno += infCadNode.ender.xCpl.Replace(";", " ") + ";";
                                    ConteudoRetorno += infCadNode.ender.xBairro.Replace(";", " ") + ";";
                                    ConteudoRetorno += infCadNode.ender.cMun.ToString("0000000") + ";";
                                    ConteudoRetorno += infCadNode.ender.xMun.Replace(";", " ") + ";";
                                    ConteudoRetorno += infCadNode.ender.CEP.ToString("00000000") + ";";
                                    ConteudoRetorno += "\r\r";
                                }
                            }
                            #endregion
                        }
                        break;

                    case Servicos.ConsultaInformacoesUniNFe:
                        break;

                    case Servicos.ConsultaNFDest:
                        /*
                        <retConsNFeDest versao="1.01">
                            <tpAmb>2</tpAmb>
                            <verAplic>1.0.0</verAplic>
                            <cStat>137</cStat>
                            <xMotivo>Nenhum documento localizado para o destinatario</xMotivo>
                            <dhResp>2012-07-10T09:59:24</dhResp>
                            <indCont>1</indCont>
                            <ultNSU>102668467</ultNSU>
                            <ret>   0..50
                                <resNFe>
                                </resNFe>
                                <resCanc>
                                </resCanc>
                                <resCCe>
                                </resCCe>
                            </ret>
                        </retConsNFeDest>              
                         */
                        {
                            #region Servicos.ConsultaNFDest
                            XmlDocument docretConsNFe = new XmlDocument();
                            docretConsNFe.Load(msXml);

                            XmlNodeList retConsNFeDestList = docretConsNFe.GetElementsByTagName("retConsNFeDest");
                            if (retConsNFeDestList != null)
                            {
                                if (retConsNFeDestList.Count > 0)
                                {
                                    XmlElement ret1 = (XmlElement)retConsNFeDestList.Item(0);
                                    ConteudoRetorno += Functions.LerTag(ret1, "tpAmb");
                                    ConteudoRetorno += Functions.LerTag(ret1, "verAplic");
                                    ConteudoRetorno += Functions.LerTag(ret1, "cStat");
                                    ConteudoRetorno += Functions.LerTag(ret1, "xMotivo");
                                    ConteudoRetorno += Functions.LerTag(ret1, "indCont");
                                    ConteudoRetorno += Functions.LerTag(ret1, "ultNSU");
                                    ConteudoRetorno += "\r\n";

                                    XmlNodeList retList = ret1.GetElementsByTagName("ret");
                                    foreach (XmlNode infretNode in retList)
                                    {
                                        foreach (XmlNode infresNFeNode in ((XmlElement)infretNode).GetElementsByTagName("resNFe"))
                                        {
                                            ConteudoRetorno += "resNFe,";
                                            ConteudoRetorno += Functions.LerTag((XmlElement)infresNFeNode, "NSU");
                                            ConteudoRetorno += Functions.LerTag((XmlElement)infresNFeNode, "chNFe");
                                            string FCNPJCPF = Functions.LerTag((XmlElement)infresNFeNode, "CNPJ", false);
                                            if (string.IsNullOrEmpty(FCNPJCPF)) FCNPJCPF = Functions.LerTag((XmlElement)infresNFeNode, "CPF", false);
                                            ConteudoRetorno += FCNPJCPF + ",";
                                            ConteudoRetorno += Functions.LerTag((XmlElement)infresNFeNode, "xNome");
                                            ConteudoRetorno += Functions.LerTag((XmlElement)infresNFeNode, "IE");
                                            ConteudoRetorno += Functions.LerTag((XmlElement)infresNFeNode, "dEmi");
                                            ConteudoRetorno += Functions.LerTag((XmlElement)infresNFeNode, "tpNF");
                                            ConteudoRetorno += Functions.LerTag((XmlElement)infresNFeNode, "vNF");
                                            //ConteudoRetorno += Functions.LerTag((XmlElement)infresNFeNode, "digVal");
                                            ConteudoRetorno += Functions.LerTag((XmlElement)infresNFeNode, "dhRecbto");
                                            ConteudoRetorno += Functions.LerTag((XmlElement)infresNFeNode, "cSitNFe");
                                            ConteudoRetorno += Functions.LerTag((XmlElement)infresNFeNode, "cSitConf");
                                            ConteudoRetorno += "\r\n";
                                        }
                                        foreach (XmlNode infresCancNode in ((XmlElement)infretNode).GetElementsByTagName("resCanc"))
                                        {
                                            ConteudoRetorno += "resCanc,";
                                            ConteudoRetorno += Functions.LerTag((XmlElement)infresCancNode, "NSU");
                                            ConteudoRetorno += Functions.LerTag((XmlElement)infresCancNode, "chNFe");
                                            string FCNPJCPF = Functions.LerTag((XmlElement)infresCancNode, "CNPJ", false);
                                            if (string.IsNullOrEmpty(FCNPJCPF)) FCNPJCPF = Functions.LerTag((XmlElement)infresCancNode, "CPF", false);
                                            ConteudoRetorno += FCNPJCPF + ",";
                                            ConteudoRetorno += Functions.LerTag((XmlElement)infresCancNode, "xNome");
                                            ConteudoRetorno += Functions.LerTag((XmlElement)infresCancNode, "IE");
                                            ConteudoRetorno += Functions.LerTag((XmlElement)infresCancNode, "dEmi");
                                            ConteudoRetorno += Functions.LerTag((XmlElement)infresCancNode, "tpNF");
                                            ConteudoRetorno += Functions.LerTag((XmlElement)infresCancNode, "vNF");
                                            //ConteudoRetorno += Functions.LerTag((XmlElement)infresCancNode, "digVal");
                                            ConteudoRetorno += Functions.LerTag((XmlElement)infresCancNode, "dhRecbto");
                                            ConteudoRetorno += Functions.LerTag((XmlElement)infresCancNode, "cSitNFe");
                                            ConteudoRetorno += Functions.LerTag((XmlElement)infresCancNode, "cSitConf");
                                            ConteudoRetorno += "\r\n";
                                        }
                                        foreach (XmlNode infresCCeNode in ((XmlElement)infretNode).GetElementsByTagName("resCCe"))
                                        {
                                            ConteudoRetorno += "resCCe,";
                                            ConteudoRetorno += Functions.LerTag((XmlElement)infresCCeNode, "dhRecbto");
                                            ConteudoRetorno += Functions.LerTag((XmlElement)infresCCeNode, "tpNF");
                                            ConteudoRetorno += Functions.LerTag((XmlElement)infresCCeNode, "chNFe");
                                            ConteudoRetorno += Functions.LerTag((XmlElement)infresCCeNode, "dhEvento");
                                            ConteudoRetorno += Functions.LerTag((XmlElement)infresCCeNode, "xCorrecao");
                                            ConteudoRetorno += Functions.LerTag((XmlElement)infresCCeNode, "tpEvento");
                                            ConteudoRetorno += Functions.LerTag((XmlElement)infresCCeNode, "descEvento");
                                            ConteudoRetorno += Functions.LerTag((XmlElement)infresCCeNode, "NSU");
                                            ConteudoRetorno += Functions.LerTag((XmlElement)infresCCeNode, "nSeqEvento");
                                            ConteudoRetorno += "\r\n";
                                        }
                                    }
                                }
                            }

                            #endregion
                        }
                        break;

                    case Servicos.DownloadNFe:
                        /*
                        <retDownloadNFe versao="1.00" xmlns="http://www.portalfiscal.inf.br/nfe">
                            <tpAmb>2</tpAmb>
                            <verAplic>XX_v123</verAplic>
                            <cStat>139</cStat>
                            <xMotivo>Pedido de download Processado</xMotivo>
                            <dhResp>2011-11-24T10:02:46</dhResp>
                            <retNFe>
                                <chNFe>12345678901234567890123456789012345678901234</chNFe>
                                <cStat>632</cStat>
                                <xMotivo>Rejeição: Solicitação fora de prazo, a NF-e não está mais disponível para download</xMotivo>
                            </retNFe>
                            <retNFe>
                                <chNFe>12345678901234567890123456789012345678901245</chNFe>
                                <cStat>140</cStat>
                                <xMotivo>Download disponibilizado</xMotivo>
                                <procNFeZip > (xml da procNFe compactado no padrão gZip com representação base64binary) </procNFeZip >
                            </retNFe>
                            <retNFe>
                                <chNFe>12345678901234567890123456789012345678901256</chNFe>
                                <cStat>140</cStat>
                                <xMotivo>Download disponibilizado</xMotivo>
                                <procNFeZip> (xml da procNFe compactado no padrão gZip com representação base64binary) </procNFeZip >
                            </retNFe>
                        </retDownloadNFe>
                         */
                        {
                            #region Servicos.DownloadNFe
                            XmlDocument docretDownload = new XmlDocument();
                            docretDownload.Load(msXml);

                            XmlNodeList retDownLoadList = docretDownload.GetElementsByTagName("retDownloadNFe");

                            if (retDownLoadList != null)
                            {
                                if (retDownLoadList.Count > 0)
                                {
                                    XmlElement retElemento = (XmlElement)retDownLoadList.Item(0);
                                    ConteudoRetorno += Functions.LerTag(retElemento, "tpAmb");
                                    ConteudoRetorno += Functions.LerTag(retElemento, "verAplic");
                                    ConteudoRetorno += Functions.LerTag(retElemento, "cStat");
                                    ConteudoRetorno += Functions.LerTag(retElemento, "xMotivo");
                                    ConteudoRetorno += Functions.LerTag(retElemento, "dhResp");
                                    ConteudoRetorno += "\r\n";

                                    foreach (XmlNode infretNFe in retElemento.ChildNodes)
                                    {
                                        XmlElement infElemento = (XmlElement)infretNFe;

                                        ConteudoRetorno += Functions.LerTag(infElemento, "chNFe");
                                        ConteudoRetorno += Functions.LerTag(infElemento, "cStat");
                                        ConteudoRetorno += Functions.LerTag(infElemento, "xMotivo");
                                        ConteudoRetorno += "\r\n";
                                    }
                                }
                            }
                            #endregion
                        }
                        break;

                    case Servicos.EnviarEventoCancelamento:
                    case Servicos.EnviarManifDest:
                    case Servicos.EnviarCCe:    //danasa 2/7/2011
                        //<retEnvEvento versao="1.00" xmlns="http://www.portalfiscal.inf.br/nfe">
                        //  <idLote>000000000038313</idLote>
                        //  <tpAmb>2</tpAmb>
                        //  <verAplic>SP_EVENTOS_PL_100</verAplic>
                        //  <cOrgao>35</cOrgao>
                        //  <cStat>128</cStat>
                        //  <xMotivo>Lote de Evento Processado</xMotivo>
                        //  <retEvento versao="1.00">
                        //      <infEvento>
                        //          <tpAmb>2</tpAmb>
                        //          <verAplic>SP_EVENTOS_PL_100</verAplic>
                        //          <cOrgao>35</cOrgao>
                        //          <cStat>494</cStat>
                        //          <xMotivo>Rejeição: Chave de Acesso inexistente para o tpEvento que exige a existência da NF-e</xMotivo>
                        //          <chNFe>35100610238568000107550010000051260000038315</chNFe>
                        //          <dhRegEvento>2011-07-02T02:44:51-03:00</dhRegEvento>
                        //      </infEvento>
                        //  </retEvento>
                        //</retEnvEvento>
                        {
                            #region Servicos.EnviarCCe
                            XmlDocument docretEnvCCe = new XmlDocument();
                            docretEnvCCe.Load(msXml);

                            XmlNodeList retCCeList = docretEnvCCe.GetElementsByTagName("retEnvEvento");
                            if (retCCeList != null)
                            {
                                if (retCCeList.Count > 0)
                                {
                                    XmlElement retCCeElemento = (XmlElement)retCCeList.Item(0);
                                    if (retCCeElemento != null)
                                    {
                                        if (retCCeElemento.ChildNodes.Count > 0)
                                        {
                                            XmlNodeList infCCeList = retCCeElemento.GetElementsByTagName("retEvento");
                                            if (infCCeList != null)
                                            {
                                                foreach (XmlNode infCCeNode in infCCeList)
                                                {
                                                    foreach (XmlNode infCCeNode2 in infCCeNode.ChildNodes)
                                                    {
                                                        XmlElement infCCeElemento = (XmlElement)infCCeNode2;

                                                        ConteudoRetorno += Functions.LerTag(infCCeElemento, "tpAmb");
                                                        ConteudoRetorno += Functions.LerTag(infCCeElemento, "cOrgao");
                                                        ConteudoRetorno += Functions.LerTag(infCCeElemento, "cStat");
                                                        ConteudoRetorno += Functions.LerTag(infCCeElemento, "xMotivo");
                                                        ConteudoRetorno += Functions.LerTag(infCCeElemento, "chNFe");
                                                        ConteudoRetorno += Functions.LerTag(infCCeElemento, "tpEvento");
                                                        ConteudoRetorno += Functions.LerTag(infCCeElemento, "xEvento");
                                                        ConteudoRetorno += Functions.LerTag(infCCeElemento, "nSeqEvento");
                                                        string FCNPJCPF = Functions.LerTag((XmlElement)infCCeElemento, "CNPJDest", false);
                                                        if (string.IsNullOrEmpty(FCNPJCPF)) FCNPJCPF = Functions.LerTag((XmlElement)infCCeElemento, "CPFDest", false);
                                                        ConteudoRetorno += FCNPJCPF + ",";
                                                        ConteudoRetorno += Functions.LerTag(infCCeElemento, "dhRegEvento");
                                                        ConteudoRetorno += Functions.LerTag(infCCeElemento, "nProt");
                                                        ConteudoRetorno += "\r\n";
                                                    }
                                                }
                                            }
                                        }
                                    }
                                }
                            }
                            #endregion
                        }
                        break;
                }
                //Gravar o TXT de retorno para o ERP
                if (!string.IsNullOrEmpty(ConteudoRetorno))
                {
                    string TXTRetorno = string.Empty;
                    TXTRetorno = Functions/*oAux*/.ExtrairNomeArq(this.NomeXMLDadosMsg, pFinalArqEnvio) + pFinalArqRetorno;
                    TXTRetorno = Empresa.Configuracoes[emp].PastaRetorno + "\\" + Functions/*oAux*/.ExtrairNomeArq(TXTRetorno, ".xml") + ".txt";

                    if (Servico == Servicos.PedidoConsultaSituacaoNFe && temEvento)
                        File.WriteAllText(TXTRetorno, ConteudoRetorno, Encoding.UTF8);
                    else
                        File.WriteAllText(TXTRetorno, ConteudoRetorno, Encoding.Default);

                    //
                    //gravar o conteudo no FTP
                    this.XmlParaFTP(emp, TXTRetorno);
                }
            }
            catch (Exception ex)
            {
                throw (ex);
            }
        }
        #endregion

        #endregion

        #region Métodos para gerar os XML´s de distribuição

        #region XMLDistInut()
        /// <summary>
        /// Criar o arquivo XML de distribuição das Inutilizações de Números de NFe´s com o protocolo de autorização anexado
        /// </summary>
        /// <param name="strArqInut">Nome arquivo XML de Inutilização</param>
        /// <param name="strProtNfe">String contendo a parte do XML do protocolo a ser anexado</param>
        /// <by>Wandrey Mundin Ferreira</by>
        /// <date>21/04/2009</date>
        public void XmlDistInut(string strArqInut, string strRetInutNFe)
        {
            string tipo = string.Empty;
            switch (Propriedade.TipoAplicativo)
            {
                case TipoAplicativo.Cte:
                    tipo = "CT";
                    break;

                case TipoAplicativo.Nfe:
                    tipo = "NF";
                    break;

                default:
                    break;
            }

            int emp = EmpIndex;
            StreamWriter swProc = null;

            try
            {
                //Separar as tag´s da NFe que interessa <NFe> até </NFe>
                XmlDocument doc = new XmlDocument();

                doc.Load(strArqInut);

                XmlNodeList InutNFeList = doc.GetElementsByTagName("inut" + tipo + "e");
                XmlNode InutNFeNode = InutNFeList[0];
                string strInutNFe = InutNFeNode.OuterXml;

                //Montar o XML -procCancNFe.xml
                string strXmlProcInutNfe = "<?xml version=\"1.0\" encoding=\"UTF-8\" ?>" +
                    "<procInut" + tipo + "e xmlns=\"" + Propriedade.nsURI + "\" versao=\"" + ConfiguracaoApp.VersaoXMLInut + "\">" +
                    strInutNFe +
                    strRetInutNFe +
                    "</procInut" + tipo + "e>";

                //Montar o nome do arquivo -proc-NFe.xml
                string strNomeArqProcInutNFe = Empresa.Configuracoes[emp].PastaEnviado + "\\" +
                                               PastaEnviados.EmProcessamento.ToString() + "\\" +
                                               Functions/*oAux*/.ExtrairNomeArq(strArqInut, Propriedade.ExtEnvio.PedInu_XML) +
                                               Propriedade.ExtRetorno.ProcInutNFe;

                //Gravar o XML em uma linha só (sem quebrar as tag's linha a linha) ou dá erro na hora de validar o XML pelos Schemas. Wandrey 13/05/2009
                swProc = File.CreateText(strNomeArqProcInutNFe);
                swProc.Write(strXmlProcInutNfe);

                this.XmlParaFTP(emp, strNomeArqProcInutNFe);
            }
            catch (Exception ex)
            {
                throw (ex);
            }
            finally
            {
                if (swProc != null)
                {
                    swProc.Close();
                }
            }
        }
        #endregion

        #region XMLDistCanc()
        /// <summary>
        /// Criar o arquivo XML de distribuição dos Cancelamentos com o protocolo de autorização anexado
        /// </summary>
        /// <param name="strArqCanc">Nome arquivo XML de Cancelamento</param>
        /// <param name="strProtNfe">String contendo a parte do XML do protocolo a ser anexado</param>
        /// <by>Wandrey Mundin Ferreira</by>
        /// <date>21/04/2009</date>
        public void XmlDistCanc(string strArqCanc, string strRetCancNFe)
        {
            string tipo = string.Empty;
            switch (Propriedade.TipoAplicativo)
            {
                case TipoAplicativo.Cte:
                    tipo = "CT";
                    break;

                case TipoAplicativo.Nfe:
                    tipo = "NF";
                    break;

                default:
                    break;
            }

            int emp = EmpIndex;
            StreamWriter swProc = null;

            try
            {
                //Separar as tag´s da NFe que interessa <NFe> até </NFe>
                XmlDocument doc = new XmlDocument();

                doc.Load(strArqCanc);

                XmlNodeList CancNFeList = doc.GetElementsByTagName("canc" + tipo + "e");
                XmlNode CancNFeNode = CancNFeList[0];
                string strCancNFe = CancNFeNode.OuterXml;

                //Montar o XML -procCancNFe.xml
                string strXmlProcCancNfe = "<?xml version=\"1.0\" encoding=\"UTF-8\" ?>" +
                    "<procCanc" + tipo + "e xmlns=\"" + Propriedade.nsURI + "\" versao=\"" + ConfiguracaoApp.VersaoXMLCanc + "\">" +
                    strCancNFe +
                    strRetCancNFe +
                    "</procCanc" + tipo + "e>";

                //Montar o nome do arquivo -proc-NFe.xml
                string strNomeArqProcCancNFe = Empresa.Configuracoes[emp].PastaEnviado + "\\" +
                                                PastaEnviados.EmProcessamento.ToString() + "\\" +
                                                Functions.ExtrairNomeArq(strArqCanc, Propriedade.ExtEnvio.PedCan_XML) +
                                                Propriedade.ExtRetorno.ProcCancNFe;

                //Gravar o XML em uma linha só (sem quebrar as tag's linha a linha) ou dá erro na hora de validar o XML pelos Schemas. Wandrey 13/05/2009
                swProc = File.CreateText(strNomeArqProcCancNFe);
                swProc.Write(strXmlProcCancNfe);
            }
            catch (Exception ex)
            {
                throw (ex);
            }
            finally
            {
                if (swProc != null)
                {
                    swProc.Close();
                }
            }
        }
        #endregion

        #region XmlPedRec()
        /// <summary>
        /// Gera o XML de pedido de analise do recibo do lote
        /// </summary>
        /// <param name="strRecibo">Número do recibo a ser consultado o lote</param>
        /// <by>Wandrey Mundin Ferreira</by>
        /// <date>21/04/2009</date>
        public void XmlPedRec(string recibo)
        {
            int emp = EmpIndex;

            string nomeArqPedRec = Empresa.Configuracoes[emp].PastaEnvio + "\\" + recibo + Propriedade.ExtEnvio.PedRec_XML;
            string nomeArqPedRecTemp = Empresa.Configuracoes[emp].PastaEnvio + "\\Temp\\" + recibo + Propriedade.ExtEnvio.PedRec_XML;

            if (!File.Exists(nomeArqPedRec) && !File.Exists(nomeArqPedRecTemp))
            {
                string tipo = string.Empty;
                switch (Propriedade.TipoAplicativo)
                {
                    case TipoAplicativo.Cte:
                        tipo = "CT";
                        break;

                    case TipoAplicativo.Nfe:
                        tipo = "NF";
                        break;

                    default:
                        break;
                }

                string strXml = "<?xml version=\"1.0\" encoding=\"UTF-8\"?>" +
                    "<consReci" + tipo + "e versao=\"" + ConfiguracaoApp.VersaoXMLPedRec + "\" xmlns=\"" + Propriedade.nsURI + "\">" +
                    "<tpAmb>" + Empresa.Configuracoes[emp].tpAmb.ToString() + "</tpAmb>" +
                    "<nRec>" + recibo + "</nRec>" +
                    "</consReci" + tipo + "e>";

                //Gravar o XML
                GravarArquivoParaEnvio(nomeArqPedRec, strXml);
            }
        }
        #endregion

        #region XMLDistNFe()
        /// <summary>
        /// Criar o arquivo XML de distribuição das NFE com o protocolo de autorização anexado
        /// </summary>
        /// <param name="strArqNFe">Nome arquivo XML da NFe</param>
        /// <param name="strProtNfe">String contendo a parte do XML do protocolo a ser anexado</param>
        /// <by>Wandrey Mundin Ferreira</by>
        /// <date>20/04/2009</date>
        public string XmlDistNFe(string strArqNFe, string strProtNfe, string extensao)  //danasa 11-4-2012
        {
            string strNomeArqProcNFe = string.Empty;
            int emp = EmpIndex;
            StreamWriter swProc = null;

            try
            {
                if (File.Exists(strArqNFe))
                {
                    string tipo = string.Empty;
                    switch (Propriedade.TipoAplicativo)
                    {
                        case TipoAplicativo.Cte:
                            tipo = "ct";
                            break;

                        case TipoAplicativo.Nfe:
                            tipo = "nf";
                            break;

                        default:
                            break;
                    }

                    //Separar as tag´s da NFe que interessa <NFe> até </NFe>
                    XmlDocument doc = new XmlDocument();

                    doc.Load(strArqNFe);

                    XmlNodeList NFeList = doc.GetElementsByTagName(tipo.ToUpper() + "e");
                    XmlNode NFeNode = NFeList[0];
                    string strNFe = NFeNode.OuterXml;

                    //Montar a string contendo o XML -proc-NFe.xml
                    string strXmlProcNfe = "<?xml version=\"1.0\" encoding=\"UTF-8\" ?>" +
                        "<" + tipo + "eProc xmlns=\"" + Propriedade.nsURI + "\" versao=\"" + ConfiguracaoApp.VersaoXMLNFe + "\">" +
                        strNFe +
                        strProtNfe +
                        "</" + tipo + "eProc>";

                    //Montar o nome do arquivo -proc-NFe.xml
                    strNomeArqProcNFe = Empresa.Configuracoes[emp].PastaEnviado + "\\" +
                                        PastaEnviados.EmProcessamento.ToString() + "\\" +
                                        Functions/*oAux*/.ExtrairNomeArq(strArqNFe, Propriedade.ExtEnvio.Nfe) +
                                        extensao;//Propriedade.ExtRetorno.ProcNFe;//danasa 11-4-2012

                    //Gravar o XML em uma linha só (sem quebrar as tag´s linha a linha) ou dá erro na hora de 
                    //validar o XML pelos Schemas. Wandrey 13/05/2009
                    swProc = File.CreateText(strNomeArqProcNFe);
                    swProc.Write(strXmlProcNfe);
                }
            }
            catch (Exception ex)
            {
                throw (ex);
            }
            finally
            {
                if (swProc != null)
                {
                    swProc.Close();
                }
            }
            return strNomeArqProcNFe;   //danasa 11-4-2012
        }
        #endregion

        #region DownloadDest
        public void EnvioDownloadNFe(string pArquivo, DadosenvDownload dadosEnvDownload)
        {
            StringBuilder vDadosMsg = new StringBuilder();
            vDadosMsg.Append("<?xml version=\"1.0\" encoding=\"UTF-8\"?>");
            vDadosMsg.Append("<downloadNFe versao=\"" + ConfiguracaoApp.VersaoXMLEnvDownload + "\" xmlns=\"" + Propriedade.nsURI + "\">");
            vDadosMsg.AppendFormat("<tpAmb>{0}</tpAmb>", dadosEnvDownload.tpAmb);
            vDadosMsg.Append("<xServ>DOWNLOAD NFE</xServ>");
            vDadosMsg.AppendFormat("<CNPJ>{0}</CNPJ>", dadosEnvDownload.CNPJ);
            vDadosMsg.AppendFormat("<chNFe>{0}</chNFe>", dadosEnvDownload.chNFe);
            vDadosMsg.Append("</downloadNFe>");

            try
            {
                GravarArquivoParaEnvio(pArquivo, vDadosMsg.ToString(), true);
            }
            catch (XmlException ex)
            {
                throw (ex);
            }
            catch (Exception ex)
            {
                throw (ex);
            }
        }
        #endregion

        #region EnvioConsultaNFeDest
        public void EnvioConsultaNFeDest(string pArquivo, DadosConsultaNFeDest dadosEnvEvento)
        {
            StringBuilder vDadosMsg = new StringBuilder();
            vDadosMsg.Append("<?xml version=\"1.0\" encoding=\"UTF-8\"?>");
            vDadosMsg.Append("<consNFeDest versao=\"" + ConfiguracaoApp.VersaoXMLEnvConsultaNFeDest + "\" xmlns=\"" + Propriedade.nsURI + "\">");
            vDadosMsg.AppendFormat("<tpAmb>{0}</tpAmb>", dadosEnvEvento.tpAmb);
            vDadosMsg.Append("<xServ>CONSULTAR NFE DEST</xServ>");
            vDadosMsg.AppendFormat("<CNPJ>{0}</CNPJ>", dadosEnvEvento.CNPJ);
            vDadosMsg.AppendFormat("<indNFe>{0}</indNFe>", dadosEnvEvento.indNFe);
            vDadosMsg.AppendFormat("<indEmi>{0}</indEmi>", dadosEnvEvento.indEmi);
            vDadosMsg.AppendFormat("<ultNSU>{0}</ultNSU>", dadosEnvEvento.ultNSU);
            vDadosMsg.Append("</consNFeDest>");

            try
            {
                GravarArquivoParaEnvio(pArquivo, vDadosMsg.ToString(), true);
            }
            catch (XmlException ex)
            {
                throw (ex);
            }
            catch (Exception ex)
            {
                throw (ex);
            }
        }
        #endregion

        #region -- Evento

        #region EnvioEvento
        /// <summary>
        /// EnvioEvento
        /// </summary>
        /// <param name="pArquivo"></param>
        /// <param name="dadosEnvEvento"></param>
        public void EnvioEvento(string pArquivo, DadosenvEvento dadosEnvEvento)
        {
            if (dadosEnvEvento.eventos.Count == 0)
                throw new Exception("Sem eventos no XML de envio");

            int currentEvento = Convert.ToInt32(dadosEnvEvento.eventos[0].tpEvento);
            foreach (Evento item in dadosEnvEvento.eventos)
                if (currentEvento != Convert.ToInt32(item.tpEvento))
                    throw new Exception(string.Format("Não é possivel mesclar tipos de eventos dentro de um mesmo xml de eventos. O tipo de evento neste xml é {0}", currentEvento));

            StringBuilder vDadosMsg = new StringBuilder();
            vDadosMsg.Append("<?xml version=\"1.0\" encoding=\"UTF-8\"?>");
            switch (currentEvento)
            {
                case 110110:
                    vDadosMsg.Append("<envEvento versao=\"" + ConfiguracaoApp.VersaoXMLEnvCCe + "\" xmlns=\"" + Propriedade.nsURI + "\">");
                    break;
                case 110111:
                    vDadosMsg.Append("<envEvento versao=\"" + ConfiguracaoApp.VersaoXMLEnvCancelamento + "\" xmlns=\"" + Propriedade.nsURI + "\">");
                    break;
                default:
                    vDadosMsg.Append("<envEvento versao=\"" + ConfiguracaoApp.VersaoXMLEnvManifestacao + "\" xmlns=\"" + Propriedade.nsURI + "\">");
                    break;
            }
            vDadosMsg.AppendFormat("<idLote>{0}</idLote>", dadosEnvEvento.idLote);

            foreach (Evento evento in dadosEnvEvento.eventos)
            {
                vDadosMsg.Append("<evento versao=\"" + dadosEnvEvento.versao + "\" xmlns=\"" + Propriedade.nsURI + "\">");
                vDadosMsg.AppendFormat("<infEvento Id=\"{0}\">", evento.Id);
                vDadosMsg.AppendFormat("<cOrgao>{0}</cOrgao>", evento.cOrgao);
                vDadosMsg.AppendFormat("<tpAmb>{0}</tpAmb>", evento.tpAmb);
                if (!string.IsNullOrEmpty(evento.CNPJ))
                    vDadosMsg.AppendFormat("<CNPJ>{0}</CNPJ>", evento.CNPJ);
                else
                    vDadosMsg.AppendFormat("<CPF>{0}</CPF>", evento.CPF);
                vDadosMsg.AppendFormat("<chNFe>{0}</chNFe>", evento.chNFe);
                // get the UTC offset depending on day light savings
                /*Data e hora do evento no formato AAAA-MM-DDThh:mm:ssTZD (UTC - Universal Coordinated Time,
                onde TZD pode ser -02:00 (Fernando de Noronha), -03:00(Brasília) ou -04:00 (Manaus), no horário de verão serão -
                01:00, -02:00 e -03:00. Ex.: 2010-08-19T13:00:15-03:00.*/
                if (!(evento.dhEvento.EndsWith("-01:00") ||
                      evento.dhEvento.EndsWith("-02:00") ||
                      evento.dhEvento.EndsWith("-03:00") ||
                      evento.dhEvento.EndsWith("-04:00")))
                {
                    //double hourOffset = Convert.ToDateTime(evento.dhEvento).IsDaylightSavingTime() ? -3 : -4;
                    //DateTimeOffset offset = DateTimeOffset.UtcNow.ToOffset(TimeSpan.FromHours(hourOffset));
                    //string tz = offset.ToString().Substring(offset.ToString().LastIndexOf(" ") + 1).Trim();
                    //if (tz == "") tz = "-03:00";
                    //string tz = TimeZoneInfo.Local.BaseUtcOffset.ToString().Substring(0,6);
                    evento.dhEvento = Convert.ToDateTime(evento.dhEvento).ToString("yyyy-MM-dd\"T\"HH:mm:sszzz");// +tz;
                }
                vDadosMsg.AppendFormat("<dhEvento>{0}</dhEvento>", evento.dhEvento);
                vDadosMsg.AppendFormat("<tpEvento>{0}</tpEvento>", evento.tpEvento);
                vDadosMsg.AppendFormat("<nSeqEvento>{0}</nSeqEvento>", evento.nSeqEvento);
                vDadosMsg.AppendFormat("<verEvento>{0}</verEvento>", evento.verEvento);
                vDadosMsg.Append("<detEvento versao=\"1.00\">");
                vDadosMsg.AppendFormat("<descEvento>{0}</descEvento>", evento.descEvento);
                switch (evento.tpEvento)
                {
                    case "110110":
                        // CCe
                        vDadosMsg.AppendFormat("<xCorrecao>{0}</xCorrecao>", evento.xCorrecao);
                        vDadosMsg.AppendFormat("<xCondUso>{0}</xCondUso>", evento.xCondUso);
                        break;
                    case "110111":
                        // Cancelamento da NFe como Evento
                        vDadosMsg.AppendFormat("<nProt>{0}</nProt>", evento.nProt);
                        vDadosMsg.AppendFormat("<xJust>{0}</xJust>", evento.xJust);
                        break;
                    case "210240":
                        // Manifestação do Destinatário
                        vDadosMsg.AppendFormat("<xJust>{0}</xJust>", evento.xJust);
                        break;
                }
                vDadosMsg.Append("</detEvento>");
                vDadosMsg.Append("</infEvento>");
                vDadosMsg.Append("</evento>");
            }
            vDadosMsg.Append("</envEvento>");

            try
            {
                GravarArquivoParaEnvio(pArquivo, vDadosMsg.ToString(), true);
            }
            catch (XmlException ex)
            {
                throw (ex);
            }
            catch (Exception ex)
            {
                throw (ex);
            }
        }
        #endregion

        #region XmlDistEvento
        /// <summary>
        /// XMLDistEvento
        /// </summary>
        /// <param name="emp"></param>
        /// <param name="vStrXmlRetorno"></param>
        public void XmlDistEvento(int emp, string vStrXmlRetorno)
        {
            //
            //<<<danasa 6-2011
            //<<<UTF8 -> tem acentuacao no retorno
            XmlDocument docEventos = new XmlDocument();
            docEventos.Load(Functions.StringXmlToStreamUTF8(vStrXmlRetorno));
            XmlNodeList retprocEventoNFeList = docEventos.GetElementsByTagName("procEventoNFe");
            if (retprocEventoNFeList != null)
            {
                foreach (XmlNode retConsSitNode1 in retprocEventoNFeList)
                {
                    string cStat = ((XmlElement)retConsSitNode1).GetElementsByTagName("cStat")[0].InnerText;
                    if (cStat == "135" || cStat == "136" || cStat == "155")
                    {
                        string chNFe = ((XmlElement)retConsSitNode1).GetElementsByTagName("chNFe")[0].InnerText;
                        Int32 nSeqEvento = Convert.ToInt32("0" + ((XmlElement)retConsSitNode1).GetElementsByTagName("nSeqEvento")[0].InnerText);
                        Int32 tpEvento = Convert.ToInt32("0" + ((XmlElement)retConsSitNode1).GetElementsByTagName("tpEvento")[0].InnerText);
                        DateTime dhRegEvento = Functions.GetDateTime/*Convert.ToDateTime*/(((XmlElement)retConsSitNode1).GetElementsByTagName("dhRegEvento")[0].InnerText);

                        //if (Empresa.Configuracoes[emp].DiretorioSalvarComo == "AM")
                        //    dhRegEvento = new DateTime(Convert.ToInt16("20" + chNFe.Substring(2, 2)), Convert.ToInt16(chNFe.Substring(4, 2)), 1);

                        this.XmlDistEvento(emp, chNFe, nSeqEvento, tpEvento, retConsSitNode1.OuterXml, string.Empty, dhRegEvento);
                    }
                }
            }
        }

        /// <summary>
        /// XMLDistEvento
        /// Criar o arquivo XML de distribuição dos Eventos
        /// </summary>
        public void XmlDistEvento(int emp, string ChaveNFe, int nSeqEvento, int tpEvento, string xmlEventoEnvio, string xmlRetornoEnvio, DateTime dhRegEvento)
        {
            try
            {
                /// grava o xml de distribuicao como: chave + "_" +  nSeqEvento
                /// ja que a nSeqEvento deve ser unico para cada chave
                /// 
                /// quando o evento for de manifestacao ou cancelamento o nome do arquivo contera o tipo do evento
                string tempXmlFile =
                        PastaEnviados.Autorizados.ToString() + "\\" +
                        Empresa.Configuracoes[emp].DiretorioSalvarComo.ToString(dhRegEvento) + "\\" +
                        ChaveNFe + "_" + (tpEvento != 110110 ? tpEvento.ToString() + "_" : "") + nSeqEvento.ToString("00") + Propriedade.ExtRetorno.ProcEventoNFe;

                string folderToWrite = Path.Combine(Empresa.Configuracoes[emp].PastaEnviado, tempXmlFile);
                string folderToWriteBackup = Path.Combine(Empresa.Configuracoes[emp].PastaBackup, tempXmlFile);

                if (tpEvento != 110111 && tpEvento != 110110) //Cancelamento e CCe
                {
                    if (ChaveNFe.Substring(6, 14) != Empresa.Configuracoes[emp].CNPJ || ChaveNFe.Substring(0, 2) != Empresa.Configuracoes[emp].UFCod.ToString())
                    {
                        ///evento não é do cliente uninfe
                        ///41120776676436000167550010000003961000316515
                        ///

                        if (!Empresa.Configuracoes[emp].GravarEventosDeTerceiros) return;

                        folderToWrite = Path.Combine(Empresa.Configuracoes[emp].PastaDownloadNFeDest, Path.GetFileName(tempXmlFile));
                        folderToWriteBackup = "";
                    }
                }
                else
                {
                    bool vePasta = false;
                    if (tpEvento == 110111) //cancelamento
                        vePasta = Empresa.Configuracoes[emp].GravarEventosCancelamentoNaPastaEnviadosNFe;
                    else
                        vePasta = Empresa.Configuracoes[emp].GravarEventosNaPastaEnviadosNFe;

                    if (vePasta)
                    {
                        string folderNFe = OndeNFeEstaGravada(emp, ChaveNFe);
                        if (!string.IsNullOrEmpty(folderNFe))
                        {
                            folderToWrite = Path.Combine(folderNFe, Path.GetFileName(folderToWrite));
                        }
                    }
                }

                // cria a pasta se não existir
                if (!Directory.Exists(Path.GetDirectoryName(folderToWrite)))
                    System.IO.Directory.CreateDirectory(Path.GetDirectoryName(folderToWrite));

                // Criar a pasta de backup, caso não exista. Wandrey 25/05/211
                if (!string.IsNullOrEmpty(folderToWriteBackup))
                    if (!Directory.Exists(Path.GetDirectoryName(folderToWriteBackup)))
                        System.IO.Directory.CreateDirectory(Path.GetDirectoryName(folderToWriteBackup));

                string protEnvioEvento;
                if (xmlEventoEnvio.IndexOf("<procEventoNFe") >= 0)
                    protEnvioEvento = xmlEventoEnvio;
                else //danasa 4/7/2011
                {
                    string versao = "";
                    switch (tpEvento)
                    {
                        case 110110:
                            versao = ConfiguracaoApp.VersaoXMLEnvCCe;
                            break;
                        case 110111:
                            versao = ConfiguracaoApp.VersaoXMLEnvCancelamento;
                            break;
                        default:
                            versao = ConfiguracaoApp.VersaoXMLEnvManifestacao;
                            break;
                    }
                    protEnvioEvento = "<procEventoNFe versao=\"" + versao + "\" xmlns=\"" + Propriedade.nsURI + "\">" +
                                      xmlEventoEnvio +
                                      xmlRetornoEnvio +
                                      "</procEventoNFe>";
                }
                //Gravar o arquivo de distribuição na pasta de enviados autorizados
                try
                {
                    if (!protEnvioEvento.StartsWith("<?xml"))
                        protEnvioEvento = "<?xml version=\"1.0\" encoding=\"UTF-8\" ?>" + protEnvioEvento;

                    //Gravar o arquivo de distribuição na pasta de backup
                    if (!string.IsNullOrEmpty(folderToWriteBackup))
                        if (!File.Exists(folderToWriteBackup))
                            File.WriteAllText(folderToWriteBackup, protEnvioEvento, Encoding.UTF8);

                    if (!File.Exists(folderToWrite))
                        File.WriteAllText(folderToWrite, protEnvioEvento, Encoding.UTF8);

                    if (!string.IsNullOrEmpty(folderToWriteBackup))
                        this.XmlParaFTP(emp, folderToWrite);

                    NomeArqGerado = folderToWrite;
                }
                catch (Exception ex)
                {
                    throw (ex);
                }
            }
            catch (Exception ex)
            {
                throw (ex);
            }
        }

        #endregion

        #endregion

        #endregion

        #region Métodos auxiliares

        #region OndeNFeEstaGravada
        public string OndeNFeEstaGravada(int emp, string ChaveNFe)
        {
            ///
            /// pesquisa onde o arquivo de distribuicao da nota foi gravado
            string[] files = System.IO.Directory.GetFiles(Empresa.Configuracoes[emp].PastaEnviado + "\\" + PastaEnviados.Autorizados.ToString(),
                                                            ChaveNFe + Propriedade.ExtRetorno.ProcNFe,
                                                            SearchOption.AllDirectories);
            if (files.Length == 0)
                files = System.IO.Directory.GetFiles(Empresa.Configuracoes[emp].PastaEnviado + "\\" + PastaEnviados.Denegados.ToString(),
                                                            ChaveNFe + Propriedade.ExtEnvio.Nfe,
                                                            SearchOption.AllDirectories);

            return files.Length > 0 ? Path.GetDirectoryName(files[0]) : "";
        }
        #endregion

        #region LerXMLNfe()
        /// <summary>
        /// Le o conteudo do XML da NFe
        /// </summary>
        /// <param name="Arquivo">Arquivo do XML da NFe</param>
        /// <returns>Dados do XML da NFe</returns>
        private DadosNFeClass LerXMLNFe(string Arquivo)
        {
            LerXML oLerXML = new LerXML();

            try
            {
                oLerXML.Nfe(Arquivo);
            }
            catch (XmlException ex)
            {
                throw (ex);
            }
            catch (Exception ex)
            {
                throw (ex);
            }

            return oLerXML.oDadosNfe;
        }
        #endregion

        #region NomeArqLoteRetERP()
        protected string NomeArqLoteRetERP(string NomeArquivoXML)
        {
            int emp = new FindEmpresaThread(Thread.CurrentThread).Index;

            return Empresa.Configuracoes[emp].PastaRetorno + "\\" +
                Functions/*oAux*/.ExtrairNomeArq(NomeArquivoXML, Propriedade.ExtEnvio.Nfe) +
                "-num-lot.xml";
        }
        #endregion

        #region GravarArquivoParaEnvio
        /// <summary>
        /// grava um arquivo na pasta de envio
        /// </summary>
        /// <param name="Arquivo"></param>
        /// <param name="Conteudo"></param>
        protected void GravarArquivoParaEnvio(string Arquivo, string Conteudo)
        {
            GravarArquivoParaEnvio(Arquivo, Conteudo, false);
        }
        protected void GravarArquivoParaEnvio(string Arquivo, string Conteudo, bool isUTF8)
        {
            try
            {
                //Arquivo na pasta Temp
                string arqTemp = Empresa.Configuracoes[EmpIndex].PastaEnvio + "\\Temp\\" + Path.GetFileName(Arquivo);
                //Arquivo na pasta de Envio
                string arqEnvio = Empresa.Configuracoes[EmpIndex].PastaEnvio + "\\" + Path.GetFileName(Arquivo);

                MemoryStream oMemoryStream;
                ///
                ///<<<danasa 6-2011
                ///inclui o "isUTF8" para suportar a gravacao do XML da CCe - caso você queira, acho que pode ser tudo em UTF-8
                if (isUTF8)
                    oMemoryStream = Functions.StringXmlToStreamUTF8(Conteudo);
                else
                    oMemoryStream = Functions.StringXmlToStream(Conteudo);
                XmlDocument docProc = new XmlDocument();
                docProc.Load(oMemoryStream);

                //Gravar o XML na pasta Temp
                docProc.Save(arqTemp);

                //Mover XML da pasta Temp para Envio
                Functions.Move(arqTemp, arqEnvio);
            }
            catch (XmlException ex)
            {
                throw (ex);
            }
            catch (Exception ex)
            {
                throw (ex);
            }
        }
        #endregion

        #endregion

        #endregion

        #region ProcessaConsultaCadastro()
        /// <summary>
        /// utilizada pela GerarXML
        /// </summary>
        /// <param name="msXml"></param>
        /// <returns></returns>
        public RetConsCad ProcessaConsultaCadastro(XmlDocument doc)
        {
            if (doc.GetElementsByTagName("infCad") == null)
                return null;

            RetConsCad vRetorno = new RetConsCad();

            foreach (XmlNode node in doc.ChildNodes)
            {
                if (node.Name == "retConsCad")
                {
                    foreach (XmlNode noderetConsCad in node.ChildNodes)
                    {
                        if (noderetConsCad.Name == "infCons")
                        {
                            foreach (XmlNode nodeinfCons in noderetConsCad.ChildNodes)
                            {
                                if (nodeinfCons.Name == "infCad")
                                {
                                    vRetorno.infCad.Add(new infCad());
                                    vRetorno.infCad[vRetorno.infCad.Count - 1].CNPJ = vRetorno.CNPJ;
                                    vRetorno.infCad[vRetorno.infCad.Count - 1].CPF = vRetorno.CPF;
                                    vRetorno.infCad[vRetorno.infCad.Count - 1].IE = vRetorno.IE;
                                    vRetorno.infCad[vRetorno.infCad.Count - 1].UF = vRetorno.UF;

                                    foreach (XmlNode nodeinfCad in nodeinfCons.ChildNodes)
                                    {
                                        switch (nodeinfCad.Name)
                                        {
                                            case "UF":
                                                vRetorno.infCad[vRetorno.infCad.Count - 1].UF = nodeinfCad.InnerText;
                                                break;
                                            case "IE":
                                                vRetorno.infCad[vRetorno.infCad.Count - 1].IE = nodeinfCad.InnerText;
                                                break;
                                            case "CNPJ":
                                                vRetorno.infCad[vRetorno.infCad.Count - 1].CNPJ = nodeinfCad.InnerText;
                                                break;
                                            case "CPF":
                                                vRetorno.infCad[vRetorno.infCad.Count - 1].CNPJ = nodeinfCad.InnerText;
                                                break;
                                            case "xNome":
                                                vRetorno.infCad[vRetorno.infCad.Count - 1].xNome = nodeinfCad.InnerText;
                                                break;
                                            case "xFant":
                                                vRetorno.infCad[vRetorno.infCad.Count - 1].xFant = nodeinfCad.InnerText;
                                                break;

                                            case "ender":
                                                foreach (XmlNode nodeinfConsEnder in nodeinfCad.ChildNodes)
                                                {
                                                    switch (nodeinfConsEnder.Name)
                                                    {
                                                        case "xLgr":
                                                            vRetorno.infCad[vRetorno.infCad.Count - 1].ender.xLgr = nodeinfConsEnder.InnerText;
                                                            break;
                                                        case "nro":
                                                            vRetorno.infCad[vRetorno.infCad.Count - 1].ender.nro = nodeinfConsEnder.InnerText;
                                                            break;
                                                        case "xCpl":
                                                            vRetorno.infCad[vRetorno.infCad.Count - 1].ender.xCpl = nodeinfConsEnder.InnerText;
                                                            break;
                                                        case "xBairro":
                                                            vRetorno.infCad[vRetorno.infCad.Count - 1].ender.xBairro = nodeinfConsEnder.InnerText;
                                                            break;
                                                        case "xMun":
                                                            vRetorno.infCad[vRetorno.infCad.Count - 1].ender.xMun = nodeinfConsEnder.InnerText;
                                                            break;
                                                        case "cMun":
                                                            vRetorno.infCad[vRetorno.infCad.Count - 1].ender.cMun = Convert.ToInt32("0" + nodeinfConsEnder.InnerText);
                                                            break;
                                                        case "CEP":
                                                            vRetorno.infCad[vRetorno.infCad.Count - 1].ender.CEP = Convert.ToInt32("0" + nodeinfConsEnder.InnerText);
                                                            break;
                                                    }
                                                }
                                                break;

                                            case "IEAtual":
                                                vRetorno.infCad[vRetorno.infCad.Count - 1].IEAtual = nodeinfCad.InnerText;
                                                break;
                                            case "IEUnica":
                                                vRetorno.infCad[vRetorno.infCad.Count - 1].IEUnica = nodeinfCad.InnerText;
                                                break;
                                            case "dBaixa":
                                                vRetorno.infCad[vRetorno.infCad.Count - 1].dBaixa = Functions.GetDateTime(nodeinfCad.InnerText);
                                                break;
                                            case "dUltSit":
                                                vRetorno.infCad[vRetorno.infCad.Count - 1].dUltSit = Functions.GetDateTime(nodeinfCad.InnerText);
                                                break;
                                            case "dIniAtiv":
                                                vRetorno.infCad[vRetorno.infCad.Count - 1].dIniAtiv = Functions.GetDateTime(nodeinfCad.InnerText);
                                                break;
                                            case "CNAE":
                                                vRetorno.infCad[vRetorno.infCad.Count - 1].CNAE = Convert.ToInt32("0" + nodeinfCad.InnerText);
                                                break;
                                            case "xRegApur":
                                                vRetorno.infCad[vRetorno.infCad.Count - 1].xRegApur = nodeinfCad.InnerText;
                                                break;
                                            case "cSit":
                                                if (nodeinfCad.InnerText == "0")
                                                    vRetorno.infCad[vRetorno.infCad.Count - 1].cSit = "Contribuinte não habilitado";
                                                else if (nodeinfCad.InnerText == "1")
                                                    vRetorno.infCad[vRetorno.infCad.Count - 1].cSit = "Contribuinte habilitado";
                                                break;
                                        }
                                    }
                                }
                                else
                                {
                                    switch (nodeinfCons.Name)
                                    {
                                        case "cStat":
                                            vRetorno.cStat = Convert.ToInt32("0" + nodeinfCons.InnerText);
                                            break;
                                        case "xMotivo":
                                            vRetorno.xMotivo = nodeinfCons.InnerText;
                                            break;
                                        case "UF":
                                            vRetorno.UF = nodeinfCons.InnerText;
                                            break;
                                        case "IE":
                                            vRetorno.IE = nodeinfCons.InnerText;
                                            break;
                                        case "CNPJ":
                                            vRetorno.CNPJ = nodeinfCons.InnerText;
                                            break;
                                        case "CPF":
                                            vRetorno.CPF = nodeinfCons.InnerText;
                                            break;
                                        case "dhCons":
                                            vRetorno.dhCons = Functions.GetDateTime(nodeinfCons.InnerText);
                                            break;
                                        case "cUF":
                                            vRetorno.cUF = Convert.ToInt32("0" + nodeinfCons.InnerText);
                                            break;
                                    }
                                }
                            }
                        }
                    }
                }
            }
            return vRetorno;
        }
        #endregion

        #region ProcessaConsultaCadastro()
        public RetConsCad ProcessaConsultaCadastro(MemoryStream msXml)
        {
            XmlDocument doc = new XmlDocument();
            doc.Load(msXml);
            return ProcessaConsultaCadastro(doc);
        }
        #endregion

        #region ProcessaConsultaCadastro()
        /// <summary>
        /// Função Callback que analisa a resposta do Status do Servido
        /// </summary>
        /// <param name="elem"></param>
        /// <by>Marcos Diez</by>
        /// <date>30/8/2009</date>
        /// <returns></returns>
        /// <summary>
        /// utilizada internamente pela VerConsultaCadastroClass
        /// </summary>
        /// <param name="cArquivoXML"></param>
        /// <returns></returns>
        public RetConsCad ProcessaConsultaCadastro(string cArquivoXML)
        {
            XmlDocument doc = new XmlDocument();
            doc.Load(cArquivoXML);
            return ProcessaConsultaCadastro(doc);
        }
        #endregion

        #region XmlParaFTP
        public void XmlParaFTP(int emp, string vNomeDoArquivo)
        {
            ///
            /// verifica se o FTP da empresa está ativo
            if (Empresa.Configuracoes[emp].FTPIsAlive)
            {
                string vFolder = "";
                ///
                /// exclui o arquivo de erro de FTP
                Functions.DeletarArquivo(Path.Combine(Empresa.Configuracoes[emp].PastaRetorno, Path.GetFileName(Path.ChangeExtension(vNomeDoArquivo, ".ftp"))));
                ///
                /// o arquivo é Autorizado ou Denegado?
                if (vNomeDoArquivo.Contains(PastaEnviados.Autorizados.ToString()) ||
                    vNomeDoArquivo.Contains(PastaEnviados.Denegados.ToString()))
                {
                    ///
                    /// verifica as extensoes
                    /// é até redundante verificar as extensoes, já que verificamos as pastas de "Autorizado ou Denegado"
                    if (vNomeDoArquivo.EndsWith(Propriedade.ExtRetorno.ProcCancNFe) ||
                        vNomeDoArquivo.EndsWith(Propriedade.ExtRetorno.ProcEventoNFe) ||
                        vNomeDoArquivo.EndsWith(Propriedade.ExtRetorno.ProcInutNFe) ||
                        vNomeDoArquivo.EndsWith(Propriedade.ExtRetorno.ProcNFe) ||
                        vNomeDoArquivo.EndsWith("-den.xml"))
                    {
                        ///
                        /// pega a pasta de enviados do FTP
                        vFolder = Empresa.Configuracoes[emp].FTPPastaAutorizados;
                        if (!string.IsNullOrEmpty(vFolder))
                        {
                            ///
                            /// verifica se é para gravar na pasta especifica ou se é para gravar na mesma
                            /// hierarquia definida para gravar localmente
                            if (!Empresa.Configuracoes[emp].FTPGravaXMLPastaUnica)
                            {
                                string[] temp = vNomeDoArquivo.Split('\\');
                                ///
                                /// pega a ultima pasta atribuida
                                /// Ex: "c:\nfe\autorizados\201112\3539438493843493-procNFe.xml
                                /// pega a pasta "201112"
                                vFolder += "/" + temp[temp.Length - 2];
                            }
                        }
                    }
                }
                else
                {
                    ///
                    /// pega a pasta de retorno no FTP para gravar os retornos dos webservices
                    /// se vazia nao grava os retornos
                    if (vNomeDoArquivo.ToLower().EndsWith(".xml") ||
                        vNomeDoArquivo.ToLower().EndsWith(".txt") ||
                        vNomeDoArquivo.ToLower().EndsWith(".err"))
                    {
                        vFolder = Empresa.Configuracoes[emp].FTPPastaRetornos;
                    }
                }
                if (!string.IsNullOrEmpty(vFolder))
                {
                    try
                    {
                        Empresa.Configuracoes[emp].SendFileToFTP(vNomeDoArquivo, vFolder);
                    }
                    catch (Exception ex)
                    {
                        ///
                        /// grava um arquivo de erro com extensao "FTP" para diferenciar dos arquivos de erro
                        oAux.GravarArqErroERP(Path.ChangeExtension(vNomeDoArquivo, ".ftp"), ex.Message);
                    }
                }
            }
        }
        #endregion
    }
}
