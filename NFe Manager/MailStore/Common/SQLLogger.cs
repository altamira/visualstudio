//------------------------------------------------------------------------------
// <copyright file="CSSqlClassFile.cs" company="Microsoft">
//     Copyright (c) Microsoft Corporation.  All rights reserved.
// </copyright>
//------------------------------------------------------------------------------
using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Data.SqlTypes;
using System.Text;
using OpenPop.Common.Logging;

namespace MailStore
{
    public enum LogType : byte
    {
        Error,
        Debug
    }

    public class SQLLogger : ILog
    {
        public void LogError(string Message)
        {
            Log(LogType.Error, Message);
        }

        public void LogDebug(string Message)
        {
            Log(LogType.Debug, Message);
        }

        private void Log(LogType logType, string Message)
        {
            //using (SqlConnection connection = new SqlConnection("context connection=true"))
            //using(SqlConnection connection = new SqlConnection(ConfigurationManager.ConnectionStrings["DemoString"].ToString())
            //using (SqlConnection connection = new SqlConnection(@"Data Source=.;Initial Catalog=OpenPop.SQLServer;Integrated Security=SSPI;Pooling=False;Connect Timeout=30"))
            using (SQLConnectionSingleton connection = new SQLConnectionSingleton())
            {
                using (SqlCommand command = new SqlCommand("INSERT INTO [Mail].[Message.Log] ([Type], [Message]) VALUES (@Type, @Message)", connection.GetConnection))
                {
                    command.CommandType = CommandType.Text;

                    command.Parameters.AddWithValue("@Type", logType);
                    command.Parameters.AddWithValue("@Message", new SqlString(Message));

                    command.ExecuteNonQuery();
                }
            }
        }
    }
}
