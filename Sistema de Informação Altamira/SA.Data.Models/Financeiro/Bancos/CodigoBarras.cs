using System;
using System.Collections.Generic;
using System.Globalization;
using System.IO;
using System.Linq;
using System.Reflection;
using System.Text;
using System.Text.RegularExpressions;
using System.Threading.Tasks;

namespace SA.Data.Models.Financeiro.Bancos
{

    /// <summary>
    /// Representa o Código de Barras e Linha Digitável
    /// </summary>
    /// <remarks>O código de barras para cobrança contém 44 posições dispostas da seguinte forma</remarks>
    public partial class CodigoBarras
    {
        #region Variaveis

        /// <summary>
        /// Este dicionário armazena os dados do codigo de barras
        /// </summary>
        protected Dictionary<string, string> Dicionario = new Dictionary<string, string>();

        #endregion

        #region Propriedades

        /// <summary>
        /// Identificação do Banco
        /// </summary>
        [Atributo(Sequencia = 0, Regex = @"(?<IDENTIFICACAO_BANCO>\d{3})")]
        public Bancos.CODIGO IDENTIFICACAO_BANCO
        {
            get
            {
                if (!Dicionario.ContainsKey("IDENTIFICACAO_BANCO"))
                    Dicionario["IDENTIFICACAO_BANCO"] = ((int)Bancos.CODIGO.BRADESCO).ToString().Substring(0, 3);

                return Enum.GetValues(typeof(Bancos.CODIGO))
                    .Cast<Bancos.CODIGO>()
                    .Where(x => ((int)x).ToString() == Dicionario["IDENTIFICACAO_BANCO"])
                    .First();
            }
            protected set
            {
                Dicionario["IDENTIFICACAO_BANCO"] = ((int)value).ToString().Substring(0, 3);
            }
        }

        /// <summary>
        /// Código da Moeda
        /// </summary>
        [Atributo(Sequencia = 1, Regex = @"(?<CODIGO_MOEDA>9)")]
        public Bancos.MOEDA CODIGO_MOEDA
        {
            get
            {
                if (!Dicionario.ContainsKey("CODIGO_MOEDA"))
                    Dicionario["CODIGO_MOEDA"] = ((int)Bancos.MOEDA.REAL).ToString().Substring(0, 1);

                return Enum.GetValues(typeof(Bancos.MOEDA))
                    .Cast<Bancos.MOEDA>()
                    .Where(x => ((int)x).ToString() == Dicionario["CODIGO_MOEDA"])
                    .First();
            }
            protected set
            {
                Dicionario["CODIGO_MOEDA"] = ((int)value).ToString().Substring(0, 1);
            }
        }
        /// <summary>
        ///  Dígito verificador
        /// </summary>
        [Atributo(Sequencia = 2, Regex = @"(?<DIGITO_VERIFICADOR>\d)")]
        public uint DIGITO_VERIFICADOR
        {
            get
            {
                if (!Dicionario.ContainsKey("DIGITO_VERIFICADOR"))
                    Dicionario["DIGITO_VERIFICADOR"] = "0";

                return UInt32.Parse(Dicionario["DIGITO_VERIFICADOR"]);
            }
            set
            {
                Dicionario["DIGITO_VERIFICADOR"] = ((int)value).ToString().Substring(0, 1);
            }
        }

        /// <summary>
        /// Fator de Vencimento. Será informado o fator de vencimento enviado no arquivo remessa. Refere-se a posição 6 a 9 do código de barras ou os 4 (quatro) primeiros caracteres do 5º campo da Linha Digitável, quando diferente de zeros.
        /// </summary>
        [Atributo(Sequencia = 3, Regex = @"(?<FATOR_VENCIMENTO>\d{4})")]
        public char[] FATOR_VENCIMENTO
        {
            get
            {
                if (!Dicionario.ContainsKey("FATOR_VENCIMENTO"))
                    Dicionario["FATOR_VENCIMENTO"] = "".PadRight(4, '0');

                return Dicionario["FATOR_VENCIMENTO"].Substring(0, 4).ToCharArray();
            }
            set
            {
                Dicionario["FATOR_VENCIMENTO"] = String.Join("", value.Select(x => x.ToString())).Substring(0, 4);
            }
        }

