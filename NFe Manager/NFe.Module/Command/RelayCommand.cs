using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Linq;
using System.Text;
using System.Threading;
using System.Windows.Input;

namespace ViewModel.Command
{
    public class RelayCommand : ICommand, INotifyPropertyChanged
    {
        private readonly Action _handler;
        private bool _isEnabled;

        public RelayCommand(Action handler)
        {
            _handler = handler;
        }

        public bool IsEnabled
        {
            get { return _isEnabled; }
            set
            {
                if (value != _isEnabled)
                {
                    _isEnabled = value;
                    if (CanExecuteChanged != null)
                    {
                        CanExecuteChanged(this, EventArgs.Empty);
                    }
                    OnPropertyChanged("IsEnabled");
                }
            }
        }

        public bool CanExecute(object parameter)
        {
            return IsEnabled;
        }

        public event EventHandler CanExecuteChanged;

        public void Execute(object parameter)
        {
            _handler();
        }

        public event PropertyChangedEventHandler PropertyChanged;

        protected virtual void OnPropertyChanged(string propName)
        {
            if (PropertyChanged != null)
            {
                SynchronizationContext ctx = SynchronizationContext.Current;
                if (ctx == null)
                {
                    PropertyChanged(this, new PropertyChangedEventArgs(propName));
                }
                else
                {
                    ctx.Post(delegate { PropertyChanged(this, new PropertyChangedEventArgs(propName)); }, null);
                }

            }
        }
    }
}
