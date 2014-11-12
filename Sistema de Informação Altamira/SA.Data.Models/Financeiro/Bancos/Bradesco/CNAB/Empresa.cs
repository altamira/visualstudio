using System;
using System.Collections.Generic;
using System.Collections.ObjectModel;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace SA.Data.Models.Financeiro.Bancos
{
    public partial class Bradesco : Banco
    {
        public partial class CNAB
        {
            /// <summary>
            /// Representa a empresa conveniada para o envio e recebimento de arquivos CNAB
            /// </summary>
            public class Empresa
            {
                public class InstrucoesCollection : Collection<Instrucao>
                {
                    public new void Add(Instrucao Instrucao)
                    {
                        Instrucao.NUMERO_SEQUENCIAL = (uint)(this.Count() + 2);
                        base.Add(Instrucao);
                    }
                }

                #region Variaveis

                private Dictionary<string, string> Dicionario = new Dictionary<string, string>();

                /// <summary>
                /// Representa o registro de Cabeçalho do arquivo CNAB do Bradesco.
                /// </summary>
                public SA.Data.Models.Financeiro.Bancos.Bradesco.CNAB.Cabecalho Cabecalho { get; protected set; }

                public InstrucoesCollection Instrucoes = new InstrucoesCollection();

                #endregion

                #region Propriedades

                /// <summary>
                /// Tipo de Inscrição da Empresa Pagadora. 1 = CPF / 2 = CNPJ / 3= OUTROS. Obrigatório - variável.
                /// </summary>
                [Atributo(Sequencia = 2, Regex = @"(?<TIPO_INSCRICAO>1|2|3)")]
                public CNAB.TIPO_INSCRICAO TIPO_INSCRICAO
                {
                    get
                    {
                        if (!Dicionario.ContainsKey("TIPO_INSCRICAO"))
                            Dicionario["TIPO_INSCRICAO"] = ((int)CNAB.TIPO_INSCRICAO.CNPJ).ToString().Substring(0, 1);

                        //return Dicionario[SA.Data.Models.Financeiro.Bancos.Banco.Bradesco.CNAB.DADOS.TIPO_INSCRICAO.ToString()].ToString().Substring(0, 1);
                        return Enum.GetValues(typeof(CNAB.TIPO_INSCRICAO))
                            .Cast<CNAB.TIPO_INSCRICAO>()
                            .Where(x => ((int)x).ToString() == Dicionario["TIPO_INSCRICAO"])
                            .First();
                    }
                    set
                    {
                        Dicionario["TIPO_INSCRICAO"] = ((int)value).ToString().Substring(0, 1);
                    }
                }

                /// <summary>
                /// CNPJ/CPF – Base da Empresa Pagadora. Número da Inscrição. Obrigatório - variável.
                /// </summary>
                [Atributo(Sequencia = 3, Regex = @"(?<CNPJ>\d{9})")]
                public string CNPJ
                {
                    get
                    {
                        if (!Dicionario.ContainsKey("CNPJ"))
                            Dicionario["CNPJ"] = "".PadLeft(9, '0');

                        return Dicionario["CNPJ"].ToString().PadLeft(9, '0').Substring(0, 9);
                    }
                    set
                    {
                        if (!value.Trim().PadLeft(9, '0').IsNumericArray(9))
                            throw new ArgumentException("CNPJ deve ter 9 digitos numéricos;");

                        Dicionario["CNPJ"] = value.Trim().PadLeft(9, '0').Substring(0, 9);
                    }
                }

                /// <summary>
                /// CNPJ/CPF - Filial. Obrigatório - variável.
                /// </summary>
                [Atributo(Sequencia = 4, Regex = @"(?<CNPJ_FILIAL>\d{4})")]
                public string CNPJ_FILIAL
                {
                    get
                    {
                        if (!Dicionario.ContainsKey("CNPJ_FILIAL"))
                            Dicionario["CNPJ_FILIAL"] = "".PadLeft(4, '0');

                        return Dicionario["CNPJ_FILIAL"].ToString().PadLeft(4, '0').Substring(0, 4);
                    }
                    set
                    {
                        if (!value.Trim().PadLeft(4, '0').IsNumericArray(4))
                            throw new ArgumentException("Filial deve ter 4 digitos numéricos;");

                        Dicionario["CNPJ_FILIAL"] = value.Trim().PadLeft(4, '0').Substring(0, 4);
                    }
                }

                /// <summary>
                /// CNPJ/CPF - Digito de Verificação. Obrigatório - variável.
                /// </summary>
                [Atributo(Sequencia = 5, Regex = @"(?<CNPJ_DIGITO>\d{2})")]
                public string CNPJ_DIGITO
                {
                    get
                    {
                        if (!Dicionario.ContainsKey("CNPJ_DIGITO"))
                            Dicionario["CNPJ_DIGITO"] = "".PadLeft(2, '0');

                        return Dicionario["CNPJ_DIGITO"].ToString().PadLeft(2, '0').Substring(0, 2);
                    }
                    set
                    {
                        if (!value.Trim().PadLeft(2, '0').IsNumericArray(2))
                            throw new ArgumentException("Controle deve ter 2 digitos numéricos;");

                        Dicionario["CNPJ_DIGITO"] = value.Trim().PadLeft(2, '0').Substring(0, 2);
                    }
                }

                /// <summary>
                /// Nome da Empresa Pagadora. Razão Social. Obrigatório - fixo.
                /// </summary>
                [Atributo(Sequencia = 6, Regex = @"(?<NOME_EMPRESA>.{40})")]
                public string NOME_EMPRESA
                {
                    get
                    {
                        if (!Dicionario.ContainsKey("NOME_EMPRESA"))
                            Dicionario["NOME_EMPRESA"] = "".PadRight(40, ' ');

                        return Dicionario["NOME_EMPRESA"].ToString().ReplaceExtendedChars().ToUpper().PadRight(40, ' ').Substring(0, 40).Trim();
                    }
                    set
                    {
                        if (value.Trim().Length < 5 || value.Trim().Length > 40)
                            throw new ArgumentException("Nome da Empresa deve ter no mínimo 5 e no máximo 40 caracteres;");

                        Dicionario["NOME_EMPRESA"] = value.Trim().ReplaceExtendedChars().ToUpper().PadRight(40, ' ').Substring(0, 40);
                    }
                }

                #endregion

                #region Contrutores

                public Empresa(Cabecalho Cabecalho)
                {
                    this.TIPO_INSCRICAO = Cabecalho.TIPO_INSCRICAO;
                    this.CNPJ = Cabecalho.CNPJ;
                    this.CNPJ_FILIAL = Cabecalho.CNPJ_FILIAL;
                    this.CNPJ_DIGITO = Cabecalho.CNPJ_DIGITO;
                    this.NOME_EMPRESA = Cabecalho.NOME_EMPRESA;

                    this.Cabecalho = Cabecalho;
                }

                public bool Parse(Instrucao Instrucao)
                {
                    Instrucoes.Add(Instrucao);

                    return true;
                }

                #endregion

            }

        }
    }
}
