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
using System.Globalization;
using System.Threading;
using OpenPop.Common.Logging;
using OpenPop.Mime;
using OpenPop.Pop3;

namespace MailStore
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
        [Microsoft.SqlServer.Server.SqlProcedure(Name="Mail.Message.Store")]
        public static SqlInt32 MessageStore(SqlString Host, SqlInt32 Port, SqlBoolean SSL, SqlString User, SqlString Password, bool DeleteMessage)
        {
            Thread.CurrentThread.CurrentCulture = new CultureInfo("pt-BR");

            DefaultLogger.SetLog(new SQLLogger());

            int messageCount = 0;
            List<Message> messages = new List<Message>();

            try
            {
                messages = OpenPop.Inbox.GetAllMessages(Host, Port, SSL, User, Password, DeleteMessage);
                messageCount = messages.Count;
            }
            catch (Exception ex)
            {
                DefaultLogger.Log.LogError(ex.Message);
            }

            using (SQLConnectionSingleton connection = new SQLConnectionSingleton())
            {
                // Messages are numbered in the interval: [1, messageCount]
                // Ergo: message numbers are 1-based.
                foreach(Message message in messages)
                {
                    using (SqlCommand command = new SqlCommand("[Mail].[Message.Add]", connection.GetConnection))
                    {
                        command.CommandType = CommandType.StoredProcedure;

                        command.Parameters.AddWithValue("@MessageId", new SqlString(message.Headers.MessageId));
                        command.Parameters.AddWithValue("@Sent", new SqlDateTime(message.Headers.DateSent.ToLocalTime()));
                        command.Parameters.AddWithValue("@Received", new SqlDateTime(DateTime.Now));
                        command.Parameters.AddWithValue("@From", new SqlString(string.Join("; ", message.Headers.From)));
                        command.Parameters.AddWithValue("@To", new SqlString(string.Join("; ", message.Headers.To)));
                        command.Parameters.AddWithValue("@Cc", new SqlString(string.Join("; ", message.Headers.Cc)));
                        command.Parameters.AddWithValue("@Bcc", new SqlString(string.Join("; ", message.Headers.Bcc)));
                        command.Parameters.AddWithValue("@ReplyTo", new SqlString(string.Join("; ", message.Headers.ReplyTo)));
                        command.Parameters.AddWithValue("@InReplyTo", new SqlString(string.Join("; ", message.Headers.InReplyTo)));
                        command.Parameters.AddWithValue("@ReturnPath", new SqlString(string.Join("; ", message.Headers.ReturnPath)));
                        command.Parameters.AddWithValue("@Subject", new SqlString(message.Headers.Subject));
                        command.Parameters.AddWithValue("@Body", new SqlBinary(message.RawMessage));

                        command.ExecuteNonQuery();

#if !(DEBUG)
                        // TODO Delete messages after store in SQL Server
                        // if (command.ExecuteNonQuery() > 0)
                        //    client.DeleteMessage(i);
#endif
                    }
                }
            }

        // Now return the fetched messages
        return messageCount;
        }
    }
}

