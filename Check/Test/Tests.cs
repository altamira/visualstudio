using System;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using CheckPrint;

namespace Test
{
    [TestClass]
    public class Tests
    {
        [TestMethod]
        public void PrintCheckTest()
        {
            PrintCheck print = new PrintCheck();
            print.check = new Config.Check();

            //print.check.Account.Agency.Bank.Code = 237;
            //print.check.Account.Agency.Bank.Name = "Bradesco";
            print.check.Account.Agency.Number = 125;
            print.check.Account.Number = 1234567;
            print.check.CheckNumber = 1234;
            print.check.Date = DateTime.Today;
            print.check.Holder.Name = "TESTE NOMINAL";
            print.check.Value = 31250.96M;
            
            print.Porta = "LPT4:";

            print.Print();
        }

        [TestMethod]
        public void PrintCopyTest()
        {
            PrintCheck print = new PrintCheck();
            print.check = new Config.Check();

            print.check.Account.Agency.Bank.Code = 237;
            print.check.Account.Agency.Bank.Name = "Bradesco";
            print.check.Account.Agency.Number = 125;
            print.check.Account.Number = 1234567;
            print.check.CheckNumber = 1234;
            print.check.Date = DateTime.Now;
            print.check.Holder.Name = "TESTE NOMINAL";
            print.check.Value = 123456789.00M;

            print.Porta = "LPT1:";

            print.PrintCopy();
        }
    }
}
