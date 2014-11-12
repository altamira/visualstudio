using System;
using System.Net;
using System.Windows.Browser;
using System.Windows.Controls;
using System.Windows.Printing;
using Telerik.Windows.Controls;
using System.Windows.Media;
using System.Windows;

namespace GestaoApp.View.Sales
{
    public partial class DashboardView : UserControl
    {
        PrintDocument PrintDialog = new PrintDocument();
        const string printScript = @"<script type=""text/javascript"">print();setTimeout(function(){close();}, 0);</script>";
        string fileName = Guid.NewGuid().ToString() + ".html";

        public DashboardView()
        {
            InitializeComponent();
        }

        private void VendorPrintButton_Click(object sender, System.Windows.RoutedEventArgs e)
        {
            fileName = "PrintSpool/" + Guid.NewGuid().ToString() + ".html";
            Uri uri = new Uri(HtmlPage.Document.DocumentUri, String.Format("PrintHandler.aspx?fn={0}", HttpUtility.UrlEncode(fileName)));
            WebClient client = new WebClient();
            client.UploadStringCompleted += new UploadStringCompletedEventHandler(UploadStringCompleted);
            client.UploadStringAsync(uri, String.Format("{0}{1}", VendorGridView.ToHtml(), printScript));

            return;
        }

        void UploadStringCompleted(object sender, UploadStringCompletedEventArgs e)
        {
            HtmlPage.Window.Navigate(new Uri(HtmlPage.Document.DocumentUri, fileName), "_blank", "menubar=0;toolbar=0;fullscreen=1;");
        }

        void GridView_Exporting(object sender, GridViewExportEventArgs e)
        {
            if (e.Element == ExportElement.HeaderRow)
            {
                e.Height = 50;
                e.Background = Colors.LightGray;
                e.Foreground = Colors.Black;
                e.FontSize = 15;
                e.FontWeight = FontWeights.Bold;
                e.FontFamily = new FontFamily("Verdana");
            }
            else if (e.Element == ExportElement.GroupHeaderRow)
            {
                e.FontFamily = new FontFamily("Verdana");
                e.Background = Colors.LightGray;
                e.Height = 12;
            }
            else
            {
                e.FontFamily = new FontFamily("Verdana");
                e.FontSize = 10;
            }
        }

        private void VendorQtdPrintButton_Click(object sender, RoutedEventArgs e)
        {
            PrintDocument doc = new PrintDocument();
            doc.PrintPage += new EventHandler<PrintPageEventArgs>(VendorQtd_PrintPage);
            doc.Print("Orçamento por Representante x Quantidade");
        }

        void VendorQtd_PrintPage(object sender, PrintPageEventArgs e)
        {
            e.PageVisual = VendorQtdBarChart;
        }
        private void VendorValPrintButton_Click(object sender, RoutedEventArgs e)
        {
            PrintDocument doc = new PrintDocument();
            doc.PrintPage += new EventHandler<PrintPageEventArgs>(VendorVal_PrintPage);
            doc.Print("Orçamento por Representante x Valores");
        }

        void VendorVal_PrintPage(object sender, PrintPageEventArgs e)
        {
            e.PageVisual = VendorValBarChart;
        }
    }
}
