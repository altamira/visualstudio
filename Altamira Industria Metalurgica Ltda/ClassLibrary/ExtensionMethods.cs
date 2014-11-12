using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.IO;
using System.ComponentModel;
using System.Reflection;

namespace SA.Data.Models
{
    public static class ExtensionMethods
    {
        #region Manipulação de Strings

        // Uso:
        // string Nome = "C# Brasil";
        // string MD5 = Nome.ToMD5();
        // Response.Write(MD5);
        public static string ToMD5(this string value)
        {
            System.Security.Cryptography.MD5 md5 = System.Security.Cryptography.MD5.Create();

            byte[] inputBytes = System.Text.Encoding.ASCII.GetBytes(value);
            byte[] hash = md5.ComputeHash(inputBytes);

            System.Text.StringBuilder sb = new System.Text.StringBuilder();

            for (int i = 0; i < hash.Length; i++)
            {
                sb.Append(hash[i].ToString("X2"));
            }

            return sb.ToString();
        }

        public static bool IsNumericArray(this string s, uint size)
        {
            char[] x = s.ToCharArray(); //.Select(i => byte.Parse(i.ToString())).ToArray();

            if (x == null || x.Length != size || x.Where(n => n < '0' || n > '9').Count() > 0)
                return false;

            return true;
        }

        public static string ReplaceExtendedChars(this string str)
        {
            try
            {
                return str.Replace("ã", "a").Replace('Ã', 'A').Replace('â', 'a').Replace('Â', 'A').Replace('á', 'a').Replace('Á', 'A').Replace('à', 'a').Replace('À', 'A').Replace('ç', 'c').Replace('Ç', 'C').Replace('é', 'e').Replace('É', 'E').Replace('õ', 'o').Replace('Õ', 'O').Replace('ó', 'o').Replace('Ó', 'O').Replace('ô', 'o').Replace('Ô', 'O').Replace('ú', 'u').Replace('Ú', 'U').Replace('ü', 'u').Replace('Ü', 'U').Replace('í', 'i').Replace('Í', 'I');
            }
            catch (Exception ex)
            {
                Exception tmpEx = new Exception("Erro ao substituir caracteres especiais no texto.", ex);
                throw tmpEx;
            }
        }

        // Ler todas as linhas de um arquivo texto e carregar em uma Coleção
        public static IEnumerable<string> GetLines(this TextReader streamReader)
        {
            string fileLine;
            while ((fileLine = streamReader.ReadLine()) != null)
            {
                yield return fileLine;
            }
        }
        #endregion

        #region Calculos
        // Calcular IPI
        public static decimal CalcularIPI(this decimal value, decimal percentual)
        {
            decimal Total = decimal.Divide(decimal.Multiply(value, percentual), 100);
            return Total;
        }
        #endregion

        #region Enums

        // TODO: Este metodo pode ser usado para listar os Enums em uma lista/combobox

        /* Exemplo de Uso: */
        //public enum TestEnum
        //{ 
        //    [Description("Something 1")]
        //    Dr = 0,
        //    [Description("Something 2")]
        //    Mr = 1
        //}

        //static void Main(string[] args)
        //{
        //    var vals = StaticClass.GetEnumFormattedNames<TestEnum>();
        //}
         
        public static string GetEnumDescription(Enum currentEnum)
        {
            string description = String.Empty;
            DescriptionAttribute da;

            FieldInfo fi = currentEnum.GetType().
                        GetField(currentEnum.ToString());
            da = (DescriptionAttribute)Attribute.GetCustomAttribute(fi,
                        typeof(DescriptionAttribute));
            if (da != null)
                description = da.Description;
            else
                description = currentEnum.ToString();

            return description;
        }

        public static List<string> GetEnumFormattedNames<TEnum>()
        {
            var enumType = typeof(TEnum);
            if (enumType == typeof(Enum))
                throw new ArgumentException("typeof(TEnum) == System.Enum", "TEnum");

            if (!(enumType.IsEnum))
                throw new ArgumentException(String.Format("typeof({0}).IsEnum == false", enumType), "TEnum");

            List<string> formattedNames = new List<string>();
            var list = Enum.GetValues(enumType).OfType<TEnum>().ToList<TEnum>();

            foreach (TEnum item in list)
            {
                formattedNames.Add(GetEnumDescription(item as Enum));
            }

            return formattedNames;
        }

        public static T ToEnum<T>(this string @string)
        {
            int tryInt;
            if (Int32.TryParse(@string, out tryInt)) return tryInt.ToEnum<T>();
            return (T)Enum.Parse(typeof(T), @string);
        }

        public static T ToEnum<T>(this int @int)
        {
            return (T)Enum.ToObject(typeof(T), @int);
        }

        #endregion
    }
}
