using System;
using System.Reflection;
using System.Windows;
using System.Windows.Browser;
using System.Windows.Controls;
using System.Windows.Media.Imaging;
using System.Windows.Navigation;
using Telerik.Windows.Controls;
using GestaoApp.ViewModel.Attendance;
using GestaoApp.View.Attendance;
using GestaoApp.Models.Attendance.Message;
using SilverlightMessageBoxLibrary;
using System.Windows.Printing;

namespace GestaoApp
{
    public partial class MainPage : UserControl
    {
        private PrintDocument printDoc;
        public UIElement printObject;

        public MainPage()
        {
            StyleManager.ApplicationTheme = new Office_BlueTheme();
            InitializeComponent();
            BitmapImage bmp = new BitmapImage(new Uri(@"/GestaoApp;component/Images/logo.png", UriKind.Relative));
            Loaded += new RoutedEventHandler(OnLoaded);

            printDoc = new PrintDocument();
            printDoc.PrintPage += new EventHandler<PrintPageEventArgs>(printDoc_PrintPage);
    
        }

        public void OnLoaded(object sender, RoutedEventArgs e)
        {
            try
            {
                Assembly assembly = Assembly.GetExecutingAssembly();
                String version = assembly.FullName.Split(',')[1];
                String fullversion = version.Split('=')[1];
                String title = String.Format("Sistema Gestão Altamira");
                string versiontitle = string.Format("versão {0}", fullversion);

                HtmlWindow top = HtmlPage.Window.GetProperty("top") as HtmlWindow;
                HtmlDocument doc = top.GetProperty("document") as HtmlDocument;
                if (doc != null)
                {
                    doc.SetProperty("title", title + " - " + versiontitle);
                    radRibbonBar.Title = title;
                    radRibbonBar.ApplicationName = versiontitle;
                }
            }
            catch (Exception ex)
            {
                MessageBox.Show(ex.Message);
            }

        }

        private void AttendanceRegisterLink_Click(object sender, RoutedEventArgs e)
        {
            if (GestaoApp.ViewModel.ViewModelBase.Session.Rules != "*" && 
                !GestaoApp.ViewModel.ViewModelBase.Session.Rules.Contains("Attendance Register"))
            {
                CustomMessage msg = new CustomMessage("Acesso negado !", CustomMessage.MessageType.Error);
                msg.Show();
                return;
            }

            foreach (RadPane p in radPaneGroup.Items)
            {
                if (p.Content != null)
                {
                    if (p.Content.GetType() == typeof(GestaoApp.View.Attendance.RegisterView))
                    {
                        p.IsSelected = true;
                        return;
                    }
                }
            }

            RadPane n = new RadPane();

            n.Header = "Registro de Atendimento";

            GestaoApp.ViewModel.Attendance.RegisterViewModel viewmodel = new GestaoApp.ViewModel.Attendance.RegisterViewModel("");
            GestaoApp.View.Attendance.RegisterView view = new GestaoApp.View.Attendance.RegisterView();
            view.DataContext = viewmodel;

            n.Content = view;

            this.radPaneGroup.AddItem(n, Telerik.Windows.Controls.Docking.DockPosition.Center);
            
        }

