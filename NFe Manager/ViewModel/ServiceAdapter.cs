using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace ViewModel.Services
{
    public interface IServiceAdapter
    {
        void GetInvoices(EventHandler<ServiceReference.GetInvoicesCompletedEventArgs> callback);
        void AcceptInvoice(EventHandler<ServiceReference.AcceptInvoiceCompletedEventArgs> callback, int Id);
        void RejectInvoice(EventHandler<ServiceReference.RejectInvoiceCompletedEventArgs> callback, int Id);
    }

    public class ServiceAdapter : IServiceAdapter
    {
        ServiceReference.ServiceClient proxy;

        public ServiceAdapter()
        {
            proxy = new ServiceReference.ServiceClient();
        }

        public void GetInvoices(EventHandler<ServiceReference.GetInvoicesCompletedEventArgs> callback)
        {
            proxy.GetInvoicesCompleted += callback;
            proxy.GetInvoicesAsync(null);
        }

        public void AcceptInvoice(EventHandler<ServiceReference.AcceptInvoiceCompletedEventArgs> callback, int Id)
        {
            proxy.AcceptInvoiceCompleted += callback;
            proxy.AcceptInvoiceAsync(Id);
        }


        public void RejectInvoice(EventHandler<ServiceReference.RejectInvoiceCompletedEventArgs> callback, int Id)
        {
            proxy.RejectInvoiceCompleted += callback;
            proxy.RejectInvoiceAsync(Id);
        }
    }
}
