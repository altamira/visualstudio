using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Linq;
using System.Windows;

namespace SA.WPF.Application
{
    /// <summary>
    /// Interaction logic for App.xaml
    /// </summary>
    public partial class App : System.Windows.Application
    {
        private void Application_Startup(object sender, StartupEventArgs e)
        {
            //SA.WPF.Application.Financeiro.ContasPagar.MainWindow w = new SA.WPF.Application.Financeiro.ContasPagar.MainWindow();
            SA.WPF.Application.Financeiro.ConciliacaoBancaria.MainWindow w = new SA.WPF.Application.Financeiro.ConciliacaoBancaria.MainWindow();
            w.Show();
        }
    }
}
