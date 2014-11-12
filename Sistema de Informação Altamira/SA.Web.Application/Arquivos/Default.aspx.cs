using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data.SqlClient;
using System.Data;

namespace SA.Web.Application.Arquivos
{
    public partial class Default : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            DateTime Validade;

            if (!SA.Web.Application.Lib.Security.VerificaValidadeSessao(Session["Sessao"], out Validade))
                Response.Redirect("/Acesso.aspx");

            Session["Validade"] = Validade;

            if (!Page.IsPostBack)
                ListaArquivos();
        }

        protected void ListaArquivos()
        {
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

            Command.CommandText = "[Representante].[Lista Arquivos do Orçamento]";

            Command.Parameters.Add(new SqlParameter("@Sessao", SqlDbType.UniqueIdentifier)).Value = Guid.Parse(Session["Sessao"].ToString().Trim());
            Command.Parameters.Add(new SqlParameter("@Orcamento", SqlDbType.Int)).Value = Numero.ToString();

            SqlDataReader DataReader = Command.ExecuteReader();

            if (DataReader.Read())
            {
                TituloLabel.Text = "Lista de Arquivo do Orçamento";

                NumeroLabel.Text = DataReader["Número"].ToString();
                ClienteLabel.Text = DataReader["Nome Fantasia"].ToString();
                DataLabel.Text = DateTime.Parse(DataReader["Data do Cadastro"].ToString()).ToShortDateString();

                DataReader.NextResult();

                ArquivosGridView.DataSource = DataReader;
                ArquivosGridView.DataBind();
            }
            else
            {
                TituloLabel.Text = "Nenhum arquivo encontrado !";
            }

            DataReader.Close();

            Connection.Close();
        }

    }
}