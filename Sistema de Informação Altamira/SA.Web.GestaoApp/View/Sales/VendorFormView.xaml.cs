using System;
using System.Windows;
using System.Windows.Controls;

namespace GestaoApp.View.Sales
{
    public partial class VendorFormView : ChildWindow
    {
        public EventHandler OnSave;

        public VendorFormView()
        {
            InitializeComponent();
        }

        private void SaveButton_Click(object sender, RoutedEventArgs e)
        {
            //CodeTextBox.GetBindingExpression(TextBox.TextProperty).UpdateSource();
            //NameTextBox.GetBindingExpression(TextBox.TextProperty).UpdateSource();

            /*if (!Helpers.ValidatorHelper.IsValid(this))
             {
                CustomMessage msg = new CustomMessage("O formulário contem erros, corriga antes de gravar.", CustomMessage.MessageType.Error)).Show();
                msg.Show();
             }*/

            //if (Helpers.ValidatorHelper.IsValid(this))
            //{
                if (OnSave != null)
                    OnSave(this, new EventArgs());

                this.DialogResult = true;
            //}
        }

        private void CancelButton_Click(object sender, RoutedEventArgs e)
        {
            this.DialogResult = false;
        }
    }
}

