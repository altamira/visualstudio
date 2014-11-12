using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace Config
{
    public class Agency
    {
        private Bank bank;
        private int number;

        public Bank Bank
        {
            get
            {
                return bank;
            }
            set
            {
                bank.Code = value.Code;
                bank.Name = value.Name;
            }
        }

        public int Number
        {
            get
            {
                return number;
            }
            set
            {
                number = value;
            }
        }

        public Agency()
        {
            bank = new Bank();
            number = int.MinValue;
        }
    }
}
