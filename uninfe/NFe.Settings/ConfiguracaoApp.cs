﻿using System;
using System.IO;
using System.Collections;
using System.Collections.Generic;
using System.ComponentModel;
using System.Reflection;
using System.Data;
using System.Drawing;
using System.Text;
using System.Windows.Forms;
using System.Xml;
using System.Xml.Linq;
using System.Linq;
using System.Diagnostics;
using System.Security.Cryptography.X509Certificates;
using System.Threading;
using NFe.Components;

namespace NFe.Settings
{
    #region Classe ConfiguracaoApp
    /// <summary>
    /// Classe responsável por realizar algumas tarefas na parte de configurações da aplicação.
    /// Arquivo de configurações: UniNfeConfig.xml
    /// </summary>
    public class ConfiguracaoApp
    {
        #region NfeConfiguracoes
        /// <summary>
        /// Enumerador com as tags do xml nfe_Configuracoes
        /// </summary>
        private enum NfeConfiguracoes
        {
            Proxy = 0,
            ProxyServidor,
            ProxyUsuario,
            ProxySenha,
            ProxyPorta,
            SenhaConfig,
            ChecarConexaoInternet,
            GravarLogOperacaoRealizada
        }
        #endregion

        #region Propriedades

        #region ChecarConexaoInternet
        public static bool ChecarConexaoInternet { get; set; }
        #endregion

        #region GravarLogOperacoesRealizadas
        public static bool GravarLogOperacoesRealizadas { get; set; }
        #endregion

        #region Propriedades das versões dos XML´s da NFe
        public static string VersaoXMLStatusServico { get; set; }
        public static string VersaoXMLNFe { get; set; }
        public static string VersaoXMLPedRec { get; set; }
        public static string VersaoXMLCanc { get; set; }
        public static string VersaoXMLInut { get; set; }
        public static string VersaoXMLPedSit { get; set; }
        public static string VersaoXMLConsCad { get; set; }
        public static string VersaoXMLCabecMsg { get; set; }
        public static string VersaoXMLEnvDPEC { get; set; }
        public static string VersaoXMLConsDPEC { get; set; }
        public static string VersaoXMLEnvCCe { get; set; }
        public static string VersaoXMLEnvCancelamento { get; set; }
        public static string VersaoXMLEnvDownload { get; set; }
        public static string VersaoXMLEnvConsultaNFeDest { get; set; }
        public static string VersaoXMLEnvManifestacao { get; set; }
        #endregion

        #region Propriedades para controle de servidor proxy
        public static bool Proxy { get; set; }
        public static string ProxyServidor { get; set; }
        public static string ProxyUsuario { get; set; }
        public static string ProxySenha { get; set; }
        public static int ProxyPorta { get; set; }
        #endregion

        #region Propriedades para tela de sobre
        public static string NomeEmpresa { get; set; }
        public static string Site { get; set; }
        public static string SiteProduto { get; set; }
        public static string Email { get; set; }
        #endregion

        #region SenhaConfig
        private static bool mSenhaConfigAlterada = false;
        private static string mSenhaConfig;
        public static string SenhaConfig
        {
            get
            {
                return mSenhaConfig;
            }
            set
            {
                if (value != mSenhaConfig)
                {
                    mSenhaConfigAlterada = true;
                    mSenhaConfig = value;
                }
                else
                    mSenhaConfigAlterada = false;
            }
        }
        #endregion

        #endregion

        #region Métodos gerais

        #region Extrae os arquivos necessarios a executacao
        internal class loadResources
        {
            public void load()
            {
                try
                {
                    System.Reflection.Assembly ass = System.Reflection.Assembly.LoadFrom("NFe.Components.Wsdl.dll");
                    string[] x = ass.GetManifestResourceNames();
                    if (x.GetLength(0) > 0)
                    {
                        foreach (string s in x)
                        {
                            string fileoutput = null;
                            switch (NFe.Components.Propriedade.TipoAplicativo)
                            {
                                case TipoAplicativo.Nfe:
                                    if (s.StartsWith("NFe.Components.Wsdl.NFe."))
                                        fileoutput = s.Replace("NFe.Components.Wsdl.NFe.", NFe.Components.Propriedade.PastaExecutavel + "\\");
                                    break;
                                case TipoAplicativo.Cte:
                                    if (s.StartsWith("NFe.Components.Wsdl.CTe."))
                                        fileoutput = s.Replace("NFe.Components.Wsdl.CTe.", NFe.Components.Propriedade.PastaExecutavel + "\\");
                                    break;
                                case TipoAplicativo.Nfse:
                                    if (s.StartsWith("NFe.Components.Wsdl.NFse."))
                                        fileoutput = s.Replace("NFe.Components.Wsdl.NFse.", NFe.Components.Propriedade.PastaExecutavel + "\\");
                                    break;
                            }

                            if (fileoutput == null)
                                continue;

                            if (fileoutput.ToLower().EndsWith(".xsd"))
                            {
                                /// Ex: NFe.Components.Wsdl.NFe.NFe.xmldsig-core-schema_v1.01.xsd
                                ///
                                /// pesquisa pelo nome do XSD
                                int plast = fileoutput.ToLower().LastIndexOf("_v");
                                if (plast == -1)
                                    plast = fileoutput.IndexOf(".xsd") - 1;

                                while (fileoutput[plast] != '.')
                                    --plast;

                                string fn = fileoutput.Substring(plast + 1);
                                fileoutput = fileoutput.Substring(0, plast).Replace(".", "\\") + "\\" + fn;
                            }
                            else
                                fileoutput = (fileoutput.Substring(0, fileoutput.LastIndexOf('.')) + "#" + fileoutput.Substring(fileoutput.LastIndexOf('.') + 1)).Replace(".", "\\").Replace("#", ".");

                            //fileoutput = fileoutput.Replace(NFe.Components.Propriedade.PastaExecutavel, "e:\\temp");
                            //System.Windows.Forms.MessageBox.Show(s + "\r\n"+fileoutput+"\r\n"+Path.GetFileName(fileoutput));
                            //continue;

                            using (StreamReader FileReader = new StreamReader(ass.GetManifestResourceStream(s)))
                            {
                                if (!Directory.Exists(Path.GetDirectoryName(fileoutput)))
                                    Directory.CreateDirectory(Path.GetDirectoryName(fileoutput));

                                using (StreamWriter FileWriter = new StreamWriter(fileoutput))
                                {
                                    FileWriter.Write(FileReader.ReadToEnd());
                                    FileWriter.Close();
                                }
                            }
                        }
                    }
                }
                catch (Exception ex)
                {
                    Auxiliar.WriteLog(ex.Message);
                }
            }
        }
        #endregion

        #region StartVersoes
        public static void StartVersoes()
        {
            new loadResources().load();

            ConfiguracaoApp.CarregarDados();
            if (!Propriedade.ServicoRodando || Propriedade.ExecutandoPeloUniNFe)
                ConfiguracaoApp.CarregarDadosSobre();

            switch (Propriedade.TipoAplicativo)
            {
                case TipoAplicativo.Cte:
                    ConfiguracaoApp.VersaoXMLCanc = "1.04";
                    ConfiguracaoApp.VersaoXMLConsCad = "2.00";
                    ConfiguracaoApp.VersaoXMLInut = "1.04";
                    ConfiguracaoApp.VersaoXMLNFe = "1.04";
                    ConfiguracaoApp.VersaoXMLPedRec = "1.04";
                    ConfiguracaoApp.VersaoXMLPedSit = "1.04";
                    ConfiguracaoApp.VersaoXMLStatusServico = "1.04";
                    ConfiguracaoApp.VersaoXMLCabecMsg = "1.04";
                    Propriedade.nsURI = "http://www.portalfiscal.inf.br/cte";

                    //Substituir a extensão de alguns arquivos da NFe para o padrão CTE, ou 
                    //os serviços do UNICTE não vai enxergar os XML´s na pasta de envio
                    Propriedade.ExtEnvio.Nfe = "-cte.xml";
                    Propriedade.ExtRetorno.Nfe_ERR = "-cte.err";
                    Propriedade.ExtRetorno.ProcCancNFe = "-procCancCTe.xml";
                    Propriedade.ExtRetorno.ProcInutNFe = "-procInutCTe.xml";
                    Propriedade.ExtRetorno.ProcNFe = "-procCTe.xml";
                    break;

                case TipoAplicativo.Nfe:
                    ConfiguracaoApp.VersaoXMLCanc = "2.00";
                    ConfiguracaoApp.VersaoXMLConsCad = "2.00";
                    ConfiguracaoApp.VersaoXMLInut = "2.00";
                    ConfiguracaoApp.VersaoXMLNFe = "2.00";
                    ConfiguracaoApp.VersaoXMLPedRec = "2.00";
                    ConfiguracaoApp.VersaoXMLPedSit = "2.00";   //<<<danasa 6-2011
                    ConfiguracaoApp.VersaoXMLStatusServico = "2.00";
                    ConfiguracaoApp.VersaoXMLCabecMsg = "2.00";
                    ConfiguracaoApp.VersaoXMLEnvDPEC = "1.01";
                    ConfiguracaoApp.VersaoXMLConsDPEC = "1.01";
                    ConfiguracaoApp.VersaoXMLEnvCCe = "1.00";   //<<<danasa 6-2011
                    ConfiguracaoApp.VersaoXMLEnvCancelamento = "1.00";
                    ConfiguracaoApp.VersaoXMLEnvDownload = "1.00";
                    ConfiguracaoApp.VersaoXMLEnvManifestacao = "1.00";
                    ConfiguracaoApp.VersaoXMLEnvConsultaNFeDest = "1.01";
                    Propriedade.nsURI = "http://www.portalfiscal.inf.br/nfe";
                    SchemaXML.CriarListaIDXML();
                    break;

                case TipoAplicativo.Nfse:
                    ConfiguracaoApp.VersaoXMLCanc = "1.03";
                    ConfiguracaoApp.VersaoXMLConsCad = "1.03";
                    ConfiguracaoApp.VersaoXMLInut = "1.03";
                    ConfiguracaoApp.VersaoXMLNFe = "1.03";
                    ConfiguracaoApp.VersaoXMLPedRec = "1.03";
                    ConfiguracaoApp.VersaoXMLPedSit = "1.03";
                    ConfiguracaoApp.VersaoXMLStatusServico = "1.03";
                    ConfiguracaoApp.VersaoXMLCabecMsg = "1.03";
                    Propriedade.nsURI = "http://www.abrasf.org.br/";

                    //Substituir a extensão de alguns arquivos da NFe para o padrão CTE, ou 
                    //os serviços do UNINFSE não vai enxergar os XML´s na pasta de envio
                    Propriedade.ExtEnvio.Nfe = "-cte.xml";
                    Propriedade.ExtRetorno.Nfe_ERR = "-cte.err";
                    Propriedade.ExtRetorno.ProcCancNFe = "-procCancCTe.xml";
                    Propriedade.ExtRetorno.ProcInutNFe = "-procInutCTe.xml";
                    Propriedade.ExtRetorno.ProcNFe = "-procCTe.xml";
                    break;
            }
        }
        #endregion

        #region TemCCe()
        /// <summary>
        /// Verifica se o Estado já tem CCe - Carta de correção Eletrônica       
        /// </summary>
        /// <returns></returns>
        public static bool TemCCe(string cUF, int tpAmb, int tpEmis)
        {
            bool retorna = true;
            /*
                        if (tpEmis != Propriedade.TipoEmissao.teNormal)
                            return retorna;

                        foreach (var item in WebServiceProxy.webServicesList)
                        {
                            if (item.ID.ToString() == cUF)
                            {
                                switch (tpAmb)
                                {
                                    case Propriedade.TipoAmbiente.taHomologacao:
                                        if (!string.IsNullOrEmpty(item.LocalHomologacao.NFeCCe))
                                        {
                                            retorna = true;
                                        }
                                        break;

                                    case Propriedade.TipoAmbiente.taProducao:
                                        if (!string.IsNullOrEmpty(item.LocalProducao.NFeCCe))
                                        {
                                            retorna = true;
                                        }
                                        break;

                                    default:
                                        break;
                                }
                            }
                        }
             */

            return retorna;
        }
        #endregion

