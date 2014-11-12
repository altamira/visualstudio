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
    public class AddPasswordViewModel : ViewModelBase
    {
        #region Attributes
        private String newPassword = "";
        private String confirmPassword = "";
        #endregion

        #region Properties
        Visibility visible = Visibility.Collapsed;
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

        //public event OnChangePasswordSuccessfullEventHandler ChangePasswordSuccessfull;

        public class OnChangePasswordSuccessfullEventArgs : EventArgs
        {
            public Session Session;
        }

        //public virtual void OnChangePasswordSuccessfull(OnChangePasswordSuccessfullEventArgs e)
        //{
        //    if (ChangePasswordSuccessfull != null)
        //        ChangePasswordSuccessfull(this, e);
        //}
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
            if (NewPassword.Trim() != ConfirmPassword.Trim())
            {
                CustomMessage msg = new CustomMessage("A senha e a confirmação da senha são diferentes. Digite novamente a senha e a confirmação da senha !", CustomMessage.MessageType.Error);
                msg.Show();
            }
            else if (NewPassword.Trim().Length < 3 || ConfirmPassword.Trim().Length < 3)
            {
                CustomMessage msg = new CustomMessage("O tamanho mínimo da senha é de 3 caracteres. Podem ser letras ou números !", CustomMessage.MessageType.Error);
                msg.Show();
            }
            else
            {
                Visible = Visibility.Collapsed;
                Session.ChangePasswordSuccessfull -= new GestaoApp.Helpers.Session.OnChangePasswordSuccessfullEventHandler(ChangePasswordSuccessfull);
                Session.ChangePasswordError -= new GestaoApp.Helpers.Session.OnChangePasswordErrorEventHandler(ChangePasswordError);

                Session.ChangePasswordSuccessfull += new GestaoApp.Helpers.Session.OnChangePasswordSuccessfullEventHandler(ChangePasswordSuccessfull);
                Session.ChangePasswordError += new GestaoApp.Helpers.Session.OnChangePasswordErrorEventHandler(ChangePasswordError);

                Session.ChangePassword(NewPassword.Trim());
            }
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
            ((LoginViewModel)((MainPage)App.Current.RootVisual).LoginView.LayoutRoot.DataContext).Visible = Visibility.Visible;
        }

        private void ChangePasswordSuccessfull(GestaoApp.Helpers.Session.OnChangePasswordSuccessfullEventArgs e)
        {
            CustomMessage msg = new CustomMessage("A senha foi alterada com sucesso !", CustomMessage.MessageType.Info);
            msg.Show();

            Visible = Visibility.Collapsed;
            //OnChangePasswordSuccessfull(new OnChangePasswordSuccessfullEventArgs() { /*Session = session*/ });
        }

        private void ChangePasswordError(GestaoApp.Helpers.Session.OnChangePasswordErrorEventArgs e)
        {
            CustomMessage msg = new CustomMessage(e.Error.Message, CustomMessage.MessageType.Error);
            msg.Show();

            Visible = Visibility.Visible;
        }
        #endregion
    }
}
