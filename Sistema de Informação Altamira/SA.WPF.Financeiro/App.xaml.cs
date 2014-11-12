using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Globalization;
using System.Linq;
using System.Threading.Tasks;
using System.Windows;
using System.Windows.Controls;
using SA.WPF.Financial.View;
using SA.WPF.Financial.ViewModel;

namespace SA.WPF.Financial
{
    /// <summary>
    /// Interaction logic for App.xaml
    /// </summary>
    public partial class App : Application
    {
        protected override void OnStartup(StartupEventArgs e)
        {
            System.Threading.Thread.CurrentThread.CurrentUICulture =
                new CultureInfo("pt-BR");

            MainWindowView v = new MainWindowView();
            //TransactionViewModel m = new TransactionViewModel();
            //v.DataContext = m;

            v.Show();

            //IViewService viewService = ServiceManager.RegisterService<IViewService>(new ViewService());
            //viewService.RegisterView(typeof(MainWindowView), typeof(TransactionViewModel));
            //viewService.RegisterView(typeof(LancamentoView), typeof(TransactionViewModel));
                
            //focus com seleção total do texto
            EventManager.RegisterClassHandler(typeof(TextBox)
                ,TextBox.GotFocusEvent, new RoutedEventHandler(TextBox_GotFocus));
        }

        private void TextBox_GotFocus(object sender, RoutedEventArgs e)
        {
            (sender as TextBox).SelectAll();
        }
    }
}
