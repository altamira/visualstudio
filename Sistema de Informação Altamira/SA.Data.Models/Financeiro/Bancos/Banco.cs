using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.IO;
using System.Text.RegularExpressions;

namespace SA.Data.Models.Financeiro.Bancos
{
    /// <summary>
    /// Representa o Código dos Bancos Brasileiros
    /// </summary>
    public enum CODIGO
    {
        ABC_BRASIL = 246,	    // Banco ABC Brasil S.A.
        ALFA = 025,	            // Banco Alfa S.A.
        ALVORADA = 641,         // Banco Alvorada S.A.
        BANERJ  = 029,	        // Banco Banerj S.A.
        BANKPAR = 000,	        // Banco Bankpar S.A.
        BARCLAYS = 740,	        // Banco Barclays S.A.
        BBM = 107,	            // Banco BBM S.A.
        BEG = 031,	            // Banco Beg S.A.
        BGN = 739,	            // Banco BGN S.A.
        BOVESPA = 096,	        // Banco BM&FBOVESPA de Serviços de Liquidação e Custódia S.A
        BMG = 318,	            // Banco BMG S.A.
        BNP_PARIBAS = 752,	    // Banco BNP Paribas Brasil S.A.
        BOAVISTA = 248,	        // Banco Boavista Interatlântico S.A.
        BONSUCESSO = 218,	    // Banco Bonsucesso S.A.
        BRACCE = 065,	        // Banco Bracce S.A.
        BRADESCO_BBI = 036,	    // Banco Bradesco BBI S.A.
        BRADESCO_CARTOES = 204,	// Banco Bradesco Cartões S.A.
        BRADESCO_FINANCIAMENTOS = 394,	 // Banco Bradesco Financiamentos S.A.
        BRADESCO = 237,	        // Banco Bradesco S.A.
        BRASCAN = 225,	        // Banco Brascan S.A.
        BTG_PACTUAL = 208,	    // Banco BTG Pactual S.A.
        BVA = 044,	            // Banco BVA S.A.
        CACIQUE = 263,	        // Banco Cacique S.A.
        CAIXA_GERAL = 473,	    // Banco Caixa Geral - Brasil S.A.
        CARGILL = 040,	        // Banco Cargill S.A.
        CIFRA = 233,	        // Banco Cifra S.A.
        CITIBANK = 745,	        // Banco Citibank S.A.
        //M08 Banco Citicard S.A.
        //CNH_CAPITAL = M19,	    // Banco CNH Capital S.A.
        SUDAMERIS = 215,	    // Banco Comercial e de Investimento Sudameris S.A.
        CONFIDENCE = 095,	    // Banco Confidence de Câmbio S.A.
        BANCOOB = 756,	        // Banco Cooperativo do Brasil S.A. - BANCOOB
        SICREDI = 748,	        // Banco Cooperativo Sicredi S.A.
        CREDIT_AGRICOLE = 222,	// Banco Credit Agricole Brasil S.A.
        CREDIT_SUISSE = 505,	// Banco Credit Suisse (Brasil) S.A.
        CRUZEIRO_DO_SUL = 229,	// Banco Cruzeiro do Sul S.A.
        AMAZONIA = 003,	        // Banco da Amazônia S.A.
        //CHINA_BRASIL = 083-3	// Banco da China Brasil S.A.
        DAYCOVAL = 707,	        // Banco Daycoval S.A.
        //LAGE_LANDER = M06	    // Banco de Lage Landen Brasil S.A.
        PERNAMBUCO = 024,	    // Banco de Pernambuco S.A. - BANDEPE
        MITSUBISHI = 456,	    // Banco de Tokyo-Mitsubishi UFJ Brasil S.A.
        DIBENS = 214,	        // Banco Dibens S.A.
        BANCO_BRASIL = 001,	    // Banco do Brasil S.A.
        BANCO_SERGIPE = 047,	// Banco do Estado de Sergipe S.A.
        BANCO_PARA = 037,	    // Banco do Estado do Pará S.A.
        BANCO_RIO_GRANDE_SUL = 041,	 // Banco do Estado do Rio Grande do Sul S.A.
        BANCO_NORDESTE = 004,	// Banco do Nordeste do Brasil S.A.
        //265	 Banco Fator S.A.
        //M03	 Banco Fiat S.A.
        //224	 Banco Fibra S.A.
        //626	 Banco Ficsa S.A.
        //394	 Banco Finasa BMC S.A.
        //M18	 Banco Ford S.A.
        //M07	 Banco GMAC S.A.
        //612	 Banco Guanabara S.A.
        //M22	 Banco Honda S.A.
        //063	 Banco Ibi S.A. Banco Múltiplo
        //M11	 Banco IBM S.A.
        //604	 Banco Industrial do Brasil S.A.
        //320	 Banco Industrial e Comercial S.A.
        //653	 Banco Indusval S.A.
        //249    Banco Investcred Unibanco S.A.
        ITAU_BBA = 184,     // Banco Itaú BBA S.A.
        ITAU = 479,         // Banco ItaúBank S.A
        //M09	 Banco Itaucred Financiamentos S.A.
        //376	 Banco J. P. Morgan S.A.
        //SAFRA = 074,	    // Banco J. Safra S.A.
        //217	 Banco John Deere S.A.
        //600	 Banco Luso Brasileiro S.A.
        //389	 Banco Mercantil do Brasil S.A.
        //746	 Banco Modal S.A.
        //045	 Banco Opportunity S.A.
        //079	 Banco Original do Agronegócio S.A.
        //623	 Banco Panamericano S.A.
        //611	 Banco Paulista S.A.
        //643	 Banco Pine S.A.
        //638	 Banco Prosper S.A.
        //M24	 Banco PSA Finance Brasil S.A.
        //747	 Banco Rabobank International Brasil S.A.
        REAL = 356,         // Banco Real S.A.
        //633	 Banco Rendimento S.A.
        //M16	 Banco Rodobens S.A.
        //072	 Banco Rural Mais S.A.
        //453	 Banco Rural S.A.
        SAFRA = 422,        // Banco Safra S.A.
        SANTANDER = 033,    // Banco Santander (Brasil) S.A.
        //749	 Banco Simples S.A.
        //366	 Banco Société Générale Brasil S.A.
        //637	 Banco Sofisa S.A.
        //012	 Banco Standard de Investimentos S.A.
        //464	 Banco Sumitomo Mitsui Brasileiro S.A.
        //082-5	 Banco Topázio S.A.
        //M20	 Banco Toyota do Brasil S.A.
        //634	 Banco Triângulo S.A.
        //M14	 Banco Volkswagen S.A.
        //M23	 Banco Volvo (Brasil) S.A.
        //655	 Banco Votorantim S.A.
        //610	 Banco VR S.A.
        //119	 Banco Western Union do Brasil S.A.
        //370	 Banco WestLB do Brasil S.A.
        //021	 BANESTES S.A. Banco do Estado do Espírito Santo
        //719	 Banif-Banco Internacional do Funchal (Brasil)S.A.
        //755	 Bank of America Merrill Lynch Banco Múltiplo S.A.
        //073	 BB Banco Popular do Brasil S.A.
        //250	 BCV - Banco de Crédito e Varejo S.A.
        //078	 BES Investimento do Brasil S.A.-Banco de Investimento
        //069	 BPN Brasil Banco Múltiplo S.A.
        //125	 Brasil Plural S.A. - Banco Múltiplo
        //070	 BRB - Banco de Brasília S.A.
        CAIXA_ECONOMICA = 104,      // Caixa Econômica Federal
        //CITIBANK = 477,	            // Citibank S.A.
        //081-7	 Concórdia Banco S.A.
        //487	 Deutsche Bank S.A. - Banco Alemão
        //064	 Goldman Sachs do Brasil Banco Múltiplo S.A.
        //062	 Hipercard Banco Múltiplo S.A.
        HSBC = 399,                 // HSBC Bank Brasil S.A. - Banco Múltiplo
        //492	 ING Bank N.V.
        ITAU_HOLDING = 652,      	// Itaú Unibanco Holding S.A.
        ITAU_UNIBANCO = 341,        // Itaú Unibanco S.A.
        //488	 JPMorgan Chase Bank
        //751	 Scotiabank Brasil S.A. Banco Múltiplo
        UNIBANCO = 409,	    // UNIBANCO - União de Bancos Brasileiros S.A.
        //230	 Unicard Banco Múltiplo S.A.
    }

