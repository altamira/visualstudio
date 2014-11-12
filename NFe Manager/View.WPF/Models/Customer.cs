using System;
using System.Linq;
using System.Collections.Generic;

using SimpleMvvmToolkit;

namespace View.WPF
{
    public class Customer : ModelBase<Customer>
    {
        private int _customerId;
        public int CustomerId
        {
            get { return _customerId; }
            set
            {
                _customerId = value;
                NotifyPropertyChanged(m => m.CustomerId);
            }
        }

        private string _customerName;
        public string CustomerName
        {
            get { return _customerName; }
            set
            {
                _customerName = value;
                NotifyPropertyChanged(m => m.CustomerName);
            }
        }

        private string _city;
        public string City
        {
            get { return _city; }
            set
            {
                _city = value;
                NotifyPropertyChanged(m => m.City);
            }
        }
    }
}