        #region CarregarDados()
        /// <summary>
        /// Carrega as configurações realizadas na Aplicação gravadas no XML UniNfeConfig.xml para
        /// propriedades, para facilitar a leitura das informações necessárias para as transações da NF-e.
        /// </summary>
        /// <remarks>
        /// Autor: Wandrey Mundin Ferreira
        /// </remarks>
        public static void CarregarDados()
        {
            string vArquivoConfig = Propriedade.PastaExecutavel + "\\" + Propriedade.NomeArqConfig;
            XmlDocument doc = null;
            if (File.Exists(vArquivoConfig))
            {
                try
                {
                    doc = new XmlDocument();
                    doc.Load(vArquivoConfig);

                    XmlNodeList configList = null;

                    configList = doc.GetElementsByTagName(NFeStrConstants.nfe_configuracoes);

                    foreach (XmlNode nodeConfig in configList)
                    {
                        XmlElement elementConfig = (XmlElement)nodeConfig;

                        if (elementConfig.GetElementsByTagName(NfeConfiguracoes.Proxy.ToString())[0] != null)
                            ConfiguracaoApp.Proxy = Convert.ToBoolean(elementConfig[NfeConfiguracoes.Proxy.ToString()].InnerText);

                        if (elementConfig.GetElementsByTagName(NfeConfiguracoes.ProxyServidor.ToString())[0] != null)
                            ConfiguracaoApp.ProxyServidor = elementConfig[NfeConfiguracoes.ProxyServidor.ToString()].InnerText.Trim();

                        if (elementConfig.GetElementsByTagName(NfeConfiguracoes.ProxyUsuario.ToString())[0] != null)
                            ConfiguracaoApp.ProxyUsuario = elementConfig[NfeConfiguracoes.ProxyUsuario.ToString()].InnerText.Trim();

                        if (elementConfig.GetElementsByTagName(NfeConfiguracoes.ProxySenha.ToString())[0] != null)
                            ConfiguracaoApp.ProxySenha = elementConfig[NfeConfiguracoes.ProxySenha.ToString()].InnerText.Trim();

                        if (elementConfig.GetElementsByTagName(NfeConfiguracoes.ProxyPorta.ToString())[0] != null)
                            ConfiguracaoApp.ProxyPorta = Convert.ToInt32(elementConfig[NfeConfiguracoes.ProxyPorta.ToString()].InnerText.Trim());

                        if (elementConfig.GetElementsByTagName(NfeConfiguracoes.SenhaConfig.ToString())[0] != null)
                            ConfiguracaoApp.SenhaConfig = elementConfig[NfeConfiguracoes.SenhaConfig.ToString()].InnerText.Trim();

                        if (elementConfig.GetElementsByTagName(NfeConfiguracoes.ChecarConexaoInternet.ToString())[0] != null)
                            ConfiguracaoApp.ChecarConexaoInternet = Convert.ToBoolean(elementConfig[NfeConfiguracoes.ChecarConexaoInternet.ToString()].InnerText);
                        else
                            ConfiguracaoApp.ChecarConexaoInternet = true;

                        if (elementConfig.GetElementsByTagName(NfeConfiguracoes.GravarLogOperacaoRealizada.ToString())[0] != null)
                            ConfiguracaoApp.GravarLogOperacoesRealizadas = Convert.ToBoolean(elementConfig[NfeConfiguracoes.GravarLogOperacaoRealizada.ToString()].InnerText);

                    }
                }
                catch (Exception ex)
                {
                    ///
                    /// danasa 8-2009
                    /// como reportar ao usuario que houve erro de leitura do arquivo de configuracao?
                    /// tem um usuário que postou um erro de leitura deste arquivo e não sabia como resolver.
                    /// 
                    ///
                    /// danasa 8-2009
                    /// 
                    if (!Propriedade.ServicoRodando || Propriedade.ExecutandoPeloUniNFe)
                        MessageBox.Show(ex.Message);
                }
                finally
                {
                    if (doc != null)
                        doc = null;

                }
            }
            else
            {
                ChecarConexaoInternet = true;
            }
            //Carregar a lista de webservices disponíveis
            try
            {
                WebServiceProxy.CarregaWebServicesList();
            }
            catch (Exception ex)
            {
                Auxiliar.WriteLog(ex.Message);
            }
        }
        #endregion

        #region CarregarDadosSobre()
        /// <summary>
        /// Carrega informações da tela de sobre
        /// </summary>
        /// <remarks>
        /// Autor: Leandro Souza
        /// </remarks>
        public static void CarregarDadosSobre()
        {
            string vArquivoConfig = Propriedade.PastaExecutavel + "\\" + Propriedade.NomeArqConfigSobre;

            if (File.Exists(vArquivoConfig))
            {
                XmlTextReader oLerXml = null;
                try
                {
                    //Carregar os dados do arquivo XML de configurações da Aplicação
                    oLerXml = new XmlTextReader(vArquivoConfig);

                    while (oLerXml.Read())
                    {
                        if (oLerXml.NodeType == XmlNodeType.Element)
                        {
                            if (oLerXml.Name == NFeStrConstants.nfe_configuracoes)
                            {
                                while (oLerXml.Read())
                                {
                                    if (oLerXml.NodeType == XmlNodeType.Element)
                                    {
                                        if (oLerXml.Name == "NomeEmpresa") { oLerXml.Read(); ConfiguracaoApp.NomeEmpresa = oLerXml.Value; }
                                        else if (oLerXml.Name == "Site") { oLerXml.Read(); ConfiguracaoApp.Site = oLerXml.Value.Trim(); }
                                        else if (oLerXml.Name == "SiteProduto") { oLerXml.Read(); ConfiguracaoApp.SiteProduto = oLerXml.Value.Trim(); }
                                        else if (oLerXml.Name == "Email") { oLerXml.Read(); ConfiguracaoApp.Email = oLerXml.Value.Trim(); }
                                    }
                                }
                                break;
                            }
                        }
                    }
                }
                catch (Exception ex)
                {
                    MessageBox.Show(ex.Message);
                }
                finally
                {
                    if (oLerXml != null)
                        oLerXml.Close();
                }
            }
        }
        #endregion

        /// <summary>
        /// Definir o webservice que será utilizado para o envio do XML
        /// </summary>
        /// <param name="servico">Serviço que será executado</param>
        /// <param name="emp">Index da empresa que será executado o serviço</param>
        /// <param name="cUF">Código da UF</param>
        /// <param name="tpAmb">Código do ambiente que será acessado</param>
        /// <param name="tpEmis">Tipo de emissão do XML</param>
        /// <param name="versaoNFe">Versão da NFe (1 ou 2)</param>
        /// <returns>Retorna o objeto do serviço</returns>
        /// <remarks>
        /// Autor: Wandrey Mundin Ferreira
        /// Data: 04/04/2011
        /// </remarks>
        public static WebServiceProxy DefinirWS(Servicos servico, int emp, int cUF, int tpAmb, int tpEmis, int versaoNFe)
        {
            WebServiceProxy wsProxy = null;
            string key = servico + " " + cUF + " " + tpAmb + " " + tpEmis + " " + versaoNFe;
            while (true)
            {
                lock (Smf.WebProxy)
                {
                    try
                    {
                        if (Empresa.Configuracoes[emp].WSProxy.ContainsKey(key))
                        {
                            wsProxy = Empresa.Configuracoes[emp].WSProxy[key];
                        }
                        else
                        {
                            //Definir a URI para conexão com o Webservice
                            string Url = ConfiguracaoApp.DefLocalWSDL(cUF, tpAmb, tpEmis, servico, versaoNFe);

                            wsProxy = new WebServiceProxy(Url, Empresa.Configuracoes[emp].X509Certificado);

                            Empresa.Configuracoes[emp].WSProxy.Add(key, wsProxy);
                        }
                    }
                    catch (Exception ex)
                    {
                        throw (ex);
                    }

                    break;
                }
            }

            return wsProxy;
        }

        /// <summary>
        /// Definir o webservice que será utilizado para o envio do XML
        /// </summary>
        /// <param name="servico">Serviço que será executado</param>
        /// <param name="emp">Index da empresa que será executado o serviço</param>
        /// <param name="cUF">Código da UF</param>
        /// <param name="tpAmb">Código do ambiente que será acessado</param>
        /// <param name="tpEmis">Tipo de emissão do XML</param>
        /// <returns>Retorna o objeto do serviço</returns>
        /// <remarks>
        /// Autor: Wandrey Mundin Ferreira
        /// Data: 04/04/2011
        /// </remarks>
        public static WebServiceProxy DefinirWS(Servicos servico, int emp, int cUF, int tpAmb, int tpEmis)
        {
            return DefinirWS(servico, emp, cUF, tpAmb, tpEmis, 2);
        }

        /// <summary>
        /// Definir o local do WSDL do webservice
        /// </summary>
        /// <param name="CodigoUF">Código da UF que é para pesquisar a URL do WSDL</param>
        /// <param name="tipoAmbiente">Tipo de ambiente da NFe</param>
        /// <param name="tipoEmissao">Tipo de Emissao da NFe</param>
        /// <param name="servico">Serviço da NFe que está sendo executado</param>
        /// <returns>Retorna a URL</returns>
        /// <remarks>
        /// Autor: Wandrey Mundin Ferreira
        /// Data: 22/03/2011
        /// </remarks>
        private static string DefLocalWSDL(int CodigoUF, int tipoAmbiente, int tipoEmissao, Servicos servico)
        {
            return DefLocalWSDL(CodigoUF, tipoAmbiente, tipoEmissao, servico, 2);
        }

        #region DefLocalWSDL
        /// <summary>
        /// Definir o local do WSDL do webservice
        /// </summary>
        /// <param name="CodigoUF">Código da UF que é para pesquisar a URL do WSDL</param>
        /// <param name="tipoAmbiente">Tipo de ambiente da NFe</param>
        /// <param name="tipoEmissao">Tipo de Emissao da NFe</param>
        /// <param name="servico">Serviço da NFe que está sendo executado</param>
        /// <param name="versaoNFe">Versão da NFe</param>
        /// <returns>Retorna a URL</returns>
        /// <remarks>
        /// Autor: Wandrey Mundin Ferreira
        /// Data: 08/02/2010
        /// </remarks>
        private static string DefLocalWSDL(int CodigoUF, int tipoAmbiente, int tipoEmissao, Servicos servico, int versaoNFe)
        {
            string WSDL = string.Empty;
            switch (tipoEmissao)
            {
                case Propriedade.TipoEmissao.teSVCRS:
                    CodigoUF = 902;
                    break;

                case Propriedade.TipoEmissao.teSVCSP:
                    CodigoUF = 903;
                    break;

                case Propriedade.TipoEmissao.teSCAN:
                    CodigoUF = 900;
                    break;

                case Propriedade.TipoEmissao.teDPEC:
                    if (servico == Servicos.ConsultarDPEC || servico == Servicos.EnviarDPEC)//danasa 21/10/2010
                        CodigoUF = 901;
                    break;

                default:
                    break;
            }
            string ufNome = CodigoUF.ToString();  //danasa 20-9-2010            

            #region --varre a lista de webservices baseado no codigo da UF

            if (WebServiceProxy.webServicesList.Count == 0)
                throw new Exception("Lista de webservices não foi processada verifique se o arquivo 'WebService.xml' existe na pasta WSDL do UniNFe");

            foreach (webServices list in WebServiceProxy.webServicesList)
            {
                if (list.ID == CodigoUF)
                {
                    switch (servico)
                    {
                        #region NFe
                        case Servicos.CancelarNFe:
                            WSDL = (tipoAmbiente == Propriedade.TipoAmbiente.taHomologacao ? list.LocalHomologacao.NFeCancelamento : list.LocalProducao.NFeCancelamento);
                            break;

                        case Servicos.ConsultaCadastroContribuinte:
                            WSDL = (tipoAmbiente == Propriedade.TipoAmbiente.taHomologacao ? list.LocalHomologacao.NFeConsultaCadastro : list.LocalProducao.NFeConsultaCadastro);
                            break;

                        case Servicos.EnviarLoteNfe:
                        case Servicos.EnviarDPEC:
                            WSDL = (tipoAmbiente == Propriedade.TipoAmbiente.taHomologacao ? list.LocalHomologacao.NFeRecepcao : list.LocalProducao.NFeRecepcao);
                            break;

                        //case Servicos.EnviarDPEC:
                        //    WSDL = (tipoAmbiente == Propriedade.TipoAmbiente.taHomologacao ? list.LocalHomologacao.NFeRecepcao : list.LocalProducao.NFeRecepcao);
                        //    break;

                        case Servicos.InutilizarNumerosNFe:
                            WSDL = (tipoAmbiente == Propriedade.TipoAmbiente.taHomologacao ? list.LocalHomologacao.NFeInutilizacao : list.LocalProducao.NFeInutilizacao);
                            break;

                        case Servicos.PedidoConsultaSituacaoNFe:
                            if (versaoNFe.Equals(1))
                                WSDL = (tipoAmbiente == Propriedade.TipoAmbiente.taHomologacao ? list.LocalHomologacao.NFeConsulta1 : list.LocalProducao.NFeConsulta1);
                            else
                                WSDL = (tipoAmbiente == Propriedade.TipoAmbiente.taHomologacao ? list.LocalHomologacao.NFeConsulta : list.LocalProducao.NFeConsulta);
                            break;

                        case Servicos.ConsultarDPEC:
                            WSDL = (tipoAmbiente == Propriedade.TipoAmbiente.taHomologacao ? list.LocalHomologacao.NFeConsulta : list.LocalProducao.NFeConsulta);
                            break;

                        case Servicos.PedidoConsultaStatusServicoNFe:
                            WSDL = (tipoAmbiente == Propriedade.TipoAmbiente.taHomologacao ? list.LocalHomologacao.NFeStatusServico : list.LocalProducao.NFeStatusServico);
                            break;

                        case Servicos.PedidoSituacaoLoteNFe:
                            WSDL = (tipoAmbiente == Propriedade.TipoAmbiente.taHomologacao ? list.LocalHomologacao.NFeRetRecepcao : list.LocalProducao.NFeRetRecepcao);
                            break;

                        case Servicos.EnviarCCe:
                            WSDL = (tipoAmbiente == Propriedade.TipoAmbiente.taHomologacao ? list.LocalHomologacao.NFeCCe : list.LocalProducao.NFeCCe);
                            break;

                        case Servicos.ConsultaNFDest:
                            WSDL = (tipoAmbiente == Propriedade.TipoAmbiente.taHomologacao ? list.LocalHomologacao.NFeConsultaNFeDest : list.LocalProducao.NFeConsultaNFeDest);
                            break;

                        case Servicos.DownloadNFe:
                            WSDL = (tipoAmbiente == Propriedade.TipoAmbiente.taHomologacao ? list.LocalHomologacao.NFeDownload : list.LocalProducao.NFeDownload);
                            break;

                        case Servicos.EnviarEventoCancelamento:
                            WSDL = (tipoAmbiente == Propriedade.TipoAmbiente.taHomologacao ? list.LocalHomologacao.NFeCancelamentoEvento : list.LocalProducao.NFeCancelamentoEvento);
                            if (string.IsNullOrEmpty(WSDL))
                                WSDL = (tipoAmbiente == Propriedade.TipoAmbiente.taHomologacao ? list.LocalHomologacao.NFeCCe : list.LocalProducao.NFeCCe);
                            break;

                        case Servicos.EnviarManifDest:
                            WSDL = (tipoAmbiente == Propriedade.TipoAmbiente.taHomologacao ? list.LocalHomologacao.NFeManifDest : list.LocalProducao.NFeManifDest);
                            break;

                        case Servicos.RegistroDeSaida:
                            WSDL = (tipoAmbiente == Propriedade.TipoAmbiente.taHomologacao ? list.LocalHomologacao.NFeRegistroDeSaida : list.LocalProducao.NFeRegistroDeSaida);
                            break;

                        case Servicos.RegistroDeSaidaCancelamento:
                            WSDL = (tipoAmbiente == Propriedade.TipoAmbiente.taHomologacao ? list.LocalHomologacao.NFeRegistroDeSaidaCancelamento : list.LocalProducao.NFeRegistroDeSaidaCancelamento);
                            break;

                        #endregion

                        #region NFs-e
                        case Servicos.RecepcionarLoteRps:
                            WSDL = (tipoAmbiente == Propriedade.TipoAmbiente.taHomologacao ? list.LocalHomologacao.RecepcionarLoteRps : list.LocalProducao.RecepcionarLoteRps);
                            break;
                        case Servicos.ConsultarSituacaoLoteRps:
                            WSDL = (tipoAmbiente == Propriedade.TipoAmbiente.taHomologacao ? list.LocalHomologacao.ConsultarSituacaoLoteRps : list.LocalProducao.ConsultarSituacaoLoteRps);
                            break;
                        case Servicos.ConsultarNfsePorRps:
                            WSDL = (tipoAmbiente == Propriedade.TipoAmbiente.taHomologacao ? list.LocalHomologacao.ConsultarNfsePorRps : list.LocalProducao.ConsultarNfsePorRps);
                            break;
                        case Servicos.ConsultarNfse:
                            WSDL = (tipoAmbiente == Propriedade.TipoAmbiente.taHomologacao ? list.LocalHomologacao.ConsultarNfse : list.LocalProducao.ConsultarNfse);
                            break;
                        case Servicos.ConsultarLoteRps:
                            WSDL = (tipoAmbiente == Propriedade.TipoAmbiente.taHomologacao ? list.LocalHomologacao.ConsultarLoteRps : list.LocalProducao.ConsultarLoteRps);
                            break;
                        case Servicos.CancelarNfse:
                            WSDL = (tipoAmbiente == Propriedade.TipoAmbiente.taHomologacao ? list.LocalHomologacao.CancelarNfse : list.LocalProducao.CancelarNfse);
                            break;
                        case Servicos.ConsultarURLNfse:
                            WSDL = (tipoAmbiente == Propriedade.TipoAmbiente.taHomologacao ? list.LocalHomologacao.ConsultarURLNfse : list.LocalProducao.ConsultarURLNfse);
                            break;
                        #endregion
                    }
                    if (tipoEmissao == Propriedade.TipoEmissao.teDPEC)  //danasa 21/10/2010
                        ufNome = "DPEC";
                    else
                        ufNome = "de " + list.Nome;  //danasa 20-9-2010

                    break;
                }
            }
            #endregion

            if (string.IsNullOrEmpty(WSDL) || !File.Exists(WSDL))
            {
                if (!File.Exists(WSDL) && !string.IsNullOrEmpty(WSDL))
                    switch (Propriedade.TipoAplicativo)
                    {
                        case TipoAplicativo.Nfe:
                            throw new Exception("O arquivo \"" + WSDL + "\" não existe. Aconselhamos a reinstalação do UniNFe.");
                        case TipoAplicativo.Nfse:
                            throw new Exception("O arquivo \"" + WSDL + "\" não existe. Aconselhamos a reinstalação do UniNFSe.");
                        case TipoAplicativo.Cte:
                            throw new Exception("O arquivo \"" + WSDL + "\" não existe. Aconselhamos a reinstalação do UniCTe.");
                    }

                string Ambiente = string.Empty;
                switch (tipoAmbiente)
                {
                    case Propriedade.TipoAmbiente.taProducao:
                        Ambiente = "produção";
                        break;

                    case Propriedade.TipoAmbiente.taHomologacao:
                        Ambiente = "homologação";
                        break;
                }
                string errorStr = "O Estado " + ufNome + " ainda não dispõe deste serviço no layout {0} para o ambiente de " + Ambiente + ".";

                switch (servico)
                {
                    case Servicos.EnviarCCe:
                    case Servicos.EnviarEventoCancelamento:
                    case Servicos.EnviarManifDest:
                        throw new Exception(string.Format(errorStr, "de envio de eventos"));

                    case Servicos.ConsultaNFDest:
                        throw new Exception(string.Format(errorStr, "de envio de consulta a nfe do destinatário"));

                    case Servicos.DownloadNFe:
                        throw new Exception(string.Format(errorStr, "de envio de download de nfe do destinatário"));

                    default:
                        switch (servico)
                        {
                            case Servicos.CancelarNfse:
                            case Servicos.ConsultarURLNfse:
                            case Servicos.ConsultarLoteRps:
                            case Servicos.ConsultarNfse:
                            case Servicos.ConsultarNfsePorRps:
                            case Servicos.ConsultarSituacaoLoteRps:
                            case Servicos.RecepcionarLoteRps:
                                throw new Exception(string.Format(errorStr, "da NFS-e"));
                        }
                        throw new Exception(string.Format(errorStr, "4.0.1 da NF-e"));
                }
            }
            return WSDL;
        }
        #endregion

