using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using SA.Data.Models.Financeiro.Bancos;

namespace SA.Data.Models.Test.Financeiro.Bancos
{
    // Testa a class Banco do Namespace Financeiro
    [TestClass]
    public partial class Banco
    {
        [Description("Testa o cálculo do Modulo 11 genérico, comum a todos os bancos"), TestMethod]
        public void Banco_Modulo11_Test()
        {
            uint[] peso = { 2, 3, 4, 5, 6, 7 };
            uint[] numero = "1234567890".ToCharArray().Select(c => uint.Parse(c.ToString())).ToArray();
            Assert.AreEqual(3u, SA.Data.Models.Financeiro.Bancos.Banco.Modulo11(numero, peso));

            numero = "9999".ToCharArray().Select(c => uint.Parse(c.ToString())).ToArray();
            Assert.AreEqual(6u, SA.Data.Models.Financeiro.Bancos.Banco.Modulo11(numero, peso));
        }

        [Description("Testa o cálculo do Digito Verificador da Linha Digitável do Código de Barras"), TestMethod]
        public void Banco_Codigo_Barra_Test()
        {
            string codigobarra;

            /*codigobarra = "29197104400002000000417090001260000600957300";
            CodigoBarras c = new CodigoBarras(codigobarra);

            Assert.AreEqual(MOEDA.REAL, c.CODIGO_MOEDA);
            Assert.AreEqual(CODIGO.BRADESCO, c.IDENTIFICACAO_BANCO);
            Assert.AreEqual("1044".ToNumericArray(), c.FATOR_VENCIMENTO);
            Assert.AreEqual(9u, c.DIGITO_VERIFICADOR);
            Assert.AreEqual(2000.00, c.VALOR);*/

            codigobarra = "23794114700000426960054020001260000701242120";

            CodigoBarras c = new CodigoBarras(codigobarra);

            Assert.AreEqual(MOEDA.REAL, c.CODIGO_MOEDA);
            Assert.AreEqual(CODIGO.BRADESCO, c.IDENTIFICACAO_BANCO);
            Assert.AreEqual("1147", string.Join("", c.FATOR_VENCIMENTO.Select(x => x.ToString())));
            Assert.AreEqual(4u, c.DIGITO_VERIFICADOR);
            Assert.AreEqual<decimal>(426.96m, c.VALOR);
            Assert.AreEqual("0054020001260000701242120", c.CAMPO_LIVRE);

            IEnumerable<Exception> v = c.Validar();

            if (v != null)
                foreach (Exception e in v)
                    Assert.Fail(e.Message);

        }

        [Description("Testa o cálculo do Digito Verificador da Linha Digitável do Código de Barras"), TestMethod]
        public void Banco_Bradesco_Codigo_Barra_Test()
        {
            string codigobarra;

            codigobarra = "23794114700000426960054020001260000701242120";

            SA.Data.Models.Financeiro.Bancos.Bradesco.CodigoBarras c = new SA.Data.Models.Financeiro.Bancos.Bradesco.CodigoBarras(codigobarra);

            Assert.AreEqual(MOEDA.REAL, c.CODIGO_MOEDA);
            Assert.AreEqual(CODIGO.BRADESCO, c.IDENTIFICACAO_BANCO);
            Assert.AreEqual("1147", string.Join("", c.FATOR_VENCIMENTO.Select(x => x.ToString())));
            Assert.AreEqual(4u, c.DIGITO_VERIFICADOR);
            Assert.AreEqual<decimal>(426.96m, c.VALOR);
            Assert.AreEqual("0054", c.AGENCIA);
            Assert.AreEqual("02", c.CARTEIRA);
            Assert.AreEqual("00012600007", c.NOSSO_NUMERO);
            Assert.AreEqual("0124212", c.CONTA_CEDENTE);
            Assert.AreEqual("0", c.ZERO_FIXO);

            IEnumerable<Exception> v = c.Validar();

            if (v != null)
                foreach (Exception e in v)
                    Assert.Fail(e.Message);

        }

        [Description("Testa o cálculo do Digito Verificador da Linha Digitável do Código de Barras"), TestMethod]
        public void Banco_Modulo10_Test()
        {
            Assert.AreEqual(4u, SA.Data.Models.Financeiro.Bancos.Banco.Modulo10("237900540".ToCharArray()));
            Assert.AreEqual(7u, SA.Data.Models.Financeiro.Bancos.Banco.Modulo10("2000126000".ToCharArray()));
            Assert.AreEqual(7u, SA.Data.Models.Financeiro.Bancos.Banco.Modulo10("0701242120".ToCharArray()));
        }

        [Description("Testa o cálculo do Digito Verificador da Linha Digitável do Código de Barras"), TestMethod]
        public void Banco_Digito_Verificador_Codigo_Barra_Test()
        {
            uint[] numero;
            
            numero = "2919104400002000000417090001260000600957300".ToCharArray().Select(c => uint.Parse(c.ToString())).ToArray();
            Assert.AreEqual(7u, SA.Data.Models.Financeiro.Bancos.Banco.CalculoDigitoVerificadorCodigoBarra(numero));

            numero = "2379114700000426960054020001260000701242120".ToCharArray().Select(c => uint.Parse(c.ToString())).ToArray();
            Assert.AreEqual(4u, SA.Data.Models.Financeiro.Bancos.Banco.CalculoDigitoVerificadorCodigoBarra(numero));

            //numero = "23790091099000000907705019386209456200000007000".ToCharArray().Select(c => uint.Parse(c.ToString())).ToArray();
            //Assert.AreEqual(4u, SA.Data.Models.Financeiro.Bancos.Banco.CalculoDigitoVerificadorCodigoBarra(numero));
        }

        [Description("Testa o algoritmo de cálculo do Modulo 11 Bradesco"), TestMethod] // This attribute identifies the method as a unit test.
        public void Banco_Bradesco_Modulo11_Test()
        {
            // Arrange: Create an instance to test:
            uint digito = 0;
            uint[] i = { 0 };

            // Act: Run the method under test:
            i = "1234567890".ToCharArray().Select(c => uint.Parse(c.ToString())).ToArray();
            digito = Bradesco.Modulo11(i);

            // Assert: Verify the result:
            Assert.AreEqual(3u, digito);

            i = "9999".ToCharArray().Select(c => uint.Parse(c.ToString())).ToArray();
            digito = Bradesco.Modulo11(i);

            // Assert: Verify the result:
            Assert.AreEqual(6u, digito);
        }
    }  
}
