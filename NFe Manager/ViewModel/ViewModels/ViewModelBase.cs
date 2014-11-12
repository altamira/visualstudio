using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Linq;
using System.Text;
using System.Threading;

namespace ViewModel.ViewModels
{
    public abstract class ViewModelBase : INotifyPropertyChanged
    {
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
