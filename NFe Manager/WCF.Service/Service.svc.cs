using System;
using System.Collections.Generic;
using System.Linq;
using System.Runtime.Serialization;
using System.ServiceModel;
using System.ServiceModel.Activation;
using System.ServiceModel.Web;
using System.Text;
using System.Data.Entity;
using DAL.Models;
using Model;

namespace WCF.Service
{

    // NOTE: You can use the "Rename" command on the "Refactor" menu to change the class name "Service1" in code, svc and config file together.
    // NOTE: In order to launch WCF Test Client for testing this service, please select Service1.svc or Service1.svc.cs at the Solution Explorer and start debugging.
    [AspNetCompatibilityRequirements(RequirementsMode = AspNetCompatibilityRequirementsMode.Required)]
    public class Service : IService
    {
        NFeDbContext context;

        public Service()
        {
            context = new NFeDbContext();
            //context.Invoices.Load();
        }

        public Invoice[] GetInvoices()
        {
            return (from i in context.Invoices
                    orderby i.Date
                    select new { i.Id, i.Date, i.Number, i.Value, i.Sender, i.Receipt, i.Type, i.Status })
                    .AsEnumerable()
                    .Where(x => x.Status == Status.New)
                    .Select(i => new Invoice() { Id = i.Id, Date = i.Date, Number = i.Number, Value = i.Value, Sender = i.Sender, Receipt = i.Receipt, Type = i.Type, Status = i.Status })
                    .ToArray();
        }

        public AcceptRejectResult AcceptInvoice(int Id)
        {
            AcceptRejectResult result = new AcceptRejectResult();

            result.Status = Model.Status.Exception;

            try
            {
                Invoice invoice = context.Invoices.Find(Id);

                if (invoice != null)
                {
                    invoice.Status = Model.Status.Accepted;
                    context.SaveChanges();
                    result.Message = String.Format("Autorizado o recebimento da Nota Fiscal {0}.", invoice.Number);
                    result.Status = Model.Status.Accepted;
                }
                else
                    result.Message = "A Nota NÃO foi encontrada. Entre em contato com o suporte técnico !";
            }
            catch (Exception e)
            {
                result.Message = e.InnerException.Message;
            }
            
            return result;
        }

        public AcceptRejectResult RejectInvoice(int Id)
        {
            AcceptRejectResult result = new AcceptRejectResult();

            result.Status = Model.Status.Exception;

            try
            {
                Invoice invoice = context.Invoices.Find(Id);

                if (invoice != null)
                {
                    invoice.Status = Model.Status.Rejected;
                    context.SaveChanges();
                    result.Message = String.Format("Confirmado a Devolução da Nota Fiscal {0}.", invoice.Number);
                    result.Status = Model.Status.Rejected;
                }
                else
                    result.Message = "A Nota NÃO foi encontrada. Entre em contato com o suporte técnico !";
            }
            catch (Exception e)
            {
                result.Message = e.InnerException.Message;
            }

            return result;
        }

        //public CompositeType GetDataUsingDataContract(CompositeType composite)
        //{
        //    if (composite == null)
        //    {
        //        throw new ArgumentNullException("composite");
        //    }
        //    if (composite.BoolValue)
        //    {
        //        composite.StringValue += "Suffix";
        //    }
        //    return composite;
        //}
    }
}
