using System.Windows.Controls;
using SA.Data.Models;
using System.Data.Entity;

namespace SA.WPF.Application.Financeiro.ConciliacaoBancaria
{
    /// <summary>
    /// Interaction logic for Lancamento.xaml
    /// </summary>
    public partial class Lancamento : UserControl
    {
        public Lancamento()
        {
            InitializeComponent();

            //using (SAContext ctx = new SAContext())
            //{
            //    var bancos = ctx.Banco;

            //    BancoComboBox.ItemsSource = bancos.Local;
            //}
        }

        private void UserControl_Loaded(object sender, System.Windows.RoutedEventArgs e)
        {
            //System.Windows.Data.CollectionViewSource bancoViewSource = ((System.Windows.Data.CollectionViewSource)(this.FindResource("bancoViewSource")));
            // Load data by setting the CollectionViewSource.Source property:
            //bancoViewSource.Source = bancoViewSource;
            // Do not load your data at design time.
            if (!System.ComponentModel.DesignerProperties.GetIsInDesignMode(this))
            {
                //Load your data here and assign the result to the CollectionViewSource.
                //System.Windows.Data.CollectionViewSource myCollectionViewSource = (System.Windows.Data.CollectionViewSource)this.Resources["bancoViewSource"];
                //using (SAContext ctx = new SAContext())
                //{

                //    myCollectionViewSource.Source = ctx.Banco.Local;
                //}
            }
            // Do not load your data at design time.
            // if (!System.ComponentModel.DesignerProperties.GetIsInDesignMode(this))
            // {
            // 	//Load your data here and assign the result to the CollectionViewSource.
            // 	System.Windows.Data.CollectionViewSource myCollectionViewSource = (System.Windows.Data.CollectionViewSource)this.Resources["Resource Key for CollectionViewSource"];
            // 	myCollectionViewSource.Source = your data
            // }
        }
    }
}
