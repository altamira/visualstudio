﻿using System;
using System.Data.SqlClient;
using System.Data.SqlTypes;
using System.Web;

namespace GestaoApp.Web.Services.Location.City
{
    public class Search : IHttpHandler
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
                    context.Response.ContentType = "text/xml";
                    context.Response.Write("<Message><Error Id=\"1090\">Invalid connection !</Error></Message>");
                    return;
                }
            }

            SqlConnection conn = new SqlConnection(connectionString.ConnectionString);
            conn.Open();

            SqlCommand cmd = new SqlCommand("[Location].[City.Search]");
            cmd.Connection = conn;
            cmd.CommandType = System.Data.CommandType.StoredProcedure;

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

                context.Response.Write(response.Value);
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
