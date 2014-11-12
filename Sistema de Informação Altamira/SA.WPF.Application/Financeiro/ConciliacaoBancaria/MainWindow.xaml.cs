using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows;
using System.Windows.Controls;
using System.Windows.Controls.Ribbon;
using System.Windows.Data;
using System.Windows.Documents;
using System.Windows.Input;
using System.Windows.Media;
using System.Windows.Media.Imaging;
using System.Windows.Shapes;
using SA.WPF.CustomControlLibrary;

namespace SA.WPF.Application.Financeiro.ConciliacaoBancaria
{
    /// <summary>
    /// Interaction logic for MainWindow.xaml
    /// </summary>
    public partial class MainWindow : RibbonWindow
    {
        public MainWindow()
        {
            InitializeComponent();
        }

        private void LancamentoContaCorrente_Click(object sender, RoutedEventArgs e)
        {
            //CloseableTabItem i = new CloseableTabItem();
            //i.Header = ((RibbonButton)sender).Label;
            //MainTab.Items.Add(i);

            //SA.WPF.Application.Financeiro.ConciliacaoBancaria.Lancamento w = new SA.WPF.Application.Financeiro.ConciliacaoBancaria.Lancamento();
            //i.Content = w.Content;
            //i.Focus();
        }

        private void ConciliacaoContaCorrente_Click(object sender, RoutedEventArgs e)
        {
            Conciliacao c = new Conciliacao();
            c.ShowDialog();
        }

        private void RibbonWindow_Loaded(object sender, RoutedEventArgs e)
        {

            //System.Windows.Data.CollectionViewSource bancoViewSource = ((System.Windows.Data.CollectionViewSource)(this.FindResource("BancoViewSource")));
            // Load data by setting the CollectionViewSource.Source property:
            // bancoViewSource.Source = [generic data source]
        }
    }
}
