using System;
using System.Data.SqlClient;
using System.Data.SqlTypes;
using System.Web;
using System.Xml.Linq;
using System.Linq;
using System.Xml;
using System.IO;

namespace GestaoApp.Web.Services.Sales.Bid
{
    public class Project : IHttpHandler
    {
        /// <summary>
        /// You will need to configure this handler in the web.config file of your 
        /// web and register it with IIS before being able to use it. For more information
        /// see the following link: http://go.microsoft.com/?linkid=8101007
        /// </summary>
        #region IHttpHandler Members

        public bool IsReusable
        {
            // Return false in case your Managed Handler cannot be reused for another request.
            // Usually this would be false in case you have some state information preserved per request.
            get { return true; }
        }

        public void ProcessRequest(HttpContext context)
        {
            System.Configuration.Configuration WebConfig = System.Web.Configuration.WebConfigurationManager.OpenWebConfiguration(context.Request.ApplicationPath);
            System.Configuration.ConnectionStringSettings connectionString = null;

            if (WebConfig.ConnectionStrings.ConnectionStrings.Count > 0)
            {
                connectionString = WebConfig.ConnectionStrings.ConnectionStrings["ConnectionString"];
                if (connectionString == null)
                {
                    context.Response.Write("<Message><Error Id=\"1090\">Invalid connection !</Error></Message>");
                    return;
                }
            }

            SqlConnection conn = new SqlConnection(connectionString.ConnectionString);
            conn.Open();

            SqlCommand cmd = new SqlCommand("Security.[Session.Validate]");
            cmd.Connection = conn;
            cmd.CommandType = System.Data.CommandType.StoredProcedure;

            Guid guid;
            SqlParameter session = new SqlParameter("@Guid", System.Data.SqlDbType.UniqueIdentifier);

            if (Guid.TryParse(context.Request.QueryString[0].Split(',')[0], out guid))
                session.SqlValue = new SqlGuid(guid);
            else
                session.SqlValue = new SqlGuid(new Guid());

            cmd.Parameters.Add(session);

            SqlParameter request = new SqlParameter("@XmlRequest", System.Data.SqlDbType.Xml);
            SqlXml xmlRequest = new SqlXml(context.Request.InputStream);
            request.SqlValue = xmlRequest;
            cmd.Parameters.Add(request);

            SqlParameter response = new SqlParameter("@XmlResponse", System.Data.SqlDbType.Xml);
            response.Direction = System.Data.ParameterDirection.Output;
            cmd.Parameters.Add(response);

            try
            {
                cmd.ExecuteNonQuery();

                //context.Response.Write(response.Value);
            }
            catch (Exception ex)
            {
                context.Response.ContentType = "text/xml";
                context.Response.Write(String.Format("<Message><Error Id=\"1090\" Source=\"{0}\">{1}</Error></Message>", ex.Source, ex.Message));
                return;
            }

            XmlReader reader = XmlReader.Create(new StringReader(response.Value.ToString()));
            XDocument result = XDocument.Load(reader);

            reader.Close();

            cmd.Dispose();
            conn.Close();
            conn.Dispose();

            bool grant = false;

            if (result.Descendants("Rules").Any())
            {
                if (result.Descendants("Rules").First().Value.ToString().IndexOf("*") > -1 ||
                    result.Descendants("Rules").First().Value.ToString().IndexOf("Bid Register") > -1)
                {
                    grant = true;
                }
            }
            else if (result.Descendants("Vendor").Any())
            {
                grant = true;
            }


            if (grant)
            {
                #if DEBUG
                String FileName = string.Format("C:\\Users\\Administrador\\Documents\\orcamentos\\pdf-draw\\{0}.pdf", context.Request.QueryString[0].Split(',')[3]);
                #else
                String FileName = string.Format("C:\\Pastas Compartilhadas\\Departamentos\\Orcamento\\PDF-DRAW\\{0}.pdf", context.Request.QueryString[0].Split(',')[3]);
                #endif

                if (File.Exists(FileName))
                {
                    context.Response.ContentType = "Application/pdf";
                    context.Response.AddHeader("content-disposition", "inline;filename=" + context.Request.QueryString[0].Split(',')[3] + ".pdf");
                    context.Response.WriteFile(FileName);
                    context.Response.End();
                    return;
                }
                else
                {
                    context.Response.ContentType = "Application/pdf";
                    context.Response.AddHeader("content-disposition", "inline;filename=" + "file_not_found.pdf");
                    context.Response.WriteFile(context.Request.PhysicalApplicationPath + "file_not_found.pdf");
                    context.Response.End();
                }
            }
            else
            {
                context.Response.ContentType = "Application/pdf";
                context.Response.AddHeader("content-disposition", "inline;filename=" + "access_denied.pdf");
                context.Response.WriteFile(context.Request.PhysicalApplicationPath + "access_denied.pdf");
                context.Response.End();
            }

        }

        #endregion
    }
}
