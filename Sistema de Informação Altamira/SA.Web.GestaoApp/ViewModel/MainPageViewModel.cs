using System;
using System.ComponentModel;
using System.Windows.Input;
using System.Windows;
using System.Collections.ObjectModel;
using System.IO.IsolatedStorage;
using System.IO;
using System.Xml.Linq;
using GestaoApp.Helpers;
using GestaoApp.Command;
using GestaoApp.View;
using GestaoApp.ViewModel;
using System.Linq;

namespace GestaoApp.ViewModel
{
    public class MainPageViewModel : ViewModelBase
    {
        public MainPageViewModel()
        {
            //LoginViewModel = new LoginViewModel();

            //LoginViewModel.LogonSuccessfull += new ViewModel.LoginViewModel.OnLogonSuccessfullEventHandler(OnSessionChanged);

            //LoginViewModel.PropertyChanged -= new PropertyChangedEventHandler(BusyPropertyChanged);
            //LoginViewModel.PropertyChanged += new PropertyChangedEventHandler(BusyPropertyChanged);

        }

        //private void BusyPropertyChanged(object sender, PropertyChangedEventArgs e)
        //{
        //    if (e.PropertyName == "IsBusy")
        //        IsBusy = (sender as ViewModelBase).IsBusy;
        //}

        //public void OnSessionChanged(object sender, ViewModel.LoginViewModel.OnLogonSuccessfullEventArgs e)
        //{
        //    IsBusy = true;
        //}

        //public void OnProcessListLoadCompleted(object sender, EventArgs e)
        //{
        //    IsBusy = false;
        //}

        #region Commands

        RelayCommand m_SubmitChangesCommand;
        RelayCommand m_FullScreenCommand;
        RelayCommand m_LogoutCommand;
        //RelayCommand m_HttpHelperCommand;
        //RelayCommand m_GraphCommand;

        bool CanSubmitChanges = true;
        bool CanFullScreen = true;
        bool CanLogout = true;
        //bool CanHttpHelper = true;
        //bool CanGraph = true;

        public ICommand SubmitChangesCommand
        {
            get
            {
                if (m_SubmitChangesCommand == null)
                {
                    m_SubmitChangesCommand = new RelayCommand(param => this.SubmitChanges(),
                        param => this.CanSubmitChanges);
                }
                return m_SubmitChangesCommand;
            }
        }
        public ICommand FullScreenCommand
        {
            get
            {
                if (m_FullScreenCommand == null)
                {
                    m_FullScreenCommand = new RelayCommand(param => this.FullScreen(),
                        param => this.CanFullScreen);
                }
                return m_FullScreenCommand;
            }
        }
        public ICommand LogoutCommand
        {
            get
            {
                if (m_LogoutCommand == null)
                {
                    m_LogoutCommand = new RelayCommand(param => this.Logout(),
                        param => this.CanLogout);
                }
                return m_LogoutCommand;
            }
        }
        //public ICommand HttpHelperCommand
        //{
        //    get
        //    {
        //        if (m_HttpHelperCommand == null)
        //        {
        //            m_HttpHelperCommand = new RelayCommand(param => this.HttpHelper(),
        //                param => this.CanHttpHelper);
        //        }
        //        return m_HttpHelperCommand;
        //    }
        //}
        //public ICommand GraphCommand
        //{
        //    get
        //    {
        //        if (m_GraphCommand == null)
        //        {
        //            m_GraphCommand = new RelayCommand(param => this.Graph(),
        //                param => this.CanGraph);
        //        }
        //        return m_GraphCommand;
        //    }
        //}
        #endregion

        public void SubmitChanges()
        {
            using (IsolatedStorageFile store = IsolatedStorageFile.GetUserStoreForApplication())
            {
                if (store.FileExists("Request.SubmitChanges.xml"))
                {
                    IsolatedStorageFileStream stream = store.OpenFile("Request.SubmitChanges.xml", FileMode.Open, FileAccess.Read);
                    StreamReader reader = new StreamReader(stream);
                    XDocument responseXml = XDocument.Load(reader);

                    //find if any entity with validation errors exists
                    if (responseXml.Descendants("entity").Any())
                    {
                        var v = responseXml.Descendants("entity").Where(f => f.Attribute("isvalid") != null);
                        if (v.Count() > 0)// if any entity with validation errors exists
                        {
                            MessageBox.Show("Some entity contains validation errors!");
                            return;
                        }
                        else
                        {
                            MessageBox.Show(responseXml.ToString());
                        }
                    }

                    reader.Dispose();
                    stream.Dispose();
                    store.DeleteFile("Request.SubmitChanges.xml");
                }
            };
        }

        public void FullScreen()
        {
            App.Current.Host.Content.IsFullScreen = App.Current.Host.Content.IsFullScreen ? false : true;
        }

        public void Logout()
        {
            //ViewModel.ViewModelBase.Session.Password = "";
            //LoginViewModel.Visible = Visibility.Visible;
            //LoginViewModel.LogonSuccessfull -= new ViewModel.LoginViewModel.OnLogonSuccessfullEventHandler(OnSessionChanged);
            //LoginViewModel.LogonSuccessfull += new ViewModel.LoginViewModel.OnLogonSuccessfullEventHandler(OnSessionChanged);
        }

        //public void HttpHelper()
        //{
        //    HttpRequestViewModel viewModel = new HttpRequestViewModel();
        //    HttpRequestForm view = new HttpRequestForm();
        //    view.DataContext = viewModel;

        //    viewModel.PropertyChanged -= new PropertyChangedEventHandler(BusyPropertyChanged);
        //    viewModel.PropertyChanged += new PropertyChangedEventHandler(BusyPropertyChanged);

        //    Workspace.Add(new PaneViewModel()
        //    {
        //        Header = "Http Request",
        //        Content = new PaneContentViewModel()
        //        {
        //            PaneContent = view
        //        }
        //    });

        //    DockingIsVisible = Visibility.Visible;
        //}

        //public void Graph()
        //{
        //    //HttpRequestViewModel viewModel = new HttpRequestViewModel();
        //    //PieGraph view = new PieGraph();
        //    Dashboard.Attendance view = new Dashboard.Attendance();
        //    //view.DataContext = viewModel;

        //    //viewModel.PropertyChanged -= new PropertyChangedEventHandler(BusyPropertyChanged);
        //    //viewModel.PropertyChanged += new PropertyChangedEventHandler(BusyPropertyChanged);

        //    Workspace.Add(new PaneViewModel()
        //    {
        //        Header = "Estatística de Atendimento",
        //        Content = new PaneContentViewModel()
        //        {
        //            PaneContent = view
        //        }
        //    });

        //    DockingIsVisible = Visibility.Visible;
        //}
    }
}