        #region GravarConfig()
        /// <summary>
        /// Método responsável por gravar as configurações da Aplicação no arquivo "UniNfeConfig.xml"
        /// </summary>
        /// <returns>Retorna true se conseguiu gravar corretamente as configurações ou false se não conseguiu</returns>
        public void GravarConfig(bool gravaArqEmpresa, bool validaCertificado)  //<<<<<<danasa 1-5-2011
        {
            try
            {
                ValidarConfig(validaCertificado);
                GravarConfigGeral();
                GravarConfigEmpresa();
                if (gravaArqEmpresa)        //<<<<<<danasa 1-5-2011
                {                           //<<<<<<danasa 1-5-2011
                    GravarArqEmpresas();    //<<<<<<danasa 1-5-2011
                }                           //<<<<<<danasa 1-5-2011
            }
            catch (Exception ex)
            {
                throw (ex);
            }
        }
        #endregion

        #region Gravar XML com as empresas cadastradas

        private void GravarArqEmpresas()
        {
            XmlWriterSettings oSettings = new XmlWriterSettings();
            UTF8Encoding c = new UTF8Encoding(false);

            //Para começar, vamos criar um XmlWriterSettings para configurar nosso XML
            oSettings.Encoding = c;
            oSettings.Indent = true;
            oSettings.IndentChars = "";
            oSettings.NewLineOnAttributes = false;
            oSettings.OmitXmlDeclaration = false;

            //Agora vamos criar um XML Writer
            XmlWriter oXmlGravar = XmlWriter.Create(Propriedade.NomeArqEmpresa, oSettings);

            //Agora vamos gravar os dados
            oXmlGravar.WriteStartDocument();
            oXmlGravar.WriteStartElement("Empresa");

            foreach (Empresa empresa in Empresa.Configuracoes)
            {
                //Abrir a tag <Registro>
                oXmlGravar.WriteStartElement("Registro");

                //Criar o atributo CNPJ dentro da tag Registro
                oXmlGravar.WriteStartAttribute("CNPJ");

                //Setar o conteúdo do atributo CNPJ
                oXmlGravar.WriteString(empresa.CNPJ);

                //Encerrar o atributo CNPJ
                oXmlGravar.WriteEndAttribute(); // Encerrar o atributo CNPJ

                //Criar a tag <Nome> com seu conteúdo </Nome>
                oXmlGravar.WriteElementString("Nome", empresa.Nome);

                //Encerrar a tag </Registro>
                oXmlGravar.WriteEndElement();
            }
            oXmlGravar.WriteEndElement(); //Encerrar o elemento Empresa
            oXmlGravar.WriteEndDocument();
            oXmlGravar.Flush();
            oXmlGravar.Close();
        }
        #endregion

        #region GravarConfigEmpresa()
        /// <summary>
        /// Gravar as configurações das empresas
        /// </summary>
        /// <remarks>
        /// Autor: Wandrey Mundin Ferreira
        /// Data: 30/07/2010
        /// </remarks>
        private void GravarConfigEmpresa()
        {
            XmlWriterSettings oSettings = new XmlWriterSettings();
            UTF8Encoding c = new UTF8Encoding(false);

            //Para começar, vamos criar um XmlWriterSettings para configurar nosso XML
            oSettings.Encoding = c;
            oSettings.Indent = true;
            oSettings.IndentChars = "";
            oSettings.NewLineOnAttributes = false;
            oSettings.OmitXmlDeclaration = false;

            foreach (Empresa empresa in Empresa.Configuracoes)
            {
                XmlWriter oXmlGravar = null;

                try
                {
                    //Criar pasta das configurações das empresas
                    string pasta = Propriedade.PastaExecutavel + "\\" + empresa.CNPJ.Trim();
                    if (!Directory.Exists(pasta))
                        Directory.CreateDirectory(pasta);

                    //Agora vamos criar um XML Writer
                    oXmlGravar = XmlWriter.Create(Propriedade.PastaExecutavel + "\\" + empresa.CNPJ.Trim() + "\\" + Propriedade.NomeArqConfig, oSettings);

                    //Agora vamos gravar os dados
                    oXmlGravar.WriteStartDocument();
                    oXmlGravar.WriteStartElement(NFeStrConstants.nfe_configuracoes);
                    oXmlGravar.WriteElementString(NFeStrConstants.PastaXmlEnvio, empresa.PastaEnvio);
                    oXmlGravar.WriteElementString(NFeStrConstants.PastaXmlRetorno, empresa.PastaRetorno);
                    oXmlGravar.WriteElementString(NFeStrConstants.PastaXmlEnviado, empresa.PastaEnviado);
                    oXmlGravar.WriteElementString(NFeStrConstants.PastaXmlErro, empresa.PastaErro);
                    oXmlGravar.WriteElementString(NFeStrConstants.PastaBackup, empresa.PastaBackup);
                    oXmlGravar.WriteElementString(NFeStrConstants.PastaXmlEmLote, empresa.PastaEnvioEmLote);
                    oXmlGravar.WriteElementString(NFeStrConstants.PastaValidar, empresa.PastaValidar);
                    oXmlGravar.WriteElementString(NFeStrConstants.PastaDownloadNFeDest, empresa.PastaDownloadNFeDest);
                    oXmlGravar.WriteElementString(NFeStrConstants.UnidadeFederativaCodigo, empresa.UFCod.ToString());
                    oXmlGravar.WriteElementString(NFeStrConstants.AmbienteCodigo, empresa.tpAmb.ToString());
                    oXmlGravar.WriteElementString(NFeStrConstants.CertificadoDigital, empresa.Certificado);
                    oXmlGravar.WriteElementString(NFeStrConstants.CertificadoInstalado, empresa.CertificadoInstalado.ToString());
                    oXmlGravar.WriteElementString(NFeStrConstants.CertificadoArquivo, empresa.CertificadoArquivo.ToString());
                    oXmlGravar.WriteElementString(NFeStrConstants.CertificadoSenha, Criptografia.criptografaSenha(empresa.CertificadoSenha));
                    oXmlGravar.WriteElementString(NFeStrConstants.tpEmis, empresa.tpEmis.ToString());
                    oXmlGravar.WriteElementString(NFeStrConstants.GravarRetornoTXTNFe, empresa.GravarRetornoTXTNFe.ToString());
                    oXmlGravar.WriteElementString(NFeStrConstants.GravarEventosDeTerceiros, empresa.GravarEventosDeTerceiros.ToString());
                    oXmlGravar.WriteElementString(NFeStrConstants.GravarEventosNaPastaEnviadosNFe, empresa.GravarEventosNaPastaEnviadosNFe.ToString());
                    oXmlGravar.WriteElementString(NFeStrConstants.GravarEventosCancelamentoNaPastaEnviadosNFe, empresa.GravarEventosCancelamentoNaPastaEnviadosNFe.ToString());
                    oXmlGravar.WriteElementString(NFeStrConstants.DiretorioSalvarComo, empresa.DiretorioSalvarComo.ToString());
                    oXmlGravar.WriteElementString(NFeStrConstants.DiasLimpeza, empresa.DiasLimpeza.ToString());
                    oXmlGravar.WriteElementString(NFeStrConstants.PastaExeUniDanfe, empresa.PastaExeUniDanfe.ToString());
                    oXmlGravar.WriteElementString(NFeStrConstants.PastaConfigUniDanfe, empresa.PastaConfigUniDanfe.ToString());
                    oXmlGravar.WriteElementString(NFeStrConstants.PastaDanfeMon, empresa.PastaDanfeMon.ToString());
                    oXmlGravar.WriteElementString(NFeStrConstants.XMLDanfeMonNFe, empresa.XMLDanfeMonNFe.ToString());
                    oXmlGravar.WriteElementString(NFeStrConstants.XMLDanfeMonProcNFe, empresa.XMLDanfeMonProcNFe.ToString());
                    oXmlGravar.WriteElementString(NFeStrConstants.XMLDanfeMonDenegadaNFe, empresa.XMLDanfeMonDenegadaNFe.ToString());
                    oXmlGravar.WriteElementString(NFeStrConstants.TempoConsulta, empresa.TempoConsulta.ToString());
                    ///
                    /// informacoes do FTP
                    /// danasa 7/7/2011
                    oXmlGravar.WriteElementString(NFeStrConstants.FTPAtivo, empresa.FTPAtivo.ToString());
                    oXmlGravar.WriteElementString(NFeStrConstants.FTPGravaXMLPastaUnica, empresa.FTPGravaXMLPastaUnica.ToString());
                    oXmlGravar.WriteElementString(NFeStrConstants.FTPNomeDoUsuario, empresa.FTPNomeDoUsuario.ToString());
                    oXmlGravar.WriteElementString(NFeStrConstants.FTPNomeDoServidor, empresa.FTPNomeDoServidor.ToString());
                    oXmlGravar.WriteElementString(NFeStrConstants.FTPPastaAutorizados, empresa.FTPPastaAutorizados.ToString());
                    oXmlGravar.WriteElementString(NFeStrConstants.FTPPastaRetornos, empresa.FTPPastaRetornos.ToString());
                    oXmlGravar.WriteElementString(NFeStrConstants.FTPPorta, empresa.FTPPorta.ToString());
                    oXmlGravar.WriteElementString(NFeStrConstants.FTPSenha, empresa.FTPSenha.ToString());

                    if (empresa.CertificadoInstalado)
                    {
                        //oXmlGravar.WriteElementString(NFeStrConstants.CertificadoDigitalThumbPrint, empresa.X509Certificado.Thumbprint);
                        oXmlGravar.WriteElementString(NFeStrConstants.CertificadoDigitalThumbPrint, empresa.CertificadoThumbPrint);
                    }

                    oXmlGravar.WriteElementString(NFeStrConstants.UsuarioWS, (empresa.UsuarioWS == null ? "" : empresa.UsuarioWS.ToString()));
                    oXmlGravar.WriteElementString(NFeStrConstants.SenhaWS, (empresa.SenhaWS == null ? "" : empresa.SenhaWS.ToString()));

                    oXmlGravar.WriteEndElement(); //nfe_configuracoes
                    oXmlGravar.WriteEndDocument();
                    oXmlGravar.Flush();
                }
                catch (Exception ex)
                {
                    throw (ex);
                }
                finally
                {
                    if (oXmlGravar != null)
                        oXmlGravar.Close();
                }
            }
        }
        #endregion

