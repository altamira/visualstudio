//------------------------------------------------------------------------------
// <copyright file="CSSqlStoredProcedure.cs" company="Microsoft">
//     Copyright (c) Microsoft Corporation.  All rights reserved.
// </copyright>
//------------------------------------------------------------------------------
using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Data.SqlTypes;
using System.Security.Cryptography;
using Microsoft.SqlServer.Server;
using OpenPop.Mime;
using OpenPop.Pop3;

namespace Mail
{
    public partial class StoredProcedures
    {
        /// <summary>
        /// Example showing:
        ///  - how to fetch all messages from a POP3 server
        /// </summary>
        /// <param name="hostname">Hostname of the server. For example: pop3.live.com</param>
        /// <param name="port">Host port to connect to. Normally: 110 for plain POP3, 995 for SSL POP3</param>
        /// <param name="ssl">Whether or not to use SSL to connect to server</param>
        /// <param name="username">Username of the user on the server</param>
        /// <param name="password">Password of the user on the server</param>
        /// <returns>All Messages on the POP3 server</returns>
        [Microsoft.SqlServer.Server.SqlProcedure(Name="Mail.Message.Fetch")]
        public static SqlInt32 MessageFetch(SqlString host, SqlInt32 port, SqlBoolean ssl, SqlString user, SqlString pass)
        {
            int messageCount = 0;

            // The client disconnects from the server when being disposed
            using (Pop3Client client = new Pop3Client())
            {
                // Connect to the server
                client.Connect(host.ToString(), port.Value, ssl.Value);

                // Authenticate ourselves towards the server
                client.Authenticate(user.ToString(), pass.ToString());

                // Get the number of messages in the inbox
                messageCount = client.GetMessageCount();

                using (SqlConnection connection = new SqlConnection("context connection=true"))
                {
                    connection.Open();

                    // Messages are numbered in the interval: [1, messageCount]
                    // Ergo: message numbers are 1-based.
                    for (int i = 1; i <= messageCount; i++)
                    {
                        Message msg = client.GetMessage(i);

                        using (SqlCommand command = new SqlCommand("[Mail].[Message.Add]", connection))
                        {
                            command.CommandType = CommandType.StoredProcedure;

                            command.Parameters.AddWithValue("@MessageId", new SqlString(msg.Headers.MessageId));
                            command.Parameters.AddWithValue("@Sent", new SqlDateTime(msg.Headers.DateSent.ToLocalTime()));
                            command.Parameters.AddWithValue("@Received", new SqlDateTime(DateTime.Now));
                            command.Parameters.AddWithValue("@From", new SqlString(string.Join("; ", msg.Headers.From)));
                            command.Parameters.AddWithValue("@To", new SqlString(string.Join("; ", msg.Headers.To)));
                            command.Parameters.AddWithValue("@Cc", new SqlString(string.Join("; ", msg.Headers.Cc)));
                            command.Parameters.AddWithValue("@Bcc", new SqlString(string.Join("; ", msg.Headers.Bcc)));
                            command.Parameters.AddWithValue("@ReplyTo", new SqlString(string.Join("; ", msg.Headers.ReplyTo)));
                            command.Parameters.AddWithValue("@InReplyTo", new SqlString(string.Join("; ", msg.Headers.InReplyTo)));
                            command.Parameters.AddWithValue("@ReturnPath", new SqlString(string.Join("; ", msg.Headers.ReturnPath)));
                            command.Parameters.AddWithValue("@Subject", new SqlString(msg.Headers.Subject));
                            command.Parameters.AddWithValue("@Body", new SqlBinary(msg.RawMessage));

                            command.ExecuteNonQuery();

                            // TODO Delete messages after store in SQL Server
                            //if (command.ExecuteNonQuery() > 0)
                            //    client.DeleteMessage(i);
                        }
                    }
                }
            }

            // Now return the fetched messages
            return messageCount;
        }
    }
}

