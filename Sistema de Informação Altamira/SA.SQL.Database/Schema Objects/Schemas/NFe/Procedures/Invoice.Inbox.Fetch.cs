//------------------------------------------------------------------------------
// <copyright file="CSSqlFunction.cs" company="Microsoft">
//     Copyright (c) Microsoft Corporation.  All rights reserved.
// </copyright>
//------------------------------------------------------------------------------
using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Data.SqlTypes;
using Microsoft.SqlServer.Server;
using OpenPop.Mime;
using OpenPop.Pop3;
using System.Security;
using System.Net;
using System.Security.Permissions;
using System.Xml;
using System.IO;
using System.Security.Cryptography;
using System.Xml.Schema;

namespace NFe
{
    public partial class UserDefinedFunctions
    {
        private static SqlConnection sharedConnection = null;
        private static Message message = null;
        private static MessagePart messagePart = null;

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
        private static List<Message> FetchAllMessages(string host, int port, bool ssl, string user, string pass)
        {
            List<Message> messages = new List<Message>();

            // The client disconnects from the server when being disposed
            using (Pop3Client client = new Pop3Client())
            {
                if (client == null)
                    return messages;

                // Connect to the server
                client.Connect(host, port, ssl);

                // Authenticate ourselves towards the server
                client.Authenticate(user, pass);

                // Get the number of messages in the inbox
                int messageCount = client.GetMessageCount();

                // We want to download all messages
                messages = new List<Message>(messageCount);

                // Messages are numbered in the interval: [1, messageCount]
                // Ergo: message numbers are 1-based.
                for (int i = 1; i <= messageCount; i++)
                {
                    messages.Add(client.GetMessage(i));
                }
            }

            // Now return the fetched messages
            return messages;
        }

        private static void ProcessXML(MemoryStream bytes, StreamReader reader)
        {
            HashAlgorithm algorithm = HashAlgorithm.Create("System.Security.Cryptography.SHA512");

            if (algorithm == null)
                throw new Exception("Hash SHA512 Algorithm not supported !");

            try
            {
                // Create the XmlSchemaSet class.
                XmlSchemaSet sc = new XmlSchemaSet();

                // Add the schema to the collection.
                //sc.Add("urn:bookstore-schema", "books.xsd");

                // Set the validation settings.
                XmlReaderSettings settings = new XmlReaderSettings();
                settings.ValidationType = ValidationType.None; // ValidationType.Schema;
                //settings.Schemas = sc;
                settings.ValidationEventHandler += new ValidationEventHandler(InvalidXmlCallBack);

                // Create the XmlReader object.
                //XmlReader reader = XmlReader.Create("booksSchemaFail.xml", settings);

                using (XmlReader xml = XmlReader.Create(reader, settings))
                //using (XmlTextReader xml = new XmlTextReader(reader, settings))
                {
                    if (xml != null && xml.Read() && !xml.IsEmptyElement)
                    {
                        using (SqlCommand command = new SqlCommand("[NFe].[Invoice.Add]", sharedConnection))
                        {
                            command.CommandType = CommandType.StoredProcedure;

                            xml.MoveToContent();

                            while (xml.Read())
                            {
                                if (xml.Name.Equals("infNFe") && xml.NodeType == XmlNodeType.Element)
                                    command.Parameters.AddWithValue("@Key", new SqlString(xml.GetAttribute("Id").Substring(3)));

                                if (xml.Name.Equals("ide") && xml.NodeType == XmlNodeType.Element)
                                {
                                    XmlReader xmlEmit = xml.ReadSubtree();

                                    while (xmlEmit.Read())
                                    {
                                        if (xml.Name.Equals("nNF") && xml.NodeType == XmlNodeType.Element)
                                            command.Parameters.AddWithValue("@Number", new SqlInt32(xml.ReadElementContentAsInt()));

                                        if (xml.Name.Equals("dEmi") && xml.NodeType == XmlNodeType.Element)
                                            command.Parameters.AddWithValue("@Date", new SqlDateTime(xml.ReadElementContentAsDateTime()));
                                    }

                                    xml.ReadToNextSibling("emit");
                                }

                                if (xml.Name.Equals("emit") && xml.NodeType == XmlNodeType.Element)
                                {
                                    XmlReader xmlEmit = xml.ReadSubtree();

                                    while (xmlEmit.Read())
                                    {
                                        if (xml.Name.Equals("xNome") && xml.NodeType == XmlNodeType.Element)
                                            command.Parameters.AddWithValue("@From", new SqlString(xml.ReadElementContentAsString()));
                                    }
                                }

                                if (xml.Name.Equals("dest") && xml.NodeType == XmlNodeType.Element)
                                {
                                    XmlReader xmlEmit = xml.ReadSubtree();

                                    while (xmlEmit.Read())
                                    {
                                        if (xml.Name.Equals("xNome") && xml.NodeType == XmlNodeType.Element)
                                            command.Parameters.AddWithValue("@To", new SqlString(xml.ReadElementContentAsString()));
                                    }
                                }
                            }

                            bytes.Position = 0;
                            command.Parameters.AddWithValue("@Xml", new SqlXml(bytes));

                            command.Parameters.AddWithValue("@Hash", new SqlBinary(algorithm.ComputeHash(messagePart.Body)));

                            command.ExecuteNonQuery();
                        }
                    }
                }
            }
            catch (NullReferenceException eNull)
            {
                LogInvalidXml(eNull);
                throw; // new NullReferenceException("ProcessXML: Referência inválida: " + eNull.Message);
            }
            catch (XmlException eXml)
            {
                LogInvalidXml(eXml);
                //throw; // new XmlException("ProcessXML: Erro no parse do XML: " + eXml.Message);
            }
            catch (XmlSchemaException eXmlSchema)
            {
                LogInvalidXml(eXmlSchema);
                //throw; // new XmlSchemaException("ProcessXML: Erro de validação no XML: " + eXmlSchema.Message);
            }
            catch (Exception e)
            {
                LogInvalidXml(e);
                throw; // e.InnerException;
            }
        }

