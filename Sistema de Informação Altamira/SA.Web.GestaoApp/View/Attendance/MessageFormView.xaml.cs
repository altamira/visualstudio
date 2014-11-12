using System;
using System.Windows;
using System.Windows.Controls;
using GestaoApp.Models.Attendance;
using GestaoApp.Models.Contact;
using GestaoApp.Models.Location;
using GestaoApp.Models.Sales;
using GestaoApp.ViewModel.Attendance;
using Telerik.Windows.Controls;
using GestaoApp.Models.Attendance.Message;
using System.Linq;
using SilverlightMessageBoxLibrary;
using System.Windows.Media;

namespace GestaoApp.View.Attendance
{
    public partial class MessageFormView : ChildWindow
    {
        public EventHandler OnEditComplete;

        public MessageFormView()
        {
            InitializeComponent();
            Loaded += new RoutedEventHandler(LoadCompleted);
        }

        public void LoadCompleted(object sender, RoutedEventArgs e)
        {
            this.VendorAutoCompleteComboBox.ItemsSource = Models.Sales.Vendor.Collection;
        }

        private void SendButton_Click(object sender, RoutedEventArgs e)
        {
            if (MessageTextBox.Text.Length > 140)
            {
                CustomMessage msg = new CustomMessage("A mensagem não pode ter mais que 140 caracteres.", CustomMessage.MessageType.Info);
                msg.Show();
            }
            else
            {
                this.DialogResult = true;

                if (OnEditComplete != null)
                    OnEditComplete(this, new EventArgs());
            }
        }

        private void CancelButton_Click(object sender, RoutedEventArgs e)
        {
            this.DialogResult = false;
        }

        public void UpdateBinding()
        {
            if ((DataContext as MessageViewModel) != null)
            {
                MessageTextBox.GetBindingExpression(TextBox.TextProperty).UpdateSource();
                if ((DataContext as MessageViewModel).SelectedItem.Text.Length > 140)
                    MessageTextBox.Foreground = new SolidColorBrush(Colors.Red);
                else
                    MessageTextBox.Foreground = new SolidColorBrush(Colors.Black);
            }
        }

        private void MessageTextBox_KeyUp(object sender, System.Windows.Input.KeyEventArgs e)
        {
            UpdateBinding();
        }
    }
}

