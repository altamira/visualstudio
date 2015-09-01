using System;
using System.Collections.Generic;
using System.Linq;
using System.Runtime.Serialization;
using System.ServiceModel;
using System.ServiceModel.Web;
using System.Text;
using System.Data.SqlClient;
using System.Configuration;
using System.Data.SqlTypes;
using System.Web;
using System.Runtime.Remoting.Contexts;
using System.ServiceModel.Channels;
using System.Net;
using System.Security.Cryptography;

namespace Webservice
{
    // NOTE: You can use the "Rename" command on the "Refactor" menu to change the class name "Service" in code, svc and config file together.
    public class Service : IPlanoContas
    {
        float VERSAO = 1.6f;

        public string GenerateToken(DateTime dateTime)
        {
            MD5 md5 = System.Security.Cryptography.MD5.Create();
            //DateTime dateTime = DateTime.UtcNow;
            dateTime = dateTime.AddSeconds(-dateTime.Second);
            if (dateTime.Minute % 2 != 0)
                dateTime = dateTime.AddMinutes(1);

            byte[] inputBytes = System.Text.Encoding.ASCII.GetBytes(dateTime.ToString());
            byte[] hash = md5.ComputeHash(inputBytes);

            StringBuilder sb = new StringBuilder();
            for (int i = 0; i < hash.Length; i++)
            {
                sb.Append(hash[i].ToString("X2"));
            }
            return sb.ToString();
        }

        public List<ContaContabil> PlanoContasList(/*string Token, DateTime RequestDateTime*/)
        {
            //string currentToken = GenerateToken(RequestDateTime);

            //if (currentToken.CompareTo(Token) != 0)
            //{
            //    Log("PLCONTAS", "INVALID TOKEN");
            //    return null;
            //}

            List<ContaContabil> pc = new List<ContaContabil>();

            SqlConnection connection = new SqlConnection(ConfigurationManager.ConnectionStrings["ConnectionString"].ConnectionString);

            connection.Open();

            SqlCommand command = new SqlCommand("SELECT * FROM View_PlContas ORDER BY Conta", connection);

            Log("PLCONTAS", "");
            
            SqlDataReader reader = command.ExecuteReader(System.Data.CommandBehavior.SingleResult);

            while (reader.Read())
            {
                pc.Add(new ContaContabil()
                {
                    Conta = !reader.IsDBNull(0) ? reader.GetSqlString(0).Value.Trim() : "",
                    ContaAntiga = !reader.IsDBNull(1) ? reader.GetSqlString(1).Value.Trim() : "",
                    CNPJ = !reader.IsDBNull(2) ? reader.GetSqlString(2).Value.Trim() : "",
                    Nome = !reader.IsDBNull(3) ? reader.GetSqlString(3).Value.Trim() : "",
                    Tipo = !reader.IsDBNull(4) ? reader.GetSqlString(4).Value.Trim() : "",
                    Reduzida = !reader.IsDBNull(5) ? reader.GetSqlInt32(5).Value : 0,
                    ReduzidaAntiga = !reader.IsDBNull(6) ? reader.GetSqlInt32(6).Value : 0,
                    Pessoa = !reader.IsDBNull(7) ? reader.GetSqlString(7).Value.Trim() : "",
                });
            }

            command.Dispose();
            connection.Close();
            connection.Dispose();

            return pc;
        }

        public bool ContaContabilUpdate(/*string Token, DateTime RequestDateTime,*/ string Conta)
        {
            //string currentToken = GenerateToken(RequestDateTime);

            //if (currentToken.CompareTo(Token) != 0)
            //{
            //    Log("PLCONTAS", "INVALID TOKEN");
            //    return false;
            //}

            SqlConnection connection = new SqlConnection(ConfigurationManager.ConnectionStrings["ConnectionString"].ConnectionString);

            connection.Open();

            SqlCommand command = new SqlCommand("UPDATE PLCONTAS SET CCSINC = GETDATE() WHERE CCCOD = @CCCOD;", connection);

            command.Parameters.AddWithValue("@CCCOD", new SqlString(Conta));

            Log("UPD PLCONTAS", string.Format("@CCCOD={0}", Conta));

            int count = command.ExecuteNonQuery();

            command.Dispose();
            connection.Close();
            connection.Dispose();

            return (count == 1);
        }

