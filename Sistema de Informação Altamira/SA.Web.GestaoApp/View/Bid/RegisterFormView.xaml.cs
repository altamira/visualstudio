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

namespace GestaoApp.View.Bid
{
    public partial class RegisterFormView : ChildWindow
    {
        private ClientViewModel viewmodel;
        private ClientFormView childWindow;
        public EventHandler OnSave;

        PrintDocument PrintDialog = new PrintDocument();

        public RegisterFormView()
        {
            InitializeComponent();
            //this.ClientAutoCompleteComboBox.ItemsSource = Client.Collection;
            this.PurchaseTypeAutoCompleteComboBox.ItemsSource = PurchaseType.Collection;
            this.VendorAutoCompleteComboBox.ItemsSource = Models.Sales.Vendor.Collection;
            
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

        private void SaveButton_Click(object sender, RoutedEventArgs e)
        {
            SaveButton.IsEnabled = false;
            SaveButton.Content = "Gravando...";

            if (OnSave != null)
                OnSave(this, new EventArgs());

            this.DialogResult = true;
        }

        private void CancelButton_Click(object sender, RoutedEventArgs e)
        {
            this.DialogResult = false;
        }

        public void UpdateSelectionBinding()
        {
            this.ContactPersonCopyToGridView.SelectedItems.Clear();
            foreach (Person p in (this.DataContext as RegisterViewModel).SelectedItem.ContactPersonCopyTo)
                this.ContactPersonCopyToGridView.SelectedItems.Add(p);

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

        private void ClientTextBox_KeyUp(object sender, System.Windows.Input.KeyEventArgs e)
        {
            if (e.Key == Key.Enter)
            {
                viewmodel = new ClientViewModel();
                viewmodel.SearchCompleted += new EventHandler(ClientSearchCompleted);
                viewmodel.Search(ClientTextBox.Text.Trim());
            }
        }

        private void ClientSearchCompleted(object sender, EventArgs e)
        {
            if (viewmodel == null)
                return;

            if (viewmodel.SearchResultList.Count == 0)
            {
                CustomMessage msg = new CustomMessage("O Cliente não esta cadastrado !", CustomMessage.MessageType.Info);

                msg.OKButton.Click += (obj, args) =>
                {
                    //ClientTextBox.Focus();
                    //ClientFormView view = new ClientFormView();
                    //model.SelectedItem = new Client();
                    //view.OnSave += new EventHandler(ClientSelected);
                    //view.DataContext = model;
                    //view.Show();

                    viewmodel = new ClientViewModel();
                    viewmodel.SelectedItem = new Client();
                    viewmodel.AddCompleted += new EventHandler(ClientSelected);
                    childWindow = new ClientFormView();
                    childWindow.OnSave = new EventHandler(viewmodel.OnAddComplete);
                    childWindow.DataContext = viewmodel;
                    childWindow.Show();
                };

                msg.Show();
            }
            else if (viewmodel.SearchResultList.Count == 1)
            {
                (this.DataContext as ViewModel.Bid.RegisterViewModel).ClientViewModel.SelectedItem = viewmodel.SearchResultList[0];
                (this.DataContext as ViewModel.Bid.RegisterViewModel).SelectedItem.Client = viewmodel.SearchResultList[0];
            }
            else
            {
                ClientSelectView view = new ClientSelectView();
                view.OnSelect += new EventHandler(ClientSelected);
                view.DataContext = viewmodel;
                view.Show();
            }
        }

        private void ClientSelected(object sender, EventArgs e)
        {
            if (childWindow != null)
                childWindow.DialogResult = true;

            (this.DataContext as ViewModel.Bid.RegisterViewModel).ClientViewModel.SelectedItem = viewmodel.SelectedItem;
            (this.DataContext as ViewModel.Bid.RegisterViewModel).SelectedItem.Client = viewmodel.SelectedItem;
            ClientTextBox.Text = (this.DataContext as ViewModel.Bid.RegisterViewModel).SelectedItem.Client.CodeName.Trim();
            LocationAddressAutoCompleteComboBox.Focus();
        }

        private void ClientTextBox_LostFocus(object sender, RoutedEventArgs e)
        {
            
        }

        private void ClientTextBox_GotFocus(object sender, RoutedEventArgs e)
        {
            ClientTextBox.SelectAll();
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

