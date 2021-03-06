﻿using System;
using System.Collections;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.IO;
using System.Xml;
using System.Runtime.InteropServices;
using System.Security.Cryptography;

namespace NFe.Components
{
    public class Functions
    {
        #region MemoryStream
        /// <summary>
        /// Método responsável por converter uma String contendo a estrutura de um XML em uma Stream para
        /// ser lida pela XMLDocument
        /// </summary>
        /// <returns>String convertida em Stream</returns>
        /// <remarks>Conteúdo do método foi fornecido pelo Marcelo da desenvolvedores.net</remarks>
        /// <by>Wandrey Mundin Ferreira</by>
        /// <date>20/04/2009</date>
        public static MemoryStream StringXmlToStream(string strXml)
        {
            byte[] byteArray = new byte[strXml.Length];
            System.Text.ASCIIEncoding encoding = new System.Text.ASCIIEncoding();
            byteArray = encoding.GetBytes(strXml);
            MemoryStream memoryStream = new MemoryStream(byteArray);
            memoryStream.Seek(0, SeekOrigin.Begin);

            return memoryStream;
        }

        public static MemoryStream StringXmlToStreamUTF8(string strXml)
        {
            byte[] byteArray = new byte[strXml.Length];
            System.Text.UTF8Encoding encoding = new System.Text.UTF8Encoding();
            byteArray = encoding.GetBytes(strXml);
            MemoryStream memoryStream = new MemoryStream(byteArray);
            memoryStream.Seek(0, SeekOrigin.Begin);

            return memoryStream;
        }
        #endregion

        #region Move()
        /// <summary>
        /// Mover arquivo para uma determinada pasta
        /// </summary>
        /// <param name="arquivoOrigem">Arquivo de origem (arquivo a ser movido)</param>
        /// <param name="arquivoDestino">Arquivo de destino (destino do arquivo)</param>
        public static void Move(string arquivoOrigem, string arquivoDestino)
        {
            try
            {
                if (File.Exists(arquivoDestino))
                    File.Delete(arquivoDestino);

                File.Copy(arquivoOrigem, arquivoDestino);
                File.Delete(arquivoOrigem);
            }
            catch (Exception ex)
            {
                throw (ex);
            }
        }
        #endregion

        #region DeletarArquivo()
        /// <summary>
        /// Excluir arquivos do HD
        /// </summary>
        /// <param name="Arquivo">Nome do arquivo a ser excluido.</param>
        /// <date>05/08/2009</date>
        /// <by>Wandrey Mundin Ferreira</by>
        public static void DeletarArquivo(string arquivo)
        {
            try
            {
                if (File.Exists(arquivo))
                {
                    File.Delete(arquivo);
                }
            }
            catch (Exception ex)
            {
                throw (ex);
            }
        }
        #endregion

        #region CodigoParaUF()
        public static string CodigoParaUF(int codigo)
        {
            try
            {
                for (int v = 0; v < Propriedade.CodigosEstados.Length / 2; ++v)
                    if (Propriedade.CodigosEstados[v, 0] == codigo.ToString())
                        return Propriedade.CodigosEstados[v, 1];

                return "";
            }
            catch
            {
                return "";
            }
        }
        #endregion

        #region UFParaCodigo()
        public static int UFParaCodigo(string uf)
        {
            try
            {
                for (int v = 0; v < Propriedade.CodigosEstados.Length / 2; ++v)
                    if (Propriedade.CodigosEstados[v, 1].Substring(0, 2) == uf.ToString())
                        return Convert.ToInt32(Propriedade.CodigosEstados[v, 0]);

                return 0;
            }
            catch
            {
                return 0;
            }
        }
        #endregion

        #region PadraoNFe()
        public static PadroesNFSe PadraoNFSe(int municipio)
        {
            foreach (Municipio mun in Propriedade.Municipios)
                if (mun.CodigoMunicipio == municipio)
                    return mun.Padrao;

            return PadroesNFSe.NaoIdentificado;
        }
        #endregion

        #region OnlyNumbers()
        /// <summary>
        /// Remove caracteres não-numéricos e retorna.
        /// </summary>
        /// <param name="text">valor a ser convertido</param>
        /// <returns>somente números com decimais</returns>
        public static object OnlyNumbers(object text)
        {
            bool flagNeg = false;

