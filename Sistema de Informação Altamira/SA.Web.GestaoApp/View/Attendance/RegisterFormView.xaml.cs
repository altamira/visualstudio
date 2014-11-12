using System;
using System.Windows;
using System.Windows.Controls;
using GestaoApp.Models.Attendance;
using GestaoApp.Models.Contact;
using GestaoApp.Models.Location;
using GestaoApp.Models.Sales;
using GestaoApp.ViewModel.Attendance;
using Telerik.Windows.Controls;
using GestaoApp.ViewModel.Sales;
using System.Windows.Input;
using SilverlightMessageBoxLibrary;
using GestaoApp.View.Sales;

namespace GestaoApp.View.Attendance
{
    public partial class RegisterFormView : ChildWindow
    {
        private ClientFormView childWindow;
        private ClientViewModel viewmodel;
        public EventHandler OnSave;

        public RegisterFormView()
        {
            InitializeComponent();
            Loaded += new RoutedEventHandler(LoadCompleted);
        }

        public void LoadCompleted(object sender, RoutedEventArgs e)
        {
            //this.ClientAutoCompleteComboBox.ItemsSource = Client.Collection;
            this.TypeAutoCompleteComboBox.ItemsSource = GestaoApp.Models.Attendance.Type.Collection;
            this.StatusAutoCompleteComboBox.ItemsSource = Status.Collection;
            this.VendorAutoCompleteComboBox.ItemsSource = Models.Sales.Vendor.Collection;

            //UpdateSelectionBinding();
        }

        //public void UpdateBinding()
        //{
        //    var selectBehavior = new RadGridViewMultiSelectBehavior();
        //    BindingOperations.SetBinding(selectBehavior, RadGridViewMultiSelectBehavior.SelectedItemsProperty, 
        //        new Binding("SelectedItem.ContactPerson") { Source = this.LayoutRoot.DataContext });
        //    Interaction.GetBehaviors(this.PersonGrid).Add(selectBehavior); 

        //}
        private void SaveButton_Click(object sender, RoutedEventArgs e)
        {
            //CodeTextBox.GetBindingExpression(TextBox.TextProperty).UpdateSource();
            //NameTextBox.GetBindingExpression(TextBox.TextProperty).UpdateSource();

            /*if (!Helpers.ValidatorHelper.IsValid(this))
            {
                this.ValidationSummary.UpdateLayout();
                CustomMessage msg = new CustomMessage("O formulário contem erros, corriga antes de gravar.", CustomMessage.MessageType.Error);
                msg.Show();
            }
            else
            {*/

            //(this.DataContext as AttendanceRegisterViewModel).SelectedItem.ContactPerson.Clear();
            //(this.DataContext as AttendanceRegisterViewModel).SelectedItem.ContactPerson.Add((this.DataContext as AttendanceRegisterViewModel).SelectedItem.Client.ContactPerson.FirstOrDefault());

            SaveButton.IsEnabled = false;
            SaveButton.Content = "Gravando...";

            if (OnSave != null)
                OnSave(this, new EventArgs());

            //this.DialogResult = true;
            //}
        }

        private void CancelButton_Click(object sender, RoutedEventArgs e)
        {
            this.DialogResult = false;
        }

        public void UpdateSelectionBinding()
        {
            this.PersonGrid.SelectedItems.Clear();
            foreach (Person p in (this.DataContext as RegisterViewModel).SelectedItem.ContactPerson)
                this.PersonGrid.SelectedItems.Add(p);

            this.AddressGrid.SelectedItems.Clear();
            foreach (Address a in (this.DataContext as RegisterViewModel).SelectedItem.LocationAddress)
                this.AddressGrid.SelectedItems.Add(a);
        }

        private void PersonGrid_SelectionChanged(object sender, Telerik.Windows.Controls.SelectionChangeEventArgs e)
        {

        }

        private void AddressGrid_SelectionChanged(object sender, SelectionChangeEventArgs e)
        {

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
                CustomMessage msg = new CustomMessage("O Cliente não foi encontrado !", CustomMessage.MessageType.Info);

                msg.OKButton.Click += (obj, args) =>
                {
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
                (this.DataContext as ViewModel.Attendance.RegisterViewModel).ClientViewModel.SelectedItem = viewmodel.SearchResultList[0];
                (this.DataContext as ViewModel.Attendance.RegisterViewModel).SelectedItem.Client = viewmodel.SearchResultList[0];
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

            (this.DataContext as ViewModel.Attendance.RegisterViewModel).ClientViewModel.SelectedItem = viewmodel.SelectedItem;
            (this.DataContext as ViewModel.Attendance.RegisterViewModel).SelectedItem.Client = viewmodel.SelectedItem;
            ClientTextBox.Text = (this.DataContext as ViewModel.Attendance.RegisterViewModel).SelectedItem.Client.CodeName.Trim();
            VendorAutoCompleteComboBox.Focus();
        }

        private void ClientTextBox_LostFocus(object sender, RoutedEventArgs e)
        {

        }

        private void ClientTextBox_GotFocus(object sender, RoutedEventArgs e)
        {
            ClientTextBox.SelectAll();
        }
    }
}