        /// <summary>
        /// Valor do Documento. 
        /// </summary>
        [Atributo(Sequencia = 4, Regex = @"(?<VALOR>\d{10})")]
        public decimal VALOR
        {
            get
            {
                if (!Dicionario.ContainsKey("VALOR"))
                    Dicionario["VALOR"] = "".PadLeft(10, '0');

                if (string.IsNullOrEmpty(Dicionario["VALOR"]))
                    return 0;

                Decimal d;

                if (!Decimal.TryParse(Dicionario["VALOR"], out d))
                    return 0;

                return d / 100;
            }
            set
            {
                Dicionario["VALOR"] = value.ToString("0.00", CultureInfo.InvariantCulture).Replace(".", "").Replace(",", "").PadLeft(10, '0');
            }
        }

        /// <summary>
        /// As posições 20 a 44 do código de barras correspondem ao campo livre, que pode variar de um banco para outro
        /// </summary>
        [Atributo(Sequencia = 5, Regex = @"(?<CAMPO_LIVRE>.{25})")]
        public virtual string CAMPO_LIVRE
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

        #endregion

        #region Construtores

        /// <summary>
        /// Construtor da classe
        /// </summary>
        public CodigoBarras()
        {
            Reset();
        }

        /// <summary>
        /// Construtor da classe
        /// </summary>
        /// <param name="Registro"></param>
        public CodigoBarras(string CodigoBarra)
        {
            Reset();

            Parse(CodigoBarra);
        }

        #endregion

        #region Metodos

        /// <summary>
        /// Carrega as propriedades com valores padrão
        /// </summary>
        public virtual void Reset()
        {
            Dicionario.Clear();

            var props = from prop in this.GetType().GetProperties()
                        select prop;

            PropertyInfo currentProp = null;

            try
            {
                foreach (PropertyInfo p in props)
                {
                    currentProp = p;
                    p.GetValue(this, null);
                }
            }
            catch (Exception ex)
            {
                throw new Exception(currentProp.Name + ":" + ex.Message);
            }
        }

        /// <summary>
        /// Gera uma coleção com as propriedades da classe
        /// </summary>
        /// <returns></returns>
        public virtual PropertyInfo[] Propriedades()
        {
            return GetType()
                    .GetProperties(BindingFlags.Instance | BindingFlags.Public)
                    .Select(x => new
                    {
                        Property = x,
                        Attribute = (Atributo)Attribute.GetCustomAttribute(x, typeof(Atributo), true)
                    })
                    .OrderBy(x => x.Attribute != null ? x.Attribute.Sequencia : -1)
                    .Select(x => x.Property)
                    .ToArray();
        }

        /// <summary>
        /// Gera a expressão regular utilizada na validação dos campos do registro
        /// </summary>
        /// <returns></returns>
        public virtual string ExpressaoRegular()
        {
            string[] Expressao;

            Expressao = GetType()
                    .GetProperties(BindingFlags.Instance | BindingFlags.Public)
                    .Select(x => new
                    {
                        Property = x,
                        Attribute = (Atributo)Attribute.GetCustomAttribute(x, typeof(Atributo), true)
                    })
                    .OrderBy(x => x.Attribute != null ? x.Attribute.Sequencia : -1)
                    .Select(x => x.Attribute.Regex)
                    .ToArray();

            return "^" + String.Join("", Expressao) + "$";
        }

