using System;
using System.Collections.Generic;
using System.Linq;
using ViewModel.ServiceReference;

namespace ViewModel.Services
{
    public class MockInvoiceServiceAgent : IInvoiceServiceAgent
    {
        // Create a fake customer
        public Invoice[] GetInvoices()
        {
            List<Invoice> l = new List<Invoice>() { new Invoice()
            {
                Number = 1,
                Date = DateTime.Now,
                Sender = "ALTAMIRA INDUSTRIA METALURGICA",
                Receipt = "TECNEQUIP TECNOLOGIA EM EQUIPAMENTOS",
                Key = "134124132549584395435343985734985734953"
            }};

            return l.ToArray();
        }
    }
}
