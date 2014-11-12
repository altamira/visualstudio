using System;
using System.Windows;
using System.Windows.Controls;
using GestaoApp.Models.Contact;
using GestaoApp.Models.Location;
using System.Windows.Input;

namespace GestaoApp.View.Contact
{
    public partial class FoneFormView : ChildWindow
    {
        public EventHandler OnSave;

        public FoneFormView()
        {
            InitializeComponent();

            FoneTypeAutoCompleteComboBox.ItemsSource = FoneType.Collection;
            CountryAutoCompleteComboBox.ItemsSource = Country.Collection;
        }

        private void SaveButton_Click(object sender, RoutedEventArgs e)
        {
            //CountryTextBox.GetBindingExpression(TextBox.TextProperty).UpdateSource();
            //FoneTypeTextBox.GetBindingExpression(TextBox.TextProperty).UpdateSource();
            //AreaCodeTextBox.GetBindingExpression(TextBox.TextProperty).UpdateSource();
            //PrefixTextBox.GetBindingExpression(TextBox.TextProperty).UpdateSource();
            //NumberTextBox.GetBindingExpression(TextBox.TextProperty).UpdateSource();
            //AccessCodeTextBox.GetBindingExpression(TextBox.TextProperty).UpdateSource();

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

        private void FoneTypeAutoCompleteComboBox_SelectionChanged(object sender, SelectionChangedEventArgs e)
        {
            if ((sender as AutoCompleteBox).SelectedItem == null || (sender as AutoCompleteBox).Text.Length == 0)
                return;

            switch ((sender as AutoCompleteBox).Text.Substring(0,3))
            {
                case "Tel":
                    AreaCodeTextBlock.Visibility = Visibility.Visible;
                    AreaCodeTextBox.Visibility = Visibility.Visible;
                    NumberTextBlock.Text = "Número do " + (sender as AutoCompleteBox).Text;
                    AccessCodeTextBlock.Visibility = Visibility.Collapsed;
                    AccessCodeTextBox.Visibility = Visibility.Collapsed;
                    AccessCodeTextBox.Text = "";
                    break;
                case "Fax":
                    AreaCodeTextBlock.Visibility = Visibility.Visible;
                    AreaCodeTextBox.Visibility = Visibility.Visible;
                    NumberTextBlock.Text = "Número do " + (sender as AutoCompleteBox).Text;
                    SeparatorTextBlock.Text = "-";
                    AccessCodeTextBlock.Visibility = Visibility.Collapsed;
                    AccessCodeTextBox.Visibility = Visibility.Collapsed;
                    AccessCodeTextBox.Text = "";
                    break;
                case "Fon":
                    AreaCodeTextBlock.Visibility = Visibility.Visible;
                    AreaCodeTextBox.Visibility = Visibility.Visible;
                    NumberTextBlock.Text = "Número do " + (sender as AutoCompleteBox).Text;
                    SeparatorTextBlock.Text = "-";
                    AccessCodeTextBlock.Visibility = Visibility.Collapsed;
                    AccessCodeTextBox.Visibility = Visibility.Collapsed;
                    AccessCodeTextBox.Text = "";
                    break;
                case "Cel":
                    AreaCodeTextBlock.Visibility = Visibility.Visible;
                    AreaCodeTextBox.Visibility = Visibility.Visible;
                    NumberTextBlock.Text = "Número do " + (sender as AutoCompleteBox).Text;
                    SeparatorTextBlock.Text = "-";
                    AccessCodeTextBlock.Visibility = Visibility.Collapsed;
                    AccessCodeTextBox.Visibility = Visibility.Collapsed;
                    AccessCodeTextBox.Text = "";
                    break;
                case "PAB":
                    AreaCodeTextBlock.Visibility = Visibility.Visible;
                    AreaCodeTextBox.Visibility = Visibility.Visible;
                    NumberTextBlock.Text = "Número do " + (sender as AutoCompleteBox).Text;
                    SeparatorTextBlock.Text = "-";
                    AccessCodeTextBlock.Text = "Ramal";
                    AccessCodeTextBlock.Visibility = Visibility.Visible;
                    AccessCodeTextBox.Visibility = Visibility.Visible;
                    AccessCodeTextBox.Text = "";
                    break;
                case "DDR":
                    AreaCodeTextBlock.Visibility = Visibility.Visible;
                    AreaCodeTextBox.Visibility = Visibility.Visible;
                    NumberTextBlock.Text = "Tronco Chave - Ramal";
                    SeparatorTextBlock.Text = "-";
                    AccessCodeTextBlock.Visibility = Visibility.Collapsed;
                    AccessCodeTextBox.Visibility = Visibility.Collapsed;
                    AccessCodeTextBox.Text = "";
                    break;
                case "Nex":
                    AreaCodeTextBlock.Visibility = Visibility.Collapsed;
                    AreaCodeTextBox.Visibility = Visibility.Collapsed;
                    AreaCodeTextBox.Text = "11";
                    NumberTextBlock.Text = "FLEET * Nro Rádio";
                    SeparatorTextBlock.Text = "*";
                    AccessCodeTextBlock.Visibility = Visibility.Collapsed;
                    AccessCodeTextBox.Visibility = Visibility.Collapsed;
                    AccessCodeTextBox.Text = "";
                    break;
                case "Pag":
                    AreaCodeTextBlock.Visibility = Visibility.Visible;
                    AreaCodeTextBox.Visibility = Visibility.Visible;
                    NumberTextBlock.Text = "Número Operadora";
                    SeparatorTextBlock.Text = "-";
                    AccessCodeTextBlock.Text = "Código";
                    AccessCodeTextBlock.Visibility = Visibility.Visible;
                    AccessCodeTextBox.Visibility = Visibility.Visible;
                    AccessCodeTextBox.Text = "";
                    break;
                default:
                    break;
            }

            if (sender is AutoCompleteBox)
                if ((sender as AutoCompleteBox).SelectedItem != null)
                    if (((sender as AutoCompleteBox).SelectedItem as FoneType).Image != null)
                        this.FoneTypeImage.Source = ((sender as AutoCompleteBox).SelectedItem as FoneType).Image.Source;
        }

        private void CountryAutoCompleteComboBox_SelectionChanged(object sender, SelectionChangedEventArgs e)
        {
            /*if (sender is AutoCompleteBox)
                if ((sender as AutoCompleteBox).SelectedItem != null)
                    if (((sender as AutoCompleteBox).SelectedItem as Country).Flag != null)
                        this.CountryImage.Source = ((sender as AutoCompleteBox).SelectedItem as Country).Flag.Source;*/
        }

        private void AreaCodeTextBox_KeyUp(object sender, System.Windows.Input.KeyEventArgs e)
        {
            if (e.Key == Key.Tab)
                return;

            if (AreaCodeTextBox.Text.Length >= 2)
                PrefixTextBox.Focus();
        }

        private void PrefixTextBox_KeyUp(object sender, System.Windows.Input.KeyEventArgs e)
        {
            if (e.Key == Key.Tab)
                return;

            if (PrefixTextBox.Text.Length >= 4)
                NumberTextBox.Focus();
        }

        private void NumberTextBox_KeyUp(object sender, System.Windows.Input.KeyEventArgs e)
        {
            if (e.Key == Key.Tab)
                return;

            if (NumberTextBox.Text.Length >= 4)
                if (AccessCodeTextBlock.Visibility == Visibility.Visible)
                    AccessCodeTextBox.Focus();
                else
                    SaveButton.Focus();
        }

        private void CountryAutoCompleteComboBox_KeyDown(object sender, System.Windows.Input.KeyEventArgs e)
        {
            if (e.Key == Key.Tab)
                return;

            if (e.Key == Key.Enter)
                FoneTypeAutoCompleteComboBox.Focus();
        }

        private void FoneTypeAutoCompleteComboBox_KeyDown(object sender, KeyEventArgs e)
        {
            if (e.Key == Key.Tab)
                return;

            if (e.Key == Key.Enter)
                AreaCodeTextBox.Focus();
        }

        private void AccessCodeTextBox_KeyUp(object sender, KeyEventArgs e)
        {
            if (AccessCodeTextBox.Text.Length == AccessCodeTextBox.MaxLength)
                SaveButton.Focus();
        }

        private void TextBox_GotFocus(object sender, RoutedEventArgs e)
        {
            (sender as TextBox).SelectAll();
        }

    }
}

