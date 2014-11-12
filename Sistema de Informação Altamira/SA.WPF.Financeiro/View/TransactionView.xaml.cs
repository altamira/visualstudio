using System.Windows.Controls.Ribbon;

namespace SA.WPF.Financial.View
{
	/// <summary>
	/// Interaction logic for Lancamento.xaml
	/// </summary>
	public partial class TransactionView : RibbonWindow
	{
       //SAContext context = new SAContext();
       //SA.Data.Models.Transaction Transaction = new SA.Data.Models.Transaction();
       //private int inclusao = 1;

        public TransactionView()
        {
            this.InitializeComponent();
        }

       // public Lancamento(SAContext context, Transaction mv)
       // {
       //     this.InitializeComponent();
       //     this.context = context;
       //     this.Transaction = mv;

       //     if (mv.Account > 0)
       //     {
       //         this.DataContext = context.Transactions.Find(mv.Id);
       //         inclusao = 0;
       //     }
       //     else
       //     {
       //         this.DataContext = mv;
       //     }
       // }

        //private void Window_Loaded(object sender, RoutedEventArgs e)
        //{

        //    System.Windows.Data.CollectionViewSource BankViewSource = ((System.Windows.Data.CollectionViewSource)(this.FindResource("BankViewSource")));
            
        //    context.Bank.Include("Agencies.Accounts").Load();
        //    BankViewSource.Source = context.Bank.Local;

        //    ComboBoxItem item =
        //        (ComboBoxItem)BankComboBox.ItemAccountinerGenerator.AccountinerFromItem(Transaction.Account1.Agency1.Bank1);

        //    BankComboBox.SelectedValuePath = Transaction.Account1.Agency1.Bank1.Name;
        //    BankComboBox.Text = Transaction.Account1.Agency1.Bank1.Name;

        //    if (Transaction.Account1 !=null)
        //    {
        //        dataDatePicker.Focus();    
        //    }
        //    else
        //    {
        //        BankComboBox.Focus();
        //    }
            
        //}

        //private void GravarButton_Click(object sender, RoutedEventArgs e)
        //{
        //    Gravar();
        //}

        //private void Gravar()
        //{
        //    try
        //    {
        //        if(!ValidaCampos())
        //        {
        //            return;
        //        }

        //        if (inclusao == 0)
        //        {
        //            context.Transactions.Attach(Transaction);
        //            context.Entry(Transaction).State = System.Data.EntityState.Modified;
        //            context.SaveChanges();
        //            MessageBox.Show("Transaction atualizado com sucesso!", "Sucesso", MessageBoxButton.OK, MessageBoxImage.Information);
        //            this.Close();
        //        }
        //        else
        //        {
        //            context.Transactions.Add(Transaction);
        //            context.SaveChanges();
        //            MessageBox.Show("Transaction inserido com sucesso!", "Sucesso", MessageBoxButton.OK, MessageBoxImage.Information);
        //            LimpaCampos();
        //            dataDatePicker.Focus();
        //        }
        //    }
        //    catch (Exception ex)
        //    {
        //        MessageBox.Show("Erro ao incluir Transaction ou atualizar: " + ex.Message, "Mensagem de Erro",
        //            MessageBoxButton.OK,MessageBoxImage.Error);
        //    }
        //}

        //private bool ValidaCampos()
        //{
        //    if (AgencyComboBox.SelectedItem == null)
        //    {
        //        MessageBox.Show("Campo Agência é de preenchimento obrigatório", "Informação",
        //            MessageBoxButton.OK, MessageBoxImage.Exclamation);
        //        AgencyComboBox.Focus();
        //        return false;
        //    }
        //    else if (AccountComboBox.SelectedItem == null)
        //    {
        //        MessageBox.Show("Campo Account Corrente é de preenchimento obrigatório", "Informação",
        //            MessageBoxButton.OK, MessageBoxImage.Exclamation);
        //        AccountComboBox.Focus();
        //        return false;
        //    }
        //    else if (string.IsNullOrEmpty(Transaction.Descricao))
        //    {
        //        MessageBox.Show("O preenchimento do campo Descrição é obrigatório!", "Informação",
        //            MessageBoxButton.OK, MessageBoxImage.Exclamation);
        //        descricaoTextBox.Focus();
        //        return false;  
        //    }
        //    else if (Transaction.Valor <= 0)
        //    {
        //        MessageBox.Show("O valor do Transaction deve ser maior que zero", "Informação", 
        //            MessageBoxButton.OK, MessageBoxImage.Exclamation);
        //        valorTextBlock.Focus();
        //        return false;
        //    }
        //    else
        //    {
        //        return true;
        //    }
        //}

        //private void LimpaCampos()
        //{
        //    dataDatePicker.DisplayDate = DateTime.Now;
        //    chequeTextBox.Text = "";
        //    descricaoTextBox.Text = "";
        //    valorTextBlock.Text = "0";
        //}

        //private void FecharButton_Click(object sender, RoutedEventArgs e)
        //{
        //    this.Close();
        //}

        //private void grid1_PreviewKeyDown(object sender, KeyEventArgs e)
        //{
        //    var uie = e.OriginalSource as UIElement;

        //    if (e.Key == Key.Enter)
        //    {
        //        e.Handled = true;
        //        uie.MoveFocus(new TraversalRequest(FocusNavigationDirection.Next));

        //    }
        //}

        //private void AccountComboBox_SelectionChanged(object sender, SelectionChangedEventArgs e)
        //{
        //    dataDatePicker.Focus();
        //    groupTransaction.IsEnabled = true;
        //    btnGravar.IsEnabled = true;
        //    btnGravar.ToolTip = "";
        //}

        //private void BankComboBox_SelectionChanged(object sender, SelectionChangedEventArgs e)
        //{
        //    if (AccountComboBox.SelectedItem == null)
        //    {
        //        groupTransaction.IsEnabled = false;
        //        btnGravar.IsEnabled = false;
        //        btnGravar.ToolTip = "Para habilitar o botão é necessário a seleção de Bank,Agência e Account Corrente";
        //    }

        //}

        //private void valorTextBlock_LostKeyboardFocus(object sender, KeyboardFocusChangedEventArgs e)
        //{
        //    Gravar();
        //}

        private void grid1_PreviewKeyDown(object sender, System.Windows.Input.KeyEventArgs e)
        {

        }
    }
}