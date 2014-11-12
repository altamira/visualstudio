using System;
using System.Collections.Generic;
using System.Globalization;
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
            /// Representa o Rodape do Arquivo padrão CNAB do Bradesco
            /// </summary>
            public partial class Rodape : Registro
            {
                #region Variaveis

                #endregion

                #region Propriedades

                /// <summary>
                /// Identificação do Registro. Constante “9”. Obrigatório.
                /// </summary>
                [Atributo(Sequencia = 0, Regex = @"(?<TIPO_REGISTRO>9)")]
                public CNAB.TIPO_REGISTRO TIPO_REGISTRO
                {
                    get
                    {
                        if (!Dicionario.ContainsKey("TIPO_REGISTRO"))
                            Dicionario["TIPO_REGISTRO"] = ((int)CNAB.TIPO_REGISTRO.RODAPE).ToString().Substring(0, 1);

                        return Enum.GetValues(typeof(CNAB.TIPO_REGISTRO))
                            .Cast<CNAB.TIPO_REGISTRO>()
                            .Where(x => ((int)x).ToString() == Dicionario["TIPO_REGISTRO"])
                            .First();
                    }
                    protected set
                    {
                        Dicionario["TIPO_REGISTRO"] = ((int)value).ToString().Substring(0, 1);
                    }
                }

                /// <summary>
                /// <para>Quantidade de registros. Total de registros do arquivo, incluindo todos os headers, transações e o próprio trailler. Obrigatório.</para>
                /// <remarks>No arquivo retorno referente à confirmação dos agendamentos efetuados, a quantidade de registros e/ou o total dos valores de pagamentos serão sempre os valores de origem no cliente mesmo que eventualmente, divergentes.</remarks>
                /// </summary>
                [Atributo(Sequencia = 1, Regex = @"(?<QUANTIDADE_REGISTROS>\d{6})")]
                public UInt32 QUANTIDADE_REGISTROS
                {
                    get
                    {
                        if (!Dicionario.ContainsKey("QUANTIDADE_REGISTROS"))
                            Dicionario["QUANTIDADE_REGISTROS"] = "".PadRight(6, '0');

                        return UInt32.Parse(Dicionario["QUANTIDADE_REGISTROS"]);
                    }
                    set
                    {
                        Dicionario["QUANTIDADE_REGISTROS"] = value.ToString().PadLeft(6, '0').Substring(0, 6);
                    }
                }

                /// <summary>
                /// <para>Total dos valores de pagamento. Somatória do conteúdo do campo valor de pagamento dos registros transações Obrigatório.</para>
                /// <remarks>No arquivo retorno referente à confirmação dos agendamentos efetuados, a quantidade de registros e/ou o total dos valores de pagamentos serão sempre os valores de origem no cliente mesmo que eventualmente, divergentes.</remarks>
                /// </summary>
                [Atributo(Sequencia = 2, Regex = @"(?<VALOR_TOTAL_PAGAMENTO>\d{17})")]
                public decimal VALOR_TOTAL_PAGAMENTO
                {
                    get
                    {
                        if (!Dicionario.ContainsKey("VALOR_TOTAL_PAGAMENTO"))
                            Dicionario["VALOR_TOTAL_PAGAMENTO"] = "".PadLeft(17, '0');

                        if (string.IsNullOrEmpty(Dicionario["VALOR_TOTAL_PAGAMENTO"]))
                            return 0;

                        Decimal d;

                        if (!Decimal.TryParse(Dicionario["VALOR_TOTAL_PAGAMENTO"], out d))
                            return 0;

                        return d / 100;
                    }
                    set
                    {
                        Dicionario["VALOR_TOTAL_PAGAMENTO"] = value.ToString("0.00", CultureInfo.InvariantCulture).Replace(".", "").Replace(",", "").PadLeft(17, '0');
                    }
                }

                /// <summary>
                /// Posição 025 A 494. Reservado para uso futuro. Fixo Brancos.
                /// </summary>
                [Atributo(Sequencia = 3, Regex = @"(?<RESERVADO>.{470})")]
                public string RESERVADO
                {
                    get
                    {
                        if (!Dicionario.ContainsKey("RESERVADO"))
                            Dicionario["RESERVADO"] = "".PadRight(470, ' ');

                        return Dicionario["RESERVADO"].PadRight(470, ' ').Substring(0, 470);
                    }
                    protected set
                    {
                        Dicionario["RESERVADO"] = value.PadRight(470, ' ').Substring(0, 470);
                    }
                }

                /// <summary>
                /// Número sequencial. Sequencial crescente no arquivo.
                /// </summary>
                [Atributo(Sequencia = 4, Regex = @"(?<NUMERO_SEQUENCIAL>\d{6})")]
                public UInt32 NUMERO_SEQUENCIAL
                {
                    get
                    {
                        if (!Dicionario.ContainsKey("NUMERO_SEQUENCIAL"))
                            Dicionario["NUMERO_SEQUENCIAL"] = "".PadRight(6, '0');

                        return UInt32.Parse(Dicionario["NUMERO_SEQUENCIAL"]);
                    }
                    set
                    {
                        Dicionario["NUMERO_SEQUENCIAL"] = value.ToString().PadLeft(6, '0').Substring(0, 6);
                    }
                }

                #endregion

                #region Contrutores

                public Rodape()
                {
                    Reset();
                }

                public Rodape(string Registro)
                {
                    Reset();

                    this._Registro = Registro;

                    Parse();
                }

                #endregion

                #region Metodos


                #endregion
            }
        }
    }
}
