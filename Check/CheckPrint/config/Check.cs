using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using PrinterClass;

namespace Config
{
    public class Check
    {
        private Account account;
        private DateTime date;
        private Holder holder;
        private string city;
        private int checkNumber;
        private string valueToString;
        private decimal dValue;

        public Account Account
        {
            get
            {
                return account;
            }
            set
            {
                account.Number = value.Number;
            }
        }

        public DateTime Date
        {
            get
            {
                return date;
            }
            set
            {
                date = value;
            }
        }

        public Holder Holder
        {
            get
            {
                return holder;
            }
            set
            {
                holder = new Holder();
                holder.Name = value.Name;
            }
        }

        public string City
        {
            get { return city; }
            set { city = value; }
        }

        public int CheckNumber
        {
            get { return checkNumber; }
            set { checkNumber = value; }
        }

        public decimal Value
        {
            get
            {
                return dValue;
            }
            set
            {
                dValue = value;
            }
        }

        public string ValueToString
        {
            get
            {
                Extenso vExtenso = new Extenso();

                valueToString = vExtenso.toExtenso(dValue);
                
                return valueToString;
            }
        }

        public Check()
        {
            account = new Account();
            holder = new Holder();

            checkNumber = int.MinValue;
            Value = decimal.MinValue;
            city = "São Paulo";
        }
    }
}
