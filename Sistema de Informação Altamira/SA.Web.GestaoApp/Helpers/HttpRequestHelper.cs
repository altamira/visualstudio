using System;
using System.Collections.Generic;
using System.IO;
using System.Net;
using System.Text;
using System.Windows.Browser;
using System.Xml.Linq;
using GestaoApp.Controls;
using System.Windows.Threading;
using System.Threading;

namespace GestaoApp.Helpers
{
    public class HttpRequestHelper
    {
        private HttpWebRequest Request { get; set; }
        public XDocument XmlRequest { get; set; }
        bool ShowWaitingMessage = false;

        public event HttpResponseCompleteEventHandler ResponseComplete;

        private void OnResponseComplete(HttpResponseCompleteEventArgs e)
        {
            if (this.ResponseComplete != null)
            {
                this.ResponseComplete(e);
            }
        }

        public HttpRequestHelper(Uri requestUri, string method, XDocument xml, bool showWaitingMessage = true)
        {
            this.Request = (HttpWebRequest)WebRequest.Create(requestUri);
            this.Request.ContentType = "text/xml";
            this.Request.Method = method;
            this.XmlRequest = xml;
            this.ShowWaitingMessage = showWaitingMessage;
        }
        public void Execute()
        {
            try
            {
                if (ShowWaitingMessage)
                    ThreadPool.QueueUserWorkItem((state) =>
                    {
                        System.Windows.Deployment.Current.Dispatcher.BeginInvoke(() => ((MainPage)App.Current.RootVisual).busyIndicator.IsBusy = true);
                    });

                this.Request.BeginGetRequestStream(new AsyncCallback(HttpRequestHelper.BeginRequest), this);

            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

        private static void BeginRequest(IAsyncResult ar)
        {
            HttpRequestHelper helper = ar.AsyncState as HttpRequestHelper;

            if (helper != null)
            {
                if (helper.XmlRequest != null)
                {

                    // End the Asynchronus request.
                    Stream streamResponse = helper.Request.EndGetRequestStream(ar);

                    // Create a string that is to be posted to the uri.
                    //Console.WriteLine("Please enter a string to be posted:");
                    //string postData = helper.XmlRequest.ToString(); // "<?xml version=\"1.0\"?><request />";
                    // Convert the string into a byte array.
                    byte[] byteArray = Encoding.UTF8.GetBytes(helper.XmlRequest.ToString());

                    // Write the data to the stream.
                    streamResponse.Write(byteArray, 0, byteArray.Length);
                    streamResponse.Close();
                }

                helper.Request.BeginGetResponse(new AsyncCallback(HttpRequestHelper.BeginResponse), helper);
            }
        }

        private static void BeginResponse(IAsyncResult ar)
        {
            HttpRequestHelper helper = null;
            StreamReader reader;

            try
            {
                helper = ar.AsyncState as HttpRequestHelper;
                if (helper != null)
                {
                    if (helper.ShowWaitingMessage)
                        ThreadPool.QueueUserWorkItem((state) =>
                        {
                            //Thread.Sleep(5 * 1000);
                            System.Windows.Deployment.Current.Dispatcher.BeginInvoke(() => ((MainPage)App.Current.RootVisual).busyIndicator.IsBusy = false);
                        });

                    HttpWebResponse response = (HttpWebResponse)helper.Request.EndGetResponse(ar);
                    if (response != null)
                    {
                        Stream stream = response.GetResponseStream();
                        if (stream != null)
                        {
                            using (reader = new StreamReader(stream))
                            {
                                helper.OnResponseComplete(new HttpResponseCompleteEventArgs(XDocument.Load(reader)));
                            }
                        }
                    }
                }
            }
            catch (Exception ex)
            {
                if (helper == null)
                    throw ex;
                helper.OnResponseComplete(new HttpResponseCompleteEventArgs(ex, helper.XmlRequest));
            }
        }
    }

    public delegate void HttpResponseCompleteEventHandler(HttpResponseCompleteEventArgs e);
    public class HttpResponseCompleteEventArgs : EventArgs
    {
        public Exception Error { get; set; }
        public XDocument XmlRequest { get; set; }
        public XDocument XmlResponse { get; set; }

        public HttpResponseCompleteEventArgs(XDocument response)
        {
            this.Error = null;
            this.XmlResponse = response;
        }
        public HttpResponseCompleteEventArgs(Exception error, XDocument request)
        {
            this.Error = error;
            this.XmlRequest = request;
        }
    }
}
