//------------------------------------------------------------------------------
// <copyright file="CSSqlClassFile.cs" company="Microsoft">
//     Copyright (c) Microsoft Corporation.  All rights reserved.
// </copyright>
//------------------------------------------------------------------------------
using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data.SqlClient;
using System.Text;
using Microsoft.SqlServer.Server;

namespace MailStore
{
    public class SQLConnectionSingleton : IDisposable
    {
        static SqlConnection connection = null;
        static uint refcount = 0;

        public SQLConnectionSingleton()
        {
            if (connection == null)
            {
                if (SqlContext.IsAvailable)
                    connection = new SqlConnection("context connection=true");
                else
                    throw new InvalidOperationException("A conexão não pode ser estabelecida por que o Contexto para o SQL Server não esta disponível.");
                //connection = new SqlConnection(ConfigurationManager.ConnectionStrings["MailConnectionString"].ToString());

                connection.Open();

                refcount++;
            }
        }

        public SqlConnection GetConnection
        {
            get
            {
                return connection;
            }
        }
    
        public void Dispose()
        {
            if (connection != null)
            {
                if (refcount > 0)
                    refcount--;

                if (refcount == 0)
                {
                    connection.Close();
                    connection.Dispose();
                    connection = null;
                }
            }
        }
    }
}
