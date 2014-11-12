using System;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Security.Cryptography.X509Certificates;
using System.Text;
using System.Xml;
using System.Xml.Schema;
using System.Xml.XPath;

namespace Sefaz.NFe.Module.Services
{
    public interface IServiceAdapter
    {
        //async based
        //void GetInvoiceStatus(NFeConsulta2_Producao.nfeCabecMsg nfeCabec, System.Xml.XmlNode nfeDados, EventHandler<NFeConsulta2_Producao.nfeConsultaNF2CompletedEventArgs> callback);
        //task based
        void GetInvoiceStatus(NFeConsulta2_Producao.nfeCabecMsg nfeCabec, System.Xml.XmlNode nfeDados);
    }

    public class ServiceAdapter : IServiceAdapter
    {
        NFeConsulta2_Producao.NfeConsulta2Soap12Client ws;

        public ServiceAdapter()
        {
            //forçar o uso do protocolo SSL 3.0 de acordo com o manual de integração do SEFAZ
            ServicePointManager.SecurityProtocol = SecurityProtocolType.Ssl3;

        }

        public void GetInvoiceStatus(NFeConsulta2_Producao.nfeCabecMsg nfeCabec, System.Xml.XmlNode nfeDados/*, EventHandler<NFeConsulta2_Producao.nfeConsultaNF2CompletedEventArgs> callback*/)
        {

            //if (scollection.Count == 0)
            //{
            //    //string msgResultado = "Nenhum certificado digital foi selecionado ou o certificado selecionado está com problemas.";
            //    //MessageBox.Show(msgResultado, "Advertência", MessageBoxButtons.OK, MessageBoxIcon.Warning);
            //    //vRetorna = false;
            //}
            //else
            //{
            //    oX509Cert = scollection[0];
            //    //oCertificado = oX509Cert;
            //    //vRetorna = true;
            //}

            //System.ServiceModel.EndpointAddress endpoint = new System.ServiceModel.EndpointAddress("https://homologacao.nfe.fazenda.sp.gov.br/nfeweb/services/NfeConsulta2.asmx");
            //ws.Endpoint.Address = endpoint;

            using (NFeConsulta2_Producao.NfeConsulta2Soap12Client ws = new NFeConsulta2_Producao.NfeConsulta2Soap12Client())
            {
                //ws.ClientCredentials.ClientCertificate.SetCertificate(StoreLocation.LocalMachine, StoreName.My, X509FindType.FindBySubjectName, "E=gerencia.ti@altamira.com.br, CN=TECNEQUIP TECNOLOGIA EM EQUIPAMENTOS LTDA, OU=ID - 3460093, OU=Assinatura Tipo A3, OU=Autenticado por Certisign Certificadora Digital, O=ICP-Brasil, C=BR");
                ws.ClientCredentials.ClientCertificate.SetCertificate("E=gerencia.ti@altamira.com.br, CN=TECNEQUIP TECNOLOGIA EM EQUIPAMENTOS LTDA, OU=ID - 3460093, OU=Assinatura Tipo A3, OU=Autenticado por Certisign Certificadora Digital, O=ICP-Brasil, C=BR", System.Security.Cryptography.X509Certificates.StoreLocation.CurrentUser, System.Security.Cryptography.X509Certificates.StoreName.My);

                //ws.nfeConsultaNF2Completed += callback;
                //ws.nfeConsultaNF2Async(nfeCabec, nfeDados);
                XmlNode result = ws.nfeConsultaNF2(ref nfeCabec, nfeDados);
            }
        }
    }
}
