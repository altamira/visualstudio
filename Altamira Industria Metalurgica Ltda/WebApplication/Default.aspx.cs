using System;
using System.Data.SqlClient;
using System.Data;

namespace WebApplication1
{
    public partial class Default : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            DateTime Validade;

            if (!ALTANet.Lib.Security.VerificaValidadeSessao(Session["Sessao"], out Validade))
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

            Command.CommandText = "[Representante].[Indicadores]";

            Command.Parameters.Add(new SqlParameter("@Sessao", SqlDbType.UniqueIdentifier)).Value = Guid.Parse(Session["Sessao"].ToString().Trim());

            SqlDataReader DataReader = Command.ExecuteReader();

            if (DataReader.Read())
            {
                if (DataReader["RecadoQuantidadeSemana"] != null) RecadosQuantidadeSemana.Text = DataReader["RecadoQuantidadeSemana"].ToString();

                if (DataReader.NextResult() && DataReader.Read())
                    if (DataReader["RecadoQuantidadeMes"] != null) RecadosQuantidadeMes.Text = DataReader["RecadoQuantidadeMes"].ToString();

                if (DataReader.NextResult() && DataReader.Read())
                    if (DataReader["RecadoQuantidadeAno"] != null) RecadosQuantidadeAno.Text = DataReader["RecadoQuantidadeAno"].ToString();

                if (DataReader.NextResult() && DataReader.Read())
                    if (DataReader["OrcamentoQuantidadeSemana"] != null) OrcamentosQuantidadeSemana.Text = DataReader["OrcamentoQuantidadeSemana"].ToString();

                if (DataReader.NextResult() && DataReader.Read())
                    if (DataReader["OrcamentoQuantidadeMes"] != null) OrcamentosQuantidadeMes.Text = DataReader["OrcamentoQuantidadeMes"].ToString();

                if (DataReader.NextResult() && DataReader.Read())
                    if (DataReader["OrcamentoQuantidadeAno"] != null) OrcamentosQuantidadeAno.Text = DataReader["OrcamentoQuantidadeAno"].ToString();

                if (DataReader.NextResult() && DataReader.Read())
                    if (DataReader["OrcamentoValorSemana"] != null) OrcamentosValorSemana.Text = DataReader.GetSqlMoney(0).ToDecimal().ToString("c"); 

                if (DataReader.NextResult() && DataReader.Read())
                    if (DataReader["OrcamentoValorMes"] != null) OrcamentosValorMes.Text = DataReader.GetSqlMoney(0).ToDecimal().ToString("c"); 

                if (DataReader.NextResult() && DataReader.Read())
                    if (DataReader["OrcamentoValorAno"] != null) OrcamentosValorAno.Text = DataReader.GetSqlMoney(0).ToDecimal().ToString("c"); 

                if (DataReader.NextResult() && DataReader.Read())
                    if (DataReader["PedidoQuantidadeSemana"] != null) PedidoQuantidadeSemana.Text = DataReader["PedidoQuantidadeSemana"].ToString();

                if (DataReader.NextResult() && DataReader.Read())
                    if (DataReader["PedidoQuantidadeMes"] != null) PedidoQuantidadeMes.Text = DataReader["PedidoQuantidadeMes"].ToString();

                if (DataReader.NextResult() && DataReader.Read())
                    if (DataReader["PedidoQuantidadeAno"] != null) PedidoQuantidadeAno.Text = DataReader["PedidoQuantidadeAno"].ToString();

                if (DataReader.NextResult() && DataReader.Read())
                    if (DataReader["PedidoValorSemana"] != null) PedidoValorSemana.Text = DataReader.GetSqlMoney(0).ToDecimal().ToString("c"); 

                if (DataReader.NextResult() && DataReader.Read())
                    if (DataReader["PedidoValorMes"] != null) PedidoValorMes.Text = DataReader.GetSqlMoney(0).ToDecimal().ToString("c"); 

                if (DataReader.NextResult() && DataReader.Read())
                    if (DataReader["PedidoValorAno"] != null) PedidoValorAno.Text = DataReader.GetSqlMoney(0).ToDecimal().ToString("c"); 

            }

            DataReader.Close();
            Connection.Close();
        }

    }
}