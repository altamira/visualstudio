using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using System.IO;
using System.Text.RegularExpressions;
using System.Reflection;

namespace SA.Data.Models.Tests.Financeiro.Bancos.Bradesco.CNAB
{
    [TestClass]
    public class CNABTest
    {
        [TestMethod]
        public void Banco_Bradesco_CNAB_Enum_List_Test()
        {
            var enumDescription = ExtensionMethods.GetEnumFormattedNames<SA.Data.Models.Financeiro.Bancos.Banco.Bradesco.CNAB.CODIGO_MOVIMENTO>();
            Console.WriteLine(enumDescription);
        }
    }

    [TestClass]
    public class RemessaTest
    {
        [TestMethod, Description("Teste de Geração do Arquivo de Remessa Bradesco")]
        [Timeout(TestTimeout.Infinite)]
        public void Banco_Bradesco_CNAB_Arquivo_Remessa_Parse_Write_Test()
        {
            DirectoryInfo dRemessa = new DirectoryInfo(@"..\..\..\SA.Data.Models.Test\Financeiro\Bancos\Bradesco\Remessa\");
            //DirectoryInfo dRetorno = new DirectoryInfo(@"..\..\..\SA.Data.Models.Test\Financeiro\Bancos\Bradesco\Retorno\");

            //IEnumerable<FileInfo> files = dRemessa.GetFiles("PG*.REM").ToArray().Union(dRetorno.GetFiles("PG*.RET"));
            IEnumerable<FileInfo> files = dRemessa.GetFiles("PG*.REM").ToArray();

            foreach (FileInfo f in files)
            {
                StreamReader reader = new StreamReader(f.FullName);

                SA.Data.Models.Financeiro.Bancos.Banco.Bradesco.CNAB.Remessa rem = new SA.Data.Models.Financeiro.Bancos.Banco.Bradesco.CNAB.Remessa();

                try
                {
                    // Parse do arquivo de Remessa
                    if (!rem.Parse(reader))
                        Assert.Fail(string.Format("O parse do arquivo de Remessa {0} falhou.", f.FullName));

                    // Grava o arquivo de Remessa
                    StreamWriter w = new StreamWriter(f.Name, true);
                    rem.Write(w);
                    w.Close();

                    // Compara o arquivo de Remessa criado com o arquivo original
                    StreamReader ArquivoOriginal = new StreamReader(f.FullName);
                    StreamReader ArquivoGerado = new StreamReader(f.Name, true);

                    while (!ArquivoOriginal.EndOfStream)
                    {
                        string linhaOriginal = ArquivoOriginal.ReadLine();
                        string linhaGerada = ArquivoGerado.ReadLine();

                        if (linhaOriginal.CompareTo(linhaGerada) != 0)
                        {
                            string expressao = "";
                            switch (linhaOriginal.First())
                            {
                                case '0': // Cabecalho
                                    //expressao = rem.Cabecalho.ExpressaoRegular();
                                    break;
                                case '1': // Detalhe
                                    //expressao = rem.Transacao[int.Parse(linhaGerada.Substring(linhaGerada.Length - 6, 6)) - 2].ExpressaoRegular();
                                    break;
                                case '9': // Rodape
                                    //expressao = rem.Rodape.ExpressaoRegular();
                                    break;
                                default:
                                    throw new Exception("Tipo de Registro inválido. Original: [" + linhaOriginal + "], Gerado: [" + linhaGerada + "]");
                            }
                            throw new Exception("Registro diferente original. Original: [" + linhaOriginal + "], Gerado: [" + linhaGerada + "], Expressao: [" + expressao + "]");

                        }
                    }
                }
                catch (Exception ex)
                {
                    Assert.Fail("Um excessão foi gerada no parse do arquivo de Remessa {0}. {1}", f.FullName, ex.Message);
                }
            }
        }   
    }

    [TestClass]
    public class RetornoTest
    {
        [TestMethod, Description("Teste de Geração do Arquivo de Retorno Bradesco")]
        [Timeout(TestTimeout.Infinite)]
        public void Banco_Bradesco_CNAB_Arquivo_Retorno_Parse_Write_Test()
        {
            //DirectoryInfo dRemessa = new DirectoryInfo(@"..\..\..\SA.Data.Models.Test\Financeiro\Bancos\Bradesco\Remessa\");
            DirectoryInfo dRetorno = new DirectoryInfo(@"..\..\..\SA.Data.Models.Test\Financeiro\Bancos\Bradesco\Retorno\");

            //IEnumerable<FileInfo> files = dRemessa.GetFiles("PG*.REM").ToArray().Union(dRetorno.GetFiles("PG*.RET"));
            //IEnumerable<FileInfo> files = dRemessa.GetFiles("PG*.REM").ToArray();
            IEnumerable<FileInfo> files = dRetorno.GetFiles("PG*.RET").ToArray();
            //IEnumerable<FileInfo> files = dRetorno.GetFiles("PG101003.RET").ToArray();

            foreach (FileInfo f in files)
            {
                StreamReader reader = new StreamReader(f.FullName);

                SA.Data.Models.Financeiro.Bancos.Banco.Bradesco.CNAB.Retorno ret = new SA.Data.Models.Financeiro.Bancos.Banco.Bradesco.CNAB.Retorno();

                try
                {
                    // Parse do arquivo de Remessa
                    if (!ret.Parse(reader))
                        Assert.Fail(string.Format("O parse do arquivo de Retorno {0} falhou.", f.FullName));

                    // Grava o arquivo de Remessa
                    StreamWriter w = new StreamWriter(f.Name, true);
                    ret.Write(w);
                    w.Close();

                    // Compara o arquivo de Remessa criado com o arquivo original
                    StreamReader ArquivoOriginal = new StreamReader(f.FullName);
                    StreamReader ArquivoGerado = new StreamReader(f.Name, true);

                    while (!ArquivoOriginal.EndOfStream)
                    {
                        string linhaOriginal = ArquivoOriginal.ReadLine();
                        string linhaGerada = ArquivoGerado.ReadLine();

                        if (linhaOriginal.CompareTo(linhaGerada) != 0)
                        {
                            string expressao = "";
                            switch (linhaOriginal.First())
                            {
                                case '0': // Cabecalho
                                    //expressao = ret.Cabecalho.ExpressaoRegular();
                                    break;
                                case '1': // Detalhe
                                    //expressao = ret.Transacao[int.Parse(linhaGerada.Substring(linhaGerada.Length - 6, 6)) - 2].ExpressaoRegular();
                                    break;
                                case '9': // Rodape
                                    //expressao = ret.Rodape.ExpressaoRegular();
                                    break;
                                default:
                                    throw new Exception("Tipo de Registro inválido. Original: [" + linhaOriginal + "], Gerado: [" + linhaGerada + "]");
                            }
                            throw new Exception("Registro diferente original. Original: [" + linhaOriginal + "], Gerado: [" + linhaGerada + "], Expressao: [" + expressao + "]");

                        }
                    }
                }
                catch (Exception ex)
                {
                    Assert.Fail("Um excessão foi gerada no parse do arquivo de Retorno {0}. {1}", f.FullName, ex.Message);
                }
            }
        }

    }
}
