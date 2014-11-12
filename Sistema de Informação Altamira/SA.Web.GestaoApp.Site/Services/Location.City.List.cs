using System;
using System.Data.SqlClient;
using System.Web;

namespace GestaoApp.Web.Services.Location.City
{
    public class List : IHttpHandler
    {
        #region IHttpHandler Members

        public bool IsReusable
        {
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
                    context.Response.ContentType = "text/xml";
                    context.Response.Write("<Message><Error Id=\"1090\">Invalid connection !</Error></Message>");
                    return;
                }
            }

            SqlConnection conn = new SqlConnection(connectionString.ConnectionString);
            conn.Open();

            SqlCommand cmd = new SqlCommand("SELECT * FROM [Location].[City.List]");

            cmd.Connection = conn;
            cmd.CommandType = System.Data.CommandType.Text;

            try
            {
                System.Xml.XmlReader reader = cmd.ExecuteXmlReader();
                reader.MoveToContent();
                context.Response.ContentType = "text/xml";
                context.Response.Write(reader.ReadOuterXml());
            }
            catch (Exception ex)
            {
                context.Response.ContentType = "text/xml";
                context.Response.Write(String.Format("<Message><Error Id=\"1090\" Source=\"{0}\">{1}</Error></Message>", ex.Source, ex.Message));
            }

            cmd.Dispose();
            conn.Close();
            conn.Dispose();
        }

        #endregion
    }
}