        #region GravarConfigGeral()
        /// <summary>
        /// Gravar as configurações gerais
        /// </summary>
        /// <remarks>
        /// Autor: Wandrey Mundin Ferreira
        /// Data: 30/07/2010
        /// </remarks>
        private void GravarConfigGeral()
        {
            XmlWriterSettings oSettings = new XmlWriterSettings();
            UTF8Encoding c = new UTF8Encoding(false);

            //Para começar, vamos criar um XmlWriterSettings para configurar nosso XML
            oSettings.Encoding = c;
            oSettings.Indent = true;
            oSettings.IndentChars = "";
            oSettings.NewLineOnAttributes = false;
            oSettings.OmitXmlDeclaration = false;

            XmlWriter oXmlGravar = null;

            try
            {
                //Agora vamos criar um XML Writer
                oXmlGravar = XmlWriter.Create(Propriedade.PastaExecutavel + "\\" + Propriedade.NomeArqConfig, oSettings);

                //Agora vamos gravar os dados
                oXmlGravar.WriteStartDocument();
                oXmlGravar.WriteStartElement(NFeStrConstants.nfe_configuracoes);
                oXmlGravar.WriteElementString(NfeConfiguracoes.Proxy.ToString(), ConfiguracaoApp.Proxy.ToString());
                oXmlGravar.WriteElementString(NfeConfiguracoes.ProxyServidor.ToString(), ConfiguracaoApp.ProxyServidor);
                oXmlGravar.WriteElementString(NfeConfiguracoes.ProxyUsuario.ToString(), ConfiguracaoApp.ProxyUsuario);
                oXmlGravar.WriteElementString(NfeConfiguracoes.ProxySenha.ToString(), ConfiguracaoApp.ProxySenha);
                oXmlGravar.WriteElementString(NfeConfiguracoes.ProxyPorta.ToString(), ConfiguracaoApp.ProxyPorta.ToString());
                oXmlGravar.WriteElementString(NfeConfiguracoes.ChecarConexaoInternet.ToString(), ConfiguracaoApp.ChecarConexaoInternet.ToString());
                oXmlGravar.WriteElementString(NfeConfiguracoes.GravarLogOperacaoRealizada.ToString(), ConfiguracaoApp.GravarLogOperacoesRealizadas.ToString());
                if (!string.IsNullOrEmpty(ConfiguracaoApp.SenhaConfig))
                {
                    if (ConfiguracaoApp.mSenhaConfigAlterada)
                    {
                        ConfiguracaoApp.SenhaConfig = Functions.GerarMD5(ConfiguracaoApp.SenhaConfig);
                    }

                    oXmlGravar.WriteElementString(NfeConfiguracoes.SenhaConfig.ToString(), ConfiguracaoApp.SenhaConfig);
                    ConfiguracaoApp.mSenhaConfigAlterada = false;
                }

                oXmlGravar.WriteEndElement(); //nfe_configuracoes
                oXmlGravar.WriteEndDocument();
                oXmlGravar.Flush();
            }
            catch (Exception ex)
            {
                throw (ex);
            }
            finally
            {
                if (oXmlGravar != null)
                    oXmlGravar.Close();
            }
        }
        #endregion

        #region ValidarConfig()
        /// <summary>
        /// Verifica se algumas das informações das configurações tem algum problema ou falha
        /// </summary>
        /// <param name="validarCertificado">Se valida se tem certificado informado ou não nas configurações</param>
        private void ValidarConfig(bool validarCertificado)
        {
            try
            {
                string erro = string.Empty;
                bool validou = true;

                #region Remover End Slash
                for (int i = 0; i < Empresa.Configuracoes.Count; i++)
                {
                    Empresa.Configuracoes[i].PastaEnvio = ConfiguracaoApp.RemoveEndSlash(Empresa.Configuracoes[i].PastaEnvio);
                    Empresa.Configuracoes[i].PastaEnviado = ConfiguracaoApp.RemoveEndSlash(Empresa.Configuracoes[i].PastaEnviado);
                    Empresa.Configuracoes[i].PastaErro = ConfiguracaoApp.RemoveEndSlash(Empresa.Configuracoes[i].PastaErro);
                    Empresa.Configuracoes[i].PastaRetorno = ConfiguracaoApp.RemoveEndSlash(Empresa.Configuracoes[i].PastaRetorno);
                    Empresa.Configuracoes[i].PastaBackup = ConfiguracaoApp.RemoveEndSlash(Empresa.Configuracoes[i].PastaBackup);
                    Empresa.Configuracoes[i].PastaEnvioEmLote = ConfiguracaoApp.RemoveEndSlash(Empresa.Configuracoes[i].PastaEnvioEmLote);
                    Empresa.Configuracoes[i].PastaDownloadNFeDest = ConfiguracaoApp.RemoveEndSlash(Empresa.Configuracoes[i].PastaDownloadNFeDest);
                    Empresa.Configuracoes[i].PastaValidar = ConfiguracaoApp.RemoveEndSlash(Empresa.Configuracoes[i].PastaValidar);
                    Empresa.Configuracoes[i].PastaDanfeMon = ConfiguracaoApp.RemoveEndSlash(Empresa.Configuracoes[i].PastaDanfeMon);
                    Empresa.Configuracoes[i].PastaExeUniDanfe = ConfiguracaoApp.RemoveEndSlash(Empresa.Configuracoes[i].PastaExeUniDanfe);
                    Empresa.Configuracoes[i].PastaConfigUniDanfe = ConfiguracaoApp.RemoveEndSlash(Empresa.Configuracoes[i].PastaConfigUniDanfe);
                }
                #endregion

                #region Verificar a duplicação de nome de pastas que não pode existir
                if (validou)
                {
                    List<FolderCompare> fc = new List<FolderCompare>();

                    for (int i = 0; i < Empresa.Configuracoes.Count; i++)
                    {
                        fc.Add(new FolderCompare(i, Empresa.Configuracoes[i].PastaEnvio));
                        fc.Add(new FolderCompare(i + 1, Empresa.Configuracoes[i].PastaEnvioEmLote));
                        fc.Add(new FolderCompare(i + 2, Empresa.Configuracoes[i].PastaRetorno));
                        fc.Add(new FolderCompare(i + 3, Empresa.Configuracoes[i].PastaEnviado));
                        fc.Add(new FolderCompare(i + 4, Empresa.Configuracoes[i].PastaErro));
                        fc.Add(new FolderCompare(i + 5, Empresa.Configuracoes[i].PastaBackup));
                        fc.Add(new FolderCompare(i + 6, Empresa.Configuracoes[i].PastaValidar));
                        fc.Add(new FolderCompare(i + 6, Empresa.Configuracoes[i].PastaDownloadNFeDest));
                    }

                    foreach (FolderCompare fc1 in fc)
                    {
                        if (string.IsNullOrEmpty(fc1.folder))
                            continue;

                        foreach (FolderCompare fc2 in fc)
                        {
                            if (fc1.id != fc2.id)
                            {
                                if (fc1.folder.ToLower().Equals(fc2.folder.ToLower()))
                                {
                                    erro = "Não é permitido a utilização de pasta idênticas na mesma ou entre as empresas..";
                                    validou = false;
                                    break;
                                }
                            }
                        }
                        if (!validou)
                            break;
                    }
                }
                #endregion

                if (validou)
                {
                    for (int i = 0; i < Empresa.Configuracoes.Count; i++)
                    {
                        Empresa empresa = Empresa.Configuracoes[i];
                        List<string> diretorios = new List<string>();
                        List<string> mensagens = new List<string>();

                        #region Verificar se tem alguma pasta em branco
                        diretorios.Clear(); mensagens.Clear();
                        diretorios.Add(empresa.PastaEnviado); mensagens.Add("Informe a pasta para arquivamento dos arquivos XML enviados.");
                        diretorios.Add(empresa.PastaEnvio); mensagens.Add("Informe a pasta de envio dos arquivos XML.");
                        diretorios.Add(empresa.PastaRetorno); mensagens.Add("Informe a pasta de retorno dos arquivos XML.");
                        diretorios.Add(empresa.PastaErro); mensagens.Add("Informe a pasta para arquivamento temporário dos arquivos XML que apresentaram erros.");
                        diretorios.Add(empresa.PastaBackup); mensagens.Add("Informe a pasta para o Backup dos arquivos XML enviados.");
                        diretorios.Add(empresa.PastaValidar); mensagens.Add("Informe a pasta onde será gravado os arquivos XML somente para ser validado pela Aplicação.");
                        //diretorios.Add(empresa.PastaDownloadNFeDest); mensagens.Add("Informe a pasta onde será gravado os arquivos XML de download de destinatário.");

                        for (int b = 0; b < diretorios.Count; b++)
                        {
                            if (diretorios[b].Equals(string.Empty))
                            {
                                erro = mensagens[b].Trim() + "\r\n" + Empresa.Configuracoes[i].Nome + "\r\n" + Empresa.Configuracoes[i].CNPJ;
                                validou = false;
                                break;
                            }
                        }
                        ///
                        /// informacoes do FTP
                        /// danasa 7/7/2011
                        if (empresa.FTPIsAlive)
                        {
                            if (string.IsNullOrEmpty(empresa.FTPPastaAutorizados))
                            {
                                erro = "Informe a pasta do FTP de destino dos autorizados\r\n" + Empresa.Configuracoes[i].Nome + "\r\n" + Empresa.Configuracoes[i].CNPJ;
                                validou = false;
                            }
                        }
                        #endregion

                        #region Verificar se o certificado foi informado
                        if (validarCertificado)
                        {
                            if (validou)
                            {
                                string aplicacao = "NF-e";
                                switch (Propriedade.TipoAplicativo)
                                {
                                    case TipoAplicativo.Cte:
                                        aplicacao = "CT-e";
                                        break;
                                    case TipoAplicativo.Nfse:
                                        aplicacao = "NFs-e";
                                        break;
                                }
                                if (empresa.CertificadoInstalado && empresa.CertificadoThumbPrint.Equals(string.Empty))
                                {
                                    erro = "Selecione o certificado digital a ser utilizado na autenticação dos serviços da " + aplicacao + ".\r\n" + Empresa.Configuracoes[i].Nome + "\r\n" + Empresa.Configuracoes[i].CNPJ;
                                    validou = false;
                                }
                                if (!empresa.CertificadoInstalado)
                                {
                                    if (empresa.CertificadoArquivo.Equals(string.Empty))
                                    {
                                        erro = "Informe o local de armazenamento do certificado digital a ser utilizado na autenticação dos serviços da " + aplicacao + ".\r\n" + Empresa.Configuracoes[i].Nome + "\r\n" + Empresa.Configuracoes[i].CNPJ;
                                        validou = false;
                                    }
                                    else if (!File.Exists(empresa.CertificadoArquivo))
                                    {
                                        erro = "Arquivo do certificado digital a ser utilizado na autenticação dos serviços da " + aplicacao + " não foi encontrado.\r\n" + Empresa.Configuracoes[i].Nome + "\r\n" + Empresa.Configuracoes[i].CNPJ;
                                        validou = false;
                                    }
                                    else if (empresa.CertificadoSenha.Equals(string.Empty))
                                    {
                                        erro = "Informe a senha do certificado digital a ser utilizado na autenticação dos serviços da " + aplicacao + ".\r\n" + Empresa.Configuracoes[i].Nome + "\r\n" + Empresa.Configuracoes[i].CNPJ;
                                        validou = false;
                                    }
                                    else
                                    {
                                        try
                                        {
                                            using (FileStream fs = new FileStream(empresa.CertificadoArquivo, FileMode.Open))
                                            {
                                                byte[] buffer = new byte[fs.Length];
                                                fs.Read(buffer, 0, buffer.Length);
                                                empresa.X509Certificado = new X509Certificate2(buffer, empresa.CertificadoSenha);
                                            }
                                        }
                                        catch (System.Security.Cryptography.CryptographicException ex)
                                        {
                                            erro = ex.Message + ".\r\n" + empresa.Nome + "\r\n" + empresa.CNPJ;
                                            validou = false;
                                        }
                                        catch (Exception ex)
                                        {
                                            erro = ex.Message + ".\r\n" + empresa.Nome + "\r\n" + empresa.CNPJ;
                                            validou = false;
                                        }
                                    }
                                }
                            }
                        }
                        #endregion

                        #region Verificar se as pastas informadas existem
                        if (validou)
                        {
                            //Fazer um pequeno ajuste na pasta de configuração do unidanfe antes de verificar sua existência
                            if (empresa.PastaConfigUniDanfe.Trim() != string.Empty)
                            {
                                if (!string.IsNullOrEmpty(empresa.PastaConfigUniDanfe))
                                {
                                    while (Empresa.Configuracoes[i].PastaConfigUniDanfe.Substring(Empresa.Configuracoes[i].PastaConfigUniDanfe.Length - 6, 6).ToLower() == @"\dados" && !string.IsNullOrEmpty(Empresa.Configuracoes[i].PastaConfigUniDanfe))
                                        Empresa.Configuracoes[i].PastaConfigUniDanfe = Empresa.Configuracoes[i].PastaConfigUniDanfe.Substring(0, Empresa.Configuracoes[i].PastaConfigUniDanfe.Length - 6);
                                }
                                Empresa.Configuracoes[i].PastaConfigUniDanfe = Empresa.Configuracoes[i].PastaConfigUniDanfe.Replace("\r\n", "").Trim();

                                empresa.PastaConfigUniDanfe = Empresa.Configuracoes[i].PastaConfigUniDanfe;
                            }

                            if (empresa.PastaEnvio.ToLower().EndsWith("temp"))
                            {
                                erro = "Pasta de envio não pode terminar com a subpasta 'temp'.\r\n" + empresa.Nome + "\r\n" + empresa.CNPJ;
                                validou = false;
                            }
                            else
                                if (empresa.PastaEnvioEmLote.ToLower().EndsWith("temp"))
                                {
                                    erro = "Pasta de envio em lote não pode terminar com a subpasta 'temp'.\r\n" + empresa.Nome + "\r\n" + empresa.CNPJ;
                                    validou = false;
                                }
                                else
                                    if (empresa.PastaValidar.ToLower().EndsWith("temp"))
                                    {
                                        erro = "Pasta de validação não pode terminar com a subpasta 'temp'.\r\n" + empresa.Nome + "\r\n" + empresa.CNPJ;
                                        validou = false;
                                    }
                                    else
                                        if (empresa.PastaErro.ToLower().EndsWith("temp"))
                                        {
                                            erro = "Pasta de XML's com erro na tentativa de envio não pode terminar com a subpasta 'temp'.\r\n" + empresa.Nome + "\r\n" + empresa.CNPJ;
                                            validou = false;
                                        }

                            if (validou)
                            {
                                diretorios.Clear(); mensagens.Clear();
                                diretorios.Add(empresa.PastaEnvio.Trim()); mensagens.Add("A pasta de envio dos arquivos XML informada não existe.");
                                diretorios.Add(empresa.PastaRetorno.Trim()); mensagens.Add("A pasta de retorno dos arquivos XML informada não existe.");
                                diretorios.Add(empresa.PastaEnviado.Trim()); mensagens.Add("A pasta para arquivamento dos arquivos XML enviados informada não existe.");
                                diretorios.Add(empresa.PastaErro.Trim()); mensagens.Add("A pasta para arquivamento temporário dos arquivos XML com erro informada não existe.");
                                diretorios.Add(empresa.PastaBackup.Trim()); mensagens.Add("A pasta para backup dos XML enviados informada não existe.");
                                diretorios.Add(empresa.PastaValidar.Trim()); mensagens.Add("A pasta para validação de XML´s informada não existe.");
                                diretorios.Add(empresa.PastaDownloadNFeDest.Trim()); mensagens.Add("A pasta para arquivamento das NFe de destinatários informada não existe.");
                                diretorios.Add(empresa.PastaEnvioEmLote.Trim()); mensagens.Add("A pasta de envio das notas fiscais eletrônicas em lote informada não existe.");
                                diretorios.Add(empresa.PastaDanfeMon.Trim()); mensagens.Add("A pasta informada para gravação do XML da NFe para o DANFeMon não existe.");
                                diretorios.Add(empresa.PastaExeUniDanfe.Trim()); mensagens.Add("A pasta do executável do UniDANFe informada não existe.");
                                diretorios.Add(empresa.PastaConfigUniDanfe.Trim()); mensagens.Add("A pasta do arquivo de configurações do UniDANFe informada não existe.");

                                for (int b = 0; b < diretorios.Count; b++)
                                {
                                    if (!string.IsNullOrEmpty(diretorios[b]))
                                    {
                                        if (!Directory.Exists(diretorios[b]))
                                        {
                                            if (empresa.CriaPastasAutomaticamente)
                                            {
                                                Directory.CreateDirectory(diretorios[b]);
                                            }
                                            else
                                            {
                                                erro = mensagens[b].Trim() + "\r\n" + empresa.Nome + "\r\n" + empresa.CNPJ;
                                                validou = false;
                                                break;
                                            }
                                        }
                                    }
                                }
                            }

                            #region Criar pasta Temp dentro da pasta de envio, envio em lote e validar
                            //Criar pasta Temp dentro da pasta de envio, envio em Lote e Validar. Wandrey 03/08/2011
                            if (validou)
                            {
                                if (Directory.Exists(empresa.PastaEnvio.Trim()))
                                {
                                    if (!Directory.Exists(empresa.PastaEnvio.Trim() + "\\Temp"))
                                    {
                                        Directory.CreateDirectory(empresa.PastaEnvio.Trim() + "\\Temp");
                                    }
                                }

                                if (Directory.Exists(empresa.PastaEnvioEmLote.Trim()))
                                {
                                    if (!Directory.Exists(empresa.PastaEnvioEmLote.Trim() + "\\Temp"))
                                    {
                                        Directory.CreateDirectory(empresa.PastaEnvioEmLote.Trim() + "\\Temp");
                                    }
                                }

                                if (Directory.Exists(empresa.PastaValidar.Trim()))
                                {
                                    if (!Directory.Exists(empresa.PastaValidar.Trim() + "\\Temp"))
                                    {
                                        Directory.CreateDirectory(empresa.PastaValidar.Trim() + "\\Temp");
                                    }
                                }
                            }
                            #endregion
                        }
                        #endregion

                        #region Verificar se as pastas configuradas do unidanfe estão corretas
                        if (validou && empresa.PastaExeUniDanfe.Trim() != string.Empty)
                        {
                            if (!File.Exists(empresa.PastaExeUniDanfe + "\\unidanfe.exe"))
                            {
                                erro = "O executável do UniDANFe não foi localizado na pasta informada.\r\n" + empresa.Nome + "\r\n" + empresa.CNPJ;
                                validou = false;
                            }
                        }

                        if (validou && empresa.PastaConfigUniDanfe.Trim() != string.Empty)
                        {
                            //Verificar a existência o arquivo de configuração
                            if (!File.Exists(empresa.PastaConfigUniDanfe + "\\dados\\config.tps"))
                            {
                                erro = "O arquivo de configuração do UniDANFe não foi localizado na pasta informada.\r\n" + empresa.Nome + "\r\n" + empresa.CNPJ;
                                validou = false;
                            }
                        }
                        #endregion
                    }
                }
                if (!validou)
                {
                    throw new Exception(erro);
                }
            }
            catch (Exception ex)
            {
                throw (ex);
            }
        }
        #endregion

