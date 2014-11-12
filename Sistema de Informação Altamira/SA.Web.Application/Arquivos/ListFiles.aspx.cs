using System;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data.SqlClient;
using System.Data;

namespace WebApplication1
{
    public partial class _Default : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            DateTime Validade;

            if (!SA.Web.Application.Lib.Security.VerificaValidadeSessao(Session["Sessao"], out Validade))
                Response.Redirect("/Acesso.aspx");

            Session["Validade"] = Validade;

            if (!Page.IsPostBack)
            {
                //ListarImagens();
            }
        }

        private void ListarImagens() 
        { 
            // esta variável armazenará a string para conexão com o SQL Server 
            // para facilitar nosso trabalho, a string de conexão foi armazenada 
            // numa variável de aplicação. Desta forma, podemos invocá-la sempre que 
            // necessário e em caso de alteração das informações de conexão, precisaremos 
            // atualizar apenas o arquivo Global.asax 
            
            //string cnString = "Data Source=servidor;UID=excel;PWD=excel;Initial Catalog=GPIMAC_Teste"; 
            
            //SqlConnection Connection = new SqlConnection(cnString); Connection.Open(); 
            SqlConnection Connection = new SqlConnection(System.Configuration.ConfigurationManager.ConnectionStrings["ConnectionString"].ConnectionString);
            Connection.Open();

            // criamos o objeto Command e definimos suas propriedades, ele será utilizado 
            // para invocar a StoredProcedure que gravará a imagem no SQL Server 
            
            SqlCommand Command = new SqlCommand(); 
            Command.Connection = Connection; 
            Command.CommandType = CommandType.StoredProcedure; 
            Command.CommandText = "spListarImagens"; 
            
            // cria o objeto SqlDataReader e carrega-o com os dados obtidos 
            SqlDataReader DataReader; 
            
            DataReader = Command.ExecuteReader(); 
            
            // atribui o objeto SqlDataReader à origem de dados do DataGrid 
            dgImagens.DataSource = DataReader; 
            dgImagens.DataBind(); 
            Connection.Close(); 
        
        }

        protected void ExcluirImagem(Object sender, DataGridCommandEventArgs e) 
        { 
            // estabelecemos a conexão 
            string cnString = "Data Source=servidor;UID=excel;PWD=excel;Initial Catalog=GPIMAC_Teste"; 
            SqlConnection Connection = new SqlConnection(cnString); 
            
            Connection.Open(); 
            
            // criamos o objeto command 
            SqlCommand Command = new SqlCommand(); 
            Command.Connection = Connection; 
            Command.CommandType = CommandType.StoredProcedure; 
            Command.CommandText = "spExcluirImagem";

            // adicionamos o parâmetro @Descricao à coleção de parâmetros do objeto Command 
            SqlParameter prmImagemID = new SqlParameter("@ImagemID", SqlDbType.Int); 
            prmImagemID.Value = e.Item.Cells[0].Text; 
            Command.Parameters.Add(prmImagemID); 
            
            // disparamos o commando para excluir a imagem 
            Command.ExecuteNonQuery(); 
            Connection.Close(); 
            
            // invocamos a rotina ListarImagens para atualizar o DataGrid     
            ListarImagens(); 
        }


        protected void Enviar_Click(object sender, EventArgs e)
        {
            if (!fileImagemParaGravar.HasFile)
            {
                Label1.Visible = true;
                // code doesnt get called as its saying HasFile is false
            }
            else
            {
                // esta string armazenará o tipo de imagem (JPEG, BMP, GIF, etc) 
                // o controle html <input type=file> fornecerá esta informação 
                string strTipo = fileImagemParaGravar.PostedFile.ContentType;

                // o tamanho do arquivo de imagem também é fornecido pelo mesmo controle 
                // e armazenado na variável intTamanho 
                int intTamanho = System.Convert.ToInt32(fileImagemParaGravar.PostedFile.InputStream.Length);

                // a variável byteImagem é um array com tamanho estabelecido pela propriedade 
                // length que foi armazenada na variável intTamanho (tamanho do arquivo em bytes) 
                byte[] byteImagem = new byte[intTamanho];

                // o método Read() do controle File se encarregará de ler o arquivo de imagem 
                // e armazenar o conteúdo na variável byteImagem. A sintaxe deste método é: 
                // Read(<variável>, início, fim) 
                fileImagemParaGravar.PostedFile.InputStream.Read(byteImagem, 0, intTamanho);

                // esta variável armazenará a string para conexão com o SQL Server 
                // para facilitar nosso trabalho, a string de conexão foi armazenada 
                // numa variável de aplicação. Desta forma, podemos invocá-la sempre que 
                // necessário e em caso de alteração das informações de conexão, precisaremos 
                // atualizar apenas o arquivo Global.asax 
                string cnString = "Data Source=servidor;UID=excel;PWD=excel;Initial Catalog=GPIMAC_Teste";

                SqlConnection Connection = new SqlConnection(cnString);

                // criamos o objeto Command e definimos suas propriedades, ele será utilizado 
                // para invocar a StoredProcedure que gravará a imagem no SQL Server 
                SqlCommand Command = new SqlCommand();

                Command.Connection = Connection;

                Command.CommandType = CommandType.StoredProcedure;

                Command.CommandText = "spAdicionarImagem";

                // adicionamos o parâmetro @Descricao à coleção de parâmetros do objeto Command 
                SqlParameter prmDescricao = new SqlParameter("@CaDoc0Nom", SqlDbType.NVarChar);

                //prmDescricao.Value = txtDescricao.Text;
                //prmDescricao.Value = HttpUtility.UrlPathEncode(fileImagemParaGravar.FileName.Trim());
                prmDescricao.Value = fileImagemParaGravar.FileName.Trim();

                Command.Parameters.Add(prmDescricao);

                // adicionamos o parâmetro @Imagem à coleção de parâmetros do objeto Command 
                SqlParameter prmImagem = new SqlParameter("@CaDoc0Arq", SqlDbType.Image);
                prmImagem.Value = byteImagem;

                Command.Parameters.Add(prmImagem);

                // adicionamos o parâmetro @Tamanho à coleção de parâmetros do objeto Command 
                //SqlParameter prmImagemTamanho = new SqlParameter("@Tamanho", SqlDbType.Int); 
                //prmImagemTamanho.Value = intTamanho; 

                //Command.Parameters.Add(prmImagemTamanho); 

                // adicionamos o parâmetro @Tipo à coleção de parâmetros do objeto Command 
                //SqlParameter prmImagemTipo = new SqlParameter("@Tipo", SqlDbType.NVarChar); 

                //prmImagemTipo.Value = strTipo; 
                //Command.Parameters.Add(prmImagemTipo); 

                // abrimos a conexão, executamos o Command e fechamos a conexão 
                Connection.Open();
                Command.ExecuteNonQuery();
                Connection.Close();

                //Response.Write("<html><body>Gravado com sucesso !</body></html>");

                ListarImagens();

                // limpa a caixa de texto txtDescricao 
                //txtDescricao.Text = ""; 
            }
        }

        protected void Mensagem_Click(object sender, EventArgs e)
        {
        
        }

        //Read more: http://www.linhadecodigo.com.br/artigo/337/armazenando-imagens-do-sql-server-com-aspnet.aspx#ixzz239RguhT8

        //Read more: http://www.linhadecodigo.com.br/artigo/337/armazenando-imagens-do-sql-server-com-aspnet.aspx#ixzz239R1MDKX

        //Read more: http://www.linhadecodigo.com.br/artigo/337/armazenando-imagens-do-sql-server-com-aspnet.aspx#ixzz239JG8hZM
    }
}
