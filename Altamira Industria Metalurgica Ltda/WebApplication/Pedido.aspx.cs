using System;
using System.Web.UI;
using System.Data.SqlClient;
using System.Data;

namespace WebApplication1
{
    public partial class pedido : System.Web.UI.Page
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

            Command.CommandText = "[Representante].[Seleciona Pedido de Venda]";

            Command.Parameters.Add(new SqlParameter("@Sessao", SqlDbType.UniqueIdentifier)).Value = Guid.Parse(Session["Sessao"].ToString().Trim());
            Command.Parameters.Add(new SqlParameter("@Numero", SqlDbType.Int)).Value = Request.QueryString.ToString();

            SqlDataReader DataReader = Command.ExecuteReader();

            if (DataReader.HasRows)
                TituloLabel.Text = "Pedido de Venda " + Numero.ToString();
            else
                TituloLabel.Text = "Este número de Pedido de Venda não foi encontrado para este Representante !";

            PedidoFormView.DataSource = DataReader;
            PedidoFormView.DataBind();

            if (DataReader.NextResult())
            {
                ItemPedidoGridView.DataSource = DataReader;
                ItemPedidoGridView.DataBind();
            }

            DataReader.Close();
            Connection.Close();
        }

    }
}