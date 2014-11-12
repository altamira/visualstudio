using System;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using System.Globalization;

namespace OpenPop.Tests
{
    [TestClass]
    public class UnitTest1
    {
        [TestMethod]
        public void TestMethod1()
        {
            System.Globalization.EncodingTable.internalGetCodePageFromName("iso-8859-10");
        }
    }
}
