using System;
using System.Collections.Generic;
using System.Text;

namespace SA.Data.Types.Fiscal
{
    class CPF
    {
        public static String validaCPF(String cpf)
        {
            if (cpf.Length < 11) return null;

            String novoCPF = cpf.Replace("[.-]", "");

            //Testa se o CPF é válido ou não 
            int d1, d4, xx, nCount, resto, digito1, digito2;
            String Check;
            String Separadores = "/-.";
            d1 = 0; d4 = 0; xx = 1;
            for (nCount = 0; nCount < cpf.Length - 2; nCount++)
            {
                String s_aux = cpf.Substring(nCount, nCount + 1);

                if (Separadores.IndexOf(s_aux) == -1)
                {
                    d1 = d1 + (11 - xx) * int.Parse(s_aux);
                    d4 = d4 + (12 - xx) * int.Parse(s_aux);
                    xx++;
                };
            };
            resto = (d1 % 11);
            if (resto < 2)
            {
                digito1 = 0;
            }
            else
            {
                digito1 = 11 - resto;
            }

            d4 = d4 + 2 * digito1;
            resto = (d4 % 11);
            if (resto < 2)
            {
                digito2 = 0;
            }
            else
            {
                digito2 = 11 - resto;
            }

            Check = (digito1 + digito2).ToString();

            String s_aux2 = cpf.Substring(cpf.Length - 2, cpf.Length);

            if (s_aux2.CompareTo(Check) != 0)
            {
                return null;
            }
            else
            {
                return novoCPF;
            }
        }
    }
}
