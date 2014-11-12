using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace SA.Web.Application
{
    public partial class VisitaDeclinar : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            DateTime Validade;

            if (!SA.Web.Application.Lib.Security.VerificaValidadeSessao(Session["Sessao"], out Validade))
                Response.Redirect("/Acesso.aspx");

            Session["Validade"] = Validade;

            if (!Page.IsPostBack)
                FormLoad();
        }

        private void FormLoad()
        {
            SqlConnection Connection = new SqlConnection(System.Configuration.ConfigurationManager.ConnectionStrings["ConnectionString"].ConnectionString);
            Connection.Open();

            SqlCommand Command = new SqlCommand();
            Command.Connection = Connection;
            Command.CommandType = CommandType.StoredProcedure;

            Command.CommandText = "[Representante].[Seleciona Agenda]";

            Command.Parameters.Add(new SqlParameter("@Sessao", SqlDbType.UniqueIdentifier)).Value = Guid.Parse(Session["Sessao"].ToString().Trim());
            Command.Parameters.Add(new SqlParameter("@Numero", SqlDbType.Int)).Value = Request.QueryString.ToString();

            SqlDataReader DataReader = Command.ExecuteReader();

            if (DataReader.Read())
            {
                ClienteLabel.Text = DataReader["Nome Fantasia"].ToString();
                DataLabel.Text = DateTime.Parse(DataReader["Data do Cadastro"].ToString()).ToShortDateString();
            }
            else
            {
                MensagemLabel.Text = "Esta agenda não foi encontrada para este Representante.";
            }

            DataReader.Close();
            Connection.Close();
        }

        protected void GravarButtom_Click(object sender, ImageClickEventArgs e)
        {

            SqlConnection Connection = new SqlConnection(System.Configuration.ConfigurationManager.ConnectionStrings["ConnectionString"].ConnectionString);
            Connection.Open();

            SqlCommand Command = new SqlCommand();
            Command.Connection = Connection;
            Command.CommandType = CommandType.StoredProcedure;

            Command.CommandText = "[Representante].[Declinar Visita]";

            Command.Parameters.Add(new SqlParameter("@Sessao", SqlDbType.UniqueIdentifier)).Value = Guid.Parse(Session["Sessao"].ToString().Trim());
            Command.Parameters.Add(new SqlParameter("@Representante", SqlDbType.Int)).Value = Session["Id"].ToString().Trim();
            Command.Parameters.Add(new SqlParameter("@Numero", SqlDbType.Int)).Value = Request.QueryString.ToString();
            Command.Parameters.Add(new SqlParameter("@Situacao", SqlDbType.Char)).Value = "D";
            Command.Parameters.Add(new SqlParameter("@Observacao", SqlDbType.NVarChar)).Value = ObservacoesTextBox.Text;

            try
            {
                Command.ExecuteNonQuery();
                MensagemLabel.Text = "A Situação foi atualizada";
            }
            catch (Exception)
            {
                MensagemLabel.Text = "Ocorreu um erro ao atualizar a Situação";
            }

            Connection.Close();

            GravarButtom.Visible = false;
            GravarLabel.Visible = false;
            ObservacoesTextBox.Text = "";

            FormLoad();
        }

    }
}