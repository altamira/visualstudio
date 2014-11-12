using System;
using System.Net;
using System.Windows.Browser;
using System.Windows.Controls;
using System.Windows.Printing;
using Telerik.Windows.Controls;
using Telerik.Windows.Controls.GridView;
using System.Windows.Media;
using System.Windows;

namespace GestaoApp.View.Sales
{
    public partial class OrderView : UserControl
    {
        PrintDocument PrintDialog = new PrintDocument();
        const string printScript = @"<script type=""text/javascript"">print();setTimeout(function(){close();}, 0);</script>";
        string fileName = Guid.NewGuid().ToString() + ".html";

        public OrderView()
        {
            InitializeComponent();
            this.SelectGridView.RowLoaded += this.SelectGridView_RowLoaded;
        }
        void SelectGridView_RowLoaded(object sender, RowLoadedEventArgs e)
        {
            GridViewRow row = e.Row as GridViewRow;
            Models.Bid.Register register = e.DataElement as Models.Bid.Register;
            if (row != null && register != null)
            {
                row.IsExpandable = register.Items.Count > 0;
            }
        }

        private void TextBox_UpdateBinding(object sender, TextChangedEventArgs e)
        {
            var binding = ((TextBox)sender).GetBindingExpression(TextBox.TextProperty);
            binding.UpdateSource();
        }

        void SelectGridView_Exporting(object sender, GridViewExportEventArgs e)
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
