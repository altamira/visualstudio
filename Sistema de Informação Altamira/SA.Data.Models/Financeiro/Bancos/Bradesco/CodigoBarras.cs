using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Text.RegularExpressions;
using System.Threading.Tasks;

namespace SA.Data.Models.Financeiro.Bancos
{
    public partial class Bradesco
    {
        public class CodigoBarras : SA.Data.Models.Financeiro.Bancos.CodigoBarras
        {
            #region Variaveis

            #endregion

            #region Construtores

            /// <summary>
            /// Construtor da classe
            /// </summary>
            public CodigoBarras()
            {
                base.Reset();
            }

            /// <summary>
            /// Construtor da classe
            /// </summary>
            /// <param name="CodigoBarra"></param>
            public CodigoBarras(string CodigoBarra)
            {
                base.Reset();
                Reset();

                base.Parse(CodigoBarra);
            }

            #endregion

            #region Propriedades

            /// <summary>
            /// As posições 20 a 44 do código de barras correspondem ao campo livre, que pode variar de um banco para outro
            /// </summary>
            [Atributo(Sequencia = 5, Regex = @"")]
            public override string CAMPO_LIVRE
            {
                get
                {
                    if (!Dicionario.ContainsKey("CAMPO_LIVRE"))
                        Dicionario["CAMPO_LIVRE"] = "".PadLeft(25, ' ');

                    return Dicionario["CAMPO_LIVRE"].PadLeft(25, ' ').Substring(0, 25);
                }
                set
                {
                    if (value.Length > 25)
                        throw new ArgumentException("CAMPO_LIVRE deve ter no máximo 25 caracteres.");

                    Dicionario["CAMPO_LIVRE"] = value.PadLeft(25, ' ').Substring(0, 25);
                }
            }

            /// <summary>
            /// Código da agência do fornecedor.
            /// </summary>
            [Atributo(Sequencia = 6, Regex = @"(?<AGENCIA>\d{4})")]
            public string AGENCIA
            {
                get
                {
                    if (!Dicionario.ContainsKey("AGENCIA"))
                        Dicionario["AGENCIA"] = "".PadLeft(4, '0');

                    return Dicionario["AGENCIA"].ToString().PadLeft(4, '0').Substring(0, 4);
                }
                set
                {
                    if (!value.Trim().PadLeft(4, '0').IsNumericArray(4))
                        throw new ArgumentException("Código da Agência deve ter 4 digitos numéricos;");

                    Dicionario["AGENCIA"] = value.Trim().PadLeft(4, '0').Substring(0, 4);
                }
            }

            /// <summary>
            /// Carteira
            /// </summary>
            [Atributo(Sequencia = 7, Regex = @"(?<CARTEIRA>\d{2})")]
            public string CARTEIRA
            {
                get
                {
                    if (!Dicionario.ContainsKey("CARTEIRA"))
                        Dicionario["CARTEIRA"] = "".PadLeft(2, '0');

                    return Dicionario["CARTEIRA"].ToString().PadLeft(2, '0').Substring(0, 2);
                }
                set
                {
                    if (!value.Trim().PadLeft(2, '0').IsNumericArray(2))
                        throw new ArgumentException("Carteira deve ter 2 digitos numéricos;");

                    Dicionario["CARTEIRA"] = value.Trim().PadLeft(2, '0').Substring(0, 2);
                }
            }

            /// <summary>
            /// Nosso Número.
            /// <para>MODALIDADE – 31 - Obrigatório somente quando o banco for igual a 237 (Bradesco), e deve ser extraído do Código de Barras ou Linha Digitável. Para os demais Bancos, preencher com zeros</para>
            /// <para>DEMAIS MODALIDADES - Fixo zeros</para>
            /// </summary>
            [Atributo(Sequencia = 8, Regex = @"(?<NOSSO_NUMERO>\d{11})")]
            public string NOSSO_NUMERO
            {
                get
                {
                    if (!Dicionario.ContainsKey("NOSSO_NUMERO"))
                        Dicionario["NOSSO_NUMERO"] = "".PadRight(11, '0');

                    return Dicionario["NOSSO_NUMERO"].ToString().PadLeft(11, '0').Substring(0, 11);
                }
                set
                {
                    if (!value.Trim().PadLeft(11, '0').IsNumericArray(11))
                        throw new ArgumentException("Nosso Número deve ser 11 digitos numéricos;");

                    Dicionario["NOSSO_NUMERO"] = value.Trim().PadLeft(11, '0').Substring(0, 11);
                }
            }

