using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using System.IO;
using System.Text.RegularExpressions;
using System.Reflection;
using SA.Data.Models.Financeiro.Bancos;

namespace SA.Data.Models.Tests
{
    [TestClass]
    public class CNABTest
    {
        [TestMethod]
        public void Banco_Bradesco_CNAB_Enum_List_Test()
        {
            var enumDescription = ExtensionMethods.GetEnumFormattedNames<Bradesco.CNAB.CODIGO_MOVIMENTO>();
            Console.WriteLine(enumDescription);
        }
    }

    [TestClass]
    public class RegexTest
    {
        [TestMethod]
        public void Banco_Bradesco_CNAB_Cabecalho_Regex_Test()
        {
            Financeiro.Bancos.Bradesco.CNAB.Cabecalho c = new Bradesco.CNAB.Cabecalho();

            Console.WriteLine(c.ExpressaoRegular());
        }

        [TestMethod]
        public void Banco_Bradesco_CNAB_Instrucao_Regex_Test()
        {
            Financeiro.Bancos.Bradesco.CNAB.Instrucao i = new Bradesco.CNAB.Instrucao();

            Console.WriteLine(i.ExpressaoRegular());
        }

        [TestMethod]
        public void Banco_Bradesco_CNAB_Rodape_Regex_Test()
        {
            Financeiro.Bancos.Bradesco.CNAB.Rodape r = new Bradesco.CNAB.Rodape();

            Console.WriteLine(r.ExpressaoRegular());
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

                Bradesco.CNAB.Remessa rem = new Bradesco.CNAB.Remessa();

                try
                {
                    // Parse do arquivo de Remessa
                    if (!rem.Parse(reader))
                        Assert.Fail(string.Format("O parse do arquivo de Remessa {0} falhou.", f.FullName));

                    // Grava o arquivo de Remessa
                    StreamWriter w = new StreamWriter(f.Name, false);
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
                                    expressao = rem.Convenios.FirstOrDefault().Empresas.FirstOrDefault().Cabecalho.ExpressaoRegular();
                                    break;
                                case '1': // Detalhe
                                    expressao = rem.Convenios.FirstOrDefault().Empresas.FirstOrDefault().Instrucoes[int.Parse(linhaOriginal.Substring(linhaOriginal.Length - 6, 6)) - 2].ExpressaoRegular();
                                    break;
                                case '9': // Rodape
                                    expressao = rem.Convenios.FirstOrDefault().Rodape.ExpressaoRegular();
                                    break;
                                default:
                                    Console.WriteLine("Original: [" + linhaOriginal + "]");
                                    Console.WriteLine("Gerado: [" + linhaGerada + "]");
                                    Assert.Fail("Tipo de Registro inválido.");
                                    break;
                            }
                            Console.WriteLine("Arquivo: " + f.FullName);
                            Console.WriteLine("Original: [" + linhaOriginal + "]");
                            Console.WriteLine("Gerado: [" + linhaGerada + "]");
                            Console.WriteLine("Expressao: [" + expressao + "]");
                            Assert.Fail("Registro diferente original.");

                        }
                    }
                }
                catch (AssertInconclusiveException ax)
                {
                    throw ax;
                }
                catch (AssertFailedException fx)
                {
                    throw fx;
                }
                catch (Exception ex)
                {
                    Assert.Fail("Um excessão foi gerada no parse do arquivo de Remessa {0}. {1}", f.FullName, ex.Message);
                }
            }
        }

        [TestMethod, Description("Teste de Geração do Arquivo de Remessa Bradesco")]
        [Timeout(TestTimeout.Infinite)]
        public void Banco_Bradesco_CNAB_Arquivo_Simulacao_Remessa_Test()
        {
            DirectoryInfo dRemessa = new DirectoryInfo(@"..\..\..\SA.Data.Models.Test\Financeiro\Bancos\Bradesco\Remessa\");
            //DirectoryInfo dRetorno = new DirectoryInfo(@"..\..\..\SA.Data.Models.Test\Financeiro\Bancos\Bradesco\Retorno\");

            //IEnumerable<FileInfo> files = dRemessa.GetFiles("PG*.REM").ToArray().Union(dRetorno.GetFiles("PG*.RET"));
            IEnumerable<FileInfo> files = dRemessa.GetFiles("PG280200.REM").ToArray();

            foreach (FileInfo f in files)
            {
                Bradesco.CNAB.Remessa rem_load = new Bradesco.CNAB.Remessa();

                StreamReader reader = new StreamReader(f.FullName);

                try
                {
                    // Parse do arquivo de Remessa
                    if (!rem_load.Parse(reader))
                        Assert.Fail(string.Format("O parse do arquivo de Remessa {0} falhou.", f.FullName));

                    Bradesco.CNAB.Cabecalho cabecalho = new Bradesco.CNAB.Cabecalho(
                            "14760".ToNumericArray(),
                            Bradesco.CNAB.TIPO_INSCRICAO.CNPJ,
                            "043799295",
                            "0001",
                            "10",
                            "ALTAMIRA IND METALURGICA LTDA",
                            "0");

                    // Variaveis para comparação com o arquivo gerado pelo PagFor. Não é necessário em produção
                    // Usado pelo banco para identificar o programa e a versão do PagFor usado para gerar o arquivo.
                    // Em produção este campo pode ficar em branco
                    cabecalho.RESERVADO_USO_EMPRESA = "    230A                                                                  ";
                    cabecalho.NUMERO_REMESSA = "636";
                    cabecalho.DATA_ARQUIVO = DateTime.Parse("2013-02-28");
                    cabecalho.HORA_ARQUIVO = DateTime.Parse("14:57:58");

                    Bradesco.CNAB.Remessa rem_w = new Bradesco.CNAB.Remessa(new SA.Data.Models.Financeiro.Bancos.Bradesco.CNAB.Convenio(cabecalho));

                    SA.Data.Models.Financeiro.Bancos.Bradesco.CNAB.Instrucao instrucao = new SA.Data.Models.Financeiro.Bancos.Bradesco.CNAB.Instrucao();

                    instrucao.TIPO_INSCRICAO = Bradesco.CNAB.TIPO_INSCRICAO.CNPJ;
                    instrucao.CNPJ = "000398641";
                    instrucao.CNPJ_FILIAL = "0001";
                    instrucao.CNPJ_DIGITO = "46";
                    instrucao.NOME_FORNECEDOR = "TECH DATA BRASIL LTDA.";
                    instrucao.ENDERECO_FORNECEDOR = "AV.DR.MARCOS P.U.RODRIGUES, 690";
                    instrucao.CEP_PREFIXO = "06460";
                    instrucao.CEP_COMPLEMENTO = "040";
                    instrucao.BANCO_FORNECEDOR = Financeiro.Bancos.CODIGO.BRADESCO;
                    instrucao.AGENCIA_FORNECEDOR = "00091";
                    instrucao.AGENCIA_FORNECEDOR_DIGITO = "4";
                    instrucao.CONTA_FORNECEDOR = "193862";
                    instrucao.CONTA_FORNECEDOR_DIGITO = "2";
                    instrucao.NUMERO_PAGAMENTO = "I000000000010498";  // Gerar número ID do pagamento, no caso de cobrança Bradesco é fornecido pelo banco
                    instrucao.CARTEIRA = "009";
                    instrucao.NOSSO_NUMERO = "90705";
                    instrucao.DATA_VENCIMENTO = DateTime.Parse("2013-02-25");
                    instrucao.FATOR_VENCIMENTO = "5620";
                    instrucao.VALOR_DOCUMENTO = 70.00m;
                    instrucao.VALOR_PAGAMENTO = 70.00m;
                    instrucao.TIPO_DOCUMENTO = Bradesco.CNAB.TIPO_DOCUMENTO.NOTA_FISCAL;
                    instrucao.NUMERO_NOTA_FISCAL = "0001233990";
                    instrucao.MODALIDADE_PAGAMENTO = Bradesco.CNAB.MODALIDADE_PAGAMENTO.COBRANCA_TITULOS_TERCEIROS;
                    instrucao.DATA_PAGAMENTO = DateTime.Parse("2013-02-28");
                    instrucao.SITUACAO_AGENDAMENTO = Bradesco.CNAB.SITUACAO_AGENDAMENTO.NAO_PAGO;
                    instrucao.CODIGO_MOVIMENTO = Bradesco.CNAB.CODIGO_MOVIMENTO.AUTORIZA_AGENDAMENTO;
                    instrucao.INFORMACAO_COMPLEMENTAR = "009109000000907050193862049"; // ????????????????????????????????
                    instrucao.CODIGO_AREA_EMPRESA = "00";
                    instrucao.RESERVADO_USO_EMPRESA = "993377881234567890";
                    instrucao.CODIGO_LANCAMENTO = "01321"; // Falta tabela com os códigos de lançamentos
                    instrucao.CONTA_COMPLEMENTAR = "0020256";

                    rem_w.Convenios.FirstOrDefault().Empresas.FirstOrDefault().Instrucoes.Add(instrucao);

                    // Grava o arquivo de Remessa
                    StreamWriter w = new StreamWriter(f.Name, false);
                    rem_w.Write(w);
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
                                    expressao = rem_w.Convenios.FirstOrDefault().Empresas.FirstOrDefault().Cabecalho.ExpressaoRegular();
                                    break;
                                case '1': // Detalhe
                                    expressao = rem_w.Convenios.FirstOrDefault().Empresas.FirstOrDefault().Instrucoes[int.Parse(linhaOriginal.Substring(linhaOriginal.Length - 6, 6)) - 2].ExpressaoRegular();
                                    break;
                                case '9': // Rodape
                                    expressao = rem_w.Convenios.FirstOrDefault().Rodape.ExpressaoRegular();
                                    break;
                                default:
                                    Console.WriteLine("Original: [" + linhaOriginal + "]");
                                    Console.WriteLine("Gerado: [" + linhaGerada + "]");
                                    Assert.Fail("Tipo de Registro inválido.");
                                    break;
                            }
                            Console.WriteLine("Arquivo: " + f.FullName);
                            Console.WriteLine("Original: [" + linhaOriginal + "]");
                            Console.WriteLine("Gerado: [" + linhaGerada + "]");
                            Console.WriteLine("Expressao: [" + expressao + "]");
                            Assert.Fail("Registro diferente original.");
                        }
                    }
                }
                catch (AssertInconclusiveException ax)
                {
                    throw ax;
                }
                catch (AssertFailedException fx)
                {
                    throw fx;
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

            IEnumerable<FileInfo> files = dRetorno.GetFiles("PG*.RET").ToArray();
            //IEnumerable<FileInfo> files = dRetorno.GetFiles("PG101003.RET").ToArray();

            foreach (FileInfo f in files)
            {
                StreamReader reader = new StreamReader(f.FullName);

                Bradesco.CNAB.Retorno ret = new Bradesco.CNAB.Retorno();

                try
                {
                    // Parse do arquivo de Remessa
                    if (!ret.Parse(reader))
                        Assert.Fail(string.Format("O parse do arquivo de Retorno {0} falhou.", f.FullName));

                    // Grava o arquivo de Remessa
                    StreamWriter w = new StreamWriter(f.Name, false);
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
                                    expressao = ret.Convenios.FirstOrDefault().Empresas.FirstOrDefault().Cabecalho.ExpressaoRegular();
                                    break;
                                case '1': // Detalhe
                                    expressao = ret.Convenios.FirstOrDefault().Empresas.FirstOrDefault().Instrucoes[int.Parse(linhaOriginal.Substring(linhaOriginal.Length - 6, 6)) - 2].ExpressaoRegular();
                                    break;
                                case '9': // Rodape
                                    expressao = ret.Convenios.FirstOrDefault().Rodape.ExpressaoRegular();
                                    break;
                                default:
                                    Console.WriteLine("Original: [" + linhaOriginal + "]");
                                    Console.WriteLine("Gerado: [" + linhaGerada + "]");
                                    Assert.Fail("Tipo de Registro inválido.");
                                    break;
                            }
                            Console.WriteLine("Arquivo: " + f.FullName);
                            Console.WriteLine("Original: [" + linhaOriginal + "]");
                            Console.WriteLine("Gerado: [" + linhaGerada + "]");
                            Console.WriteLine("Expressao: [" + expressao + "]");
                            Assert.Fail("Registro diferente original.");
                        }
                    }
                }
                catch (AssertInconclusiveException ax)
                {
                    throw ax;
                }
                catch (AssertFailedException fx)
                {
                    throw fx;
                }
                catch (Exception ex)
                {
                    Assert.Fail("Um excessão foi gerada no parse do arquivo de Retorno {0}. {1}", f.FullName, ex.Message);
                }
            }
        }

    }
}
