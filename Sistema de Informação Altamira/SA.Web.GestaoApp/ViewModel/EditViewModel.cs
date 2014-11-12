using System;
using System.Collections.Generic;
using System.Threading;
using System.Windows.Input;
using GestaoApp.Command;
using GestaoApp.Helpers;
using System.Windows.Controls;

namespace GestaoApp.ViewModel
{
    public class EditViewModel<T> : ViewModelBase
    {
        #region Attributes

        private T selecteditem = default(T);

        private bool cansubmitchanges = true;
        private bool cancancel = true;

        private RelayCommand submitchangescommand;
        private RelayCommand cancelcommand;

        #endregion

        #region Properties

        public T SelectedItem
        {
            get
            {
                return selecteditem;
            }
            set
            {
                if ((object.ReferenceEquals(this.selecteditem, value) != true))
                {
                    selecteditem = value;
                    OnPropertyChanged("SelectedItem");
                }
            }
        }

        #endregion

        #region Constructor

        #endregion

        #region Events
        #endregion

        #region Commands

        public bool CanCancel
        {
            get
            {
                return cancancel;
            }
            set
            {
                if ((object.ReferenceEquals(this.cancancel, value) != true))
                {
                    cancancel = value;
                    OnPropertyChanged("CanCancel");
                }
            }
        }

        public bool CanSubmitChanges
        {
            get
            {
                return cansubmitchanges;
            }
            set
            {
                if ((object.ReferenceEquals(this.cansubmitchanges, value) != true))
                {
                    cansubmitchanges = value;
                    OnPropertyChanged("CanSubmitChanges");
                }
            }
        }

        public bool CanCancelCommand(object parameter)
        {
            return cancancel;
        }

        public bool CanSubmitChangesCommand(object parameter)
        {
            return cansubmitchanges;
        }

        public ICommand CancelCommand
        {
            get
            {
                if (cancelcommand == null)
                {
                    cancelcommand = new RelayCommand(Cancel, CanCancelCommand);
                }
                return cancelcommand;
            }
        }

        public ICommand SubmitChangesCommand
        {
            get
            {
                if (submitchangescommand == null)
                {
                    submitchangescommand = new RelayCommand(SubmitChanges, CanSubmitChangesCommand);
                }
                return submitchangescommand;
            }
        }

        public virtual void Cancel(object parameter)
        {
            ChildWindow container = null;

            if (parameter != null)
                container = (parameter as ChildWindow);

            if (container != null)
                container.DialogResult = false;
        }

        public virtual void SubmitChanges(object parameter)
        {
            ChildWindow container = null;

            if (parameter != null)
                container = (parameter as ChildWindow);

            if (container != null)
                container.DialogResult = false;
        }

        #endregion

    }
}