        public List<Participante> ParticipantesList(/*string Token, DateTime RequestDateTime*/)
        {
            //string currentToken = GenerateToken(RequestDateTime);

            //if (currentToken.CompareTo(Token) != 0)
            //{
            //    Log("PLCONTAS", "INVALID TOKEN");
            //    return null;
            //}

            List<Participante> p = new List<Participante>();

            SqlConnection connection = new SqlConnection(ConfigurationManager.ConnectionStrings["ConnectionString"].ConnectionString);

            connection.Open();

            SqlCommand command = new SqlCommand("SELECT * FROM View_CACLI ORDER BY [Razão Social]", connection);

            Log("CACLI", "");

            SqlDataReader reader = command.ExecuteReader(System.Data.CommandBehavior.SingleResult);

            while (reader.Read())
            {
                p.Add(new Participante()
                {
                    CNPJ = !reader.IsDBNull(0) ? reader.GetSqlString(0).Value.Trim() : "",
                    Nome = !reader.IsDBNull(2) ? reader.GetSqlString(2).Value.Trim() : "",
                    Tipo = !reader.IsDBNull(38) ? reader.GetSqlString(38).Value.Trim() : "",
                    Pessoa = !reader.IsDBNull(39) ? reader.GetSqlString(39).Value.Trim() : "",
                    CCCliente = !reader.IsDBNull(43) ? reader.GetSqlInt32(43).Value.ToString() : "",
                    CCFornecedor = !reader.IsDBNull(44) ? reader.GetSqlInt32(44).Value.ToString() : ""
                });
            }

            command.Dispose();
            connection.Close();
            connection.Dispose();

            return p;
        }