            if (text == null || text.ToString().Length == 0) return 0;
            string ret = "";

            foreach (char c in text.ToString().ToCharArray())
            {
                if (c.Equals('.') == true || c.Equals(',') == true || char.IsNumber(c) == true)
                    ret += c.ToString();
                else if (c.Equals('-') == true)
                    flagNeg = true;
            }

            if (flagNeg == true) ret = "-" + ret;

            return ret;
        }
        #endregion

        #region OnlyNumbers()
        /// <summary>
        /// Remove caracteres não-numéricos e retorna.
        /// </summary>
        /// <param name="text">valor a ser convertido</param>
        /// <param name="additionalChars">caracteres adicionais a serem removidos</param>
        /// <returns>somente números com decimais</returns>
        public static object OnlyNumbers(object text, string removeChars)
        {
            string ret = OnlyNumbers(text).ToString();

            foreach (char c in removeChars.ToCharArray())
            {
                ret = ret.Replace(c.ToString(), "");
            }

            return ret;
        }
        #endregion

        #region Gerar MD5
        public static string GerarMD5(string valor)
        {
            // Cria uma nova intância do objeto que implementa o algoritmo para
            // criptografia MD5
            System.Security.Cryptography.MD5 md5Hasher = System.Security.Cryptography.MD5.Create();

            // Criptografa o valor passado
            byte[] valorCriptografado = md5Hasher.ComputeHash(Encoding.Default.GetBytes(valor));

            // Cria um StringBuilder para passarmos os bytes gerados para ele
            StringBuilder strBuilder = new StringBuilder();

            // Converte cada byte em um valor hexadecimal e adiciona ao
            // string builder
            // and format each one as a hexadecimal string.
            for (int i = 0; i < valorCriptografado.Length; i++)
            {
                strBuilder.Append(valorCriptografado[i].ToString("x2"));
            }

            // retorna o valor criptografado como string
            return strBuilder.ToString();
        }
        #endregion

        #region LerArquivo()
        /// <summary>
        /// Le arquivos no formato TXT
        /// Retorna uma lista do conteudo do arquivo
        /// </summary>
        /// <param name="cArquivo"></param>
        /// <returns></returns>
        public static List<string> LerArquivo(string cArquivo)
        {
            List<string> lstRetorno = new List<string>();
            if (File.Exists(cArquivo))
            {
                using (System.IO.StreamReader txt = new StreamReader(cArquivo, Encoding.Default, true))
                {
                    try
                    {
                        string cLinhaTXT = txt.ReadLine();
                        while (cLinhaTXT != null)
                        {
                            string[] dados = cLinhaTXT.Split('|');
                            if (dados.GetLength(0) > 1)
                            {
                                lstRetorno.Add(cLinhaTXT);
                            }
                            cLinhaTXT = txt.ReadLine();
                        }
                    }
                    finally
                    {
                        txt.Close();
                    }
                    if (lstRetorno.Count == 0)
                        throw new Exception("Arquivo: " + cArquivo + " vazio");
                }
            }
            return lstRetorno;
        }
        #endregion

        #region ExtrairNomeArq()
        /// <summary>
        /// Extrai somente o nome do arquivo de uma string; para ser utilizado na situação desejada. Veja os exemplos na documentação do código.
        /// </summary>
        /// <param name="pPastaArq">String contendo o caminho e nome do arquivo que é para ser extraido o nome.</param>
        /// <param name="pFinalArq">String contendo o final do nome do arquivo até onde é para ser extraído.</param>
        /// <returns>Retorna somente o nome do arquivo de acordo com os parâmetros passados - veja exemplos.</returns>
        /// <example>
        /// MessageBox.Show(this.ExtrairNomeArq("C:\\TESTE\\NFE\\ENVIO\\ArqSituacao-ped-sta.xml", "-ped-sta.xml"));
        /// //Será demonstrado no message a string "ArqSituacao"
        /// 
        /// MessageBox.Show(this.ExtrairNomeArq("C:\\TESTE\\NFE\\ENVIO\\ArqSituacao-ped-sta.xml", ".xml"));
        /// //Será demonstrado no message a string "ArqSituacao-ped-sta"
        /// </example>
        /// <by>Wandrey Mundin Ferreira</by>
        /// <date>19/06/2008</date>
        public static string ExtrairNomeArq(string pPastaArq, string pFinalArq)
        {
            FileInfo fi = new FileInfo(pPastaArq);
            string ret = fi.Name;
            ret = ret.Substring(0, ret.Length - pFinalArq.Length);
            return ret;
        }
        #endregion

