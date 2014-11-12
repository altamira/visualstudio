using System;
using System.Collections.Generic;
using System.ComponentModel.Composition;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Microsoft.Practices.Prism.MefExtensions.Modularity;
using Microsoft.Practices.Prism.Modularity;
using Microsoft.Practices.Prism.Regions;
using WPF.Views;

namespace WPF
{
    [ModuleExport(typeof(InvoiceModule))]
    public class InvoiceModule : IModule
    {
        IRegionManager regionManager;

        [ImportingConstructor]
        public InvoiceModule(IRegionManager regionManager)
        {
            this.regionManager = regionManager;
        }

        public void Initialize()
        {
            regionManager.RegisterViewWithRegion("ContentRegion", typeof(InvoiceView));
        }
    }
}
