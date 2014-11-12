using System;
using System.Collections.Generic;
using System.Collections.ObjectModel;
using System.ComponentModel;

namespace SA.WPF.Financial.Model
{
    public partial class Bank:Base
    {
        public Bank()
        {
            this.Agencies = new ObservableCollection<Agency>();
        }

        public int Id { get; set; }
        public int Number { get; set; }
        public string Name { get; set; }
        public virtual ObservableCollection<Agency> Agencies { get; set; }

    }
}