        public List<LancamentoFluxoCaixa> LancamentosFluxoCaixaList(/*string Token, DateTime RequestDateTime,*/ int Data, DateTime DataInicial, DateTime DataFinal, string Tipo, string Origem, string Banco, string Filtro)
        {
            //string currentToken = GenerateToken(RequestDateTime);

            //if (currentToken.CompareTo(Token) != 0)
            //{
            //    Log("PLCONTAS", "INVALID TOKEN");
            //    return null;
            //}

            List<LancamentoFluxoCaixa> f = new List<LancamentoFluxoCaixa>();

            SqlConnection connection = new SqlConnection(ConfigurationManager.ConnectionStrings["ConnectionString"].ConnectionString);

            connection.Open();

            bool Pagar = false;
            bool Receber = false;

            if (Tipo != null)
            {
                Pagar = Tipo.IndexOf("Pagar") > -1;
                Receber = Tipo.IndexOf("Receber") > -1;
            }

            SqlCommand command = new SqlCommand("SELECT TOP 1000 * FROM View_LAFLU WHERE Empresa = '01' AND ((@Data = 0 AND [Data da Emissao] > @DataInicial AND [Data da Emissao] < @DataFinal) OR (@Data = 1 AND [Data do Vencimento] > @DataInicial AND [Data do Vencimento] < @DataFinal) OR (@Data = 2 AND [Data do Pagamento] > @DataInicial AND [Data do Pagamento] < @DataFinal) OR (@Data = 3 AND [Data do Faturamento] > @DataInicial AND [Data do Faturamento] < @DataFinal)) AND ((@Pagar = 1 AND LTRIM(RTRIM([Tipo de Lançamento])) = 'Pagar') OR (@Receber = 1 AND LTRIM(RTRIM([Tipo de Lançamento])) = 'Receber')) AND (@Origem = 'Todos' OR LTRIM(RTRIM([Origem])) = @Origem) AND (@Banco = 'Todos' OR LTRIM(RTRIM([Banco])) = @Banco) AND (LEN(LTRIM(RTRIM(ISNULL(@Filtro, '')))) = 0 OR ([Titular] LIKE '%' + LTRIM(RTRIM(@Filtro)) + '%') OR (LTRIM(RTRIM([Documento])) = LTRIM(RTRIM(@Filtro))) OR (CAST([Pedido de Venda] AS NVARCHAR(10)) = LTRIM(RTRIM(@Filtro))) OR (CAST([Titulo] AS NVARCHAR(10)) = LTRIM(RTRIM(@Filtro))) OR (LTRIM(RTRIM([CNPJ do titular])) = LTRIM(RTRIM(@Filtro)))) ORDER BY [Origem]", connection);

            command.Parameters.AddWithValue("@DataInicial", new SqlDateTime(DataInicial.Date.AddDays(-1)));
            command.Parameters.AddWithValue("@DataFinal", new SqlDateTime(DataFinal.Date.AddDays(1)));
            command.Parameters.AddWithValue("@Pagar", new SqlBoolean(Pagar));
            command.Parameters.AddWithValue("@Receber", new SqlBoolean(Receber));
            command.Parameters.AddWithValue("@Origem", new SqlString(Origem));
            command.Parameters.AddWithValue("@Banco", new SqlString(Banco));
            command.Parameters.AddWithValue("@Filtro", new SqlString(Filtro));
            command.Parameters.AddWithValue("@Data", new SqlInt32(Data));

            Log("LAFLU", string.Format("@DataInicial={0}, @DataFinal={1}, @Pagar={2}, @Receber={3}, @Origem={4}, @Banco={5}, @Filtro={6}, @Data={7}"
                , DataInicial.Date.AddDays(-1), DataFinal.Date.AddDays(1), Pagar, Receber, Origem, Banco, Filtro, Data));

            SqlDataReader reader = command.ExecuteReader(System.Data.CommandBehavior.SingleResult);

            while (reader.Read())
            {
                f.Add(new LancamentoFluxoCaixa()
                {
                    Titulo = !reader.IsDBNull(1) ? reader.GetSqlInt32(1).Value : 0,
                    Documento = !reader.IsDBNull(2) ? reader.GetSqlString(2).Value.Trim() : "",
                    Pedido = !reader.IsDBNull(3) ? reader.GetSqlString(3).Value.ToString() : "",
                    Origem = !reader.IsDBNull(4) ? reader.GetSqlString(4).Value.Trim() : "",
                    Emissao = !reader.IsDBNull(5) ? reader.GetDateTime(5) : (DateTime?)null,
                    Vencimento = !reader.IsDBNull(6) ? reader.GetDateTime(6) : (DateTime?)null,
                    Pagamento = !reader.IsDBNull(7) ? reader.GetDateTime(7) : (DateTime?)null,
                    Faturamento = !reader.IsDBNull(8) ? reader.GetDateTime(8) : (DateTime?)null,
                    CNPJ = !reader.IsDBNull(9) ? reader.GetSqlString(9).Value.Trim() : "",
                    Titular = !reader.IsDBNull(10) ? reader.GetSqlString(10).Value.Trim() : "",
                    Tipo = !reader.IsDBNull(11) ? reader.GetSqlString(11).Value.Trim() : "",
                    Banco = !reader.IsDBNull(12) ? reader.GetSqlString(12).Value : "",
                    Parcela = !reader.IsDBNull(13) ? reader.GetSqlString(13).Value.Trim() : "",
                    Parcelas = !reader.IsDBNull(14) ? reader.GetSqlString(14).Value.ToString() : "",
                    Valor = !reader.IsDBNull(15) ? reader.GetDecimal(15) : 0,
                    ValorBaixa = !reader.IsDBNull(16) ? reader.GetDecimal(16) : 0,
                    Conciliacao = !reader.IsDBNull(17) ? reader.GetDateTime(17) : (DateTime?)null,
                    Lancamento = !reader.IsDBNull(18) ? reader.GetSqlInt32(18).Value : 0,
                    Sequencia = !reader.IsDBNull(19) ? reader.GetSqlInt32(19).Value : 0,
                    CCDebito = !reader.IsDBNull(20) ? reader.GetSqlString(20).Value.Trim() : "",
                    CCCredito = !reader.IsDBNull(21) ? reader.GetSqlString(21).Value.Trim() : "",
                    Observacao = !reader.IsDBNull(22) ? reader.GetSqlString(22).Value.ToString() : ""
                });
            }

            command.Dispose();
            connection.Close();
            connection.Dispose();

            return f;
        }

