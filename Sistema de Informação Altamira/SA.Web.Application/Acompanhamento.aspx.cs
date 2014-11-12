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
    public partial class Acompanhamento : System.Web.UI.Page
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
            string[] TiposMateriais, PrincipaisConcorrentes;

            SqlConnection Connection = new SqlConnection(System.Configuration.ConfigurationManager.ConnectionStrings["ConnectionString"].ConnectionString);
            Connection.Open();

            SqlCommand Command = new SqlCommand();
            Command.Connection = Connection;
            Command.CommandType = CommandType.StoredProcedure;

            Command.CommandText = "[Representante].[Seleciona Orçamento]";

            Command.Parameters.Add(new SqlParameter("@Sessao", SqlDbType.UniqueIdentifier)).Value = Guid.Parse(Session["Sessao"].ToString().Trim());
            Command.Parameters.Add(new SqlParameter("@Numero", SqlDbType.Int)).Value = Request.QueryString.ToString();

            SqlDataReader DataReader = Command.ExecuteReader();

            if (DataReader.Read())
            {
                NumeroLabel.Text = DataReader["Número"].ToString();
                ClienteLabel.Text = DataReader["Nome Fantasia"].ToString();
                DataLabel.Text = DateTime.Parse(DataReader["Data do Cadastro"].ToString()).ToShortDateString();
                //SituacaoDropDown.SelectedValue = DataReader["Situação"].ToString();
                SituacaoRadioButtonList.SelectedValue = DataReader["Situação Atual"].ToString();
                //TipoMaterialCheckBoxList.SelectedValue = DataReader["Principais Tipos de Materiais"].ToString();
                TipoMaterialTextBox.Text = DataReader["Outros Tipos de Materiais"].ToString();
                ProbabilidadeRabioButtonList.SelectedValue = DataReader["Probabilidade de Fechamento"].ToString();
                //ConcorrentesCheckBoxList.SelectedValue = DataReader["Nome dos Principais Concorrentes"].ToString();
                ConcorrentesTextBox.Text = DataReader["Nome de Outros Concorrentes"].ToString();
                //ObservacoesTextBox.Text = DataReader["Observações"].ToString();
                ProximoContatoCalendar.SelectedDate = DateTime.Today.AddDays(10);

                if (SituacaoRadioButtonList.SelectedValue.Length == 0)
                    SituacaoRadioButtonList.SelectedValue = "Em Andamento";

                TiposMateriais = DataReader["Principais Tipos de Materiais"].ToString().Trim().Split(',');
                foreach (string t in TiposMateriais)
                    if (TipoMaterialCheckBoxList.Items.FindByValue(t.Trim()) != null)
                        TipoMaterialCheckBoxList.Items.FindByValue(t.Trim()).Selected = true;

                PrincipaisConcorrentes = DataReader["Nome dos Principais Concorrentes"].ToString().Trim().Split(',');
                foreach (string c in PrincipaisConcorrentes)
                    if (ConcorrentesCheckBoxList.Items.FindByValue(c.Trim()) != null)
                        ConcorrentesCheckBoxList.Items.FindByValue(c.Trim()).Selected = true;

                DataReader.NextResult(); // Itens do Orçamento

                if (DataReader.NextResult())
                {
                    HistoricoGridView.DataSource = DataReader;
                    HistoricoGridView.DataBind();
                }

                if (SituacaoRadioButtonList.SelectedValue == "Perdido" || 
                    SituacaoRadioButtonList.SelectedValue == "Fechado" ||
                    SituacaoRadioButtonList.SelectedValue == "Cancelado" ||
                    SituacaoRadioButtonList.SelectedValue == "Suspenso")
                {
                    FormDisable();
                }
            }
            else
            {
                MensagemLabel.Text = "Este número de Orçamento não foi encontrado para este Representante.";
                FormDisable();
            }

            DataReader.Close();
            Connection.Close();
        }

        protected void GravarButtom_Click(object sender, ImageClickEventArgs e)
        {
            string TiposMateriais = "";
            string PrincipaisConcorrentes = "";

            foreach (ListItem t in TipoMaterialCheckBoxList.Items)
            {
                if (t.Selected)
                    TiposMateriais += (TiposMateriais.Length > 0 ? "," : "") + t.Text;
            }

            foreach (ListItem c in ConcorrentesCheckBoxList.Items)
            {
                if (c.Selected)
                    PrincipaisConcorrentes += (PrincipaisConcorrentes.Length > 0 ? "," : "") + c.Text;
            }

            SqlConnection Connection = new SqlConnection(System.Configuration.ConfigurationManager.ConnectionStrings["ConnectionString"].ConnectionString);
            Connection.Open();

            SqlCommand Command = new SqlCommand();
            Command.Connection = Connection;
            Command.CommandType = CommandType.StoredProcedure;

            Command.CommandText = "[Representante].[Atualizar a Situação do Orçamento]";

            Command.Parameters.Add(new SqlParameter("@Sessao", SqlDbType.UniqueIdentifier)).Value = Guid.Parse(Session["Sessao"].ToString().Trim());
            Command.Parameters.Add(new SqlParameter("@Representante", SqlDbType.Int)).Value = Session["Id"].ToString().Trim();
            Command.Parameters.Add(new SqlParameter("@Numero", SqlDbType.Int)).Value = Request.QueryString.ToString();
            //Command.Parameters.Add(new SqlParameter("@Situacao", SqlDbType.NVarChar, 50)).Value = SituacaoDropDown.SelectedValue.ToString();
            Command.Parameters.Add(new SqlParameter("@Situacao", SqlDbType.NVarChar, 50)).Value = SituacaoRadioButtonList.SelectedValue.ToString();
            Command.Parameters.Add(new SqlParameter("@TiposMateriais", SqlDbType.NVarChar, 5000)).Value = TiposMateriais;
            Command.Parameters.Add(new SqlParameter("@OutrosTiposMateriais", SqlDbType.NVarChar, 50)).Value = TipoMaterialTextBox.Text;
            //Command.Parameters.Add(new SqlParameter("@Probabilidade", SqlDbType.Int)).Value = int.Parse(ProbabilidadeDropDownList.SelectedValue.ToString());
            Command.Parameters.Add(new SqlParameter("@Probabilidade", SqlDbType.Int)).Value = int.Parse(ProbabilidadeRabioButtonList.SelectedValue.ToString());
            Command.Parameters.Add(new SqlParameter("@PrincipaisConcorrentes", SqlDbType.NVarChar, 5000)).Value = PrincipaisConcorrentes; // ConcorrentesCheckBoxList.SelectedValue;
            Command.Parameters.Add(new SqlParameter("@OutrosConcorrentes", SqlDbType.NVarChar, 50)).Value = ConcorrentesTextBox.Text;
            Command.Parameters.Add(new SqlParameter("@ProximoContato", SqlDbType.Date)).Value = ProximoContatoCalendar.SelectedDate;
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

        private void FormDisable()
        {
            GravarButtom.Visible = false;
            GravarLabel.Visible = false;

            NumeroLabel.Enabled = false;
            SituacaoRadioButtonList.Enabled = false;
            TipoMaterialTextBox.Enabled = false;
            ProbabilidadeRabioButtonList.Enabled = false;
            ConcorrentesTextBox.Enabled = false;
            ProximoContatoCalendar.Enabled = false;
            TipoMaterialCheckBoxList.Enabled = false;
            ConcorrentesCheckBoxList.Enabled = false;
            ObservacoesTextBox.Enabled = false;
        }
    }
}