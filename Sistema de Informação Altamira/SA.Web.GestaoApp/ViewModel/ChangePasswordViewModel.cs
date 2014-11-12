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
    public class ChangePasswordViewModel : ViewModelBase
    {
        #region Attributes
        private String newPassword = "";
        private String confirmPassword = "";
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

        public String NewPassword
        {
            get
            {
                return newPassword;
            }
            set
            {
                if ((object.ReferenceEquals(this.newPassword, value) != true))
                {
                    newPassword = value;
                    OnPropertyChanged("NewPassword");
                }
            }
        }

        public String ConfirmPassword
        {
            get
            {
                return confirmPassword;
            }
            set
            {
                if ((object.ReferenceEquals(this.confirmPassword, value) != true))
                {
                    confirmPassword = value;
                    OnPropertyChanged("ConfirmPassword");
                }
            }
        }
        #endregion

        #region Events
        public delegate void OnChangePasswordSuccessfullEventHandler(object sender, OnChangePasswordSuccessfullEventArgs e);

        //public event OnChangePasswordSuccessfullEventHandler LogonSuccessfull;

        public class OnChangePasswordSuccessfullEventArgs : EventArgs
        {
            public Session Session;
        }

        public virtual void OnChangePasswordSuccessfull(OnChangePasswordSuccessfullEventArgs e)
        {
            //if (ChangePasswordSuccessfull != null)
            //    ChangePasswordSuccessfull(this, e);
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

            Session.Autenticate(NewPassword, ConfirmPassword);
        }

        RelayCommand m_CancelCommand;

        bool CanCancel = true;

        public ICommand CancelCommand
        {
            get
            {
                if (m_CancelCommand == null)
                {
                    m_CancelCommand = new RelayCommand(param => this.Cancel(),
                        param => this.CanCancel);
                }
                return m_CancelCommand;
            }
        }

        public void Cancel()
        {
            Visible = Visibility.Collapsed;
        }

        private void AutenticateSuccessfull(GestaoApp.Helpers.Session.OnAutenticateSuccessfullEventArgs e)
        {
            //Visible = Visibility.Collapsed;
            OnChangePasswordSuccessfull(new OnChangePasswordSuccessfullEventArgs() { /*Session = session*/ });
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