        public bool LancamentosFluxoCaixaConciliado(/*string Token, DateTime RequestDateTime,*/ int Titulo, int Lancamento, int Sequencia, string Debito, string Credito)
        {
            //string currentToken = GenerateToken(RequestDateTime);

            //if (currentToken.CompareTo(Token) != 0)
            //{
            //    Log("PLCONTAS", "INVALID TOKEN");
            //    return false;
            //}

            SqlConnection connection = new SqlConnection(ConfigurationManager.ConnectionStrings["ConnectionString"].ConnectionString);

            connection.Open();

            SqlCommand command = new SqlCommand("UPDATE LAFLU SET LFLULCCONC = GETDATE(), LFLULCLANC = @Lancamento, LFLULCSEQ = @Sequencia, LFLULCDEB = @CCDebito, LFLULCCRED = @CCCredito WHERE LFLUREG = @Titulo", connection);

            command.Parameters.AddWithValue("@Titulo", new SqlInt32(Titulo));
            command.Parameters.AddWithValue("@Lancamento", new SqlInt32(Lancamento));
            command.Parameters.AddWithValue("@Sequencia", new SqlInt32(Sequencia));
            command.Parameters.AddWithValue("@CCDebito", new SqlString(Debito));
            command.Parameters.AddWithValue("@CCCredito", new SqlString(Credito));

            Log("UPD LAFLU", string.Format("@Titulo={0}, @Lancamento={1}, @Sequencia={2}, @CCDebito={3}, @CCCredito={4}", Titulo, Lancamento, Sequencia, Debito, Credito));

            int i = command.ExecuteNonQuery();

            command.Dispose();
            connection.Close();
            connection.Dispose();

            return i > 0;
        }

        public string GetToken(DateTime RequestDateTime)
        {
            string currentToken = GenerateToken(RequestDateTime);

            Log("GET TOKEN", currentToken);

            return currentToken;
        }

        public float GetCurrentVersion(string Token, DateTime RequestDateTime)
        {
            /*string currentToken = GenerateToken(RequestDateTime);

            if (currentToken.CompareTo(Token) != 0)
            {
                Log("VERSAO", "INVALID TOKEN");
                return 0f;
            }*/

            //Log("VERSAO", currentToken);

            return VERSAO;
        }

        private void Log(string Operacao, string SQL)
        {
            SqlConnection connection = new SqlConnection(ConfigurationManager.ConnectionStrings["ConnectionString"].ConnectionString);

            connection.Open();

            SqlCommand command = new SqlCommand("INSERT INTO CONSULT_LOG_ACESSO (IP, HOSTNAME, VERSAO, OPERACAO, [SQL]) VALUES (@IP, @HOST, @VERSAO, @OPERACAO, @SQL)", connection);
            
            string ip = ((RemoteEndpointMessageProperty)OperationContext.Current.IncomingMessageProperties[RemoteEndpointMessageProperty.Name]).Address;
            //string host = OperationContext.Current.RequestContext.RequestMessage.Headers[0].ToString();

            string host = "NOTFOUND";

            try
            {
                var remp = OperationContext.Current.IncomingMessageProperties[RemoteEndpointMessageProperty.Name] as RemoteEndpointMessageProperty;
                string[] computer_name = Dns.GetHostEntry(remp.Address).HostName.Split(new Char[] { '.' });
                //host = computer_name[0].ToString();
                host = Dns.GetHostEntry(remp.Address).HostName;
            }
            catch (Exception e)
            {
                host = "NOTFOUND";
            }

            command.Parameters.AddWithValue("@IP", new SqlString(ip));
            command.Parameters.AddWithValue("@HOST", new SqlString(host));
            command.Parameters.AddWithValue("@VERSAO", new SqlSingle(VERSAO));
            command.Parameters.AddWithValue("@OPERACAO", new SqlString(Operacao));
            command.Parameters.AddWithValue("@SQL", new SqlString(SQL));

            int i = command.ExecuteNonQuery();

            command.Dispose();
            connection.Close();
            connection.Dispose();
        }
    }
}
