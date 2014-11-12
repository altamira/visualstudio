using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Reflection;
using System.Text;
using System.Text.RegularExpressions;
using System.Threading.Tasks;

namespace SA.Data.Models.Financeiro.Bancos
{
    public partial class Bradesco : Banco
    {
        public partial class CNAB
        {
            /// <summary>
            /// Representa um registro dentro do arquivo Remessa/Retorno
            /// </summary>
            public abstract partial class Registro
            {
                #region Variaveis

                /// <summary>
                /// Armazena a linha original do registro extraida do arquivo CNAB para efeito de depuração ou arquivamento para uso futuro.
                /// </summary>
                protected string _Registro = "";

                /// <summary>
                /// Este dicionário armazena os dados do registro CNAB no formato chave/valor.
                /// </summary>
                protected Dictionary<string, string> Dicionario = new Dictionary<string, string>();

                #endregion

                #region Construtores

                public Registro()
                {
                    Reset();
                }

                #endregion

                #region Metodos

                /// <summary>
                /// Carrega as propriedades do Registro com valores padrão
                /// </summary>
                public virtual void Reset()
                {
                    Dicionario.Clear();
                    _Registro = "";

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
                            .Where(x => !x.Attribute.Escritural)
                            .OrderBy(x => x.Attribute != null ? x.Attribute.Sequencia : -1)
                            .Select(x => x.Property)
                        //.Select(x => x.Attribute.Regex)
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
                            .Where(x => !x.Attribute.Escritural)
                            .OrderBy(x => x.Attribute != null ? x.Attribute.Sequencia : -1)
                        //.Select(x => x.Property)
                            .Select(x => x.Attribute.Regex)
                            .ToArray();

                    return "^" + String.Join("", Expressao) + "$";
                }

                /// <summary>
                /// Analisa e carrega nas propriedades da classe os valores de cada campo do registro.
                /// </summary>
                /// <returns>Retorna verdadeiro se a carga for concluida com sucesso</returns>
                public virtual bool Parse()
                {
                    Regex regex = new Regex(ExpressaoRegular(), RegexOptions.Compiled | RegexOptions.IgnoreCase | RegexOptions.ExplicitCapture /*| RegexOptions.Multiline*/);

                    Match match = regex.Match(_Registro);  // Analisa 1 registro (linha) por vez

                    if (!match.Success)
                        throw new Exception("Registro CNAB inválido. O dados do registro " + this.GetType().Name + " não estão de acordo com o formato esperado. Registro:[" + _Registro + "], Expressão de Validação:[" + ExpressaoRegular() + "]");

                    Dictionary<string, string> dicionario = regex.GetGroupNames()
                        .Where(name => match.Groups[name].Success && match.Groups[name].Captures.Count > 0 && name != "0" /*&& match.Groups[name].Index > 0*/)
                        .ToDictionary(name => name, name => match.Groups[name].Value);

                    return Parse(dicionario);
                }

                /// <summary>
                /// Analisa e carrega nas propriedades da classe os valores de cada campo do registro.
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
                                else if (Nullable.GetUnderlyingType(p.PropertyType) == typeof(CNAB.Ocorrencia) || p.PropertyType == typeof(System.Nullable<CNAB.Ocorrencia>))
                                {
                                    if (dicionario[p.Name].Trim().Length == 0)
                                        p.SetValue(this, null, null);
                                    else if (CNAB.Ocorrencias.ContainsKey(dicionario[p.Name]))
                                        p.SetValue(this, CNAB.Ocorrencias[dicionario[p.Name]], null);
                                    else
                                        throw new ArgumentException("O valor para " + currentProp.Name + " é inválido: '" + dicionario[p.Name] + "'");
                                }
                                else
                                    throw new ArgumentException("Tipo desconhecido " + p.PropertyType.ToString() + " para a propriedade " + p.Name);
                            else
                                throw new ArgumentException("O registro não tem o valor para " + currentProp.Name);
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
                /// Gerar registro CNAB
                /// </summary>
                /// <param name="Stream">Fluxo de dados onde será escrito o registro</param>
                /// <returns>Retorna verdadeiro se o registro for gerado com sucesso.</returns>
                public virtual bool Write(StreamWriter Stream)
                {
                    StringBuilder s = new StringBuilder();

                    var props = from prop in this.GetType().GetProperties()
                                select prop;

                    PropertyInfo currentProp = null;
                    try
                    {
                        foreach (PropertyInfo p in props)
                        {
                            currentProp = p;
                            if (Dicionario.ContainsKey(p.Name) && !String.IsNullOrEmpty(Dicionario[p.Name]))
                            {
                                s.Append(Dicionario[p.Name]);
                            }
                            else
                                throw new ArgumentException("Os dados para o campo " + p.Name + " não foi encontrado.");
                        }
                    }
                    catch (ArgumentException a)
                    {
                        throw new ArgumentException(a.Message);
                    }
                    catch (Exception e)
                    {
                        throw new Exception(e.Message);
                    }

                    Stream.WriteLine(s.ToString());

                    return true;
                }

                #endregion

            }

        }
    }
}
