//------------------------------------------------------------------------------
// <copyright file="CSSqlFunction.cs" company="Microsoft">
//     Copyright (c) Microsoft Corporation.  All rights reserved.
// </copyright>
//------------------------------------------------------------------------------
using System;
using System.Collections;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Data.SqlTypes;
using System.IO;
using Microsoft.SqlServer.Server;
using OpenPop.Mime;
using OpenPop.Mime.Decode;
using OpenPop.Pop3;
using OpenPop.Common.Logging;

namespace Mail
{
    public partial class UserDefinedFunctions
    {
        public class MsgContent
        {
            public Message msg { get; set; }
            public MessagePart part { get; set; }
        }

        private static System.Text.Encoding LastTryDecode(string charset)
        {
            DefaultLogger.Log.LogError(String.Format("Fallback decode charset {0}.", charset));
            return System.Text.Encoding.GetEncoding(1252); // iso-8859-1
        }

        [SqlFunction(
            Name = "Mail.Message.List.Attachments",
            DataAccess = DataAccessKind.Read,
            SystemDataAccess = SystemDataAccessKind.Read,
            FillRowMethodName = "FillRow",
            TableDefinition = "[Sent] [datetime], [From] [nvarchar](MAX), [Subject] [nvarchar](MAX), [MimeType] [nvarchar](MAX), [Body] [nvarchar](MAX)"
            )]
        public static IEnumerable ListAttachments(SqlString Host, SqlInt32 Port, SqlBoolean SSL, SqlString User, SqlString Password)
        {
            List<MsgContent> messages = new List<MsgContent>();

            // The client disconnects from the server when being disposed
            Pop3Client client = new Pop3Client();

            EncodingFinder.FallbackDecoder = new EncodingFinder.FallbackDecoderDelegate(LastTryDecode);


            {
                // Connect to the server
                client.Connect(Host.ToString(), Port.Value, SSL.Value);

                // Authenticate ourselves towards the server
                client.Authenticate(User.ToString(), Password.ToString());

                // Get the number of messages in the inbox
                int messageCount = client.GetMessageCount();

                // Messages are numbered in the interval: [1, messageCount]
                // Ergo: message numbers are 1-based.
                for (int i = 1; i <= messageCount; i++)
                {
                    Message message = client.GetMessage(i);

                    foreach (MessagePart p in message.FindAllAttachments())
                    {
                        MsgContent c = new MsgContent() { msg = message, part = p };
                        messages.Add(c);
                    }
                }
            }

            client.Disconnect();
            client = null;

            // Now return the fetched messages
            return messages;
        }

        public static void FillRow(Object obj, out SqlDateTime Sent, out SqlString From, out SqlString Subject, out SqlString ContentType, out SqlString Body)
        {
            MsgContent m = (MsgContent)obj;

            Sent = new SqlDateTime(m.msg.Headers.DateSent);
            From = new SqlString(m.msg.Headers.From.ToString());
            Subject = new SqlString(m.msg.Headers.Subject);
            ContentType = new SqlString(m.part.ContentType.ToString());
            MemoryStream body = new MemoryStream(m.part.Body);
            StreamReader reader = new StreamReader(body, m.part.BodyEncoding);
            Body = new SqlString(reader.ReadToEnd());

        }
    }
}
