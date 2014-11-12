using System;
using System.Data;
using System.Data.SqlClient;
using System.Data.SqlTypes;
using System.IO;
using System.Net;

namespace Utils
{
    public class SMS
    {
        private const string HUMAN_SMS_GATEWAY_ACCOUNT = "altamira";
        private const string HUMAN_SMS_GATEWAY_CODE = "8Zpee5u2x2";
 
        public static void Send(
                            SqlString TextMessage,
                            SqlString From,
                            SqlString Mobile,
                            SqlGuid MessageId)
        {
            string ReturnString = "";

            System.Net.ServicePointManager.Expect100Continue = false;

            try
            {
                HttpWebRequest request = (HttpWebRequest)WebRequest.Create("http://system.human.com.br/GatewayIntegration/msgSms.do");
                request.Method = "POST";
                request.ContentType = "application/x-www-form-urlencoded";

                string Data = "dispatch=send" +                                  // required
                             "&account=" + HUMAN_SMS_GATEWAY_ACCOUNT +           // required
                             "&code=" + HUMAN_SMS_GATEWAY_CODE +                 // required
                             "&msg=" + TextMessage.ToString().Trim() +           // required
                             "&to=" + Mobile.ToString().Trim() +                 // required
                             "&id=" + MessageId.ToString().Trim() +
                             "&from=" + From.ToString().Trim(); 
                             //"&schedule=" + schedule.ToString().Trim();

                byte[] Buffer = System.Text.Encoding.GetEncoding(28591).GetBytes(Data);

                request.ContentLength = Buffer.Length;
                Stream requestStream = request.GetRequestStream();
                requestStream.Write(Buffer, 0, Buffer.Length);
                requestStream.Close();

                WebResponse response = request.GetResponse();
                Stream responseStream = response.GetResponseStream();
                System.Text.Encoding encoding = System.Text.Encoding.Default;
                StreamReader reader = new StreamReader(responseStream, encoding);
                ReturnString = reader.ReadToEnd();

                responseStream.Close();
                reader.Close();
                response.Close();

                /*
                       HttpRequestHelper w = new HttpRequestHelper();
                       //w.OnReceiveCompleted += new HttpRequestHelper.OnReceivedCompletedEventHandler(OnReceiveCompleted);
                       w.Begin("http://system.human.com.br/GatewayIntegration/msgSms.do", Data);
                */
            }
            catch (Exception e)
            {
                ReturnString = e.Message;
            }

            using (SqlConnection connection = new SqlConnection("context connection=true"))
            {
                if (connection.State != ConnectionState.Open)
                    connection.Open();

                SqlCommand command = new SqlCommand("SET NOCOUNT ON; " +
                                                    "UPDATE SMS.[Log] SET [Return] = '" + ReturnString + "' WHERE [Guid] = CAST('" + MessageId.ToString().Trim() + "' AS UNIQUEIDENTIFIER)", connection);
                command.ExecuteNonQuery();

                if (connection.State != ConnectionState.Closed)
                    connection.Close();
            }
        }
    }
}