        private void AttendanceDashboardLink_Click(object sender, RoutedEventArgs e)
        {
            if (GestaoApp.ViewModel.ViewModelBase.Session.Rules != "*" && 
                !GestaoApp.ViewModel.ViewModelBase.Session.Rules.Contains("Attendance Dashboard"))
            {
                CustomMessage msg = new CustomMessage("Acesso negado !", CustomMessage.MessageType.Error);
                msg.Show();
                return;
            }

            foreach (RadPane p in radPaneGroup.Items)
            {
                if (p.Content != null)
                {
                    if (p.Content.GetType() == typeof(GestaoApp.View.Attendance.DashboardView))
                    {
                        p.IsSelected = true;
                        return;
                    }
                }
            }

            RadPane pane = new RadPane();

            pane.Header = "Estatísticas de Atendimento";

            GestaoApp.ViewModel.Attendance.DashboardViewModel viewmodel = new GestaoApp.ViewModel.Attendance.DashboardViewModel();
            GestaoApp.View.Attendance.DashboardView view = new GestaoApp.View.Attendance.DashboardView();
            view.DataContext = viewmodel;

            pane.Content = view;

            this.radPaneGroup.AddItem(pane, Telerik.Windows.Controls.Docking.DockPosition.Center);

        }
        private void ClientLink_Click(object sender, RoutedEventArgs e)
        {
            if (GestaoApp.ViewModel.ViewModelBase.Session.Rules != "*" && 
                !GestaoApp.ViewModel.ViewModelBase.Session.Rules.Contains("Client Register"))
            {
                CustomMessage msg = new CustomMessage("Acesso negado !", CustomMessage.MessageType.Error);
                msg.Show();
                return;
            }

            foreach (RadPane p in radPaneGroup.Items)
            {
                if (p.Content != null)
                {
                    if (p.Content.GetType() == typeof(GestaoApp.View.Sales.ClientView))
                    {
                        p.IsSelected = true;
                        return;
                    }
                }
            }

            RadPane n = new RadPane();

            n.Header = "Cadastro de Clientes";

            GestaoApp.ViewModel.Sales.ClientViewModel viewmodel = new GestaoApp.ViewModel.Sales.ClientViewModel();
            GestaoApp.View.Sales.ClientView view = new GestaoApp.View.Sales.ClientView();
            view.DataContext = viewmodel;

            n.Content = view;

            this.radPaneGroup.AddItem(n, Telerik.Windows.Controls.Docking.DockPosition.Center);
        }

        private void SalesVendorLink_Click(object sender, RoutedEventArgs e)
        {
            if (GestaoApp.ViewModel.ViewModelBase.Session.Rules != "*" && 
                !GestaoApp.ViewModel.ViewModelBase.Session.Rules.Contains("Vendor Register"))
            {
                CustomMessage msg = new CustomMessage("Acesso negado !", CustomMessage.MessageType.Error);
                msg.Show();
                return;
            }

            foreach (RadPane p in radPaneGroup.Items)
            {
                if (p.Content != null)
                {
                    if (p.Content.GetType() == typeof(GestaoApp.View.Sales.VendorView))
                    {
                        p.IsSelected = true;
                        return;
                    }
                }
            }

            RadPane n = new RadPane();

            n.Header = "Cadastro de Vendedores";

            GestaoApp.ViewModel.Sales.VendorViewModel viewmodel = new GestaoApp.ViewModel.Sales.VendorViewModel();
            GestaoApp.View.Sales.VendorView view = new GestaoApp.View.Sales.VendorView();
            view.DataContext = viewmodel;

            n.Content = view;

            this.radPaneGroup.AddItem(n, Telerik.Windows.Controls.Docking.DockPosition.Center);
        }

        private void FullScreenButton_Click(object sender, RoutedEventArgs e)
        {
            App.Current.Host.Content.IsFullScreen = App.Current.Host.Content.IsFullScreen ? false : true;
        }

        private void BidRegisterLink_Click(object sender, RoutedEventArgs e)
        {
            if (GestaoApp.ViewModel.ViewModelBase.Session.Rules != "*" && 
                !GestaoApp.ViewModel.ViewModelBase.Session.Rules.Contains("Bid Register"))
            {
                CustomMessage msg = new CustomMessage("Acesso negado !", CustomMessage.MessageType.Error);
                msg.Show();
                return;
            }

            foreach (RadPane p in radPaneGroup.Items)
            {
                if (p.Content != null)
                {
                    if (p.Content.GetType() == typeof(GestaoApp.View.Bid.RegisterView))
                    {
                        p.IsSelected = true;
                        return;
                    }
                }
            }

            RadPane n = new RadPane();

            n.Header = "Registro de Orçamento";

            GestaoApp.ViewModel.Bid.RegisterViewModel viewmodel = new GestaoApp.ViewModel.Bid.RegisterViewModel("");
            GestaoApp.View.Bid.RegisterView view = new GestaoApp.View.Bid.RegisterView();
            view.DataContext = viewmodel;

            n.Content = view;

            this.radPaneGroup.AddItem(n, Telerik.Windows.Controls.Docking.DockPosition.Center);
        }

