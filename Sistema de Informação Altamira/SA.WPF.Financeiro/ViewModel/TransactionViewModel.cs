using System;
using System.Collections.ObjectModel;
using System.ComponentModel;
using System.Diagnostics;
using System.Windows.Input;
using GalaSoft.MvvmLight.Command;
using GalaSoft.MvvmLight.Messaging;
using SA.WPF.Financial.Model;
using System.Data.Entity;
using System.Linq;
using System.Windows;
using System.Data;
using System.Windows.Data;
using System.Collections.Generic;
using GalaSoft.MvvmLight;
using SA.WPF.Financial.Model.Filters;
using SA.WPF.Financial.Enum;
using SA.WPF.Financial.Extension;
using SA.WPF.Financial.View;

namespace SA.WPF.Financial.ViewModel
{
    public class TransactionViewModel : ViewModelBase
    {
        #region Contexto

        IMessenger Messeger = Messenger.Default;

        Context context = new Context();

        #endregion

        #region Filtro

        private DateTime?   startDate, endDate;
        private LIQUIDATED liquidated = LIQUIDATED.NO;

        #endregion

        #region Properties

        private Bank bankSelectedItem;
        private Agency agencySelectedItem;
        private Account accountSelectedItem;
        private Transaction transactionSelectedItem;

        private ObservableCollection<Transaction> transactionCollection;

        public Bank BankSelectedItem
        {
            get
            {
                if (bankSelectedItem == null)
                    bankSelectedItem = new Bank();

                return bankSelectedItem;
            }
            set
            {
                if ((object.ReferenceEquals(this.BankSelectedItem, value) != true))
                {
                    BankSelectedItem = value;
                    this.RaisePropertyChanged("BankSelectedItem");
                }
            }
        }

        public Agency AgencySelectedItem
        {
            get
            {
                if (agencySelectedItem == null)
                    agencySelectedItem = new Agency();

                return agencySelectedItem;
            }
            set
            {
                if ((object.ReferenceEquals(this.AgencySelectedItem, value) != true))
                {
                    agencySelectedItem = value;
                    this.RaisePropertyChanged("AgencySelectedItem");
                }
            }
        }

        public Account AccountSelectedItem
        {
            get
            {
                //if (AccountSelectedItem == null)
                    //AccountSelectedItem = new Account();

                return accountSelectedItem;
            }
            set
            {
                if ((object.ReferenceEquals(this.accountSelectedItem, value) != true))
                {
                    accountSelectedItem = value;
                    this.RaisePropertyChanged("AccountSelectedItem");

                    if (value != null)
                    {
                        CanAdd = true;
                        CanFilter = true;

                        Filter();
                    }
                    else
                    {
                        CanAdd = true;
                        CanFilter = false;
                    }
                }
            }
        }

        public Transaction TransactionSelectedItem
        {
            get
            {
                //if (transactionSelectedItem == null)
                //    transactionSelectedItem = new Transaction();

                return transactionSelectedItem;
            }
            set
            {
                if ((object.ReferenceEquals(this.transactionSelectedItem, value) != true))
                {
                    transactionSelectedItem = value;
                    this.RaisePropertyChanged("TransactionSelectedItem");

                    if (value != null)
                    {
                        this.CanEdit = true;
                        this.CanSave = true;
                        this.CanDelete = true;
                    }
                    else
                    {
                        this.CanEdit = false;
                        this.CanSave = false;
                        this.CanDelete = false;
                    }
                }
            }
        }

        public ObservableCollection<Bank> Bank
        {
            get
            {
                return context.Bank.Local;
            }
        }

        public ObservableCollection<Agency> Agencies
        {
            get
            {
                return context.Agencies.Local;
            }
        }

        public ObservableCollection<Account> Accounts
        {
            get
            {
                return context.Accounts.Local;
            }
        }

        public ObservableCollection<Transaction> TransactionCollection
        {
            get
            {
                //return TransactionCollection;
                return context.Transactions.Local;
            }
            //set
            //{
            //    transactionCollection = value;
            //    RaisePropertyChanged("TransactionCollection");
            //}
        }

        public LIQUIDATED Liquidated
        {
            get
            {
                return liquidated;
            }
            set
            {
                liquidated = value;
                RaisePropertyChanged("liquidated");
            }
        }

        public DateTime? StartDate
        {
            get
            {
                return startDate;
            }
            set
            {
                startDate = value;
                RaisePropertyChanged("StartDate");
            }
        }

        public DateTime? EndDate
        {
            get
            {
                return endDate;
            }
            set
            {
                endDate = value;
                RaisePropertyChanged("EndDate");
            }
        }

        #endregion

        #region Constructors

