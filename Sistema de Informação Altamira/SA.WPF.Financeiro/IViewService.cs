using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using GalaSoft.MvvmLight;

namespace SA.WPF.Financial
{
    public interface IViewService : IService
    {
        void RegisterView(Type windowType, Type viewModelType);

        void OpenWindow(ViewModelBase viewModel);
        bool? OpenDialog(ViewModelBase viewModel);
    }
}
