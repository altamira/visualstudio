using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Config;
using PrinterClass;

namespace CheckPrint
{
    public class PrintCheck
    {
        ImprimeTexto printTexto = new ImprimeTexto();
        
        public Check check { get; set; }
        public string Porta { get;  set; }
       
        public void Print()
        {
            printTexto.Inicio(Porta);

            //primeira linha do cheque
            printTexto.ImpCol(9, check.Account.Agency.Number.ToString("{0:0000}"));
            printTexto.ImpCol(22, check.Account.Number.ToString("{0:00000}"));
            printTexto.ImpCol(42, check.CheckNumber.ToString("{0:000000}"));
            printTexto.ImpCol(60, check.Value.ToString());
            printTexto.ImpColLF(79, "");
            printTexto.ImpLF("");


            printTexto.ImpColLF(10, check.ValueToString);
            printTexto.ImpLF("Segunda Linha digitavel");
            printTexto.ImpColLF(2, "Nominal");

            printTexto.ImpCol(40, "São Paulo");
            printTexto.ImpCol(55, "00");
            printTexto.ImpCol(59, "MÊS");
            printTexto.ImpColLF(73, "0000");

            printTexto.Fim();
        }

        public void PrintCopy()
        {
            printTexto.Inicio(Porta);

            //primeira linha do cheque
            printTexto.ImpCol(9, check.Account.Agency.Number.ToString("{0:0000}"));
            printTexto.ImpCol(22, check.Account.Number.ToString("{0:00000}"));
            printTexto.ImpCol(42, check.CheckNumber.ToString("{0:000000}"));
            printTexto.ImpCol(60, check.Value.ToString());
            printTexto.ImpColLF(79, "");
            printTexto.ImpLF("");


            printTexto.ImpColLF(10, check.ValueToString);
            printTexto.ImpLF("Segunda Linha digitavel");
            printTexto.ImpColLF(2, "Nominal");

            printTexto.ImpCol(40, "São Paulo");
            printTexto.ImpCol(55, "00");
            printTexto.ImpCol(59, "MÊS");
            printTexto.ImpColLF(73, "0000");

            printTexto.Fim();
        }
    }
}