        private static void ProcessMessageParts(List<Message> messages)
        {
            List<MessagePart> messageParts = null;

            if (messages == null)
            {
                Log("------> Error :Messages list is null !");
                return;
            }

            Log(String.Format("-Starting process message list with {0} messages...", messages.Count));

            try
            {
                for (int i = 0; i < messages.Count; i++)
                {
                    message = messages[i];

                    if (message == null)
                    {
                        Log(String.Format("------> Error :Message {0} is null !", i));
                        continue;
                    }

                    Log(String.Format("--Starting process message {0}.", i));
                    Log(String.Format("----------> {0} <----------", message.Headers.Subject));

                    messageParts = message.FindAllAttachments();

                    if (messageParts == null)
                    {
                        Log("------> Error :Message doesn't have attachments !");
                        continue;
                    }

                    if (messageParts.Count == 0)
                    {
                        Log("------> Error :Message have zero attachments !");
                        continue;
                    }

                    if (messageParts != null && messageParts.Count > 0)
                    {
                        Log(String.Format("---Starting process of message part with {0} attachment(s).", messageParts.Count));

                        for (int x = 0; x < messageParts.Count; x++)
                        {
                            Log(String.Format("----Starting process of message {0}/{1}.", x, messageParts.Count));

                            messagePart = messageParts[x];

                            if (messagePart == null)
                            {
                                Log("------> Error :Message part is null !");
                                continue;
                            }

                            if (!messagePart.IsAttachment)
                            {
                                Log("------> Error :Message part is not an attachment !");
                                continue;
                            }

                            if (messagePart.Body == null)
                            {
                                Log("------> Error :Message part body is null !");
                                continue;
                            }

                            if (messagePart.Body.Length == 0)
                            {
                                Log("------> Error :Message part body is zero length !");
                                continue;
                            }

                            if (messagePart.ContentType == null)
                            {
                                Log("------> Error :ContentType of message part is null !");
                                continue;
                            }

                            //if (messagePart.ContentType.Name == null)
                            //{
                            //    Log("------> Error :ContentType Name of message part is null !");
                            //    continue;
                            //}

                            //if (messagePart.ContentType.Name.Trim().Length == 0)
                            //{
                            //    Log("------> Error :ContentType of message part doesn't have a name !");
                            //    continue;
                            //}

                            Log(String.Format("-----Starting process of message part with Subject '{0}', ContentType {1}, Name {2} and Body Length {3}.", message.Headers.Subject, messagePart.ContentType.MediaType, messagePart.ContentType.Name, messagePart.Body.Length));

                            if (messagePart != null &&
                                messagePart.IsAttachment &&
                                messagePart.Body.Length > 0 &&
                                ((messagePart.ContentType != null &&
                                  messagePart.ContentType.Name != null &&
                                  messagePart.ContentType.Name.Trim().ToLower().Substring(messagePart.ContentType.Name.Trim().Length - 4) == ".xml") ||
                                (messagePart.ContentType != null &&
                                 messagePart.ContentType.MediaType != null &&
                                 (messagePart.ContentType.Name == null || (messagePart.ContentType.Name != null && messagePart.ContentType.Name.Trim() == "")) &&
                                (messagePart.ContentType.MediaType == "text/xml" ||
                                messagePart.ContentType.MediaType == "text/plain" ||
                                messagePart.ContentType.MediaType == "application/octet-stream" ||
                                messagePart.ContentType.MediaType == "application/xml" ||
                                messagePart.ContentType.MediaType == "application/zip"))))
                            {
                                Log("---------------->  Message with a xml file attached.  <----------------");

                                using (MemoryStream body = new MemoryStream(messagePart.Body))
                                {
                                    if (body != null && body.Length > 0)
                                    {
                                        using (StreamReader reader = new StreamReader(body, messagePart.BodyEncoding))
                                        {
                                            Log("----------------> Call ProcessXML() <----------------");

                                            if (reader != null)
                                                ProcessXML(body, reader);
                                        }
                                    }
                                }

                                //Log("Ending to process message with a xml file attached.");
                            }
                            else
                            {
                                Log("------Message without a xml file attached, skip.");
                            }

                            Log(String.Format("----Ending process of message {0}/{1}.", x, messageParts.Count));
                        }
                        Log(String.Format("---Ending process of message part with {0} attachment(s).", messageParts.Count));
                    }
                    Log(String.Format("--Ending process message {0}.", i));
                }
            }
            catch (NullReferenceException eNull)
            {
                LogInvalidXml(eNull);
                throw;
            }
            catch (Exception e)
            {
                LogInvalidXml(e);
                throw;
            }

            Log(string.Format(".Ending process message list with {0} messages...", messages.Count));
        }

