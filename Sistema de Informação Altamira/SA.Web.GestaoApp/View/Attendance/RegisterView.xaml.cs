using System;
using System.Net;
using System.Windows.Browser;
using System.Windows.Controls;
using System.Windows.Printing;
using Telerik.Windows.Controls;
using Telerik.Windows.Controls.GridView;

namespace GestaoApp.View.Attendance
{
    public partial class RegisterView : UserControl
    {
        PrintDocument PrintDialog = new PrintDocument();
        const string printScript = @"<script type=""text/javascript"">print();setTimeout(function(){close();}, 0);</script>";
        string fileName = Guid.NewGuid().ToString() + ".html";

        public RegisterView()
        {
            InitializeComponent();
        }

        private void PrintButton_Click(object sender, System.Windows.RoutedEventArgs e)
        {
            fileName = "PrintSpool/" + Guid.NewGuid().ToString() + ".html";
            SelectDataPager.PageSize = 0;
            Uri uri = new Uri(HtmlPage.Document.DocumentUri, String.Format("PrintHandler.aspx?fn={0}", HttpUtility.UrlEncode(fileName)));
            WebClient client = new WebClient();
            client.UploadStringCompleted += new UploadStringCompletedEventHandler(UploadStringCompleted);
            client.UploadStringAsync(uri, String.Format("{0}{1}", SelectGridView.ToHtml(), printScript));

            return;
        }

        void UploadStringCompleted(object sender, UploadStringCompletedEventArgs e)
        {
            HtmlPage.Window.Navigate(new Uri(HtmlPage.Document.DocumentUri, fileName), "_blank", "menubar=0;toolbar=0;fullscreen=1;");
        }
    }
}