        #region ReconfigurarUniNFe()
        /// <summary>
        /// Método responsável por reconfigurar automaticamente o UniNFe a partir de um XML com as 
        /// informações necessárias.
        /// O Método grava um arquivo na pasta de retorno do UniNFe com a informação se foi bem 
        /// sucedida a reconfiguração ou não.
        /// </summary>
        /// <param name="cArquivoXml">Nome e pasta do arquivo de configurações gerado pelo ERP para atualização das configurações do uninfe</param>
        public void ReconfigurarUniNFe(string cArquivoXml)
        {
            int emp = new FindEmpresaThread(Thread.CurrentThread).Index;

            string cStat = "";
            string xMotivo = "";
            bool lErro = false;
            bool lEncontrouTag = false;

            try
            {
                emp = CadastrarEmpresa(cArquivoXml, emp);

                try
                {
                    if (Path.GetExtension(cArquivoXml).ToLower() == ".txt")
                    {
                        #region Formato TXT
                        List<string> cLinhas = Functions.LerArquivo(cArquivoXml);

                        foreach (string texto in cLinhas)
                        {
                            string[] dados = texto.Split('|');
                            int nElementos = dados.GetLength(0);
                            if (nElementos <= 1)
                                continue;

                            switch (dados[0].ToLower())
                            {
                                case "pastaxmlenvio":
                                    Empresa.Configuracoes[emp].PastaEnvio = (nElementos == 2 ? ConfiguracaoApp.RemoveEndSlash(dados[1].Trim()) : "");
                                    lEncontrouTag = true;
                                    break;
                                case "pastaxmlemlote":
                                    Empresa.Configuracoes[emp].PastaEnvioEmLote = (nElementos == 2 ? ConfiguracaoApp.RemoveEndSlash(dados[1].Trim()) : "");
                                    lEncontrouTag = true;
                                    break;
                                case "pastaxmlretorno":
                                    Empresa.Configuracoes[emp].PastaRetorno = (nElementos == 2 ? ConfiguracaoApp.RemoveEndSlash(dados[1].Trim()) : "");
                                    lEncontrouTag = true;
                                    break;
                                case "pastaxmlenviado": //Se a tag <PastaXmlEnviado> existir ele pega no novo conteúdo
                                    Empresa.Configuracoes[emp].PastaEnviado = (nElementos == 2 ? ConfiguracaoApp.RemoveEndSlash(dados[1].Trim()) : "");
                                    lEncontrouTag = true;
                                    break;
                                case "pastaxmlerro":    //Se a tag <PastaXmlErro> existir ele pega no novo conteúdo
                                    Empresa.Configuracoes[emp].PastaErro = (nElementos == 2 ? ConfiguracaoApp.RemoveEndSlash(dados[1].Trim()) : "");
                                    lEncontrouTag = true;
                                    break;
                                case "unidadefederativacodigo": //Se a tag <UnidadeFederativaCodigo> existir ele pega no novo conteúdo
                                    Empresa.Configuracoes[emp].UFCod = (nElementos == 2 ? Convert.ToInt32("0" + dados[1].Trim()) : 0);
                                    lEncontrouTag = true;
                                    break;
                                case "ambientecodigo":  //Se a tag <AmbienteCodigo> existir ele pega no novo conteúdo
                                    Empresa.Configuracoes[emp].tpAmb = (nElementos == 2 ? Convert.ToInt32("0" + dados[1].Trim()) : 1);
                                    lEncontrouTag = true;
                                    break;
                                case "tpemis":  //Se a tag <tpEmis> existir ele pega no novo conteúdo
                                    Empresa.Configuracoes[emp].tpEmis = (nElementos == 2 ? Convert.ToInt32("0" + dados[1].Trim()) : 0);
                                    lEncontrouTag = true;
                                    break;
                                case "pastabackup": //Se a tag <PastaBackup> existir ele pega no novo conteúdo
                                    Empresa.Configuracoes[emp].PastaBackup = (nElementos == 2 ? ConfiguracaoApp.RemoveEndSlash(dados[1].Trim()) : "");
                                    lEncontrouTag = true;
                                    break;
                                case "pastadownloadnfedest": //Se a tag <PastaDownloadNFeDest> existir ele pega no novo conteúdo
                                    Empresa.Configuracoes[emp].PastaDownloadNFeDest = (nElementos == 2 ? ConfiguracaoApp.RemoveEndSlash(dados[1].Trim()) : "");
                                    lEncontrouTag = true;
                                    break;
                                case "pastavalidar":    //Se a tag <PastaValidar> existir ele pega no novo conteúdo
                                    Empresa.Configuracoes[emp].PastaValidar = (nElementos == 2 ? ConfiguracaoApp.RemoveEndSlash(dados[1].Trim()) : "");
                                    lEncontrouTag = true;
                                    break;
                                case "gravarretornotxtnfe": //Se a tag <PastaValidar> existir ele pega no novo conteúdo
                                    Empresa.Configuracoes[emp].GravarRetornoTXTNFe = (nElementos == 2 ? dados[1].Trim() == "True" : false);
                                    lEncontrouTag = true;
                                    break;
                                case "gravareventosdeterceiros":
                                    Empresa.Configuracoes[emp].GravarEventosDeTerceiros = (nElementos == 2 ? dados[1].Trim() == "True" : false);
                                    lEncontrouTag = true;
                                    break;
                                case "gravareventosnapastaenviadosnfe":
                                    Empresa.Configuracoes[emp].GravarEventosNaPastaEnviadosNFe = (nElementos == 2 ? dados[1].Trim() == "True" : false);
                                    lEncontrouTag = true;
                                    break;
                                case "gravareventoscancelamentonapastaenviadosnfe":
                                    Empresa.Configuracoes[emp].GravarEventosCancelamentoNaPastaEnviadosNFe = (nElementos == 2 ? dados[1].Trim() == "True" : false);
                                    lEncontrouTag = true;
                                    break;
                                case "diretoriosalvarcomo": //Se a tag <DiretorioSalvarComo> existir ele pega no novo conteúdo
                                    Empresa.Configuracoes[emp].DiretorioSalvarComo = (nElementos == 2 ? dados[1].Trim() : "");
                                    lEncontrouTag = true;
                                    break;
                                case "diaslimpeza": //Se a tag <DiasLimpeza> existir ele pega o novo conteúdo
                                    Empresa.Configuracoes[emp].DiasLimpeza = (nElementos == 2 ? Convert.ToInt32("0" + dados[1].Trim()) : 0);
                                    lEncontrouTag = true;
                                    break;
                                case "proxy": //Se a tag <Proxy> existir ele pega o novo conteúdo
                                    ConfiguracaoApp.Proxy = (nElementos == 2 ? Convert.ToBoolean(dados[1].Trim()) : false);
                                    lEncontrouTag = true;
                                    break;
                                case "proxyservidor": //Se a tag <ProxyServidor> existir ele pega o novo conteúdo
                                    ConfiguracaoApp.ProxyServidor = (nElementos == 2 ? dados[1].Trim() : "");
                                    lEncontrouTag = true;
                                    break;
                                case "proxyusuario": //Se a tag <ProxyUsuario> existir ele pega o novo conteúdo
                                    ConfiguracaoApp.ProxyUsuario = (nElementos == 2 ? dados[1].Trim() : "");
                                    lEncontrouTag = true;
                                    break;
                                case "proxysenha": //Se a tag <ProxySenha> existir ele pega o novo conteúdo
                                    ConfiguracaoApp.ProxySenha = (nElementos == 2 ? dados[1].Trim() : "");
                                    lEncontrouTag = true;
                                    break;
                                case "proxyporta": //Se a tag <ProxyPorta> existir ele pega o novo conteúdo
                                    ConfiguracaoApp.ProxyPorta = (nElementos == 2 ? Convert.ToInt32("0" + dados[1].Trim()) : 0);
                                    lEncontrouTag = true;
                                    break;
                                case "checarconexaointernet": //Se a tag <ChecarConexaoInternet> existir ele pega o novo conteúdo
                                    ConfiguracaoApp.ChecarConexaoInternet = (nElementos == 2 ? Convert.ToBoolean(dados[1].Trim()) : true);
                                    lEncontrouTag = true;
                                    break;
                                case "gravarlogoperacaorealizada":
                                    ConfiguracaoApp.GravarLogOperacoesRealizadas = (nElementos == 2 ? Convert.ToBoolean(dados[1].Trim()) : true);
                                    lEncontrouTag = true;
                                    break;
                                case "pastaexeunidanfe": //Se a tag <PastaExeUniDanfe> existir ele pega no novo conteúdo
                                    Empresa.Configuracoes[emp].PastaExeUniDanfe = (nElementos == 2 ? ConfiguracaoApp.RemoveEndSlash(dados[1].Trim()) : "");
                                    lEncontrouTag = true;
                                    break;
                                case "pastaconfigunidanfe": //Se a tag <PastaConfigUniDanfe> existir ele pega no novo conteúdo
                                    Empresa.Configuracoes[emp].PastaConfigUniDanfe = (nElementos == 2 ? ConfiguracaoApp.RemoveEndSlash(dados[1].Trim()) : "");
                                    lEncontrouTag = true;
                                    break;
                                case "pastadanfemon": //Se a tag <PastaDanfeMon> existir ele pega no novo conteúdo
                                    Empresa.Configuracoes[emp].PastaDanfeMon = (nElementos == 2 ? ConfiguracaoApp.RemoveEndSlash(dados[1].Trim()) : "");
                                    lEncontrouTag = true;
                                    break;
                                case "xmldanfemonnfe": //Se a tag <XMLDanfeMonNFe> existir ele pega no novo conteúdo
                                    Empresa.Configuracoes[emp].XMLDanfeMonNFe = (nElementos == 2 ? dados[1].Trim() == "True" : false);
                                    lEncontrouTag = true;
                                    break;
                                case "xmldanfemonprocnfe": //Se a tag <XMLDanfeMonProcNFe> existir ele pega no novo conteúdo
                                    Empresa.Configuracoes[emp].XMLDanfeMonProcNFe = (nElementos == 2 ? dados[1].Trim() == "True" : false);
                                    lEncontrouTag = true;
                                    break;
                                case "xmldanfemondenegadanfe": //Se a tag <XMLDanfeMonProcNFe> existir ele pega no novo conteúdo
                                    Empresa.Configuracoes[emp].XMLDanfeMonDenegadaNFe = (nElementos == 2 ? dados[1].Trim() == "True" : false);
                                    lEncontrouTag = true;
                                    break;
                                case "senhaconfig": //Se a tag <senhaconfig> existir ele pega o novo conteúdo
                                    ConfiguracaoApp.SenhaConfig = (nElementos == 2 ? dados[1].Trim() : "");
                                    lEncontrouTag = true;
                                    break;
                                case "tempoconsulta": //Se a tag <TempoConsulta> existir ele pega o novo conteúdo
                                    Empresa.Configuracoes[emp].TempoConsulta = (nElementos == 2 ? Convert.ToInt32("0" + dados[1].Trim()) : 0);
                                    lEncontrouTag = true;
                                    break;
                                ///
                                /// informacoes do FTP
                                /// danasa 7/7/2011
                                #region -- FTP
                                case "ftpativo":
                                    Empresa.Configuracoes[emp].FTPAtivo = (nElementos == 2 ? Convert.ToBoolean(dados[1].Trim()) : false);
                                    lEncontrouTag = true;
                                    break;
                                case "ftpgravaxmlpastaunica":
                                    Empresa.Configuracoes[emp].FTPGravaXMLPastaUnica = (nElementos == 2 ? Convert.ToBoolean(dados[1].Trim()) : false);
                                    lEncontrouTag = true;
                                    break;
                                case "ftpsenha":
                                    Empresa.Configuracoes[emp].FTPSenha = (nElementos == 2 ? dados[1].Trim() : "");
                                    lEncontrouTag = true;
                                    break;
                                case "ftppastaautorizados":
                                    Empresa.Configuracoes[emp].FTPPastaAutorizados = (nElementos == 2 ? dados[1].Trim() : "");
                                    lEncontrouTag = true;
                                    break;
                                case "ftppastaretornos":
                                    Empresa.Configuracoes[emp].FTPPastaRetornos = (nElementos == 2 ? dados[1].Trim() : "");
                                    lEncontrouTag = true;
                                    break;
                                case "ftpnomedousuario":
                                    Empresa.Configuracoes[emp].FTPNomeDoUsuario = (nElementos == 2 ? dados[1].Trim() : "");
                                    lEncontrouTag = true;
                                    break;
                                case "ftpnomedoservidor":
                                    Empresa.Configuracoes[emp].FTPNomeDoServidor = (nElementos == 2 ? dados[1].Trim() : "");
                                    lEncontrouTag = true;
                                    break;
                                case "ftpporta":
                                    Empresa.Configuracoes[emp].FTPPorta = (nElementos == 2 ? Convert.ToInt32("0" + dados[1].Trim()) : 21);
                                    lEncontrouTag = true;
                                    break;
                                #endregion
                                #region Usuário e Senha WS
                                case "usuariows":
                                    Empresa.Configuracoes[emp].UsuarioWS = (nElementos == 2 ? dados[1].Trim() : "");
                                    lEncontrouTag = true;
                                    break;
                                case "senhaws":
                                    Empresa.Configuracoes[emp].SenhaWS = (nElementos == 2 ? dados[1].Trim() : "");
                                    lEncontrouTag = true;
                                    break;
                                #endregion
                            }
                        }
                        #endregion
                    }
                    else
                    {
                        #region Formato XML
                        XmlDocument doc = new XmlDocument();
                        doc.Load(cArquivoXml);

                        XmlNodeList ConfUniNfeList = doc.GetElementsByTagName("altConfUniNFe");

                        XmlNodeList RegistroEmpList = doc.GetElementsByTagName("DadosEmpresa");

                        foreach (XmlNode ConfUniNfeNode in ConfUniNfeList)
                        {
                            XmlElement ConfUniNfeElemento = (XmlElement)ConfUniNfeNode;

                            //Se a tag <PastaXmlEnvio> existir ele pega no novo conteúdo
                            if (ConfUniNfeElemento.GetElementsByTagName(NFeStrConstants.PastaXmlEnvio).Count != 0)
                            {
                                Empresa.Configuracoes[emp].PastaEnvio = ConfiguracaoApp.RemoveEndSlash(ConfUniNfeElemento.GetElementsByTagName(NFeStrConstants.PastaXmlEnvio)[0].InnerText, true);
                                lEncontrouTag = true;
                            }
                            //Se a tag <PastaXmlEmLote> existir ele pega no novo conteúdo
                            if (ConfUniNfeElemento.GetElementsByTagName(NFeStrConstants.PastaXmlEmLote).Count != 0)
                            {
                                Empresa.Configuracoes[emp].PastaEnvioEmLote = ConfiguracaoApp.RemoveEndSlash(ConfUniNfeElemento.GetElementsByTagName(NFeStrConstants.PastaXmlEmLote)[0].InnerText, true);
                                lEncontrouTag = true;
                            }
                            //Se a tag <PastaXmlRetorno> existir ele pega no novo conteúdo
                            if (ConfUniNfeElemento.GetElementsByTagName(NFeStrConstants.PastaXmlRetorno).Count != 0)
                            {
                                Empresa.Configuracoes[emp].PastaRetorno = ConfiguracaoApp.RemoveEndSlash(ConfUniNfeElemento.GetElementsByTagName(NFeStrConstants.PastaXmlRetorno)[0].InnerText, true);
                                lEncontrouTag = true;
                            }
                            //Se a tag <PastaXmlEnviado> existir ele pega no novo conteúdo
                            if (ConfUniNfeElemento.GetElementsByTagName(NFeStrConstants.PastaXmlEnviado).Count != 0)
                            {
                                Empresa.Configuracoes[emp].PastaEnviado = ConfiguracaoApp.RemoveEndSlash(ConfUniNfeElemento.GetElementsByTagName(NFeStrConstants.PastaXmlEnviado)[0].InnerText, true);
                                lEncontrouTag = true;
                            }
                            //Se a tag <PastaXmlErro> existir ele pega no novo conteúdo
                            if (ConfUniNfeElemento.GetElementsByTagName(NFeStrConstants.PastaXmlErro).Count != 0)
                            {
                                Empresa.Configuracoes[emp].PastaErro = ConfiguracaoApp.RemoveEndSlash(ConfUniNfeElemento.GetElementsByTagName(NFeStrConstants.PastaXmlErro)[0].InnerText, true);
                                lEncontrouTag = true;
                            }
                            //Se a tag <UnidadeFederativaCodigo> existir ele pega no novo conteúdo
                            if (ConfUniNfeElemento.GetElementsByTagName(NFeStrConstants.UnidadeFederativaCodigo).Count != 0)
                            {
                                Empresa.Configuracoes[emp].UFCod = Convert.ToInt32(ConfUniNfeElemento.GetElementsByTagName(NFeStrConstants.UnidadeFederativaCodigo)[0].InnerText);
                                lEncontrouTag = true;
                            }
                            //Se a tag <AmbienteCodigo> existir ele pega no novo conteúdo
                            if (ConfUniNfeElemento.GetElementsByTagName(NFeStrConstants.AmbienteCodigo).Count != 0)
                            {
                                Empresa.Configuracoes[emp].tpAmb = Convert.ToInt32(ConfUniNfeElemento.GetElementsByTagName(NFeStrConstants.AmbienteCodigo)[0].InnerText);
                                lEncontrouTag = true;
                            }
                            //Se a tag <tpEmis> existir ele pega no novo conteúdo
                            if (ConfUniNfeElemento.GetElementsByTagName(NFeStrConstants.tpEmis).Count != 0)
                            {
                                Empresa.Configuracoes[emp].tpEmis = Convert.ToInt32(ConfUniNfeElemento.GetElementsByTagName(NFeStrConstants.tpEmis)[0].InnerText);
                                lEncontrouTag = true;
                            }
                            //Se a tag <PastaBackup> existir ele pega no novo conteúdo
                            if (ConfUniNfeElemento.GetElementsByTagName(NFeStrConstants.PastaBackup).Count != 0)
                            {
                                Empresa.Configuracoes[emp].PastaBackup = ConfiguracaoApp.RemoveEndSlash(ConfUniNfeElemento.GetElementsByTagName(NFeStrConstants.PastaBackup)[0].InnerText, true);
                                lEncontrouTag = true;
                            }
                            //Se a tag <PastaValidar> existir ele pega no novo conteúdo
                            if (ConfUniNfeElemento.GetElementsByTagName(NFeStrConstants.PastaValidar).Count != 0)
                            {
                                Empresa.Configuracoes[emp].PastaValidar = ConfiguracaoApp.RemoveEndSlash(ConfUniNfeElemento.GetElementsByTagName(NFeStrConstants.PastaValidar)[0].InnerText, true);
                                lEncontrouTag = true;
                            }
                            //Se a tag <PastaDownloadNFeDest> existir ele pega no novo conteúdo
                            if (ConfUniNfeElemento.GetElementsByTagName(NFeStrConstants.PastaDownloadNFeDest).Count != 0)
                            {
                                Empresa.Configuracoes[emp].PastaDownloadNFeDest = ConfiguracaoApp.RemoveEndSlash(ConfUniNfeElemento.GetElementsByTagName(NFeStrConstants.PastaDownloadNFeDest)[0].InnerText, true);
                                lEncontrouTag = true;
                            }
                            //Se a tag <PastaValidar> existir ele pega no novo conteúdo
                            if (ConfUniNfeElemento.GetElementsByTagName(NFeStrConstants.GravarRetornoTXTNFe).Count != 0)
                            {
                                Empresa.Configuracoes[emp].GravarRetornoTXTNFe = Convert.ToBoolean(ConfUniNfeElemento.GetElementsByTagName(NFeStrConstants.GravarRetornoTXTNFe)[0].InnerText);
                                lEncontrouTag = true;
                            }
                            if (ConfUniNfeElemento.GetElementsByTagName(NFeStrConstants.GravarEventosDeTerceiros).Count > 0)
                            {
                                Empresa.Configuracoes[emp].GravarEventosDeTerceiros = Convert.ToBoolean(ConfUniNfeElemento.GetElementsByTagName(NFeStrConstants.GravarEventosDeTerceiros)[0].InnerText);
                                lEncontrouTag = true;
                            }
                            if (ConfUniNfeElemento.GetElementsByTagName(NFeStrConstants.GravarEventosNaPastaEnviadosNFe).Count > 0)
                            {
                                Empresa.Configuracoes[emp].GravarEventosNaPastaEnviadosNFe = Convert.ToBoolean(ConfUniNfeElemento.GetElementsByTagName(NFeStrConstants.GravarEventosNaPastaEnviadosNFe)[0].InnerText);
                                lEncontrouTag = true;
                            }
                            if (ConfUniNfeElemento.GetElementsByTagName(NFeStrConstants.GravarEventosCancelamentoNaPastaEnviadosNFe).Count > 0)
                            {
                                Empresa.Configuracoes[emp].GravarEventosCancelamentoNaPastaEnviadosNFe = Convert.ToBoolean(ConfUniNfeElemento.GetElementsByTagName(NFeStrConstants.GravarEventosCancelamentoNaPastaEnviadosNFe)[0].InnerText);
                                lEncontrouTag = true;
                            }
                            //Se a tag <DiretorioSalvarComo> existir ele pega no novo conteúdo
                            if (ConfUniNfeElemento.GetElementsByTagName(NFeStrConstants.DiretorioSalvarComo).Count != 0)
                            {
                                Empresa.Configuracoes[emp].DiretorioSalvarComo = Convert.ToString(ConfUniNfeElemento.GetElementsByTagName(NFeStrConstants.DiretorioSalvarComo)[0].InnerText);
                                lEncontrouTag = true;
                            }
                            //Se a tag <DiasLimpeza> existir ele pega o novo conteúdo
                            if (ConfUniNfeElemento.GetElementsByTagName(NFeStrConstants.DiasLimpeza).Count != 0)
                            {
                                Empresa.Configuracoes[emp].DiasLimpeza = Convert.ToInt32(ConfUniNfeElemento.GetElementsByTagName(NFeStrConstants.DiasLimpeza)[0].InnerText);
                                lEncontrouTag = true;
                            }
                            //Se a tag <Proxy> existir ele pega o novo conteúdo
                            if (ConfUniNfeElemento.GetElementsByTagName(NfeConfiguracoes.Proxy.ToString()).Count != 0)
                            {
                                ConfiguracaoApp.Proxy = Convert.ToBoolean(ConfUniNfeElemento.GetElementsByTagName(NfeConfiguracoes.Proxy.ToString())[0].InnerText);
                                lEncontrouTag = true;
                            }
                            //Se a tag <ProxyServidor> existir ele pega o novo conteúdo
                            if (ConfUniNfeElemento.GetElementsByTagName(NfeConfiguracoes.ProxyServidor.ToString()).Count != 0)
                            {
                                ConfiguracaoApp.ProxyServidor = ConfUniNfeElemento.GetElementsByTagName(NfeConfiguracoes.ProxyServidor.ToString())[0].InnerText;
                                lEncontrouTag = true;
                            }
                            //Se a tag <ProxyUsuario> existir ele pega o novo conteúdo
                            if (ConfUniNfeElemento.GetElementsByTagName(NfeConfiguracoes.ProxyUsuario.ToString()).Count != 0)
                            {
                                ConfiguracaoApp.ProxyUsuario = ConfUniNfeElemento.GetElementsByTagName(NfeConfiguracoes.ProxyUsuario.ToString())[0].InnerText;
                                lEncontrouTag = true;
                            }
                            //Se a tag <ProxySenha> existir ele pega o novo conteúdo
                            if (ConfUniNfeElemento.GetElementsByTagName(NfeConfiguracoes.ProxySenha.ToString()).Count != 0)
                            {
                                ConfiguracaoApp.ProxySenha = ConfUniNfeElemento.GetElementsByTagName(NfeConfiguracoes.ProxySenha.ToString())[0].InnerText;
                                lEncontrouTag = true;
                            }
                            //Se a tag <ProxyPorta> existir ele pega o novo conteúdo
                            if (ConfUniNfeElemento.GetElementsByTagName(NfeConfiguracoes.ProxyPorta.ToString()).Count != 0)
                            {
                                ConfiguracaoApp.ProxyPorta = Convert.ToInt32("0" + ConfUniNfeElemento.GetElementsByTagName(NfeConfiguracoes.ProxyPorta.ToString())[0].InnerText);
                                lEncontrouTag = true;
                            }
                            //Se a tag <ChecarConexaoInternet> existir ele pega o novo conteúdo
                            if (ConfUniNfeElemento.GetElementsByTagName(NfeConfiguracoes.ChecarConexaoInternet.ToString()).Count != 0)
                            {
                                ConfiguracaoApp.ChecarConexaoInternet = Convert.ToBoolean(ConfUniNfeElemento.GetElementsByTagName(NfeConfiguracoes.ChecarConexaoInternet.ToString())[0].InnerText);
                                lEncontrouTag = true;
                            }
                            if (ConfUniNfeElemento.GetElementsByTagName(NfeConfiguracoes.GravarLogOperacaoRealizada.ToString()).Count != 0)
                            {
                                ConfiguracaoApp.GravarLogOperacoesRealizadas = Convert.ToBoolean(ConfUniNfeElemento.GetElementsByTagName(NfeConfiguracoes.GravarLogOperacaoRealizada.ToString())[0].InnerText);
                                lEncontrouTag = true;
                            }
                            //Se a tag <PastaExeUniDanfe> existir ele pega no novo conteúdo
                            if (ConfUniNfeElemento.GetElementsByTagName(NFeStrConstants.PastaExeUniDanfe).Count != 0)
                            {
                                Empresa.Configuracoes[emp].PastaExeUniDanfe = ConfiguracaoApp.RemoveEndSlash(ConfUniNfeElemento.GetElementsByTagName(NFeStrConstants.PastaExeUniDanfe)[0].InnerText, true);
                                lEncontrouTag = true;
                            }
                            //Se a tag <PastaConfigUniDanfe> existir ele pega no novo conteúdo
                            if (ConfUniNfeElemento.GetElementsByTagName(NFeStrConstants.PastaConfigUniDanfe).Count != 0)
                            {
                                Empresa.Configuracoes[emp].PastaConfigUniDanfe = ConfiguracaoApp.RemoveEndSlash(ConfUniNfeElemento.GetElementsByTagName(NFeStrConstants.PastaConfigUniDanfe)[0].InnerText, true);
                                lEncontrouTag = true;
                            }
                            //Se a tag <PastaDanfeMon> existir ele pega no novo conteúdo
                            if (ConfUniNfeElemento.GetElementsByTagName(NFeStrConstants.PastaDanfeMon).Count != 0)
                            {
                                Empresa.Configuracoes[emp].PastaDanfeMon = ConfiguracaoApp.RemoveEndSlash(ConfUniNfeElemento.GetElementsByTagName(NFeStrConstants.PastaDanfeMon)[0].InnerText, true);
                                lEncontrouTag = true;
                            }
                            //Se a tag <XMLDanfeMonNFe> existir ele pega no novo conteúdo
                            if (ConfUniNfeElemento.GetElementsByTagName(NFeStrConstants.XMLDanfeMonNFe).Count != 0)
                            {
                                Empresa.Configuracoes[emp].XMLDanfeMonNFe = Convert.ToBoolean(ConfUniNfeElemento.GetElementsByTagName(NFeStrConstants.XMLDanfeMonNFe)[0].InnerText);
                                lEncontrouTag = true;
                            }
                            //Se a tag <XMLDanfeMonProcNFe> existir ele pega no novo conteúdo
                            if (ConfUniNfeElemento.GetElementsByTagName(NFeStrConstants.XMLDanfeMonProcNFe).Count != 0)
                            {
                                Empresa.Configuracoes[emp].XMLDanfeMonProcNFe = Convert.ToBoolean(ConfUniNfeElemento.GetElementsByTagName(NFeStrConstants.XMLDanfeMonProcNFe)[0].InnerText);
                                lEncontrouTag = true;
                            }
                            //Se a tag <XMLDanfeMonDenegadaNFe> existir ele pega no novo conteúdo
                            if (ConfUniNfeElemento.GetElementsByTagName(NFeStrConstants.XMLDanfeMonDenegadaNFe).Count != 0)
                            {
                                Empresa.Configuracoes[emp].XMLDanfeMonDenegadaNFe = Convert.ToBoolean(ConfUniNfeElemento.GetElementsByTagName(NFeStrConstants.XMLDanfeMonDenegadaNFe)[0].InnerText);
                                lEncontrouTag = true;
                            }
                            //Se a tag <SenhaConfig> existir ele pega no novo conteúdo
                            if (ConfUniNfeElemento.GetElementsByTagName(NfeConfiguracoes.SenhaConfig.ToString()).Count != 0)
                            {
                                ConfiguracaoApp.SenhaConfig = ConfUniNfeElemento.GetElementsByTagName(NfeConfiguracoes.SenhaConfig.ToString())[0].InnerText;
                                ConfiguracaoApp.mSenhaConfigAlterada = false;
                                lEncontrouTag = true;
                            }
                            //Se a tag <TempoConsulta> existir ele pega o novo conteúdo
                            if (ConfUniNfeElemento.GetElementsByTagName(NFeStrConstants.TempoConsulta).Count != 0)
                            {
                                Empresa.Configuracoes[emp].TempoConsulta = Convert.ToInt32(ConfUniNfeElemento.GetElementsByTagName(NFeStrConstants.TempoConsulta)[0].InnerText);
                                lEncontrouTag = true;
                            }

                            #region -- FTP
                            if (ConfUniNfeElemento.GetElementsByTagName(NFeStrConstants.FTPAtivo).Count != 0)
                            {
                                Empresa.Configuracoes[emp].FTPAtivo = Convert.ToBoolean(ConfUniNfeElemento.GetElementsByTagName(NFeStrConstants.FTPAtivo)[0].InnerText);
                                lEncontrouTag = true;
                            }
                            if (ConfUniNfeElemento.GetElementsByTagName(NFeStrConstants.FTPGravaXMLPastaUnica).Count != 0)
                            {
                                Empresa.Configuracoes[emp].FTPGravaXMLPastaUnica = Convert.ToBoolean(ConfUniNfeElemento.GetElementsByTagName(NFeStrConstants.FTPGravaXMLPastaUnica)[0].InnerText.Trim());
                                lEncontrouTag = true;
                            }
                            if (ConfUniNfeElemento.GetElementsByTagName(NFeStrConstants.FTPSenha).Count != 0)
                            {
                                Empresa.Configuracoes[emp].FTPSenha = ConfUniNfeElemento.GetElementsByTagName(NFeStrConstants.FTPSenha)[0].InnerText.Trim();
                                lEncontrouTag = true;
                            }
                            if (ConfUniNfeElemento.GetElementsByTagName(NFeStrConstants.FTPPastaAutorizados).Count != 0)
                            {
                                Empresa.Configuracoes[emp].FTPPastaAutorizados = ConfUniNfeElemento.GetElementsByTagName(NFeStrConstants.FTPPastaAutorizados)[0].InnerText.Trim();
                                lEncontrouTag = true;
                            }
                            if (ConfUniNfeElemento.GetElementsByTagName(NFeStrConstants.FTPPastaRetornos).Count != 0)
                            {
                                Empresa.Configuracoes[emp].FTPPastaRetornos = ConfUniNfeElemento.GetElementsByTagName(NFeStrConstants.FTPPastaRetornos)[0].InnerText.Trim();
                                lEncontrouTag = true;
                            }
                            if (ConfUniNfeElemento.GetElementsByTagName(NFeStrConstants.FTPNomeDoUsuario).Count != 0)
                            {
                                Empresa.Configuracoes[emp].FTPNomeDoUsuario = ConfUniNfeElemento.GetElementsByTagName(NFeStrConstants.FTPNomeDoUsuario)[0].InnerText.Trim();
                                lEncontrouTag = true;
                            }
                            if (ConfUniNfeElemento.GetElementsByTagName(NFeStrConstants.FTPNomeDoServidor).Count != 0)
                            {
                                Empresa.Configuracoes[emp].FTPNomeDoServidor = ConfUniNfeElemento.GetElementsByTagName(NFeStrConstants.FTPNomeDoServidor)[0].InnerText.Trim();
                                lEncontrouTag = true;
                            }
                            if (ConfUniNfeElemento.GetElementsByTagName(NFeStrConstants.FTPPorta).Count != 0)
                            {
                                Empresa.Configuracoes[emp].FTPPorta = Convert.ToInt32(ConfUniNfeElemento.GetElementsByTagName(NFeStrConstants.FTPPorta)[0].InnerText.Trim());
                                lEncontrouTag = true;
                            }
                            #endregion

                            #region Usuário e Senha WS
                            if (ConfUniNfeElemento.GetElementsByTagName(NFeStrConstants.UsuarioWS).Count != 0)
                            {
                                Empresa.Configuracoes[emp].UsuarioWS = ConfUniNfeElemento.GetElementsByTagName(NFeStrConstants.UsuarioWS)[0].InnerText.Trim();
                                lEncontrouTag = true;
                            }
                            if (ConfUniNfeElemento.GetElementsByTagName(NFeStrConstants.SenhaWS).Count != 0)
                            {
                                Empresa.Configuracoes[emp].SenhaWS = ConfUniNfeElemento.GetElementsByTagName(NFeStrConstants.SenhaWS)[0].InnerText.Trim();
                                lEncontrouTag = true;
                            }
                            #endregion

                            #region --Certificado Digital

                            //Se a tag <CertificadoInstalado> existir ele pega o novo conteúdo
                            if (ConfUniNfeElemento.GetElementsByTagName(NFeStrConstants.CertificadoInstalado).Count != 0)
                            {
                                Empresa.Configuracoes[emp].CertificadoInstalado = Convert.ToBoolean(ConfUniNfeElemento.GetElementsByTagName(NFeStrConstants.CertificadoInstalado)[0].InnerText);
                                lEncontrouTag = true;
                            }

                            //Se a tag <CertificadoArquivo> existir ele pega o novo conteúdo
                            if (ConfUniNfeElemento.GetElementsByTagName(NFeStrConstants.CertificadoArquivo).Count != 0)
                            {
                                Empresa.Configuracoes[emp].CertificadoArquivo = ConfUniNfeElemento.GetElementsByTagName(NFeStrConstants.CertificadoArquivo)[0].InnerText;
                                lEncontrouTag = true;
                            }
                            //Se a tag <CertificadoSenha> existir ele pega o novo conteudo
                            if (ConfUniNfeElemento.GetElementsByTagName(NFeStrConstants.CertificadoSenha).Count != 0)
                            {
                                Empresa.Configuracoes[emp].CertificadoSenha = ConfUniNfeElemento.GetElementsByTagName(NFeStrConstants.CertificadoSenha)[0].InnerText;
                                lEncontrouTag = true;
                            }
                            //Se a tag <certificado> existir ele pega o novo conteudo
                            if (ConfUniNfeElemento.GetElementsByTagName(NFeStrConstants.CertificadoDigital).Count != 0)
                            {
                                Empresa.Configuracoes[emp].Certificado = ConfUniNfeElemento.GetElementsByTagName(NFeStrConstants.CertificadoDigital)[0].InnerText;
                                lEncontrouTag = true;
                            }
                            //Se a tag <CertificadoDigitalThumbPrint> existir ele pega o novo conteudo
                            if (ConfUniNfeElemento.GetElementsByTagName(NFeStrConstants.CertificadoDigitalThumbPrint).Count != 0)
                            {
                                Empresa.Configuracoes[emp].CertificadoThumbPrint = ConfUniNfeElemento.GetElementsByTagName(NFeStrConstants.CertificadoDigitalThumbPrint)[0].InnerText;
                                lEncontrouTag = true;
                            }

                            #endregion
                        }
                        #endregion
                    }
                }
                catch (Exception ex)
                {
                    cStat = "2";
                    xMotivo = "Ocorreu uma falha ao tentar alterar a configuracao do " + Propriedade.NomeAplicacao + ": " + ex.Message;
                    lErro = true;
                }
            }
            catch (Exception ex)
            {
                cStat = "2";
                xMotivo = "Ocorreu uma falha ao tentar alterar cadastrar a nova empresa nas configurações do " + Propriedade.NomeAplicacao + ": " + ex.Message;
                lErro = true;
            }

            if (lEncontrouTag)
            {
                if (!lErro)
                {
                    try
                    {
                        Empresa.CriarPasta();

                        //Na reconfiguração enviada pelo ERP, não vou validar o certificado, vou deixar gravar mesmo que o certificado esteja com problema. Wandrey 05/10/2012
                        this.GravarConfig(false, false);

                        cStat = "1";
                        xMotivo = "Configuracao do " + Propriedade.NomeAplicacao + " alterada com sucesso";
                        lErro = false;
                    }
                    catch (Exception ex)
                    {
                        cStat = "2";
                        xMotivo = "Ocorreu uma falha ao tentar alterar a configuracao do " + Propriedade.NomeAplicacao + ": " + ex.Message;
                        lErro = true;
                    }
                }
            }
            else
            {
                cStat = "2";
                xMotivo = "Ocorreu uma falha ao tentar alterar a configuracao do " + Propriedade.NomeAplicacao + ": Nenhuma tag padrão de configuração foi localizada no XML";
                lErro = true;
            }

            //Se deu algum erro tenho que voltar as configurações como eram antes, ou seja
            //exatamente como estavam gravadas no XML de configuração
            if (lErro)
            {
                ConfiguracaoApp.CarregarDados();
                ConfiguracaoApp.CarregarDadosSobre();
                Empresa.CarregaConfiguracao();
            }

            //Gravar o XML de retorno com a informação do sucesso ou não na reconfiguração
            FileInfo arqInfo = new FileInfo(cArquivoXml);
            string pastaRetorno = string.Empty;
            if (arqInfo.DirectoryName.ToLower().Trim() == Propriedade.PastaGeralTemporaria.ToLower().Trim())
            {
                pastaRetorno = Propriedade.PastaGeralRetorno;
            }
            else
            {
                pastaRetorno = Empresa.Configuracoes[emp].PastaRetorno;
            }

            string nomeArqRetorno;
            if (Path.GetExtension(cArquivoXml).ToLower() == ".txt")
                nomeArqRetorno = Functions.ExtrairNomeArq(cArquivoXml, Propriedade.ExtEnvio.AltCon_TXT) + "-ret-alt-con.txt";
            else
                nomeArqRetorno = Functions.ExtrairNomeArq(cArquivoXml, Propriedade.ExtEnvio.AltCon_XML) + "-ret-alt-con.xml";

            string cArqRetorno = pastaRetorno + "\\" + nomeArqRetorno;

            try
            {
                FileInfo oArqRetorno = new FileInfo(cArqRetorno);
                if (oArqRetorno.Exists == true)
                {
                    oArqRetorno.Delete();
                }

                if (Path.GetExtension(cArquivoXml).ToLower() == ".txt")
                {
                    File.WriteAllText(cArqRetorno, "cStat|" + cStat + "\r\nxMotivo|" + xMotivo + "\r\n", Encoding.Default);
                }
                else
                {
                    XmlWriterSettings oSettings = new XmlWriterSettings();
                    UTF8Encoding c = new UTF8Encoding(false);

                    oSettings.Encoding = c;
                    oSettings.Indent = true;
                    oSettings.IndentChars = "";
                    oSettings.NewLineOnAttributes = false;
                    oSettings.OmitXmlDeclaration = false;

                    XmlWriter oXmlGravar = XmlWriter.Create(cArqRetorno, oSettings);

                    oXmlGravar.WriteStartDocument();
                    oXmlGravar.WriteStartElement("retAltConfUniNFe");
                    oXmlGravar.WriteElementString("cStat", cStat);
                    oXmlGravar.WriteElementString("xMotivo", xMotivo);
                    oXmlGravar.WriteEndElement(); //retAltConfUniNFe
                    oXmlGravar.WriteEndDocument();
                    oXmlGravar.Flush();
                    oXmlGravar.Close();
                }
            }
            catch (Exception ex)
            {
                //Ocorreu erro na hora de gerar o arquivo de erro para o ERP
                ///
                /// danasa 8-2009
                /// 
                Auxiliar oAux = new Auxiliar();
                oAux.GravarArqErroERP(Path.GetFileNameWithoutExtension(cArqRetorno) + ".err", xMotivo + Environment.NewLine + ex.Message);
            }

            try
            {
                //Deletar o arquivo de configurações automáticas gerado pelo ERP
                FileInfo oArqReconf = new FileInfo(cArquivoXml);
                oArqReconf.Delete();
            }
            catch
            {
                //Não vou fazer nada, so trato a exceção para evitar fechar o aplicativo. Wandrey 09/03/2010
            }
        }
        #endregion

