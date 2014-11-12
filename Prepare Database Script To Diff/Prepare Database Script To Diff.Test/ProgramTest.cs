using ScriptDiff;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using System;
using System.IO;

namespace ScriptDiff.Test
{
    
    
    /// <summary>
    ///This is a test class for ProgramTest and is intended
    ///to contain all ProgramTest Unit Tests
    ///</summary>
    [TestClass()]
    public class ProgramTest
    {


        private TestContext testContextInstance;

        /// <summary>
        ///Gets or sets the test context which provides
        ///information about and functionality for the current test run.
        ///</summary>
        public TestContext TestContext
        {
            get
            {
                return testContextInstance;
            }
            set
            {
                testContextInstance = value;
            }
        }

        #region Additional test attributes
        // 
        //You can use the following additional attributes as you write your tests:
        //
        //Use ClassInitialize to run code before running the first test in the class
        //[ClassInitialize()]
        //public static void MyClassInitialize(TestContext testContext)
        //{
        //}
        //
        //Use ClassCleanup to run code after all tests in a class have run
        //[ClassCleanup()]
        //public static void MyClassCleanup()
        //{
        //}
        //
        //Use TestInitialize to run code before running each test
        //[TestInitialize()]
        //public void MyTestInitialize()
        //{
        //}
        //
        //Use TestCleanup to run code after each test has run
        //[TestCleanup()]
        //public void MyTestCleanup()
        //{
        //}
        //
        #endregion

        /// <summary>
        ///A test for Main
        ///</summary>
        [TestMethod()]
        public void MainTest()
        {
            const string ScriptFileName = "C:\\Users\\Administrador\\Documents\\Gestao_script.sql";
            const string OutputDir = "C:\\Users\\Administrador\\Documents\\Gestao_script";
            string[] args = { ScriptFileName, OutputDir};

            if (Directory.Exists(OutputDir))
                Directory.Delete(OutputDir, true);

            Assert.IsTrue(Program.Main(args) > 0);
            Assert.IsTrue(Directory.Exists(OutputDir));
            Assert.IsTrue(Directory.GetFiles(OutputDir, "*.sql").GetLength(0) > 0);

            const string ScriptFileNameToCompateTo = "C:\\Users\\Administrador\\Documents\\GestaoRelease_script.sql";
            const string OutputDirToCompateTo = "C:\\Users\\Administrador\\Documents\\GestaoRelease_script";
            string[] argsToCompateTo = { ScriptFileNameToCompateTo, OutputDirToCompateTo };

            if (Directory.Exists(OutputDirToCompateTo))
                Directory.Delete(OutputDirToCompateTo, true);

            Assert.IsTrue(Program.Main(argsToCompateTo) > 0);
            Assert.IsTrue(Directory.Exists(OutputDirToCompateTo));
            Assert.IsTrue(Directory.GetFiles(OutputDirToCompateTo, "*.sql").GetLength(0) > 0);
        }
    }
}
