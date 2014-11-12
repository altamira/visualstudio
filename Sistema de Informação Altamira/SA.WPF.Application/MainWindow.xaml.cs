using System;
using System.Collections.Generic;
using System.Globalization;
using System.Linq;
using System.Text;
using System.Threading;
using System.Windows;
using System.Windows.Controls;
using System.Windows.Data;
using System.Windows.Documents;
using System.Windows.Input;
using System.Windows.Media;
using System.Windows.Media.Imaging;
using System.Windows.Shapes;
using System.Windows.Controls.Ribbon;
using SA.WPF.Application.Financeiro;
using SA.WPF.CustomControlLibrary;

namespace SA.WPF.Application
{
    /// <summary>
    /// Interaction logic for MainWindow.xaml
    /// </summary>
    public partial class MainWindow : RibbonWindow
    {
        public MainWindow()
        {
            CultureInfo en = new CultureInfo("pt-BR");
            Thread.CurrentThread.CurrentCulture = en;

            InitializeComponent();

            this.AddHandler(CloseableTabItem.CloseTabEvent, new RoutedEventHandler(this.CloseTab));

            // Insert code required on object creation below this point.
        }

        private void CloseTab(object source, RoutedEventArgs args)
        {
            TabItem tabItem = args.Source as TabItem;

            if (tabItem != null)
            {
                TabControl tabControl = tabItem.Parent as TabControl;
                if (tabControl != null)
                    tabControl.Items.Remove(tabItem);
            }
        }

        private void AddTab(object sender, RoutedEventArgs e)
        {
        }

        private void RibbonButton_Click(object sender, MouseEventArgs e)
        {
            CloseableTabItem i = new CloseableTabItem();
            i.Header = ((RibbonButton)sender).Label;
            MainTab.Items.Add(i);
        }

        private void FluxoCaixaRibbonButton_Click(object sender, RoutedEventArgs e)
        {
            CloseableTabItem i = new CloseableTabItem();
            i.Header = ((RibbonButton)sender).Label;
            MainTab.Items.Add(i);

            FluxoCaixa c = new FluxoCaixa();
            i.Content = c.Content;
            i.Focus();

        }

        private void BOMRibbonButton_Click(object sender, RoutedEventArgs e)
        {
            CloseableTabItem i = new CloseableTabItem();
            i.Header = ((RibbonButton)sender).Label;
            MainTab.Items.Add(i);

            Materiais m = new Materiais();
            i.Content = m.Content;
            i.Focus();

        }

        private void CNABRibbonButton_Click(object sender, MouseEventArgs e)
        {
            CloseableTabItem i = new CloseableTabItem();
            i.Header = ((RibbonButton)sender).Label;
            MainTab.Items.Add(i);

            CNAB m = new CNAB();
            i.Content = m.Content;
            i.Focus();
        }

        private void ContasReceberRibbonButton_Click(object sender, MouseEventArgs e)
        {
            CloseableTabItem i = new CloseableTabItem();
            i.Header = ((RibbonButton)sender).Label;
            MainTab.Items.Add(i);

            Cobranca m = new Cobranca();
            i.Content = m.Content;
            i.Focus();
        }

        private void ContasPagarBoletoRibbonButton_Click(object sender, MouseEventArgs e)
        {
            CloseableTabItem i = new CloseableTabItem();
            i.Header = ((RibbonButton)sender).Label;
            MainTab.Items.Add(i);

            Cobranca m = new Cobranca();
            i.Content = m.Content;
            i.Focus();
        }

        private void CCO_Click(object sender, RoutedEventArgs e)
        {
            Conta_Contabil cco = new Conta_Contabil();

            cco.ShowDialog();
        }

        private void CCONT_Click(object sender, RoutedEventArgs e)
        {
            CloseableTabItem i = new CloseableTabItem();
            i.Header = ((RibbonButton)sender).Label;
            MainTab.Items.Add(i);

            Contabilidade.Plano_de_Contas m = new Contabilidade.Plano_de_Contas();
            i.Content = m.Content;
            i.Focus();
        }

        private void LançamentoTitulosRibbonButton_Click(object sender, RoutedEventArgs e)
        {
            CloseableTabItem i = new CloseableTabItem();
            i.Header = ((RibbonButton)sender).Label;
            MainTab.Items.Add(i);

            SA.WPF.Application.Financeiro.ContasPagar.MainWindow m = new SA.WPF.Application.Financeiro.ContasPagar.MainWindow();
            i.Content = m.Content;
            i.Focus();
        }
    }
}
