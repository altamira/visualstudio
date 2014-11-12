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
using OpenPop.Mime;
using OpenPop.Pop3;

namespace OpenPop
{
    public class Inbox
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
        /// <param name="deletemessage">Delete message on the server</param>
        /// <returns>All Messages on the POP3 server</returns>
        public static List<Message> GetAllMessages(SqlString Host, SqlInt32 Port, SqlBoolean SSL, SqlString User, SqlString Password, bool DeleteMessage)
        {
            int messageCount = 0;

            List<Message> messages = new List<Message>();

            // The client disconnects from the server when being disposed
            Pop3Client client = new Pop3Client();

            // Connect to the server
            client.Connect(Host.ToString(), Port.Value, SSL.Value);

            // Authenticate ourselves towards the server
            client.Authenticate(User.ToString(), Password.ToString());

            // Get the number of messages in the inbox
            messageCount = client.GetMessageCount();

            // Messages are numbered in the interval: [1, messageCount]
            // Ergo: message numbers are 1-based.
            for (int i = 1; i <= messageCount; i++)
            {
                Message msg = client.GetMessage(i);

                messages.Add(msg);

                if (DeleteMessage)
                    client.DeleteMessage(i);
            }

            // Now return the fetched messages
            return messages;
        }
    }
}

