using System;
using System.Collections.Generic;
using System.Linq;
using System.Runtime.Serialization;
using System.ServiceModel;
using System.ServiceModel.Web;
using System.Text;
using Model;

namespace WCF.Service
{
    // NOTE: You can use the "Rename" command on the "Refactor" menu to change the interface name "IService1" in both code and config file together.
    [ServiceContract]
    public interface IService
    {

        [OperationContract]
        [WebGet(UriTemplate = "/Invoice", ResponseFormat = WebMessageFormat.Json)]
        Invoice[] GetInvoices();

        [OperationContract]
        [WebGet(UriTemplate = "/Invoice", ResponseFormat = WebMessageFormat.Json)]
        AcceptRejectResult AcceptInvoice(int Id);

        [OperationContract]
        [WebGet(UriTemplate = "/Invoice", ResponseFormat = WebMessageFormat.Json)]
        AcceptRejectResult RejectInvoice(int Id);

        //[OperationContract]
        //CompositeType GetDataUsingDataContract(CompositeType composite);

        // TODO: Add your service operations here
    }


    // Use a data contract as illustrated in the sample below to add composite types to service operations.
    [DataContract]
    public class AcceptRejectResult
    {
        int id = 0;
        Status status;
        String message;

        [DataMember]
        public int Id
        {
            get { return id; }
            set { id = value; }
        }

        [DataMember]
        public Status Status
        {
            get { return status; }
            set { status = value; }
        }

        [DataMember]
        public string Message
        {
            get { return message; }
            set { message = value; }
        }
    }
}
