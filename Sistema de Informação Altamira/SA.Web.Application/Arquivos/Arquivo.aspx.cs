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
    public partial class Arquivo : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            DateTime Validade;

            if (!SA.Web.Application.Lib.Security.VerificaValidadeSessao(Session["Sessao"], out Validade))
                Response.Redirect("/Acesso.aspx");

            Session["Validade"] = Validade;

            if (!Page.IsPostBack)
                BaixaArquivo();
        }

        private void BaixaArquivo() 
        { 
            // estabelece a conexão 

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

            Command.CommandText = "[Representante].[Download de Arquivo do Orçamento]";

            Command.Parameters.Add(new SqlParameter("@Sessao", SqlDbType.UniqueIdentifier)).Value = Guid.Parse(Session["Sessao"].ToString().Trim());
            Command.Parameters.Add(new SqlParameter("@Arquivo", SqlDbType.Int)).Value = Numero.ToString();

            SqlDataReader DataReader = Command.ExecuteReader();

            if (DataReader.Read())
            {
                // utiliza o objeto Response para enviar o conteúdo para o browser 

                Response.Buffer = true;

                //Response.ContentType = dr["Tipo"].ToString();
                Response.ContentType = "application/pdf";
                Response.ContentType = "application/vnd.ms-excel";

                //string extension = Path.GetExtension(dr["Nome"].ToString()).ToLower();
                string extension = DataReader["Extensão do Arquivo"].ToString();

                //.docm,application/vnd.ms-word.document.macroEnabled.12
                //.docx,application/vnd.openxmlformats-officedocument.wordprocessingml.document
                //.dotm,application/vnd.ms-word.template.macroEnabled.12
                //.dotx,application/vnd.openxmlformats-officedocument.wordprocessingml.template
                //.potm,application/vnd.ms-powerpoint.template.macroEnabled.12
                //.potx,application/vnd.openxmlformats-officedocument.presentationml.template
                //.ppam,application/vnd.ms-powerpoint.addin.macroEnabled.12
                //.ppsm,application/vnd.ms-powerpoint.slideshow.macroEnabled.12
                //.ppsx,application/vnd.openxmlformats-officedocument.presentationml.slideshow
                //.pptm,application/vnd.ms-powerpoint.presentation.macroEnabled.12
                //.pptx,application/vnd.openxmlformats-officedocument.presentationml.presentation
                //.xlam,application/vnd.ms-excel.addin.macroEnabled.12
                //.xlsb,application/vnd.ms-excel.sheet.binary.macroEnabled.12
                //.xlsm,application/vnd.ms-excel.sheet.macroEnabled.12
                //.xlsx,application/vnd.openxmlformats-officedocument.spreadsheetml.sheet
                //.xltm,application/vnd.ms-excel.template.macroEnabled.12
                //.xltx,application/vnd.openxmlformats-officedocument.spreadsheetml.template
                /*
                string MIMEType = null;

                switch (extension.Trim())
                {
                    case ".gif":
                        MIMEType = "image/gif";
                        break;
                    case ".jpg":
                    case ".jpeg":
                    case ".jpe":
                        MIMEType = "image/jpeg";
                        break;
                    case ".png":
                        MIMEType = "image/png";
                        break;
                    case ".csv":
                        MIMEType = "application/msexcel";
                        break;
                    case ".xls":
                        MIMEType = "application/vnd.ms-excel";
                        break;
                    //case ".xlsx":
                    //    MIMEType = "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet";
                    //    break;
                    case ".doc":
                        MIMEType = "application/msword";
                        break;
                    //case ".docx":
                    //    MIMEType = "application/vnd.openxmlformats-officedocument.wordprocessingml.document";
                    //    break;
                    case ".pdf":
                        MIMEType = "application/pdf";
                        break;
                    default:
                        MIMEType = "application/octet-stream";
                        break;
                }*/

                string FileName = DataReader["Localização do Arquivo"].ToString().Trim() + "\\" + DataReader["Nome do Arquivo"].ToString().Trim() + DataReader["Extensão do Arquivo"].ToString().Trim();

                string contentDisposition;
                if (Request.Browser.Browser == "IE" && (Request.Browser.Version == "7.0" || Request.Browser.Version == "8.0"))
                    contentDisposition = "filename=" + HttpUtility.UrlPathEncode(FileName);
                else if (Request.Browser.Browser == "Safari")
                    contentDisposition = "filename=" + HttpUtility.UrlPathEncode(FileName);
                else
                    contentDisposition = "filename*=UTF-8''" + HttpUtility.UrlPathEncode(FileName);

                //Response.ContentType = MIMEType;
                //Response.AddHeader("Content-Disposition", contentDisposition);

                Response.ContentType = "application/octet-stream";
                Response.AppendHeader("Content-Disposition", "attachment;filename=" + DataReader["Nome do Arquivo"].ToString().Trim() + DataReader["Extensão do Arquivo"].ToString().Trim() + ";size=" + DataReader["Tamanho do Arquivo"].ToString());

                //Response.OutputStream.Write(((byte[])dr["Imagem"], 0, System.Convert.ToInt32(dr["Tamanho"]));
                //Response.WriteFile(FileName.Replace(@"C:\Pastas Compartilhadas\", @"\\servidor\"), true);
                Response.TransmitFile(FileName, 0, DataReader.GetInt32(7)); // DataReader["Tamanho do Arquivo"]
                Response.Flush();
                Response.End();
            }

            DataReader.Close();
            Connection.Close();
        }

        //Read more: http://www.linhadecodigo.com.br/artigo/337/armazenando-imagens-do-sql-server-com-aspnet.aspx#ixzz239MINiEl
    }
}