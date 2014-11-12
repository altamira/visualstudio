using System;
using System.Windows;
using System.Windows.Controls;

namespace GestaoApp.View.Contact
{
    public partial class PersonFormView : ChildWindow
    {
        public EventHandler OnSave;

        public PersonFormView()
        {
            InitializeComponent();
        }

        private void SaveButton_Click(object sender, RoutedEventArgs e)
        {
            //FirstNameTextBox.GetBindingExpression(TextBox.TextProperty).UpdateSource();
            //LastNameTextBox.GetBindingExpression(TextBox.TextProperty).UpdateSource();

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

