using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data.SqlClient;
using System.Data;

namespace SA.Web.Application
{
    public partial class RecadoDeclinar : System.Web.UI.Page
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

            if (DataReader.Read())
            {
                NumeroLabel.Text = DataReader["Número"].ToString();
                ClienteLabel.Text = DataReader["Nome Fantasia"].ToString();
                DataLabel.Text = DateTime.Parse(DataReader["Data do Cadastro"].ToString()).ToShortDateString();
            }
            else
            {
                TituloLabel.Text = "Recado não encontrado";
                FormDisable();
            }

            DataReader.Close();
            Connection.Close();
        }

        protected void GravarButtom_Click(object sender, ImageClickEventArgs e)
        {

        }

        private void FormDisable()
        {
            GravarButtom.Visible = false;
            GravarLabel.Visible = false;

            //NumeroLabel.Enabled = false;
            //SituacaoRadioButtonList.Enabled = false;
            //TipoMaterialTextBox.Enabled = false;
            //ProbabilidadeRabioButtonList.Enabled = false;
            //ConcorrentesTextBox.Enabled = false;
            //ProximoContatoCalendar.Enabled = false;
            //TipoMaterialCheckBoxList.Enabled = false;
            //ConcorrentesCheckBoxList.Enabled = false;
        }
    }
}