            /// <summary>
            /// Conta-Corrente do fornecedor.
            /// </summary>
            [Atributo(Sequencia = 9, Regex = @"(?<CONTA_CEDENTE>\d{7})")]
            public string CONTA_CEDENTE
            {
                get
                {
                    if (!Dicionario.ContainsKey("CONTA_CEDENTE"))
                        Dicionario["CONTA_CEDENTE"] = "".PadLeft(7, '0');

                    return Dicionario["CONTA_CEDENTE"].ToString().ToString().PadLeft(7, '0').Substring(0, 7);
                }
                set
                {
                    if (!value.Trim().PadLeft(7, '0').Substring(0, 7).IsNumericArray(7))
                        throw new ArgumentException("Conta Corrente deve ter 13 digitos numéricos;");

                    Dicionario["CONTA_CEDENTE"] = value.Trim().PadLeft(7, '0').Substring(0, 7);
                }
            }

            /// <summary>
            /// Campo fixo zero. Desconsiderar
            /// </summary>
            [Atributo(Sequencia = 10, Regex = @"(?<ZERO_FIXO>0)")]
            public string ZERO_FIXO
            {
                get
                {
                    if (!Dicionario.ContainsKey("ZERO_FIXO"))
                        Dicionario["ZERO_FIXO"] = "0";

                    return Dicionario["ZERO_FIXO"];
                }
                protected set
                {
                    Dicionario["ZERO_FIXO"] = "0";
                }
            }

            #endregion

            #region Metodos

            /// <summary>
            /// Analisa e carrega nas propriedades da classe os valores de cada campo do código de barras.
            /// </summary>
            /// <returns>Retorna verdadeiro se a carga for concluida com sucesso</returns>
            public override bool Parse(string CodigoBarra)
            {
                if (!base.Parse(CodigoBarra))
                    return false;

                Regex regex = new Regex(ExpressaoRegular(), RegexOptions.Compiled | RegexOptions.IgnoreCase | RegexOptions.ExplicitCapture /*| RegexOptions.Multiline*/);

                Match match = regex.Match(base.CAMPO_LIVRE);  // Analisa 1 registro (linha) por vez

                if (!match.Success)
                    throw new Exception("Código de Barras inválido. Não esta de acordo com o formato esperado. Código de Barras:[" + CodigoBarra + "], Expressão de Validação:[" + ExpressaoRegular() + "]");

                Dictionary<string, string> dicionario = regex.GetGroupNames()
                    .Where(name => match.Groups[name].Success && match.Groups[name].Captures.Count > 0 && name != "0" /*&& match.Groups[name].Index > 0*/)
                    .ToDictionary(name => name, name => match.Groups[name].Value);

                bool r = Parse(dicionario);

                IEnumerable<Exception> v = null;

                if (r)
                    v = Validar();

                return r && (v != null && v.Count() == 0);
            }

            /// <summary>
            /// Validação do registro.
            /// </summary>
            /// <returns></returns>
            public override IEnumerable<Exception> Validar()
            {
                string codigoBarra = Dicionario["IDENTIFICACAO_BANCO"] + Dicionario["CODIGO_MOEDA"] + Dicionario["FATOR_VENCIMENTO"] + Dicionario["VALOR"] + Dicionario["AGENCIA"] + Dicionario["CARTEIRA"] + Dicionario["NOSSO_NUMERO"] + Dicionario["CONTA_CEDENTE"] + Dicionario["ZERO_FIXO"];

                uint digito = Banco.CalculoDigitoVerificadorCodigoBarra(codigoBarra.ToCharArray().ToNumericArray());

                if (DIGITO_VERIFICADOR != digito)
                    yield return new Exception("Digito verificador errado. Digito atual: " + DIGITO_VERIFICADOR.ToString() + ", Digito calculado: " + digito.ToString());
            }

            #endregion
        }
    }
}
