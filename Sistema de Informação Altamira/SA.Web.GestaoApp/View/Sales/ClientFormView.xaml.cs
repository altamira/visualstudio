using System;
using System.Windows;
using System.Windows.Controls;
using GestaoApp.Models.Contact;
using GestaoApp.Models.Sales;

namespace GestaoApp.View.Sales
{
    public partial class ClientFormView : ChildWindow
    {
        public EventHandler OnSave;

        public ClientFormView()
        {
            InitializeComponent();
            Loaded += new RoutedEventHandler(LoadCompleted);
        }

        public void LoadCompleted(object sender, RoutedEventArgs e)
        {
            this.VendorAutoCompleteComboBox.ItemsSource = Vendor.Collection;
            this.MediaAutoCompleteComboBox.ItemsSource = Media.Collection;
        }

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
                if (OnSave != null)
                    OnSave(this, new EventArgs());

                //this.DialogResult = true;
            //}
        }

        private void CancelButton_Click(object sender, RoutedEventArgs e)
        {
            this.DialogResult = false;
        }

        /*private void BindingValidationError(object sender, ValidationErrorEventArgs e)
        {
            if (e.Action == ValidationErrorEventAction.Added)
            {
                ValidationSummaryItem vsi = new ValidationSummaryItem() { Message = e.Error.ErrorContent.ToString(), Context = e.OriginalSource };
                vsi.Sources.Add(
                    new ValidationSummaryItemSource(String.Empty, e.OriginalSource as Control));
                this.ValidationSummary.Errors.Add(vsi);
            }
            else
            {
                ValidationSummaryItem valsumremove =
                    this.ValidationSummary.Errors.FirstOrDefault(v => v.Context == e.OriginalSource);
                if (valsumremove != null)
                {
                    this.ValidationSummary.Errors.Remove(valsumremove);
                }
            }
        }*/
    }
}