        public TransactionViewModel()
        {
            try
            {
                //this.TransactionCollection = new ObservableCollection<Transaction>();
                //context.ApplyFilters(new List<IFilter<Context>>() 
                //                {
                //                    new TransactionFilter(AccountSelectedItem,
                //                                        liquidated,
                //                                        StartDate,
                //                                        EndDate)
                //                });

                context.Bank.Include("Agencies.Accounts").Load();
                //context.Transactions.Load();

                //this.TransactionCollection = context.Transactions.Local;

                //this.TransactionCollection.CollectionChanged += new System.Collections.Specialized.NotifyCollectionChangedEventHandler(TransactionCollectionChanged);

            }
            catch (Exception ex)
            {
                Messeger.Send(new GalaSoft.MvvmLight.Messaging.DialogMessage(ex.Message, result =>
                {
                }), "OnAddErrorMessageBox");
            }
        }

        void TransactionCollectionChanged(object sender, System.Collections.Specialized.NotifyCollectionChangedEventArgs e)
        {
            decimal balance = AccountSelectedItem.Balance;

            foreach (Transaction m in this.TransactionCollection)
            {
                balance += m.Value;
                m.Balance = balance;
            }

        }

        #endregion

        #region Comandos

        private RelayCommand addCommand;
        private RelayCommand editCommand;
        private RelayCommand saveCommand;
        private RelayCommand deleteCommand;
        private RelayCommand filterCommand;
        private RelayCommand searchCommand;
        private RelayCommand<CancelEventArgs> closeCommand;

        bool canAdd = false;
        bool canEdit = false;
        bool canSave = false;
        bool canDelete = false;
        bool canFilter = false;
        bool canSearch = false;
        bool canClose = false;

        public bool CanAdd
        {
            get
            {
                return canAdd;
            }
            set
            {
                canAdd = value;
                RaisePropertyChanged("CanAdd");
            }
        }

        public bool CanEdit
        {
            get
            {
                return canEdit; // TransactionSelectedItem != null;
            }
            set
            {
                canEdit = value;
                RaisePropertyChanged("CanEdit");
            }
        }

        public bool CanSave
        {
            get
            {
                return canSave; // TransactionSelectedItem != null;
            }
            set
            {
                canSave = value;
                RaisePropertyChanged("CanSave");
            }
        }

        public bool CanDelete
        {
            get
            {
                return canDelete; // TransactionSelectedItem != null;
            }
            set
            {
                canDelete = value;
                RaisePropertyChanged("CanDelete");
            }
        }

        public bool CanFilter
        {
            get
            {
                return canFilter && AccountSelectedItem != null; // && liquidated != null;
            }
            set
            {
                canFilter = value;
                RaisePropertyChanged("CanFilter");
            }
        }

        public bool CanSearch
        {
            get
            {
                return canSearch;
            }
            set
            {
                canSearch = value;
                RaisePropertyChanged("CanSearch");
            }
        }

        public bool CanClose
        {
            get
            {
                return canClose;
            }
            set
            {
                canClose = value;
                RaisePropertyChanged("CanClose");
            }
        }

        public RelayCommand AddCommand
        {
            get
            {
                if (addCommand == null)
                {
                    addCommand = new RelayCommand(() => this.Add(), () => CanAdd);
                }
                return addCommand;
            }
        }

        public RelayCommand EditCommand
        {
            get
            {
                if (editCommand == null)
                {
                    editCommand = new RelayCommand(() => this.Edit(), () => CanEdit);
                }
                return editCommand;
            }
        }

        public RelayCommand SaveCommand
        {
            get
            {
                if (saveCommand == null)
                {
                    saveCommand = new RelayCommand(() => this.Save(), () => CanSave);
                }
                return saveCommand;
            }
        }

        public RelayCommand DeleteCommand
        {
            get
            {
                if (deleteCommand == null)
                {
                    deleteCommand = new RelayCommand(() => this.Delete(), () => CanDelete);
                }
                return deleteCommand;
            }
        }

        public RelayCommand FilterCommand
        {
            get
            {
                if (filterCommand == null)
                {
                    filterCommand = new RelayCommand(() => this.Filter(), () => CanFilter);
                }
                return filterCommand;
            }
        }

        public RelayCommand SearchCommand
        {
            get
            {
                if (searchCommand == null)
                {
                    searchCommand = new RelayCommand(() => this.Search(), () => CanSearch);
                }
                return searchCommand;
            }
        }

        public RelayCommand<CancelEventArgs> CloseCommand
        {
            get
            {
                if (closeCommand == null)
                    closeCommand = new RelayCommand<CancelEventArgs>(Close);

                return closeCommand;
            }
        }

        #endregion

        #region Metodos

        private void Add()
        {
            try
            {
                TransactionSelectedItem = new Transaction();
                TransactionSelectedItem.Account = AccountSelectedItem;

                context.Transactions.Add(TransactionSelectedItem);
                TransactionCollection.Add(TransactionSelectedItem);

                Messeger.Send<NotificationMessage>(new NotificationMessage("LancamentoView"));
            }
            catch (Exception ex)
            {
                Messeger.Send(new GalaSoft.MvvmLight.Messaging.DialogMessage(ex.Message, result =>
                {
                }), "OnAddErrorMessageBox");
            }
        }