        //[System.Security.Permissions.PermissionSet(System.Security.Permissions.SecurityAction.PermitOnly, Name = "FullTrust")]
        [Microsoft.SqlServer.Server.SqlProcedure(Name = "NFe.Invoice.Inbox.Fetch")]
        public static SqlInt32 InvoiceFetchInbox(SqlString host, SqlInt32 port, SqlBoolean ssl, SqlString user, SqlString pass)
        {
            int Count = 0;

            //Log("Starting fetch messages...");

            List<Message> messages = FetchAllMessages(host.Value, port.Value, ssl.Value, user.Value, pass.Value);

            //try
            //{
            if (messages != null)
            {
                //Log(String.Format("Fetched {0} messages.", messages.Count));

                if (messages.Count > 0)
                {
                    Count = messages.Count;

                    using (SqlConnection connection = new SqlConnection("context connection=true"))
                    {
                        if (connection.State == System.Data.ConnectionState.Broken)
                            connection.Close();

                        if (connection.State == System.Data.ConnectionState.Closed)
                            connection.Open();

                        sharedConnection = connection;

                        //using (SqlCommand command = new SqlCommand("DELETE FROM [NFe.Database].[NFe].[FetchLog]", connection))
                        //{
                        //    command.ExecuteNonQuery();
                        //}

                        Log(String.Format("Start processing {0} messages...", Count));
                        ProcessMessageParts(messages);
                        Log(String.Format("End processing {0} messages...", Count));
                    }
                }
            }
            //}
            //catch (NullReferenceException eNull)
            //{
            //    throw new NullReferenceException("GetNFeFromMailInbox: Referência inválida: " + eNull.Message);
            //}
            //catch (Exception e)
            //{
            //    throw e.InnerException;
            //}

            //Log("Ending fetch messages.");

            return Count;
        }

        private static void Log(string history)
        {
            using (SqlCommand command = new SqlCommand("[NFe].[Invoice.Fetch.Log.Add]", sharedConnection))
            {
                command.CommandType = CommandType.StoredProcedure;

                command.Parameters.AddWithValue("@History", new SqlString(history));

                command.ExecuteNonQuery();
            }
        }

        private static void LogInvalidXml(Exception e)
        {
            if (message != null)
            {
                using (SqlCommand command = new SqlCommand("[NFe].[Invoice.Fetch.Error.Message.Add]", sharedConnection))
                {
                    command.CommandType = CommandType.StoredProcedure;

                    command.Parameters.AddWithValue("@Sent", new SqlDateTime(message.Headers.DateSent));
                    command.Parameters.AddWithValue("@From", new SqlString(string.Join("; ", message.Headers.From)));
                    command.Parameters.AddWithValue("@To", new SqlString(string.Join("; ", message.Headers.To)));
                    command.Parameters.AddWithValue("@Cc", new SqlString(string.Join("; ", message.Headers.Cc)));
                    command.Parameters.AddWithValue("@Bcc", new SqlString(string.Join("; ", message.Headers.Bcc)));
                    command.Parameters.AddWithValue("@Subject", new SqlString(message.Headers.Subject));
                    command.Parameters.AddWithValue("@Body", new SqlBinary(message.RawMessage));

                    //command.ExecuteScalar();

                    int Id = (int)command.ExecuteScalar();

                    if (messagePart != null && Id > 0)
                    {
                        using (SqlCommand command2 = new SqlCommand("[NFe].[Invoice.Fetch.Error.Message.Part.Add]", sharedConnection))
                        {
                            command2.CommandType = CommandType.StoredProcedure;

                            command2.Parameters.AddWithValue("@Message", new SqlInt32(Id));
                            command2.Parameters.AddWithValue("@ContentType", new SqlString(messagePart.ContentType.ToString()));
                            MemoryStream body = new MemoryStream(messagePart.Body);
                            StreamReader reader = new StreamReader(body, messagePart.BodyEncoding);
                            command2.Parameters.AddWithValue("@MessagePart", new SqlString(reader.ReadToEnd()));
                            command2.Parameters.AddWithValue("@Error", new SqlString(e.Message));

                            command2.ExecuteNonQuery();
                        }
                    }
                }
            }
        }

        private static void InvalidXmlCallBack(object sender, ValidationEventArgs e)
        {
            LogInvalidXml(new Exception(e.Message));
        }
    }
}