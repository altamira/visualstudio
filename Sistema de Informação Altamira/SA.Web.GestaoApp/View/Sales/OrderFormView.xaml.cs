using System;
using System.Windows;
using System.Windows.Controls;
using GestaoApp.Models.Bid;
using GestaoApp.Models.Contact;
using GestaoApp.Models.Location;
using GestaoApp.Models.Sales;
using GestaoApp.ViewModel.Bid;
using Telerik.Windows.Controls;
using System.Windows.Input;
using GestaoApp.ViewModel.Sales;
using SilverlightMessageBoxLibrary;
using GestaoApp.View.Sales;
using GestaoApp.Helpers;
using System.Windows.Browser;
using System.Net;
using System.Windows.Printing;

namespace GestaoApp.View.Sales
{
    public partial class OrderFormView : ChildWindow
    {
        private ClientViewModel viewmodel;
        private ClientFormView childWindow;
        public EventHandler OnSave;

        PrintDocument PrintDialog = new PrintDocument();

        public OrderFormView()
        {
            InitializeComponent();
            
            Loaded += new RoutedEventHandler(LoadCompleted);
        }

        public void LoadCompleted(object sender, RoutedEventArgs e)
        {
            //HTMLBidView.SourceUri = new Uri(string.Format("http://{0}:{1}/Sales.Bid.Document?guid={2}&id={3}", 
            //    Application.Current.Host.Source.Host, 
            //    Application.Current.Host.Source.Port, 
            //    GestaoApp.ViewModel.ViewModelBase.Session.Guid.ToString(), 
            //    int.Parse((this.DataContext as RegisterViewModel).SelectedItem.Number).ToString()));

            //HTMLProjectView.SourceUri = new Uri(string.Format("http://{0}:{1}/Sales.Bid.Project?guid={2}&id={3}",
            //    Application.Current.Host.Source.Host,
            //    Application.Current.Host.Source.Port,
            //    GestaoApp.ViewModel.ViewModelBase.Session.Guid.ToString(),
            //    int.Parse((this.DataContext as RegisterViewModel).SelectedItem.Number).ToString()));

        }

        //private void SaveButton_Click(object sender, RoutedEventArgs e)
        //{
        //    SaveButton.IsEnabled = false;
        //    SaveButton.Content = "Gravando...";

        //    if (OnSave != null)
        //        OnSave(this, new EventArgs());

        //    this.DialogResult = true;
        //}

        private void CancelButton_Click(object sender, RoutedEventArgs e)
        {
            this.DialogResult = false;
        }

        public void UpdateSelectionBinding()
        {
            //this.ContactPersonCopyToGridView.SelectedItems.Clear();
            //foreach (Person p in (this.DataContext as RegisterViewModel).SelectedItem.ContactPersonCopyTo)
            //    this.ContactPersonCopyToGridView.SelectedItems.Add(p);

            /*this.AddressGrid.SelectedItems.Clear();
            foreach (Address a in (this.DataContext as RegisterViewModel).SelectedItem.LocationAddress)
                this.AddressGrid.SelectedItems.Add(a);*/
        }

        private void AddressGrid_SelectionChanged(object sender, SelectionChangeEventArgs e)
        {

        }

        private void DrawFileButton_Click(object sender, RoutedEventArgs e)
        {
            System.Windows.Controls.OpenFileDialog dlg = new System.Windows.Controls.OpenFileDialog();
            dlg.Multiselect = false;
            dlg.Filter = "Desenhos em PDF|*.pdf";

            if ((bool)dlg.ShowDialog())
            {
                //UploadFile(dlg.SelectedFile.Name, dlg.SelectedFile.OpenRead());
                //UploadFile("", new System.IO.Stream());
            }
        }

        private void UploadFile(string fileName, System.IO.Stream fileContent)
        {
            throw new NotImplementedException();
        }

        private void BidFileButton_Click(object sender, RoutedEventArgs e)
        {
            System.Windows.Controls.OpenFileDialog dlg = new System.Windows.Controls.OpenFileDialog();
            dlg.Multiselect = false;
            dlg.Filter = "Orçamentos em PDF|*.pdf";

            if ((bool)dlg.ShowDialog())
            {
                //UploadFile(dlg.SelectedFile.Name, dlg.SelectedFile.OpenRead());
                //UploadFile("", new System.IO.Stream());
            }
        }

        private void OrderPrintButton_Click(object sender, RoutedEventArgs e)
        {
            PrintDocument doc = new PrintDocument();
            doc.PrintPage += new EventHandler<PrintPageEventArgs>(Order_PrintPage);
            doc.Print("Pedido");
        }

        void Order_PrintPage(object sender, PrintPageEventArgs e)
        {
            e.PageVisual = OrderGrid;
        }

    }
}

