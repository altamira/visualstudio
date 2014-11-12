//------------------------------------------------------------------------------
// <copyright file="CSSqlClassFile.cs" company="Microsoft">
//     Copyright (c) Microsoft Corporation.  All rights reserved.
// </copyright>
//------------------------------------------------------------------------------
using System;
using System.Collections.Generic;
using System.Text;
using OpenPop.Pop3;
using OpenPop.Mime;
using System.Data;
using System.Data.SqlClient;
using System.Data.SqlTypes;
using Microsoft.SqlServer.Server;

namespace EmailConnector
{
    public partial class UserDefinedFunctions
    {
        //private mailConfiguration configMail = new mailConfiguration();

        /// <summary>
        /// Example showing:
        ///  - how to fetch all messages from a POP3 server
        /// </summary>
        /// <param name="hostname">Hostname of the server. For example: pop3.live.com</param>
        /// <param name="port">Host port to connect to. Normally: 110 for plain POP3, 995 for SSL POP3</param>
        /// <param name="useSsl">Whether or not to use SSL to connect to server</param>
        /// <param name="username">Username of the user on the server</param>
        /// <param name="password">Password of the user on the server</param>
        /// <returns>All Messages on the POP3 server</returns>
        //private List<Message> FetchAllMessages()
        //{
        //    // The client disconnects from the server when being disposed
        //    using (Pop3Client client = new Pop3Client())
        //    {
        //        // Connect to the server
        //        client.Connect(configMail.hostname, configMail.port, configMail.useSsl);

        //        // Authenticate ourselves towards the server
        //        client.Authenticate(configMail.username, configMail.password);

        //        // Get the number of messages in the inbox
        //        int messageCount = client.GetMessageCount();

        //        // We want to download all messages
        //        List<Message> allMessages = new List<Message>(messageCount);

        //        // Messages are numbered in the interval: [1, messageCount]
        //        // Ergo: message numbers are 1-based.
        //        for (int i = 1; i <= messageCount; i++)
        //        {
        //            allMessages.Add(client.GetMessage(i));
        //        }

        //        // Now return the fetched messages
        //        return allMessages;
        //    }
        //}

        [Microsoft.SqlServer.Server.SqlFunction]
        public static void ReadMessages()
        {
        }

        //private void setInit(string hostname, int port, bool useSsl, string username, string password)
        //{
        //    configMail.useSsl = useSsl;
        //    configMail.hostname = hostname;
        //    configMail.username = username;
        //    configMail.password = password;
        //    configMail.port = port;
        //}

    }
}