        #region RemoveEndSlash
        public static string RemoveEndSlash(string value)
        {
            return RemoveEndSlash(value, false);
        }
        #endregion

        #region RemoveEndSlash
        /// <summary>
        /// danasa 8-2009
        /// </summary>
        /// <param name="value"></param>
        /// <param name="acertarNomeCurto"></param>
        /// <returns></returns>
        public static string RemoveEndSlash(string value, bool acertarNomeCurto)
        {
            if (!string.IsNullOrEmpty(value))
            {
                if (acertarNomeCurto)
                {
                    DirectoryInfo dir = new DirectoryInfo(value);
                    value = dir.FullName;
                }

                while (value.Substring(value.Length - 1, 1) == @"\" && !string.IsNullOrEmpty(value))
                    value = value.Substring(0, value.Length - 1);
            }
            else
            {
                value = string.Empty;
            }

            return value.Replace("\r\n", "").Trim();
        }
        #endregion

        #region CadastrarEmpresa()
        private int CadastrarEmpresa(string arqXML, int emp)
        {
            int retEmp = emp;

            try
            {
                XmlDocument doc = new XmlDocument();
                doc.Load(arqXML);

                if (doc.DocumentElement.SelectNodes("DadosEmpresa").Count > 0)
                {
                    string cnpj = "";
                    string nomeEmp = "";

                    foreach (XmlElement item in doc.DocumentElement)
                    {
                        cnpj = doc.DocumentElement.SelectNodes("DadosEmpresa")[0].Attributes["CNPJ"].Value;

                        if (item.GetElementsByTagName("Nome").Count != 0)
                        {
                            nomeEmp = item.GetElementsByTagName("Nome")[0].InnerText;
                        }
                    }

                    if (string.IsNullOrEmpty(cnpj) || string.IsNullOrEmpty(nomeEmp))
                    {
                        throw new Exception("Não foi possível localizar os dados da empresa no xml de configuração.");
                    }

                    if (Empresa.FindConfEmpresa(cnpj.Trim()) == null)
                    {
                        Empresa empresa = new Empresa();
                        empresa.CNPJ = cnpj;
                        empresa.Nome = nomeEmp;
                        Empresa.Configuracoes.Add(empresa);

                        GravarArqEmpresas();
                    }

                    retEmp = Empresa.FindConfEmpresaIndex(cnpj);
                }
            }
            catch (Exception ex)
            {
                throw (ex);
            }


            return retEmp;
        }
        #endregion

        #region CertificadosInstalados()
        public void CertificadosInstalados(string arquivo)
        {
            bool lConsultar = false;
            bool lErro = false;
            string arqRet = "uninfe-ret-cons-certificado.xml";
            string tmp_arqRet = Path.Combine(Propriedade.PastaGeralTemporaria, arqRet);
            string cStat = "";
            string xMotivo = "";

            try
            {
                XmlDocument doc = new XmlDocument();
                doc.Load(arquivo);

                foreach (XmlElement item in doc.DocumentElement)
                {
                    lConsultar = doc.DocumentElement.GetElementsByTagName("xServ")[0].InnerText.Equals("CONS-CERTIFICADO", StringComparison.InvariantCultureIgnoreCase);
                }

                if (lConsultar)
                {
                    X509Store store = new X509Store("MY", StoreLocation.CurrentUser);
                    store.Open(OpenFlags.ReadOnly | OpenFlags.OpenExistingOnly);
                    X509Certificate2Collection collection = (X509Certificate2Collection)store.Certificates;
                    X509Certificate2Collection collection1 = (X509Certificate2Collection)collection.Find(X509FindType.FindByTimeValid, DateTime.Now, false);
                    X509Certificate2Collection collection2 = (X509Certificate2Collection)collection.Find(X509FindType.FindByKeyUsage, X509KeyUsageFlags.DigitalSignature, false);

                    #region Cria XML de retorno
                    if (File.Exists(tmp_arqRet))
                        File.Delete(tmp_arqRet);

                    XmlDocument RetCertificados = new XmlDocument();

                    XmlNode raiz = RetCertificados.CreateElement("Certificados");
                    RetCertificados.AppendChild(raiz);

                    RetCertificados.Save(tmp_arqRet);

                    #endregion

                    #region Monta XML de Retorno com dados do Certificados Instalaos
                    for (int i = 0; i < collection2.Count; i++)
                    {
                        #region layout retorno
                        /*laoyut de retorno - Renan Borges
                        <Certificados> 
                        <ThumbPrint ID="999..."> 
                        <Subject>XX...</Subject> 
                        <ValidadeInicial>dd/dd/dddd</ValidadeInicial> 
                        <ValidadeFinal>dd/dd/dddd</ValidadeFinal> 
                        </Certificados>
                        */
                        #endregion

                        XmlDocument docGerar = new XmlDocument();
                        docGerar.Load(tmp_arqRet);

                        XmlNode Registro = docGerar.CreateElement("ThumbPrint");
                        XmlAttribute IdThumbPrint = docGerar.CreateAttribute("ID");
                        IdThumbPrint.Value = collection2[i].Thumbprint.ToString();
                        Registro.Attributes.Append(IdThumbPrint);

                        XmlNode Subject = docGerar.CreateElement("Subject");
                        XmlNode ValidadeInicial = docGerar.CreateElement("ValidadeInicial");
                        XmlNode ValidadeFinal = docGerar.CreateElement("ValidadeFinal");

                        Subject.InnerText = collection2[i].Subject.ToString();
                        ValidadeInicial.InnerText = collection2[i].NotBefore.ToShortDateString();
                        ValidadeFinal.InnerText = collection2[i].NotAfter.ToShortDateString();

                        docGerar.SelectSingleNode("Certificados").AppendChild(Registro);
                        Registro.AppendChild(Subject);
                        Registro.AppendChild(ValidadeInicial);
                        Registro.AppendChild(ValidadeFinal);

                        docGerar.Save(tmp_arqRet);

                    }
                    #endregion
                }

            }
            catch
            {
                cStat = "2";
                xMotivo = "Nao foi possivel fazer a consulta de Certificados Instalados na estação " + Propriedade.NomeAplicacao;
                lErro = true;
                File.Delete(tmp_arqRet);
            }
            finally
            {
                string cArqRetorno = Propriedade.PastaGeralRetorno + "\\" + arqRet;

                #region XML de Retorno para ERP
                try
                {
                    FileInfo oArqRetorno = new FileInfo(cArqRetorno);
                    if (oArqRetorno.Exists == true)
                    {
                        oArqRetorno.Delete();
                    }

                    if (!lConsultar && !lErro)
                    {
                        cStat = "2";
                        xMotivo = "Nao foi possivel fazer a consulta de Certificados Instalados na estação (xServ não identificado) no " + Propriedade.NomeAplicacao;
                    }

                    if (lErro || !lConsultar)
                    {
                        File.Delete(tmp_arqRet);

                        XmlWriterSettings oSettings = new XmlWriterSettings();
                        UTF8Encoding c = new UTF8Encoding(false);

                        oSettings.Encoding = c;
                        oSettings.Indent = true;
                        oSettings.IndentChars = "";
                        oSettings.NewLineOnAttributes = false;
                        oSettings.OmitXmlDeclaration = false;

                        XmlWriter oXmlGravar = XmlWriter.Create(cArqRetorno, oSettings);

                        oXmlGravar.WriteStartDocument();
                        oXmlGravar.WriteStartElement("retCadConfUniNFe");
                        oXmlGravar.WriteElementString("cStat", cStat);
                        oXmlGravar.WriteElementString("xMotivo", xMotivo);
                        oXmlGravar.WriteEndElement(); //retAltConfUniNFe
                        oXmlGravar.WriteEndDocument();
                        oXmlGravar.Flush();
                        oXmlGravar.Close();
                    }
                    else
                    {
                        if (File.Exists(cArqRetorno))
                            File.Delete(cArqRetorno);

                        if (File.Exists(arquivo))
                            File.Delete(arquivo);

                        File.Move(tmp_arqRet, Propriedade.PastaGeralRetorno + "\\" + arqRet);
                    }
                }
                catch (Exception ex)
                {
                    //Ocorreu erro na hora de gerar o arquivo de erro para o ERP
                    Auxiliar oAux = new Auxiliar();
                    oAux.GravarArqErroERP(Path.GetFileNameWithoutExtension(cArqRetorno) + ".err", xMotivo + Environment.NewLine + ex.Message);
                }
                #endregion
            }
        }
        #endregion

        #endregion
    }
    #endregion
}

