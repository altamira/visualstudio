﻿using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.IO;
using System.Xml;

namespace NFe.Components
{
    public class TipoArquivoXML
    {
        public int nRetornoTipoArq { get; private set; }
        public string cRetornoTipoArq { get; private set; }
        /// <summary>
        /// Tag que deve ser assinada no XML, se o conteúdo estiver em branco é por que o XML não deve ser assinado
        /// </summary>
        public string TagAssinatura { get; private set; }
        /// <summary>
        /// Tag que tem o atributo ID no XML
        /// </summary>
        public string TagAtributoId { get; private set; }
        /// <summary>
        /// Tag que deve ser assinada no XML, se o conteúdo estiver em branco é por que o XML não deve ser assinado
        /// </summary>
        public string TagLoteAssinatura { get; private set; }
        /// <summary>
        /// Tag que tem o atributo ID no XML
        /// </summary>
        public string TagLoteAtributoId { get; private set; }
        public string cArquivoSchema { get; private set; }
        public string TargetNameSpace { get; private set; }

        public TipoArquivoXML(string rotaArqXML, int UFCod)
        {
            DefinirTipoArq(rotaArqXML, UFCod);
        }

        private void DefinirTipoArq(string cRotaArqXML, int UFCod)
        {
            nRetornoTipoArq = 0;
            cRetornoTipoArq = string.Empty;
            cArquivoSchema = string.Empty;
            TagAssinatura = string.Empty;
            TagAtributoId = string.Empty;
            TagLoteAssinatura = string.Empty;
            TagLoteAtributoId = string.Empty;
            TargetNameSpace = string.Empty;

            string padraoNFSe = string.Empty;
            if (Propriedade.TipoAplicativo == TipoAplicativo.Nfse)
                padraoNFSe = Functions.PadraoNFSe(UFCod).ToString() + "-";
            else
                padraoNFSe = string.Empty;

            try
            {
                if (File.Exists(cRotaArqXML))
                {
                    //Carregar os dados do arquivo XML de configurações do UniNfe
                    XmlTextReader oLerXml = null;

                    try
                    {
                        oLerXml = new XmlTextReader(cRotaArqXML);

                        while (oLerXml.Read())
                        {
                            if (oLerXml.NodeType == XmlNodeType.Element)
                            {
                                InfSchema schema = null;
                                try
                                {
                                    string nome = oLerXml.Name;
                                    if (oLerXml.Name.Equals("envEvento") && Propriedade.TipoAplicativo == TipoAplicativo.Nfe)
                                    {
                                        ///
                                        /// **** tirei pq como estamos lendo a tag <tpEvento>, e nela tem como verificar qual XSD utilizar para validacao
                                        /// então, o arquivo pode ter como sufixo -env-cce, -env-canc ou -env-manif
                                        //if (!cRotaArqXML.EndsWith(Propriedade.ExtEnvio.EnvCCe_XML))
                                        {
                                            XmlDocument xml = new XmlDocument();
                                            xml.Load(oLerXml);

                                            XmlElement cl = (XmlElement)xml.GetElementsByTagName("tpEvento")[0];
                                            if (cl != null)
                                            {
                                                switch (cl.InnerText)
                                                {
                                                    case "110110":
                                                        nome = "envEvento";
                                                        break;   //name=envEvento, pois existe uma entrada especifica no dicionario InfSchemas p/CCe
                                                    case "110111":
                                                        nome = "envEvento110111";
                                                        break;   //name=envEvento110111, pois existe uma entrada especifica no dicionario InfSchemas p/ cancelamentos
                                                    default:
                                                        ///
                                                        /// retorna:
                                                        /// envEvento210200
                                                        /// envEvento210210
                                                        /// envEvento210220
                                                        /// envEvento210240
                                                        //nome = "envEvento" + cl.InnerText;
                                                        nome = "envConfRecebto";
                                                        break;
                                                }
                                            }
                                        }
                                    }
                                    schema = SchemaXML.InfSchemas[Propriedade.TipoAplicativo.ToString().ToUpper() + "-" + padraoNFSe + nome];
                                }
                                catch
                                {
                                    throw new Exception("Não foi possível identificar o tipo do XML para ser validado, ou seja, o sistema não sabe se é um XML de NFe, consulta, etc. Por favor verifique se não existe algum erro de estrutura do XML que impede sua identificação.");
                                }

                                nRetornoTipoArq = schema.ID;
                                cRetornoTipoArq = schema.Descricao;
                                cArquivoSchema = schema.ArquivoXSD;
                                TagAssinatura = schema.TagAssinatura;
                                TagAtributoId = schema.TagAtributoId;
                                TagLoteAssinatura = schema.TagLoteAssinatura;
                                TagLoteAtributoId = schema.TagLoteAtributoId;
                                TargetNameSpace = schema.TargetNameSpace;

                                #region Código temporário, vai sumir com o tempo. Wandrey
                                //TODO Wandrey - Este código é temporário até que todos os estados tenha o serviço da CCe - Wandrey 13/07/2011
                                if (oLerXml.Name == "consSitNFe")
                                {
                                    XmlDocument xml = new XmlDocument();
                                    xml.Load(oLerXml);

                                    XmlElement cl = (XmlElement)xml.GetElementsByTagName("consSitNFe")[0];
                                    if (cl.GetAttribute("versao") == "2.01")
                                    {
                                        cArquivoSchema = "NFe\\consSitNFe_v2.01.xsd";
                                    }
                                }
                                #endregion

                                if (this.nRetornoTipoArq != 0) //Arquivo XML já foi identificado
                                {
                                    break;
                                }
                            }
                        }
                    }
                    catch (Exception ex)
                    {
                        this.nRetornoTipoArq = 102;
                        this.cRetornoTipoArq = ex.Message;
                    }
                    finally
                    {
                        if (oLerXml != null)
                        {
                            if (oLerXml.ReadState != ReadState.Closed)
                            {
                                oLerXml.Close();
                            }
                        }
                    }
                }
                else
                {
                    this.nRetornoTipoArq = 100;
                    this.cRetornoTipoArq = "Arquivo XML não foi encontrado";
                }
            }
            catch (Exception ex)
            {
                this.nRetornoTipoArq = 103;
                this.cRetornoTipoArq = ex.Message;
            }

            if (this.nRetornoTipoArq == 0)
            {
                this.nRetornoTipoArq = 101;
                this.cRetornoTipoArq = "Não foi possível identificar o arquivo XML";
            }
        }

    }
}