        /// <summary>
        /// Analisa e carrega nas propriedades da classe os valores de cada campo do código de barras.
        /// </summary>
        /// <returns>Retorna verdadeiro se a carga for concluida com sucesso</returns>
        public virtual bool Parse(string CodigoBarra)
        {
            Regex regex = new Regex(ExpressaoRegular(), RegexOptions.Compiled | RegexOptions.IgnoreCase | RegexOptions.ExplicitCapture /*| RegexOptions.Multiline*/);

            Match match = regex.Match(CodigoBarra);  // Analisa 1 registro (linha) por vez

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
        /// Analisa e carrega nas propriedades da classe os valores de cada campo do código de barras.
        /// </summary>
        /// <param name="dicionario">Dicionario contendo o par chave/valor a ser carregado para cada propriedade da classe, sendo o chave o nome do propriedade e valor os dados do campo.</param>
        /// <returns>Retorna verdadeiro se a carga for concluida com sucesso</returns>
        protected virtual bool Parse(Dictionary<string, string> dicionario)
        {

            #region Modo 1 - Carrega o Dicionario de Dados com foreach

            //foreach (string key in Parse.GetGroupNames())
            //{
            //    if (key != "0")
            //        Dicionario[key] = m.Groups[key].Value;
            //}

            #endregion

            #region Modo 2 - Carrega o Dicionario usando Linq:

            //Registro = Parse.GetGroupNames()
            //    .Where(name => m.Groups[name].Success)
            //    .ToDictionary(name => name, name => m.Groups[name].Value);

            #endregion

            #region Modo 3 - Carrega via propriedades GET/SET

            var props = from prop in this.GetType().GetProperties()
                        select prop;

            PropertyInfo p = null;
            PropertyInfo currentProp = null;
            string currentVal = "";

            try
            {
                Dictionary<string, string>.KeyCollection keys = dicionario.Keys;
                //foreach (PropertyInfo p in props)
                foreach (string key in keys.ToArray())
                {
                    //currentProp = p;
                    currentVal = dicionario[key];
                    p = props.Where(x => x.Name == key).First();

                    if (dicionario.ContainsKey(key) && !String.IsNullOrEmpty(dicionario[key]))
                        if (p.PropertyType == typeof(string))
                        {
                            p.SetValue(this, dicionario[p.Name], null);
                        }
                        else if (p.PropertyType.IsArray && p.PropertyType == typeof(char[]))
                        {
                            p.SetValue(this, dicionario[p.Name].ToCharArray(), null);
                        }
                        else if (p.PropertyType == typeof(Int32) || p.PropertyType == typeof(System.Nullable<Int32>))
                        {
                            Int32 i;

                            if (Int32.TryParse(dicionario[p.Name], out i))
                                p.SetValue(this, i, null);
                            else
                                throw new ArgumentException("O valor para " + currentProp.Name + " esta em um formato inválido: '" + dicionario[p.Name] + "'");
                        }
                        else if (p.PropertyType == typeof(uint) || p.PropertyType == typeof(System.Nullable<uint>))
                        {
                            uint i;

                            if (uint.TryParse(dicionario[p.Name], out i))
                                p.SetValue(this, i, null);
                            else
                                throw new ArgumentException("O valor para " + currentProp.Name + " esta em um formato inválido: '" + dicionario[p.Name] + "'");
                        }
                        else if (p.PropertyType == typeof(UInt32) || p.PropertyType == typeof(System.Nullable<UInt32>))
                        {
                            UInt32 i;

                            if (UInt32.TryParse(dicionario[p.Name], out i))
                                p.SetValue(this, i, null);
                            else
                                throw new ArgumentException("O valor para " + currentProp.Name + " esta em um formato inválido: '" + dicionario[p.Name] + "'");
                        }
                        else if (p.PropertyType == typeof(int) || p.PropertyType == typeof(System.Nullable<int>))
                        {
                            int i;

                            if (int.TryParse(dicionario[p.Name], out i))
                                p.SetValue(this, i, null);
                            else
                                throw new ArgumentException("O valor para " + currentProp.Name + " esta em um formato inválido: '" + dicionario[p.Name] + "'");
                        }
                        else if (p.PropertyType == typeof(decimal) || p.PropertyType == typeof(System.Nullable<decimal>))
                        {
                            decimal d;

                            if (dicionario[p.Name].Trim().Length == 0)
                                p.SetValue(this, null, null);
                            else if (dicionario[p.Name].ToString().IsNumericArray((uint)dicionario[p.Name].Trim().Length))
                            {
                                if (Decimal.TryParse(dicionario[p.Name], out d))
                                    p.SetValue(this, d / 100, null);
                                else
                                    throw new ArgumentException("O valor para " + currentProp.Name + " esta em um formato inválido: '" + dicionario[p.Name] + "'");
                            }
                            else
                                throw new ArgumentException("O valor para " + currentProp.Name + " esta em um formato inválido: '" + dicionario[p.Name] + "'");

                        }
                        else if (p.PropertyType == typeof(DateTime) || p.PropertyType == typeof(System.Nullable<DateTime>))
                        {
                            string format = "yyyyMMdd";
                            DateTime dt;

                            if (dicionario[p.Name].Trim().Length == 0)
                            {
                                p.SetValue(this, null, null);
                                continue;
                            }

                            if (dicionario[p.Name].Trim().Length != 4 && dicionario[p.Name].Trim().Length != 6 && dicionario[p.Name].Trim().Length != 8)
                                throw new InvalidDataException("O valor para " + currentProp.Name + " esta em um formato inválido: '" + dicionario[p.Name] + "'");

                            if (dicionario[p.Name].Trim().Length == 4)
                                format = "HHmm";

                            if (dicionario[p.Name].Trim().Length == 6)
                                format = "HHmmss";

                            if (DateTime.TryParseExact(dicionario[p.Name], format, null, System.Globalization.DateTimeStyles.None, out dt))
                                p.SetValue(this, dt, null);
                            else
                            {
                                if (dicionario[p.Name].Trim().CompareTo("".PadLeft(dicionario[p.Name].Trim().Length, '0')) == 0)
                                    p.SetValue(this, null, null);
                                else
                                    throw new ArgumentException("O valor para " + currentProp.Name + " esta em um formato inválido [" + format + "]: '" + dicionario[p.Name] + "'");
                            }
                        }
                        else if (p.PropertyType.IsEnum || (Nullable.GetUnderlyingType(p.PropertyType) != null && Nullable.GetUnderlyingType(p.PropertyType).IsEnum))
                        {
                            if (dicionario[p.Name].Trim().Length == 0)
                                p.SetValue(this, null, null);
                            //else if (dicionario[p.Name].Trim().CompareTo("".PadLeft(dicionario[p.Name].Trim().Length, '0')) == 0)
                            //    p.SetValue(this, null, null);
                            else if (dicionario[p.Name].Trim().Length > 0 && dicionario[p.Name].Trim().IsNumericArray((uint)dicionario[p.Name].Trim().Length))
                            {
                                try
                                {
                                    if (Nullable.GetUnderlyingType(p.PropertyType) != null)
                                        p.SetValue(this, Enum.Parse(Nullable.GetUnderlyingType(p.PropertyType), dicionario[p.Name].Trim(), true), null);
                                    else
                                        p.SetValue(this, Enum.Parse(p.PropertyType, dicionario[p.Name].Trim(), true), null);
                                }
                                catch
                                {
                                    p.SetValue(this, null, null);
                                }
                            }
                            else
                                throw new ArgumentException("O valor para " + currentProp.Name + " é inválido: '" + dicionario[p.Name] + "'");
                        }
                        else
                            throw new ArgumentException("Tipo desconhecido " + p.PropertyType.ToString() + " para a propriedade " + p.Name);
                    else
                        throw new ArgumentException("O código de barras não tem o valor de " + currentProp.Name);
                }
            }
            catch (ArgumentException a)
            {
                throw new ArgumentException((currentProp != null ? currentProp.Name : "") + " = [" + currentVal + "]:" + a.Message);
            }
            catch (Exception ex)
            {
                throw new Exception((currentProp != null ? currentProp.Name : "") + ":" + ex.Message);
            }

            #endregion

            return true;
        }

        /// <summary>
        /// Validação do registro.
        /// </summary>
        /// <returns></returns>
        public virtual IEnumerable<Exception> Validar()
        {
            string codigoBarra = Dicionario["IDENTIFICACAO_BANCO"] + Dicionario["CODIGO_MOEDA"] + Dicionario["FATOR_VENCIMENTO"] + Dicionario["VALOR"] + Dicionario["CAMPO_LIVRE"];

            uint digito = Banco.CalculoDigitoVerificadorCodigoBarra(codigoBarra.ToCharArray().ToNumericArray());

            if (DIGITO_VERIFICADOR != digito)
                yield return new Exception("Digito verificador errado. Digito atual: " + DIGITO_VERIFICADOR.ToString() + ", Digito calculado: " + digito.ToString());

        }

        #endregion

        #region Definição de Atributos

        /// <summary>
        /// Representa os atributos das propriedades de classe relacionadas aos registros no arquivo CNAB.
        /// </summary>
        [AttributeUsage(AttributeTargets.Property)]
        public class Atributo : Attribute
        {
            /// <summary>
            /// Representa a sequência em que os campos devem aparecer no arquivo CNAB.
            /// </summary>
            public int Sequencia { get; set; }

            /// <summary>
            /// Representa a expressão regular dos dados usada na validação do registro
            /// </summary>
            public string Regex { get; set; }

        }

        #endregion
    }


}
