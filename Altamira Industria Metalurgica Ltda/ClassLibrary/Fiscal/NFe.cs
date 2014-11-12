using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace SA.Data.Models.Fiscal
{
    class NFe
    {
    // http://www.guj.com.br/java/97204-calculo-modulo-11
    //    String gerarChaveDeAcessoNfe(String chaveSemDigito) throws InputMismatchException {  
          
    //    // UMA CHAVE DE ACESSO DE NF-E TEM 44 DIGITOS, ENTAO O CALCULO SE DÁ COM OS 43 ANTERIORES  
    //    if (chaveSemDigito.length() != 43) {   
    //        throw new InputMismatchException("Chave Invalida possui " + chaveSemDigito.length());  
    //    }  
    //    int[] aux = new int[chaveSemDigito.length()];  
    //    int variavel = 2;  
    //    int total = 0;  
    //    int dv = 0;  
    //    for (int i = aux.length - 1; i >= 0; i--) {  
    //        aux[i] = Integer.parseInt("" + chaveSemDigito.charAt(i));  
    //        aux[i] = aux[i] * variavel;  
    //        variavel++;  
    //        if (variavel > 9)  
    //            variavel = 2;  
    //        total += aux[i];  
    //    }  
          
    //    if (total == 0 || total == 1)  
    //        dv = 0;  
    //    else  
    //        dv = 11 - (total % 11);  
          
  
    //    String chaveFinal = (chaveSemDigito + dv);  
    //    System.out.println("Digito Verificador: " + dv);  
    //    System.out.println("chave FInal: " + chaveFinal);  
    //    return chaveFinal;  
  
    //    } 
    }
}
