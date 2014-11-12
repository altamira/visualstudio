using System;
using System.Windows;
using System.Windows.Controls;
using Telerik.Windows.Controls;
using GestaoApp.ViewModel.Shipping;
using GestaoApp.Models.Sales;

namespace GestaoApp.View.Shipping
{
    public partial class PackingListFormView : ChildWindow
    {
        public EventHandler OnSave;

        public PackingListFormView()
        {
            InitializeComponent();
            Loaded += new RoutedEventHandler(LoadCompleted);
        }

        public void LoadCompleted(object sender, RoutedEventArgs e)
        {
            this.ClientAutoCompleteComboBox.ItemsSource = Client.Collection;
            //this.PurchaseTypeAutoCompleteComboBox.ItemsSource = PurchaseType.Collection;
            this.VendorAutoCompleteComboBox.ItemsSource = Models.Sales.Vendor.Collection;
        }

        private void SaveButton_Click(object sender, RoutedEventArgs e)
        {
            if (OnSave != null)
                OnSave(this, new EventArgs());

            this.DialogResult = true;
        }

        private void CancelButton_Click(object sender, RoutedEventArgs e)
        {
            this.DialogResult = false;
        }

        private void ClientAutoCompleteComboBox_SelectionChanged(object sender, System.Windows.Controls.SelectionChangedEventArgs e)
        {
            if ((sender as AutoCompleteBox).SelectedItem != null)
                (this.DataContext as PackingListViewModel).ClientViewModel.SelectedItem = (sender as AutoCompleteBox).SelectedItem as Client;
        }

        public void UpdateSelectionBinding()
        {
            /*this.ContactPersonCopyToGrid.SelectedItems.Clear();
            foreach (Person p in (this.DataContext as PackingListViewModel).SelectedItem.ContactPersonCopyTo)
                this.ContactPersonCopyToGrid.SelectedItems.Add(p);

            this.AddressGrid.SelectedItems.Clear();
            foreach (Address a in (this.DataContext as PackingListViewModel).SelectedItem.LocationAddress)
                this.AddressGrid.SelectedItems.Add(a);*/
        }

        private void PersonGrid_SelectionChanged(object sender, Telerik.Windows.Controls.SelectionChangeEventArgs e)
        {

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
    }
}

