using System;
using System.ComponentModel;
using Microsoft.VisualStudio.TestTools.UnitTesting;

namespace ViewModel.Tests
{
    [TestClass]
    public class UnitTest1
    {
        [TestMethod]
        public void GetInvoices()
        {
            ViewModel.Services.ServiceAdapter adapter = new Services.ServiceAdapter();

            InvoiceViewModel vm = new InvoiceViewModel(adapter);

            vm.GetInvoices();

            vm.PropertyChanged += new System.ComponentModel.PropertyChangedEventHandler(InvoiceListChanged);
            
        }

        private void InvoiceListChanged(object sender, PropertyChangedEventArgs e)
        {
            Assert.IsNotNull(((InvoiceViewModel)sender).Invoices);
        }
        
    }
}
