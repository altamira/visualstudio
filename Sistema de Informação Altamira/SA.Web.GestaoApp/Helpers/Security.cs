using System;
using System.Security.Cryptography;
using System.Text;

namespace GestaoApp.Helpers
{
    public static class Cripto
    {
        public static string GetSHA1Hash(string str)
        {
            Encoder enc = System.Text.Encoding.Unicode.GetEncoder();

            byte[] unicodeText = new byte[str.Length * 2];
            enc.GetBytes(str.ToCharArray(), 0, str.Length, unicodeText, 0, true);

            System.Security.Cryptography.SHA1 sha = new System.Security.Cryptography.SHA1Managed();

            byte[] result = sha.ComputeHash(unicodeText);

            StringBuilder sb = new StringBuilder();
            for (int i = 0; i < result.Length; i++)
            {
                sb.Append(result[i].ToString("X2"));
            }
            return sb.ToString();
        }
    }
}
