using System;
using System.Linq;
using System.Threading;
using System.Windows;
using System.Windows.Input;
using System.Xml.Linq;
using GestaoApp.Helpers;
using GestaoApp.Command;
using SilverlightMessageBoxLibrary;

namespace GestaoApp.ViewModel
{
    public class LoginViewModel : ViewModelBase
    {
        #region Attributes
        private String userName = "";
        private String password = "";        
        #endregion

        #region Properties
        Visibility visible = Visibility.Visible;
        public Visibility Visible 
        {
            get 
            { 
                return visible; 
            } 
            set 
            {
                if ((object.ReferenceEquals(this.visible, value) != true))
                {
                    visible = value;
                    OnPropertyChanged("Visible");
                }
            } 
        }

        public String UserName
        {
            get
            {
                return userName;
            }
            set
            {
                if ((object.ReferenceEquals(this.userName, value) != true))
                {
                    userName = value;
                    OnPropertyChanged("UserName");
                }
            }
        }

        public String Password
        {
            get
            {
                return password;
            }
            set
            {
                if ((object.ReferenceEquals(this.password, value) != true))
                {
                    password = value;
                    OnPropertyChanged("Password");
                }
            }
        }
        #endregion

        #region Events
        public delegate void OnLogonSuccessfullEventHandler(object sender, OnLogonSuccessfullEventArgs e);

        public event OnLogonSuccessfullEventHandler LogonSuccessfull;

        public class OnLogonSuccessfullEventArgs : EventArgs
        {
            public Session Session;
        }

        public virtual void OnLogonSuccessfull(OnLogonSuccessfullEventArgs e)
        {
            if (LogonSuccessfull != null)
                LogonSuccessfull(this, e);
        }
        #endregion

        #region Commands
        RelayCommand m_AcceptEnterCommand;

        bool canacceptenter = true;

        public bool CanAcceptEnterCommand(object parameter)
        {
            return canacceptenter;
        }

        public ICommand AcceptEnterCommand
        {
            get
            {
                if (m_AcceptEnterCommand == null)
                {
                    m_AcceptEnterCommand = new RelayCommand(AcceptEnter, CanAcceptEnterCommand);
                }
                return m_AcceptEnterCommand;
            }
        }

        private void AcceptEnter(object parameter)
        {
            if (parameter != null)
            {
            }
        }

        RelayCommand m_SubmitCommand;

        bool CanSubmit = true;

        public ICommand SubmitCommand
        {
            get
            {
                if (m_SubmitCommand == null)
                {
                    m_SubmitCommand = new RelayCommand(param => this.Submit(),
                        param => this.CanSubmit);
                }
                return m_SubmitCommand;
            }
        }

        public void Submit()
        {
            Visible = Visibility.Collapsed;
            Session.AutenticateSuccessfull -= new GestaoApp.Helpers.Session.OnAutenticateSuccessfullEventHandler(AutenticateSuccessfull);
            Session.AutenticateError -= new GestaoApp.Helpers.Session.OnAutenticateErrorEventHandler(AutenticateError);

            Session.AutenticateSuccessfull += new GestaoApp.Helpers.Session.OnAutenticateSuccessfullEventHandler(AutenticateSuccessfull);
            Session.AutenticateError += new GestaoApp.Helpers.Session.OnAutenticateErrorEventHandler(AutenticateError);

            Session.Autenticate(UserName, Password);
        }

        private void AutenticateSuccessfull(GestaoApp.Helpers.Session.OnAutenticateSuccessfullEventArgs e)
        {
            //Visible = Visibility.Collapsed;
            OnLogonSuccessfull(new OnLogonSuccessfullEventArgs() { /*Session = session*/ });
            if (e.Session.User != null)
            {
                if (e.Session.User.BlankPassword)
                {
                    CustomMessage msg = new CustomMessage("Sua senha esta em branco. Clique OK para cadastrar uma senha e acessar o sistema !", CustomMessage.MessageType.Info);
                    msg.Show();

                    //MessageBox.Show("Sua senha esta em branco. Cadastre uma senha para acessar o sistema !", "Controle de Acesso", MessageBoxButton.OK);
                    ((AddPasswordViewModel)((MainPage)App.Current.RootVisual).AddPasswordView.LayoutRoot.DataContext).Visible = Visibility.Visible;
                }
            }
            else if (e.Session.Vendor != null)
            {
                if (e.Session.Vendor.BlankPassword)
                {
                    CustomMessage msg = new CustomMessage("Sua senha esta em branco. Clique OK para cadastrar uma senha e acessar o sistema !", CustomMessage.MessageType.Info);
                    msg.Show();

                    //MessageBox.Show("Sua senha esta em branco. Cadastre uma senha para acessar o sistema !", "Controle de Acesso", MessageBoxButton.OK);
                    ((AddPasswordViewModel)((MainPage)App.Current.RootVisual).AddPasswordView.LayoutRoot.DataContext).Visible = Visibility.Visible;
                }
            }
        }

        private void AutenticateError(GestaoApp.Helpers.Session.OnAutenticateErrorEventArgs e)
        {
            CustomMessage msg = new CustomMessage(e.Error.Message, CustomMessage.MessageType.Error);
            msg.Show();

            Visible = Visibility.Visible;
        }
        #endregion
    }
}
