using System;
using System.Collections.Generic;
using System.Linq;
using System.Security.Cryptography.X509Certificates;
using System.Text;
using System.Threading.Tasks;
using System.Xml;
using Microsoft.Practices.Prism.Interactivity.InteractionRequest;
using Sefaz.NFe.Models;
using Sefaz.NFe.Module.Services;
using ViewModel.Command;

namespace Sefaz.NFe.Module.ViewModel
{
    public class ServiceViewModel : ViewModelBase
    {
        #region Properties

        private IServiceAdapter Adapter;

        public ServiceViewModel() : this(new ServiceAdapter()) { }

        public ServiceViewModel(IServiceAdapter adapter)
        {
            if (adapter != null)
            {
                this.Adapter = adapter;
            }

            CanGetInvoiceStatus = true;

            SelectCertificateRequest = new InteractionRequest<Notification>();
        }

        // Certificado A1
        //FileStream fs = new FileStream(@"caminho do certificado", FileMode.Open);
        //byte[] buffer = new byte[fs.Length];
        //X509Certificate2 cert = new X509Certificate2(buffer, "senha");

        X509Certificate2 X509Cert;

        public X509Certificate2 X509CertificateSelectedItem
        {
            get
            {
                if (X509Cert == null)
                {
                    X509Cert = new X509Certificate2();
                }
                return X509Cert;
            }
            set
            {
                if (X509Cert != value)
                {
                    X509Cert = value;
                    OnPropertyChanged("X509CertificateSelectedItem");
                }
            }
        }

        public X509Certificate2Collection X509Certificate2Collection
        {
            get
            {
                X509Store store = new X509Store("MY", StoreLocation.CurrentUser);
                store.Open(OpenFlags.ReadOnly | OpenFlags.OpenExistingOnly);

                X509Certificate2Collection collection = (X509Certificate2Collection)store.Certificates;
                X509Certificate2Collection collection1 = (X509Certificate2Collection)collection.Find(X509FindType.FindByTimeValid, DateTime.Now, false);
                X509Certificate2Collection collection2 = (X509Certificate2Collection)collection.Find(X509FindType.FindByKeyUsage, X509KeyUsageFlags.DigitalSignature, false);
                //X509Certificate2Collection scollection = X509Certificate2UI.SelectFromCollection(collection2, "Certificado(s) Digital(is) disponível(is)", "Selecione o certificado digital para uso no aplicativo", X509SelectionFlag.SingleSelection);
                
                //X509Certificate2Collection scollection = X509Certificate2UI.SelectFromCollection(collection1, "Certificado(s) Digital(is) válido(s)", "Selecione o certificado digital para uso no aplicativo", X509SelectionFlag.SingleSelection);

                return collection;
            }
        }
        X509Certificate2 oX509Cert = new X509Certificate2();

        #endregion

        #region Actions

        // view can bind to this request
        public InteractionRequest<Notification> SelectCertificateRequest
        {
            get;
            private set;
        }

        // trigger message
        private void RaiseMessageRequest(string message)
        {
            SelectCertificateRequest.Raise(new Notification() { Content = "Selecione o Certificado.", Title = message });
        }

        public void GetInvoiceStatus()
        {
            try
            {
                //RaiseMessageRequest("Selecione o Certificado");

                //return;

                NFeConsulta2_Producao.nfeCabecMsg nfeCabec = new NFeConsulta2_Producao.nfeCabecMsg();
                TConsSitNFe consSitNFe = new TConsSitNFe();

                nfeCabec.cUF = "35";
                nfeCabec.versaoDados = "2.01";
                //nfeCabec.versaoDados = "2.00";

                //consSitNFe.tpAmb = TAmb.Homologacao;
                consSitNFe.tpAmb = TAmb.Producao;
                consSitNFe.versao = TVerConsSitNFe.versao_2_01;
                //consSitNFe.versao = TVerConsSitNFe.versao_2_00;
                consSitNFe.chNFe = "35121243799295000110550010000093441593864234";  // Altamira
                consSitNFe.chNFe = "35130543799295000110550010000106881593864220";  // Altamira
                consSitNFe.chNFe = "35130500867888000164550010000011201593864236";  // Tecnequip
                consSitNFe.xServ = TConsSitNFeXServ.CONSULTAR;

                XmlDocument consSitNFeXml = new XmlDocument();
                consSitNFeXml.LoadXml(consSitNFe.Serialize());

                XmlNode result;

                //Adapter.GetInvoiceStatus(nfeCabec, consSitNFeXml, (s, args) => result = args.Result);
                Adapter.GetInvoiceStatus(nfeCabec, consSitNFeXml);
            }
            catch (System.ServiceModel.Security.SecurityNegotiationException securityException)
            {

            }
            catch (Exception e)
            {
                
            }
        }

        #endregion

        #region Commands

        public bool CanGetInvoiceStatus
        {
            get { return GetInvoiceStatusCommand.IsEnabled; }
            set { GetInvoiceStatusCommand.IsEnabled = value; OnPropertyChanged("CanGetInvoiceStatus"); }
        }

        private RelayCommand getInvoiceStatusCommand;

        public RelayCommand GetInvoiceStatusCommand
        {
            get
            {
                if (getInvoiceStatusCommand == null)
                {
                    getInvoiceStatusCommand = new RelayCommand(GetInvoiceStatus);
                }
                return getInvoiceStatusCommand;
            }
        }

        #endregion
    }
}
