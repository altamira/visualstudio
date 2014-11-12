using System;
using System.Security.Cryptography;
using System.Text;
using System.Web.SessionState;
using System.Data.SqlClient;
using System.Data;

namespace SA.Web.Application.Lib
{
    public static class Security
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

        public static bool VerificaValidadeSessao(object Sessao, out DateTime Validade)
        {
            bool result = false;
            Guid Session;

            Validade = new DateTime();

            if (Sessao == null)
                return false;

            if (!Guid.TryParse(Sessao.ToString(), out Session))
                return false;

            SqlConnection Connection = new SqlConnection(System.Configuration.ConfigurationManager.ConnectionStrings["ConnectionString"].ConnectionString);
            Connection.Open();

            SqlCommand Command = new SqlCommand();
            Command.Connection = Connection;
            Command.CommandType = CommandType.StoredProcedure;
            //Command.UpdatedRowSource = UpdateRowSource.FirstReturnedRecord;
            Command.CommandText = "[Representante].[Verifica se a Sessão é Válida]";

            Command.Parameters.Add(new SqlParameter("@Sessao", SqlDbType.UniqueIdentifier)).Value = Session;

            SqlDataReader DataReader = Command.ExecuteReader();

            if (DataReader.Read())
            {
                Validade = DataReader.GetDateTime(2);
                result = true;
            }
            else
            {
                result = false;
            }

            DataReader.Close();
            Connection.Close();

            return result;
        }

    }
}