using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using Microsoft.VisualStudio.TestTools.UnitTesting;

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

        [Description("Testa o algoritmo de cálculo do Modulo 11 Bradesco"), TestMethod] // This attribute identifies the method as a unit test.
        public void Banco_Bradesco_Modulo11_Test()
        {
            // Arrange: Create an instance to test:
            uint digito = 0;
            uint[] i = { 0 };

            // Act: Run the method under test:
            i = "1234567890".ToCharArray().Select(c => uint.Parse(c.ToString())).ToArray();
            digito = SA.Data.Models.Financeiro.Bancos.Banco.Bradesco.Modulo11(i);

            // Assert: Verify the result:
            Assert.AreEqual(3u, digito);

            i = "9999".ToCharArray().Select(c => uint.Parse(c.ToString())).ToArray();
            digito = SA.Data.Models.Financeiro.Bancos.Banco.Bradesco.Modulo11(i);

            // Assert: Verify the result:
            Assert.AreEqual(6u, digito);

        }
    }  
}