        private void Edit()
        {
            try
            {
                Messeger.Send<NotificationMessage>(new NotificationMessage("LancamentoView"));
            }
            catch (Exception ex)
            {
                Messeger.Send(new GalaSoft.MvvmLight.Messaging.DialogMessage(ex.Message, result =>
                {
                }), "OnEditErrorMessageBox");
            }
        }

        private void Save()
        {
            try
            {
                //context.SaveChanges(AccountSelectedItem);

                Messeger.Send(new GalaSoft.MvvmLight.Messaging.DialogMessage(null, result =>
                {
                }), "OnSaveSucessMessageBox");
            }
            catch (Exception ex)
            {
                Messeger.Send(new GalaSoft.MvvmLight.Messaging.DialogMessage(ex.Message, result =>
                {
                }), "OnSaveErrorMessageBox");
            }
        }

        private void Delete()
        {
            try
            {
                Messeger.Send(new GalaSoft.MvvmLight.Messaging.DialogMessage(null, result =>
                {
                    Debug.WriteLine(result.ToString());

                    if (result == System.Windows.MessageBoxResult.Yes)
                    {
                        context.Transactions.Remove(TransactionSelectedItem);

                        context.Transactions.Local.Remove(TransactionSelectedItem);

                        TransactionCollection.Remove(TransactionSelectedItem);

                        // TODO Criar um metodo especifico para atualizar TransactionCollection
                        bool i = Convert.ToBoolean(liquidated);

                        TransactionCollection = new ObservableCollection<Transaction>(context.Transactions.Local.Where(m => m.Account.Id == AccountSelectedItem.Id
                                                && (liquidated == liquidated.TODOS || m.liquidated == i)
                                                && ((!StartDate.HasValue || !EndDate.HasValue) || (m.Data >= StartDate && m.Data <= EndDate))));

                        this.TransactionCollection.CollectionChanged += new System.Collections.Specialized.NotifyCollectionChangedEventHandler(TransactionCollectionChanged);

                    }

                }), "OnDeleteConfirmMessageBox");
            }
            catch (Exception ex)
            {
                Messeger.Send(new GalaSoft.MvvmLight.Messaging.DialogMessage(ex.Message, result =>
                {
                    
                }), "OnDeleteErrorMessageBox");
            }
        }

        private void Filter()
        {
            if (!CanFilter)
            {
                Messeger.Send(new GalaSoft.MvvmLight.Messaging.DialogMessage(null, result =>
                {
                }), "OnFilterMessageBox");

                return;
            }

            context.ApplyFilters(new List<IFilter<Context>>() 
                                {
                                    new TransactionFilter(AccountSelectedItem,
                                                        liquidated,
                                                        StartDate,
                                                        EndDate)
                                });

            context.Transactions.Load();

            //bool i = Convert.ToBoolean(liquidated);

            //context.Transactions.Where(m => m.Account.Id == AccountSelectedItem.Id
            //                        && (liquidated == liquidated.TODOS || m.liquidated == i)
            //                        && ((!StartDate.HasValue || !EndDate.HasValue) || (m.Data >= StartDate && m.Data <= EndDate))).Load();

            //TransactionCollection = new ObservableCollection<Transaction>(context.Transactions.Local.Where(m => m.Account.Id == AccountSelectedItem.Id
            //                        && (liquidated == liquidated.TODOS || m.liquidated == i)
            //                        && ((!StartDate.HasValue || !EndDate.HasValue) || (m.Data >= StartDate && m.Data <= EndDate))));

            //this.TransactionCollection.CollectionChanged += new System.Collections.Specialized.NotifyCollectionChangedEventHandler(TransactionCollectionChanged);

        }

        private void Search()
        {
        }

        private void Close(CancelEventArgs e)
        {
            if (context.ChangeTracker.Entries().Any(
                            entity => entity.State == EntityState.Added ||
                            entity.State == EntityState.Deleted ||
                            entity.State == EntityState.Modified))
            {
                //Messeger.Send<GalaSoft.MvvmLight.Messaging.NotificationMessageWithCallback>(new NotificationMessageWithCallback("Deseja gravar as alterações pendentes antes de sair do programa ?", result =>
                //{
                //    if (result == MessageBoxResult.Yes)
                //    {
                //        context.SaveChanges(AccountSelectedItem);
                //    }
                //    else if (result == System.Windows.MessageBoxResult.Cancel)
                //    {
                //        if (e != null)
                //            e.Cancel = true;
                //    }

                //}), "OnCloseMessageBox");
            }
        }

        #endregion

    }
}
