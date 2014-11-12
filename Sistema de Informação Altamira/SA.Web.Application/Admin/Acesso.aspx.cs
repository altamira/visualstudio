using System;
using System.Web.UI.WebControls;
using System.Web.Security;
using System.Data.SqlClient;
using System.Data;
using SA.Web.Application.Lib;

namespace SA.Web.Application.Admin
{
    public partial class Acesso : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {

        }

        protected void Authenticate(object sender, AuthenticateEventArgs e)
        {
            SqlConnection Connection = new SqlConnection(System.Configuration.ConfigurationManager.ConnectionStrings["ConnectionString"].ConnectionString);
            Connection.Open();

            SqlCommand Command = new SqlCommand();
            Command.Connection = Connection;
            Command.CommandType = CommandType.StoredProcedure;
            //Command.UpdatedRowSource = UpdateRowSource.FirstReturnedRecord;
            Command.CommandText = "[Usuario].[Cria Sessão do Usuario]";

            Command.Parameters.Add(new SqlParameter("RETURN_VALUE", SqlDbType.Int)).Direction = ParameterDirection.ReturnValue;
            Command.Parameters.Add(new SqlParameter("@Usuario", SqlDbType.NVarChar, 50)).Value = Login.UserName.ToString();
            Command.Parameters.Add(new SqlParameter("@Senha", SqlDbType.NVarChar, 40)).Value = Security.GetSHA1Hash(Login.Password.ToString());

            SqlDataReader DataReader = Command.ExecuteReader();

            //Int32 returnErro = (Int32)Command.Parameters["RETURN_VALUE"].Value;

            //if (DataReader.HasRows)
            //{
                if (DataReader.Read())
                {
                    //if (returnErro == 0)
                    //{
                        Session.Add("Sessao", DataReader.GetGuid(0));
                        Session.Add("Id", DataReader.GetInt32(1));
                        Session.Add("Nome", DataReader.GetString(2).ToString());
                        Session.Add("Validade", DataReader.GetDateTime(3));

                        e.Authenticated = true;
                        FormsAuthentication.RedirectFromLoginPage("~/Default.aspx", false);
                    //}
                    //else
                    //{
                    //    Login.FailureText = DataReader["Mensagem"].ToString();
                    //}
                }
            //}
            //else
            //{
            //    Login.FailureText = "Ocorreu um erro ao validar o acesso. Contate o suporte técnico da Altamira (sistemas.ti@altamira.com.br)";
            //}

            DataReader.Close();
            Command.Parameters.Clear();
        }

    }
}