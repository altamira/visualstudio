using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace Config
{
    public class Account
    {
        private Agency agency;
        private int number;

        public Agency Agency
        {
            get
            {
                return agency;
            }
            set
            {
                agency.Bank = value.Bank;
                agency.Number = value.Number;
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

        public Account()
        {
            agency = new Agency();
            number = int.MinValue;
        }
    }
}
