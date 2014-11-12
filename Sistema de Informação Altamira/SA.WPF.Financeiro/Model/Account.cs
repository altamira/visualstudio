using System;
using System.Collections.Generic;
using System.Collections.ObjectModel;
using System.ComponentModel;
using System.ComponentModel.DataAnnotations.Schema;

namespace SA.WPF.Financial.Model
{
    public partial class Account: Base
    {
        #region Variables

        private int id;
        private decimal balance;
        private decimal balancechecked;

        #endregion

        #region Properties

        public int Id
        {
            get
            {
                return id;
            }
            set
            {
                id = value;
                OnPropertyChanged(new PropertyChangedEventArgs("Id"));
            }
        }

        public int AgencyId { get; set; }
        public string Number { get; set; }
        public decimal Balance
        {
            get
            {
                return balance;
            }
            set
            {
                balance = value;
                OnPropertyChanged(new PropertyChangedEventArgs("Balance"));
                BalanceCheck = balance;
            }
        }

        [NotMappedAttribute]
        public decimal BalanceCheck
        {
            get
            {
                return balancecheck;
            }
            set
            {
                balancecheck = value;
                OnPropertyChanged(new PropertyChangedEventArgs("BalanceCheck"));
            }
        }

        public virtual Agency Agency { get; set; }
        public virtual ObservableCollection<Transaction> Transactions { get; set; }

        #endregion

        #region Constructors

        public Account()
        {
            this.Transactions = new ObservableCollection<Transaction>();
        }

        #endregion

        #region Methods

        public override string ToString()
        {
            return Number;
        }
        #endregion

    }
}
