using System;
using System.Linq;
using System.Windows;
using System.Windows.Controls;
using GestaoApp.Models.Location;
using GestaoApp.ViewModel.Location;

namespace GestaoApp.View.Location
{
    public partial class AddressFormView : ChildWindow
    {
        public EventHandler OnSave;

        public AddressFormView()
        {
            InitializeComponent();
            Loaded += new RoutedEventHandler(LoadCompleted);
        }

        public void LoadCompleted(object sender, RoutedEventArgs e)
        {
            this.VendorAutoCompleteComboBox.ItemsSource = Models.Sales.Vendor.Collection;
            CityAutoCompleteComboBox.ItemsSource = City.Collection;
        }

        private void SaveButton_Click(object sender, RoutedEventArgs e)
        {
            //StreetTextBox.GetBindingExpression(TextBox.TextProperty).UpdateSource();
            //NumberTextBox.GetBindingExpression(TextBox.TextProperty).UpdateSource();
            //ComplementTextBox.GetBindingExpression(TextBox.TextProperty).UpdateSource();
            //DistrictTextBox.GetBindingExpression(TextBox.TextProperty).UpdateSource();
            //PostalCodeTextBox.GetBindingExpression(TextBox.TextProperty).UpdateSource();

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

        private void LayoutRoot_BindingValidationError(object sender, ValidationErrorEventArgs e)
        {
            /*if (e.Action == ValidationErrorEventAction.Added)
            {
                (e.OriginalSource as Control).Background = new SolidColorBrush(Colors.Yellow);
                ToolTipService.SetToolTip((e.OriginalSource as TextBox), e.Error.Exception.Message);
            }

            if (e.Action == ValidationErrorEventAction.Removed)
            {
                (e.OriginalSource as Control).Background = new SolidColorBrush(Colors.White);
                ToolTipService.SetToolTip((e.OriginalSource as TextBox), null);
            }*/
        }

        #region Beravior

        // Commits text box values when the user presses ENTER. This makes it 
        // easier to experiment with different values in the text boxes.
        private void TextBox_KeyDown(object sender,
            System.Windows.Input.KeyEventArgs e)
        {
            /*if (e.Key == System.Windows.Input.Key.Enter)
            {
                (sender as TextBox).GetBindingExpression(TextBox.TextProperty).UpdateSource();

                if (!((sender as Control).Parent is Panel))
                    return;

                int index = (sender as Control).IsTabStop ? (sender as Control).TabIndex : 0;

                var next = (from c in ((sender as Control).Parent as Grid).Children.OfType<Control>()
                            where c.IsEnabled && c.IsTabStop && c.TabIndex > index
                            select c).FirstOrDefault();

                if (next != null)
                    next.Focus();  
            }*/
        }

        #endregion

        private void TextBox_TextChanged(object sender, RoutedEventArgs e)
        {
            /*if (sender is TextBox)
                if ((sender as TextBox).Text.Length < (sender as TextBox).MaxLength || (sender as TextBox).MaxLength == 0)
                    return;

            if (sender is AutoCompleteBox)
                if ((sender as AutoCompleteBox).SelectedItem == null)
                    return;

            var element = e.OriginalSource as UIElement;

            if (!((sender as Control).Parent is Panel))
                return;

            int index = (sender as Control).IsTabStop ? (sender as Control).TabIndex : 0; 
 
            var next = (from c in ((sender as Control).Parent as Grid).Children.OfType<Control>()  
                        where c.IsEnabled && c.IsTabStop && c.TabIndex > index  
                        select c).FirstOrDefault();

            if (next != null)  
                next.Focus();  */

        }

        private void StreetAutoCompleteComboBox_SelectionChanged(object sender, SelectionChangedEventArgs e)
        {

        }

        private void StreetAutoCompleteComboBox_LostFocus(object sender, RoutedEventArgs e)
        {
            UpdateBinding(sender);
        }

        private void StreetAutoCompleteComboBox_DropDownClosed(object sender, RoutedPropertyChangedEventArgs<bool> e)
        {
            //UpdateBinding(sender);
        }

        private void UpdateBinding(object sender)
        {
            if (sender != null)
            {
                (this.DataContext as AddressViewModel).SelectedItem.Street = (sender as AutoCompleteBox).Text;
                if ((sender as AutoCompleteBox).SelectedItem != null)
                {
                    //(this.DataContext as Address).Street = ((sender as AutoCompleteBox).SelectedItem as Address).Street;
                    (this.DataContext as AddressViewModel).SelectedItem.District = ((sender as AutoCompleteBox).SelectedItem as Address).District;
                    (this.DataContext as AddressViewModel).SelectedItem.City = City.Collection.FirstOrDefault(c => c.Id == ((sender as AutoCompleteBox).SelectedItem as Address).City.Id);
                }
            }
        }

        private void StreetAutoCompleteComboBox_GotFocus(object sender, RoutedEventArgs e)
        {
            if (sender != null)
            {
                (sender as AutoCompleteBox).Text = (this.DataContext as AddressViewModel).SelectedItem.Street;
            }

        }
    }
}

