using System;
using System.Security.Cryptography.X509Certificates;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using Sefaz.NFe.Module.ViewModel;

namespace NFe.Module.Tests
{
    [TestClass]
    public class UnitTest1
    {
        [TestMethod]
        public void TestMethod1()
        {
            ServiceViewModel service = new ServiceViewModel();

            service.GetInvoiceStatus();
        }
        [TestMethod]
        public void X509Certificate2CollectionTest()
        {
            ServiceViewModel service = new ServiceViewModel();

            X509Certificate2Collection collection = service.X509Certificate2Collection;

            Assert.IsNotNull(collection);
            Assert.IsNotNull(collection[0].Subject);

            //X509Certificate2Collection selectionCollection = X509Certificate2UI.SelectFromCollection(collection, "Certificado(s) Digital(is) disponível(is)", "Selecione o certificado digital para uso no aplicativo", X509SelectionFlag.SingleSelection);
        }

    }
}