        private void PackingListLink_Click(object sender, RoutedEventArgs e)
        {
            if (GestaoApp.ViewModel.ViewModelBase.Session.Rules != "*" && 
                !GestaoApp.ViewModel.ViewModelBase.Session.Rules.Contains("PackingList Register"))
            {
                CustomMessage msg = new CustomMessage("Acesso negado !", CustomMessage.MessageType.Error);
                msg.Show();
                return;
            }

            foreach (RadPane p in radPaneGroup.Items)
            {
                if (p.Content != null)
                {
                    if (p.Content.GetType() == typeof(GestaoApp.View.Shipping.PackingListView))
                    {
                        p.IsSelected = true;
                        return;
                    }
                }
            }

            RadPane n = new RadPane();

            n.Header = "Registro de Romaneio";

            GestaoApp.ViewModel.Shipping.PackingListViewModel viewmodel = new GestaoApp.ViewModel.Shipping.PackingListViewModel();
            GestaoApp.View.Shipping.PackingListView view = new GestaoApp.View.Shipping.PackingListView();
            view.DataContext = viewmodel;

            n.Content = view;

            this.radPaneGroup.AddItem(n, Telerik.Windows.Controls.Docking.DockPosition.Center);
        }

        private void AttendanceMessageLink_Click(object sender, RoutedEventArgs e)
        {
            if (GestaoApp.ViewModel.ViewModelBase.Session.Rules != "*" && 
                !GestaoApp.ViewModel.ViewModelBase.Session.Rules.Contains("Attendance Message"))
            {
                CustomMessage msg = new CustomMessage("Acesso negado !", CustomMessage.MessageType.Error);
                msg.Show();
                return;
            }

            MessageViewModel viewmodel = new MessageViewModel();
            viewmodel.SelectedItem = new SMS();
            MessageFormView childWindowMessage = new MessageFormView();
            childWindowMessage.OnEditComplete = new EventHandler(viewmodel.OnEditComplete);
            childWindowMessage.DataContext = viewmodel;
            childWindowMessage.Show();
        }

        private void SalesDashboardLink_Click(object sender, RoutedEventArgs e)
        {
            if (GestaoApp.ViewModel.ViewModelBase.Session.Rules != "*" && 
                !GestaoApp.ViewModel.ViewModelBase.Session.Rules.Contains("Sales Dashboard"))
            {
                CustomMessage msg = new CustomMessage("Acesso negado !", CustomMessage.MessageType.Error);
                msg.Show();
                return;
            }

            foreach (RadPane p in radPaneGroup.Items)
            {
                if (p.Content != null)
                {
                    if (p.Content.GetType() == typeof(GestaoApp.View.Sales.DashboardView))
                    {
                        p.IsSelected = true;
                        return;
                    }
                }
            }

            RadPane pane = new RadPane();

            pane.Header = "Estatísticas de Vendas";

            GestaoApp.ViewModel.Sales.DashboardViewModel viewmodel = new GestaoApp.ViewModel.Sales.DashboardViewModel();
            GestaoApp.View.Sales.DashboardView view = new GestaoApp.View.Sales.DashboardView();
            view.DataContext = viewmodel;

            pane.Content = view;

            this.radPaneGroup.AddItem(pane, Telerik.Windows.Controls.Docking.DockPosition.Center);
        }

        private void PrintButton_Click(object sender, RoutedEventArgs e)
        {
            printDoc.Print("Relatório");
        }

        void printDoc_PrintPage(object sender, PrintPageEventArgs e)
        {
            if (printObject != null)
                e.PageVisual = printObject;
        }

        private void OrderLink_Click(object sender, RoutedEventArgs e)
        {
            if (GestaoApp.ViewModel.ViewModelBase.Session.Rules != "*" &&
                !GestaoApp.ViewModel.ViewModelBase.Session.Rules.Contains("Bid Register"))
            {
                CustomMessage msg = new CustomMessage("Acesso negado !", CustomMessage.MessageType.Error);
                msg.Show();
                return;
            }

            foreach (RadPane p in radPaneGroup.Items)
            {
                if (p.Content != null)
                {
                    if (p.Content.GetType() == typeof(GestaoApp.View.Sales.OrderView))
                    {
                        p.IsSelected = true;
                        return;
                    }
                }
            }

            RadPane n = new RadPane();

            n.Header = "Consulta de Pedido";

            GestaoApp.ViewModel.Sales.OrderViewModel viewmodel = new GestaoApp.ViewModel.Sales.OrderViewModel("");
            GestaoApp.View.Sales.OrderView view = new GestaoApp.View.Sales.OrderView();
            view.DataContext = viewmodel;

            n.Content = view;

            this.radPaneGroup.AddItem(n, Telerik.Windows.Controls.Docking.DockPosition.Center);

        }    
    }
}