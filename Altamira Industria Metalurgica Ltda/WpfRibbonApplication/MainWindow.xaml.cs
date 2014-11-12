using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Windows;
using System.Windows.Controls;
using System.Windows.Data;
using System.Windows.Documents;
using System.Windows.Input;
using System.Windows.Media;
using System.Windows.Media.Imaging;
using System.Windows.Navigation;
using System.Windows.Shapes;
using Microsoft.Windows.Controls.Ribbon;
using System.Globalization;
using System.Threading;
using SA.WpfCustomControlLibrary;
using SA.WpfRibbonApplication.Financeiro;

namespace SA.WpfRibbonApplication
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

        private void PedidoVendaRibbonButton_Click(object sender, MouseEventArgs e)
        {

        }

        private void FluxoCaixaRibbonButton_Click(object sender, MouseEventArgs e)
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

        private void ContasPagarDARFRibbonButton_Click(object sender, MouseEventArgs e)
        {

        }
    }
}
