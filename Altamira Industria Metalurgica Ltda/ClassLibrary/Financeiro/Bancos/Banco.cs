using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.IO;
using System.Text.RegularExpressions;

namespace SA.Data.Models.Financeiro.Bancos
{
    /// <summary>
    /// Código dos bancos brasileiros
    /// </summary>
    public enum CODIGO
    {
        BRADESCO = 237
    }

    public abstract partial class Banco
    {
        //public readonly Bancos.Codigo Numero;

        /// <summary>
        /// Calculo do Modulo 11. Esta é uma funcão genérica para cálculo do Modulo 11. A passagem de um array de pesos permite que a implementação seja genérica e atenda vários bancos. Na implementação especifica de cada banco deve chamar esta função passando o número a ser calculado e os pesos conforme especificação do Banco.
        /// </summary>
        /// <example>
        /// <para>Como transformar o número em array:</para>
        /// <para>uint numero[] = "1234567890".ToCharArray().Select(c => uint.Parse(c.ToString())).ToArray();</para>
        /// <para>Chamando esta versão genérica a partir da versão especifica de cada banco:</para>
        /// <para>int[] peso = { 2, 3, 4, 5, 6, 7 };</para>
        /// <para>return SA.Data.Models.Financeiro.Bancos.Banco.Modulo11(Numero, peso);</para>
        /// </example>
        /// <param name="Numero">Um array do número a ser cálculado o Módulo 11.
        /// <example>
        /// <para>uint numero[] = "1234567890".ToCharArray().Select(c => uint.Parse(c.ToString())).ToArray();</para>
        /// </example>
        /// </param>
        /// <param name="Peso">Um array com os pesos para o cálculo do Módulo 11.
        /// <example>
        /// <para>uint[] peso = { 2, 3, 4, 5, 6, 7 };</para>
        /// </example>
        /// </param>
        /// <returns></returns>
        public static uint Modulo11(uint[] Numero, uint[] Peso)
        {
            //int[] peso = { 2, 3, 4, 5, 6, 7 };
            uint soma = 0;
            uint resto = 0;

            uint[] n = Numero.Reverse().ToArray();

            for (int i = 0; i < Numero.Count(); i++)
            {
                soma += n[i] * Peso[i % Peso.Length];
            }

            resto = soma % 11;

            if (resto <= 1)
                return 0;

            if (resto > 11)
                throw new Exception("Erro no cálculo do Módulo 11. O resto é da divisão não pode ser maior que 11 !"); 

            return 11 - resto;
        }

    }
}
