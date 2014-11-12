using System;
using System.Windows;
using System.Windows.Controls;

namespace GestaoApp.View.Contact
{
    public partial class EmailFormView : ChildWindow
    {
        public EventHandler OnSave;

        public EmailFormView()
        {
            InitializeComponent();
        }

        private void SaveButton_Click(object sender, RoutedEventArgs e)
        {
            AddressTextBox.GetBindingExpression(TextBox.TextProperty).UpdateSource();

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

