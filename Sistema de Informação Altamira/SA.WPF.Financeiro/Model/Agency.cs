using System;
using System.Collections.Generic;
using System.Collections.ObjectModel;

namespace SA.WPF.Financial.Model
{
    public partial class Agency : Base
    {
        public Agency()
        {
            this.Accounts = new ObservableCollection<Account>();
        }

        public int Id { get; set; }
        public int BankId { get; set; }
        public string Number { get; set; }
        public string Manager { get; set; }
        public string AccountctPhone { get; set; }
        public virtual Bank Bank { get; set; }
        public virtual ObservableCollection<Account> Account { get; set; }

    }
}
