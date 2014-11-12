using System;
using System.Linq;
using ViewModel.ServiceReference;

namespace ViewModel.Services
{
    public interface IInvoiceServiceAgent
    {
        Invoice[] GetInvoices();
    }
}
