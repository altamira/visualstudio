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
    public partial class Agenda : System.Web.UI.Page
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
            ProximoContatoCalendar.SelectedDate = DateTime.Now.Date;

            DataLabel.Text = DateTime.Now.Date.ToShortDateString();

            int Numero = 0;
            if (!int.TryParse(Request.QueryString.ToString(), out Numero))
            {
                //TituloLabel.Text = "Número inválido";
                return;
            }

            SqlConnection Connection = new SqlConnection(System.Configuration.ConfigurationManager.ConnectionStrings["ConnectionString"].ConnectionString);
            Connection.Open();

            SqlCommand Command = new SqlCommand();
            Command.Connection = Connection;
            Command.CommandType = CommandType.StoredProcedure;

            Command.CommandText = "[Representante].[Seleciona Recado]";

            Command.Parameters.Add(new SqlParameter("@Sessao", SqlDbType.UniqueIdentifier)).Value = Guid.Parse(Session["Sessao"].ToString().Trim());
            Command.Parameters.Add(new SqlParameter("@Numero", SqlDbType.Int)).Value = Numero;

            SqlDataReader DataReader = Command.ExecuteReader();

            if (DataReader.Read())
            {
                NumeroLabel.Text = DataReader["Número"].ToString();
                ClienteLabel.Text = DataReader["Nome Fantasia"].ToString();
                DataLabel.Text = DateTime.Parse(DataReader["Data do Cadastro"].ToString()).ToShortDateString();
                NomeFantasiaTextBox.Text = DataReader["Nome Fantasia"].ToString();
                RazaoSocialTextBox.Text = DataReader["Razão Social"].ToString();
                EnderecoTextBox.Text = DataReader["Endereço"].ToString();
                NumeroTextBox.Text = DataReader["Número do Endereço"].ToString();
                ComplementoTextBox.Text = DataReader["Complemento do Endereço"].ToString();
                BairroTextBox.Text = DataReader["Bairro"].ToString();
                CidadeTextBox.Text = DataReader["Cidade"].ToString();
                EstadoDropDownList.SelectedValue = DataReader["Estado"].ToString();
                DDDTelefoneTextBox.Text = DataReader["DDD do Telefone do Contato"].ToString();
                TelefoneTextBox.Text = DataReader["Telefone do Contato"].ToString();
                TelefoneRamalTextBox.Text = DataReader["Ramal do Telefone do Contato"].ToString();
                DDDCelularTextBox.Text = DataReader["DDD do Celular do Contato"].ToString();
                CelularTextBox.Text = DataReader["Celular do Contato"].ToString();
                ContatoTextBox.Text = DataReader["Nome do Contato"].ToString();
                DepartamentoTextBox.Text = DataReader["Departamento"].ToString();
                EmailTextBox.Text = DataReader["Email"].ToString();

                ProximoContatoCalendar.SelectedDate = DateTime.Now.Date;

                //RecadoFormView.DataSource = DataReader;
                //RecadoFormView.DataBind();
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
            int Numero = 0;
            if (!int.TryParse(Request.QueryString.ToString(), out Numero))
            {
                //TituloLabel.Text = "Número inválido";
                //return;
            }

            SqlConnection Connection = new SqlConnection(System.Configuration.ConfigurationManager.ConnectionStrings["ConnectionString"].ConnectionString);
            Connection.Open();

            SqlCommand Command = new SqlCommand();
            Command.Connection = Connection;
            Command.CommandType = CommandType.StoredProcedure;

            Command.CommandText = "[Representante].[Agendar Visita do Representante]";

            Command.Parameters.Add(new SqlParameter("@Sessao", SqlDbType.UniqueIdentifier)).Value = Guid.Parse(Session["Sessao"].ToString().Trim());
            Command.Parameters.Add(new SqlParameter("@Representante", SqlDbType.Int)).Value = Session["Id"].ToString().Trim();
            Command.Parameters.Add(new SqlParameter("@Recado", SqlDbType.Int)).Value = Numero;
            DateTime dt = ProximoContatoCalendar.SelectedDate;
            dt = dt.AddHours(int.Parse(HoraDropDownList.SelectedValue));
            dt = dt.AddMinutes(int.Parse(MinutoDropDownList.SelectedValue));
            Command.Parameters.Add(new SqlParameter("@DataAgenda", SqlDbType.DateTime)).Value = dt;

            Command.Parameters.Add(new SqlParameter("@NomeFantasia", SqlDbType.NVarChar, 50)).Value = NomeFantasiaTextBox.Text;
            Command.Parameters.Add(new SqlParameter("@RazaoSocial", SqlDbType.NVarChar, 50)).Value = RazaoSocialTextBox.Text;
            Command.Parameters.Add(new SqlParameter("@Endereco", SqlDbType.NVarChar, 50)).Value = EnderecoTextBox.Text;
            Command.Parameters.Add(new SqlParameter("@Numero", SqlDbType.NVarChar, 5)).Value = NumeroTextBox.Text;
            Command.Parameters.Add(new SqlParameter("@Complemento", SqlDbType.NVarChar, 10)).Value = ComplementoTextBox.Text;
            Command.Parameters.Add(new SqlParameter("@Bairro", SqlDbType.NVarChar, 50)).Value = BairroTextBox.Text;
            Command.Parameters.Add(new SqlParameter("@Cidade", SqlDbType.NVarChar, 50)).Value = CidadeTextBox.Text;
            Command.Parameters.Add(new SqlParameter("@Estado", SqlDbType.NChar, 2)).Value = EstadoDropDownList.SelectedValue;
            Command.Parameters.Add(new SqlParameter("@Contato", SqlDbType.NVarChar, 40)).Value = ContatoTextBox.Text;
            Command.Parameters.Add(new SqlParameter("@Departamento", SqlDbType.NVarChar, 35)).Value = DepartamentoTextBox.Text;
            Command.Parameters.Add(new SqlParameter("@DDDTelefone", SqlDbType.NChar, 3)).Value = DDDTelefoneTextBox.Text;
            Command.Parameters.Add(new SqlParameter("@Telefone", SqlDbType.NVarChar, 15)).Value = TelefoneTextBox.Text;
            Command.Parameters.Add(new SqlParameter("@RamalTelefone", SqlDbType.NChar, 5)).Value = TelefoneRamalTextBox.Text;
            Command.Parameters.Add(new SqlParameter("@DDDCelular", SqlDbType.NVarChar)).Value = DDDCelularTextBox.Text;
            Command.Parameters.Add(new SqlParameter("@Celular", SqlDbType.NVarChar, 15)).Value = CelularTextBox.Text;
            Command.Parameters.Add(new SqlParameter("@Email", SqlDbType.NVarChar, 100)).Value = EmailTextBox.Text;

            Command.Parameters.Add(new SqlParameter("@Observacao", SqlDbType.NVarChar)).Value = ObservacoesTextBox.Text;

            try
            {
                Command.ExecuteNonQuery();
                MensagemLabel.Text = "A Visita foi Agendada.";
            }
            catch (Exception)
            {
                MensagemLabel.Text = "Ocorreu um erro ao Agendar a Visita";
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