    /// <summary>
    /// Representa o Código da Moeda
    /// </summary>
    public enum MOEDA
    {
        REAL = 9
    }

    public abstract partial class Banco
    {
        #region Variaveis

        #endregion

        #region Propriedades

        public int Codigo { get; set; }

        public string Nome { get; set; }

        #endregion

        #region Metodos

        public static uint Modulo10(char[] Numero)
        {
            uint i = 2;
            uint sum = 0;
            uint res = 0;

            foreach (uint c in Numero.ToNumericArray().Reverse().ToArray())
            {
                res = (c * i);
                sum += res > 9 ? (res - 9) : res;
                i = i == 2 ? 1u : 2u;
            }

            return 10 - (sum % 10);
        }

        public static uint Modulo10(string Numero)
        {
            return Modulo10(Numero.ToCharArray());
        }

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

        /// <summary>
        /// Cálculo do digito verificador do código de barras da linha digitável
        /// </summary>
        /// <remarks>
        /// O critério para o cálculo do dígito verificador do código de barras é o mesmo para todos os Bancos, ou seja, módulo 11 com base 9.
        /// </remarks>
        /// <param name="Numero"></param>
        /// <returns></returns>
        public static uint CalculoDigitoVerificadorCodigoBarra(uint[] Numero)
        {
            uint[] peso = { 2, 3, 4, 5, 6, 7, 8, 9 };
            return Banco.Modulo11(Numero, peso);
        }

        #endregion

    }
}
