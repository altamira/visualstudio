using System;
using System.Web;
using System.Data.SqlClient;
using System.Data;
using System.IO;

namespace WebApplication1
{
    public partial class exibir_imagem : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            DateTime Validade;

            if (!ALTANet.Lib.Security.VerificaValidadeSessao(Session["Sessao"], out Validade))
                Response.Redirect("/Acesso.aspx");

            Session["Validade"] = Validade;

            //ExibirImagem();
        }

        private void ExibirImagem() 
        { 
            // estabelece a conexão 

            string cnString = "Data Source=servidor;UID=excel;PWD=excel;Initial Catalog=GPIMAC_Teste"; 
            
            SqlConnection cn = new SqlConnection(cnString); 
            
            cn.Open(); 
            
            // cria o objeto SqlCommand 
            SqlCommand cmd = new SqlCommand(); 
            cmd.Connection = cn; 
            
            cmd.CommandType = CommandType.StoredProcedure; 
            cmd.CommandText = "spExibirImagem"; 
            
            // adiciona o parâmetro @ImagemID obtido através da variável de URL 
            SqlParameter prmImagemID = new SqlParameter("@CaDoc0Cod", SqlDbType.Int);	 
            prmImagemID.Value = Request.QueryString["ImagemID"]; 
            cmd.Parameters.Add(prmImagemID); 
            
            // cria o objeto SqlDataReader e alimenta-o com a respectiva imagem 
            SqlDataReader dr; 
            dr = cmd.ExecuteReader(); 
            
            dr.Read(); 
            
            // utiliza o objeto Response para enviar o conteúdo para o browser 
            
            //Response.ContentType = dr["Tipo"].ToString();
            Response.ContentType = "application/pdf";
            Response.ContentType = "application/vnd.ms-excel";

            string extension = Path.GetExtension(dr["Nome"].ToString()).ToLower();

            string MIMEType = null;

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
            }
            
            Response.ContentType = MIMEType;

            string contentDisposition;
            if (Request.Browser.Browser == "IE" && (Request.Browser.Version == "7.0" || Request.Browser.Version == "8.0"))
                contentDisposition = "filename=" + HttpUtility.UrlPathEncode(dr["Nome"].ToString().Trim());
            else if (Request.Browser.Browser == "Safari")
                contentDisposition = "filename=" + HttpUtility.UrlPathEncode(dr["Nome"].ToString().Trim());
            else
                contentDisposition = "filename*=UTF-8''" + HttpUtility.UrlPathEncode(dr["Nome"].ToString().Trim());
            
            Response.AddHeader("Content-Disposition", contentDisposition);

            
            Response.OutputStream.Write((byte[])dr["Imagem"], 0, System.Convert.ToInt32(dr["Tamanho"])); 
            
            cn.Close(); 
        }

        //Read more: http://www.linhadecodigo.com.br/artigo/337/armazenando-imagens-do-sql-server-com-aspnet.aspx#ixzz239MINiEl
    }
}