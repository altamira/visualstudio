using System;
using System.Threading;
using ViewModel.Services;
using ViewModel.Command;
using ViewModel.ServiceReference;
using System.Collections.Generic;
using System.Linq;
using ViewModel.Extensions;
using System.ComponentModel.Composition;

namespace ViewModel
{
    [Export(typeof(InvoiceViewModel))]
    public class InvoiceViewModel : ViewModel.ViewModels.ViewModelBase
    {
        #region Properties

        private readonly SynchronizationContext context;

        private IServiceAdapter Adapter;

        public InvoiceViewModel() : this(new ServiceAdapter()) { }

        public InvoiceViewModel(IServiceAdapter adapter)
        {
            context = SynchronizationContext.Current;

            if (adapter != null)
            {
                this.Adapter = adapter;

                CanGetInvoices = true;

                GetInvoices();
            }
        }

        private Invoice selectedItem;

        public Invoice SelectedItem
        {
            get { return selectedItem; }
            set 
            { 
                selectedItem = value;
                if (value != null)
                {
                    CanAcceptInvoice = true;
                    CanRejectInvoice = true;
                }
                else
                {
                    CanAcceptInvoice = false;
                    CanRejectInvoice = false;
                }

                OnPropertyChanged("SelectedItem"); 
            }
        }

        List<Invoice> invoices;

        public List<Invoice> Invoices
        {
            get { return invoices; }
            set
            {
                invoices = value;
                OnPropertyChanged("Invoices");
                OnPropertyChanged("Dates");
            }
        }

        private string message;

        public string Message
        {
            get { return message; }
            set { message = value; OnPropertyChanged("Message"); }
        }

        private AcceptRejectResult AcceptRejectResultAsync
        {
            set
            {
                SelectedItem.Status = value.Status;
                Message = value.Message;
            }
        }
        #endregion

        #region Preferences

        private Enums.OrderBy orderBy = Enums.OrderBy.Date;

        public Enums.OrderBy OrderBy
        {
            get { return orderBy; }
            set { orderBy = value; OnPropertyChanged("OrderBy"); }
        }

        private Enums.GroupBy groupBy = Enums.GroupBy.Date;

        public Enums.GroupBy GroupBy
        {
            get { return groupBy; }
            set { groupBy = value; OnPropertyChanged("GroupBy"); }
        }

        private Enums.ExportTo exportTo = Enums.ExportTo.Mail;

        public Enums.ExportTo ExportTo
        {
            get { return exportTo; }
            set { exportTo = value; OnPropertyChanged("ExportTo"); }
        }

        private bool compact = false;

        public bool Compact
        {
            get { return compact; }
            set { compact = value; OnPropertyChanged("Compact"); }
        }

        #endregion

        #region Filters

        public List<DateTime> Dates 
        { 
            get 
            {
                if (Invoices != null)
                    return Invoices.Select(i => i.Date).Distinct(new CustomComparer<DateTime>()).ToList();
                return new List<DateTime>();
            } 
        }

        public List<int> Numbers
        {
            get
            {
                if (Invoices != null)
                    return Invoices.Select(i => i.Number).Distinct(new CustomComparer<int>()).ToList();
                return new List<int>();
            }
        }

        public List<string> Senders
        {
            get
            {
                if (Invoices != null)
                    return Invoices.Select(i => i.Sender).Distinct(new CustomComparer<string>()).ToList();
                return new List<string>();
            }
        }

        public List<string> Receipts
        {
            get
            {
                if (Invoices != null)
                    return Invoices.Select(i => i.Receipt).Distinct(new CustomComparer<string>()).ToList();
                return new List<string>();
            }
        }

        //public List<InvoiceType> Recipts
        //{
        //    get
        //    {
        //        if (Invoices != null)
        //            return Invoices.Select(i => i).Distinct(new CustomComparer<string>()).ToList();
        //        return new List<string>();
        //    }
        //}
        #endregion

        #region Actions

        public void GetInvoices()
        {
            Adapter.GetInvoices((s, args) => Invoices = args.Result); 
        }

        public void AcceptInvoice()
        {
            Adapter.AcceptInvoice((s, args) => AcceptRejectResultAsync = args.Result, SelectedItem.Id); 
        }

        public void RejectInvoice()
        {
            Adapter.RejectInvoice((s, args) => AcceptRejectResultAsync = args.Result, SelectedItem.Id); 
        }

        #endregion

        #region Commands

        public bool CanGetInvoices
        {
            get { return GetInvoicesCommand.IsEnabled; }
            set { GetInvoicesCommand.IsEnabled = value; OnPropertyChanged("CanGetInvoices"); }
        }

        public bool CanAcceptInvoice
        {
            get { return AcceptInvoiceCommand.IsEnabled; }
            set { AcceptInvoiceCommand.IsEnabled = value; OnPropertyChanged("CanAcceptInvoice"); }
        }

        public bool CanRejectInvoice
        {
            get { return RejectInvoiceCommand.IsEnabled; }
            set { RejectInvoiceCommand.IsEnabled = value; OnPropertyChanged("CanRejectInvoice"); }
        }

        private RelayCommand getInvoicesCommand;

        public RelayCommand GetInvoicesCommand
        {
            get
            {
                if (getInvoicesCommand == null)
                {
                    getInvoicesCommand = new RelayCommand(GetInvoices);
                }
                return getInvoicesCommand;
            }
        }

        private RelayCommand acceptInvoiceCommand;

        public RelayCommand AcceptInvoiceCommand
        {
            get
            {
                if (acceptInvoiceCommand == null)
                {
                    acceptInvoiceCommand = new RelayCommand(AcceptInvoice);
                }
                return acceptInvoiceCommand;
            }
        }

        private RelayCommand rejectCommand;

        public RelayCommand RejectInvoiceCommand
        {
            get
            {
                if (rejectCommand == null)
                {
                    rejectCommand = new RelayCommand(RejectInvoice);
                }
                return rejectCommand;
            }
        }
        
        #endregion

    }
}