        #region FileInUse()
        /// <summary>
        /// detectar se o arquivo está em uso
        /// </summary>
        /// <param name="file">caminho do arquivo</param>
        /// <returns>true se estiver em uso</returns>
        /// <by>http://desenvolvedores.net/marcelo</by>
        public static bool FileInUse(string file)
        {
            bool ret = false;

            try
            {
                using (FileStream fs = new FileStream(file, FileMode.Open, FileAccess.Read, FileShare.Read))
                {
                    fs.Close();//fechar o arquivo para nao dar erro em outras aplicações
                }
            }
            catch
            {
                ret = true;
            }

            return ret;
        }
        #endregion

        #region LerTag()
        /// <summary>
        /// Busca o nome de uma determinada TAG em um Elemento do XML para ver se existe, se existir retorna seu conteúdo com um ponto e vírgula no final do conteúdo.
        /// </summary>
        /// <param name="Elemento">Elemento a ser pesquisado o Nome da TAG</param>
        /// <param name="NomeTag">Nome da Tag</param>
        /// <returns>Conteúdo da tag</returns>
        /// <date>05/08/2009</date>
        /// <by>Wandrey Mundin Ferreira</by>
        public static string LerTag(XmlElement Elemento, string NomeTag)
        {
            return LerTag(Elemento, NomeTag, true);
        }
        #endregion

        #region LerTag()
        /// <summary>
        /// Busca o nome de uma determinada TAG em um Elemento do XML para ver se existe, se existir retorna seu conteúdo, com ou sem um ponto e vírgula no final do conteúdo.
        /// </summary>
        /// <param name="Elemento">Elemento a ser pesquisado o Nome da TAG</param>
        /// <param name="NomeTag">Nome da Tag</param>
        /// <param name="RetornaPontoVirgula">Retorna com ponto e vírgula no final do conteúdo da tag</param>
        /// <returns>Conteúdo da tag</returns>
        /// <date>05/08/2009</date>
        /// <by>Wandrey Mundin Ferreira</by>
        public static string LerTag(XmlElement Elemento, string NomeTag, bool RetornaPontoVirgula)
        {
            string Retorno = string.Empty;

            if (Elemento.GetElementsByTagName(NomeTag).Count != 0)
            {
                if (RetornaPontoVirgula)
                {
                    Retorno = Elemento.GetElementsByTagName(NomeTag)[0].InnerText.Replace(";", " ");  //danasa 19-9-2009
                    Retorno += ";";
                }
                else
                {
                    Retorno = Elemento.GetElementsByTagName(NomeTag)[0].InnerText;  //Wandrey 07/10/2009
                }
            }
            return Retorno;
        }

        public static string LerTag(XmlElement Elemento, string NomeTag, string defaultValue)
        {
            string result = LerTag(Elemento, NomeTag, false);
            if (string.IsNullOrEmpty(result))
                result = defaultValue;
            return result;
        }
        #endregion

        #region IsConnectedToInternet()
        //Creating the extern function...
        [DllImport("wininet.dll")]
        private extern static bool InternetGetConnectedState(out int Description, int ReservedValue);

        //Creating a function that uses the API function...
        public static bool IsConnectedToInternet()
        {
            int Desc;
            return InternetGetConnectedState(out Desc, 0);
        }
        #endregion

        #region XmlToString()
        /// <summary>
        /// Método responsável por ler o conteúdo de um XML e retornar em uma string
        /// </summary>
        /// <param name="parNomeArquivo">Caminho e nome do arquivo XML que é para pegar o conteúdo e retornar na string.</param>
        /// <returns>Retorna uma string com o conteúdo do arquivo XML</returns>
        /// <example>
        /// string ConteudoXML;
        /// ConteudoXML = THIS.XmltoString( @"c:\arquivo.xml" );
        /// MessageBox.Show( ConteudoXML );
        /// </example>
        /// <by>Wandrey Mundin Ferreira</by>
        /// <date>04/06/2008</date>
        public static string XmlToString(string parNomeArquivo)
        {
            string conteudo_xml = string.Empty;

            StreamReader SR = null;
            try
            {
                SR = File.OpenText(parNomeArquivo);
                conteudo_xml = SR.ReadToEnd();
            }
            catch (Exception ex)
            {
                throw (ex);
            }
            finally
            {
                SR.Close();
            }

            return conteudo_xml;
        }
        #endregion

