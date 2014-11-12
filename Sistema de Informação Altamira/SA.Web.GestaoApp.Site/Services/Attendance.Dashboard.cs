﻿using System;
using System.Data.SqlClient;
using System.Data.SqlTypes;
using System.Web;

namespace GestaoApp.Web.Services.Attendance
{
    public class Dashboard : IHttpHandler
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

            SqlCommand cmd = new SqlCommand("Attendance.[Dashboard]");
            cmd.Connection = conn;
            cmd.CommandType = System.Data.CommandType.StoredProcedure;

            Guid guid;
            SqlParameter session = new SqlParameter("@SessionGuid", System.Data.SqlDbType.UniqueIdentifier);

            if (Guid.TryParse(context.Request.QueryString.ToString(), out guid))
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
