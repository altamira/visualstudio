using System;
using System.Web.UI;
using System.Data.SqlClient;
using System.Data;

namespace WebApplication1
{
    public partial class recado : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            DateTime Validade;

            if (!ALTANet.Lib.Security.VerificaValidadeSessao(Session["Sessao"], out Validade))
                Response.Redirect("/Acesso.aspx");

            Session["Validade"] = Validade;

            if (!Page.IsPostBack)
            {
                View();
            }
        }

        private void View()
        {
            int Numero = 0;
            if (!int.TryParse(Request.QueryString.ToString(), out Numero))
            {
                TituloLabel.Text = "Número inválido";
                return;
            }

            SqlConnection Connection = new SqlConnection(System.Configuration.ConfigurationManager.ConnectionStrings["ConnectionString"].ConnectionString);
            Connection.Open();

            SqlCommand Command = new SqlCommand();
            Command.Connection = Connection;
            Command.CommandType = CommandType.StoredProcedure;

            Command.CommandText = "[Representante].[Seleciona Recado]";

            Command.Parameters.Add(new SqlParameter("@Sessao", SqlDbType.UniqueIdentifier)).Value = Guid.Parse(Session["Sessao"].ToString().Trim());
            Command.Parameters.Add(new SqlParameter("@Numero", SqlDbType.Int)).Value = Request.QueryString.ToString();

            SqlDataReader DataReader = Command.ExecuteReader();

            if (DataReader.HasRows)
                TituloLabel.Text = "Recado " + Numero.ToString();
            else
                TituloLabel.Text = "Este número de Recado não foi encontrado para este Representante !";

            RecadoFormView.DataSource = DataReader;
            RecadoFormView.DataBind();

            DataReader.Close();
            Connection.Close();
        }
    }
}