        #region getDateTime()
        public static DateTime GetDateTime(string value)
        {
            if (string.IsNullOrEmpty(value))
                return DateTime.MinValue;

            int _ano = Convert.ToInt16(value.Substring(0, 4));
            int _mes = Convert.ToInt16(value.Substring(5, 2));
            int _dia = Convert.ToInt16(value.Substring(8, 2));
            if (value.Contains("T") && value.Contains(":"))
            {
                int _hora = Convert.ToInt16(value.Substring(11, 2));
                int _min = Convert.ToInt16(value.Substring(14, 2));
                int _seg = Convert.ToInt16(value.Substring(17, 2));
                return new DateTime(_ano, _mes, _dia, _hora, _min, _seg);
            }
            return new DateTime(_ano, _mes, _dia);
        }
        #endregion

        #region CarregaUF()
        /// <summary>
        /// Carrega os Estados que possuem serviço de NFE já disponível. Estes Estados são carregados a partir do XML Webservice.xml que fica na pasta do executável do UNINFE
        /// </summary>
        /// <returns>Retorna a lista de UF e seus ID´s</returns>
        /// <remarks>
        /// Autor: Wandrey Mundin Ferreira
        /// Data: 01/03/2010
        /// </remarks>
        public static ArrayList CarregaUF()
        {
            ArrayList UF = new ArrayList();

            /// danasa 1-2012
            if (Propriedade.TipoAplicativo == TipoAplicativo.Nfse)
                foreach (Municipio mun in Propriedade.Municipios)
                {
                    UF.Add(new ComboElem(mun.UF, mun.CodigoMunicipio, mun.Nome));
                }
            /// danasa 1-2012

            if (File.Exists(Propriedade.NomeArqXMLWebService))
            {
                XmlTextReader oLerXml = null;
                try
                {
                    //Carregar os dados do arquivo XML de configurações da Aplicação
                    oLerXml = new XmlTextReader(Propriedade.NomeArqXMLWebService);

                    while (oLerXml.Read())
                    {
                        if (oLerXml.NodeType == XmlNodeType.Element)
                        {
                            if (oLerXml.Name == "Estado" && (Convert.ToInt32(oLerXml.GetAttribute("ID")) < 900 || Propriedade.TipoAplicativo == TipoAplicativo.Nfse) && Convert.ToInt32(oLerXml.GetAttribute("ID")) != 999)
                            {
                                /// danasa 1-2012
                                bool jahExiste = false;
                                foreach (ComboElem ee in UF)
                                    if (ee.Codigo == Convert.ToInt32(oLerXml.GetAttribute("ID")))
                                    {
                                        jahExiste = true;
                                        break;
                                    }
                                /// danasa 1-2012
                                /// 
                                if (!jahExiste)
                                    UF.Add(new ComboElem(oLerXml.GetAttribute("UF"), Convert.ToInt32(oLerXml.GetAttribute("ID")), oLerXml.GetAttribute("Nome")));
                            }
                        }
                    }
                }
                catch (Exception ex)
                {
                    throw (ex);
                }
                finally
                {
                    if (oLerXml != null)
                        oLerXml.Close();
                }
            }

            UF.Sort(new OrdenacaoPorNome());

            return UF;
        }
        #endregion

        /// <summary>
        /// Criptografar conteúdo com MD5
        /// </summary>
        /// <param name="input">Conteúdo a ser criptografado</param>
        /// <returns>Conteúdo criptografado com MD5</returns>
        public static string GetMD5Hash(string input)
        {
            MD5 md5Hasher = MD5.Create();
            byte[] data = md5Hasher.ComputeHash(Encoding.Default.GetBytes(input));
            StringBuilder sBuilder = new StringBuilder();

            for (int i = 0; i < data.Length; i++)
            {
                sBuilder.Append(data[i].ToString("x2"));
            }

            return sBuilder.ToString();
        }
    }
}
