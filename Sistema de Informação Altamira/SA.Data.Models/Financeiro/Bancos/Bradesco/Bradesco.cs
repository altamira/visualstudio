using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.IO;
using System.Text.RegularExpressions;
using System.Collections.ObjectModel;
using System.Reflection;
using System.Globalization;

namespace SA.Data.Models.Financeiro.Bancos
{
    /// <summary>
    /// Representa os dados e a implementação para o banco Bradesco
    /// </summary>
    public partial class Bradesco : Banco
    {
        #region Variaveis

        #endregion

        #region Propriedades

        #endregion

        #region Construtores

        #endregion

        #region Metodos

        /// <summary>
        /// <para>Esta é função de cálculo do Módulo 11 especifica para o banco Bradesco.</para>
        /// <para>O cálculo do Módulo 11 do Bradesco utiliza pesos de 2 a 7.</para>
        /// </summary>
        /// <param name="Numero">O número a ser calculado o Módulo 11.
        /// <para>O número deve ser passado em forma de array. 
        /// </param>
        /// <returns>Inteiro, sem sinal, representando o dígito verificador do número, calculado pelo Módulo 11.</returns>
        /// <example>
        /// <para>Para transformar o número em array:</para>
        /// <para>uint i[] = "1234567890".ToCharArray().Select(c => uint.Parse(c.ToString())).ToArray();</para>
        /// <para>uint digito = Modulo11(i);</para>
        /// </example>
        public static uint Modulo11(uint[] Numero)
        {
            uint[] peso = { 2, 3, 4, 5, 6, 7 };
            return Banco.Modulo11(Numero, peso);
        }

        #endregion

    }

}
