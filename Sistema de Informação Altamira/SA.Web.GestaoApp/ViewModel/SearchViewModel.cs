using System;
using System.Collections.Generic;
using System.Threading;
using System.Windows.Input;
using GestaoApp.Command;
using GestaoApp.Helpers;
using System.Collections.ObjectModel;
using System.Windows.Controls;
using GestaoApp.Controls;
using System.Windows.Data;
using SilverlightMessageBoxLibrary;
using System.Net;
using System.Windows.Browser;
//using System.Windows.Controls;
using System.Windows.Printing;
using Telerik.Windows.Controls;
using Telerik.Windows.Controls.GridView;

namespace GestaoApp.ViewModel
{
    public class SearchViewModel<T> : ViewModelBase
    {
        #region Attributes

        protected ObservableCollection<T> searchResultList;
        protected T selectedItem;
        protected string searchString;

        protected bool canadd = false;
        protected bool canedit = false;
        protected bool cansave = false;
        protected bool candelete = false;
        protected bool cansearch = false;
        protected bool canprint = false;
        protected bool canresetpassword = false;

        protected Timer searchchangedtimer;

        protected RelayCommand addcommand;
        protected RelayCommand editcommand;
        protected RelayCommand savecommand;
        protected RelayCommand deletecommand;
        protected RelayCommand searchcommand;
        protected RelayCommand searchchangedcommand;
        protected RelayCommand printcommand;
        protected RelayCommand resetpasswordcommand;

        #endregion

        #region Properties

        public virtual ObservableCollection<T> SearchResultList
        {
            get
            {
                if (searchResultList == null)
                    searchResultList = new ObservableCollection<T>();
                return searchResultList;
            }
            set
            {
                if ((object.ReferenceEquals(this.searchResultList, value) != true))
                {
                    searchResultList = value;
                    this.OnPropertyChanged("SearchResultList");
                    SelectedItem = default(T);

                    if (value == null)
                    {
                        this.CanAdd = false;
                        this.CanPrint = false;
                    }
                    else
                    {
                        this.CanAdd = true;
                        if (value.Count > 0)
                            this.CanPrint = true;
                        else
                            this.CanPrint = false;
                    }

                    this.CanEdit = false;
                    this.CanDelete = false;
                }
            }
        }

        public virtual T SelectedItem
        {
            get
            {
                if (selectedItem == null)
                    selectedItem = default(T);
                return selectedItem;
            }
            set
            {
                if ((object.ReferenceEquals(this.selectedItem, value) != true))
                {
                    selectedItem = value;
                    this.OnPropertyChanged("SelectedItem");

                    if (value != null)
                    {
                        this.CanEdit = true;
                        //this.CanDelete = true;
                    }
                    else
                    {
                        this.CanEdit = false;
                        //this.CanDelete = false;
                    }

                }
            }
        }

        public Timer SearchChangedTimer
        {
            get
            {
                if (searchchangedtimer == null)
                    SearchChangedTimer = new Timer(new TimerCallback(DispatchSearchCommand), this, Timeout.Infinite, Timeout.Infinite);
                return searchchangedtimer;
            }
            set
            {
                if ((object.ReferenceEquals(this.searchchangedtimer, value) != true))
                {
                    searchchangedtimer = value;
                    this.OnPropertyChanged("SearchChangedTimer");
                }
            }
        }

        #endregion

        #region Constructor
        public string SearchString
        {
            get
            {
                if (searchString == null)
                    searchString = "";
                return searchString;
            }
            set
            {
                if ((object.ReferenceEquals(this.searchString, value) != true))
                {
                    searchString = value;
                    this.OnPropertyChanged("SearchString");
                }
            }
        }

        #endregion

        #region Events
        #endregion

        #region Commands

        public bool CanAdd
        {
            get
            {
                return canadd;
            }
            set
            {
                if ((object.ReferenceEquals(this.canadd, value) != true))
                {
                    canadd = value;
                    this.OnPropertyChanged("CanAdd");
                }
            }
        }

        public bool CanEdit
        {
            get
            {
                return canedit;
            }
            set
            {
                if ((object.ReferenceEquals(this.canedit, value) != true))
                {
                    canedit = value;
                    this.OnPropertyChanged("CanEdit");
                }
            }
        }

        public bool CanSave
        {
            get
            {
                return cansave;
            }
            set
            {
                if ((object.ReferenceEquals(this.cansave, value) != true))
                {
                    cansave = value;
                    this.OnPropertyChanged("CanSave");
                }
            }
        }

        public bool CanDelete
        {
            get
            {
                return candelete;
            }
            set
            {
                if ((object.ReferenceEquals(this.candelete, value) != true))
                {
                    candelete = value;
                    this.OnPropertyChanged("CanDelete");
                }
            }
        }

        public bool CanSearch
        {
            get
            {
                return cansearch;
            }
            set
            {
                if ((object.ReferenceEquals(this.cansearch, value) != true))
                {
                    cansearch = value;
                    this.OnPropertyChanged("CanSearch");
                }
            }
        }

        public bool CanPrint
        {
            get
            {
                return canprint;
            }
            set
            {
                if ((object.ReferenceEquals(this.canprint, value) != true))
                {
                    canprint = value;
                    this.OnPropertyChanged("CanPrint");
                }
            }
        }

        public bool CanResetPassword
        {
            get
            {
                return canresetpassword;
            }
            set
            {
                if ((object.ReferenceEquals(this.canresetpassword, value) != true))
                {
                    canresetpassword = value;
                    this.OnPropertyChanged("CanResetPassword");
                }
            }
        }

        public bool CanAddCommand(object parameter)
        {
            return true; // canadd;
        }

        public bool CanEditCommand(object parameter)
        {
            return true; // canedit;
        }

        public bool CanSaveCommand(object parameter)
        {
            return true; // cansave;
        }

        public bool CanDeleteCommand(object parameter)
        {
            return true; // candelete;
        }

        public bool CanSearchCommand(object parameter)
        {
            return true; // cansearch;
        }

        public bool CanSearchChangedCommand(object parameter)
        {
            return true;
        }

        public bool CanPrintCommand(object parameter)
        {
            return true; // canprint;
        }

        public bool CanResetPasswordCommand(object parameter)
        {
            return true;
        }

        public static void DispatchSearchCommand(object state)
        {
            System.Windows.Deployment.Current.Dispatcher.BeginInvoke(new Action<object>((state as SearchViewModel<T>).Search), (state as SearchViewModel<T>).SearchString);
        }

        public ICommand AddCommand
        {
            get
            {
                if (addcommand == null)
                {
                    addcommand = new RelayCommand(Add, CanAddCommand);
                }
                return addcommand;
            }
        }

        public ICommand EditCommand
        {
            get
            {
                if (editcommand == null)
                {
                    editcommand = new RelayCommand(Edit, CanEditCommand);
                }
                return editcommand;
            }
        }

        public ICommand SaveCommand
        {
            get
            {
                if (savecommand == null)
                {
                    savecommand = new RelayCommand(Save, CanSaveCommand);
                }
                return savecommand;
            }
        }

        public ICommand DeleteCommand
        {
            get
            {
                if (deletecommand == null)
                {
                    deletecommand = new RelayCommand(Delete, CanDeleteCommand);
                }
                return deletecommand;
            }
        }

        public ICommand SearchCommand
        {
            get
            {
                if (searchcommand == null)
                {
                    searchcommand = new RelayCommand(Search, CanSearchCommand);
                }
                return searchcommand;
            }
        }

        public ICommand SearchChangedCommand
        {
            get
            {
                if (searchchangedcommand == null)
                {
                    searchchangedcommand = new RelayCommand(SearchChanged, CanSearchChangedCommand);
                }
                return searchchangedcommand;
            }
        }

        public ICommand PrintCommand
        {
            get
            {
                if (printcommand == null)
                {
                    printcommand = new RelayCommand(Print, CanPrintCommand);
                }
                return printcommand;
            }
        }

        public ICommand ResetPasswordCommand
        {
            get
            {
                if (resetpasswordcommand == null)
                {
                    resetpasswordcommand = new RelayCommand(ResetPassword, CanResetPasswordCommand);
                }
                return resetpasswordcommand;
            }
        }

        public virtual void Add(object parameter)
        {
        }

        public virtual void Edit(object parameter)
        {
        }

        public virtual void Save(object parameter)
        {
        }

        public virtual void Delete(object parameter)
        {
            if (SelectedItem != null)
            {
                CustomMessage confirmMessage = new CustomMessage("Confirma a exclusão deste item", CustomMessage.MessageType.Confirm);

                confirmMessage.OKButton.Click += (obj, args) =>
                {
                    SearchResultList.Remove(SelectedItem);
                    SelectedItem = default(T);
                };

                confirmMessage.Show();
            }
        }

        public virtual void Search(object parameter)
        {
        }

        public virtual void ResetPassword(object parameter)
        {
        }

        public void SearchChanged(object parameter)
        {
            SearchChangedTimer.Change(1000, Timeout.Infinite);
        }

        private string printName = Guid.NewGuid().ToString() + ".html";
        public virtual void Print(object parameter)
        {
            if ((parameter as DataPager) == null)
                return;

            const string printScript = @"<script type=""text/javascript"">print();setTimeout(function(){close();}, 0);</script>";

            printName = "PrintSpool/" + Guid.NewGuid().ToString() + ".html";
            (parameter as DataPager).PageSize = 0;
            Uri uri = new Uri(HtmlPage.Document.DocumentUri, String.Format("PrintHandler.aspx?fn={0}", HttpUtility.UrlEncode(printName)));
            WebClient client = new WebClient();
            client.UploadStringCompleted += new UploadStringCompletedEventHandler(UploadStringCompleted);
            client.UploadStringAsync(uri, String.Format("{0}{1}", ((parameter as DataPager).Source as RadGridView).ToHtml(), printScript));

            return;
        }

        void UploadStringCompleted(object sender, UploadStringCompletedEventArgs e)
        {
            HtmlPage.Window.Navigate(new Uri(HtmlPage.Document.DocumentUri, printName), "_blank", "menubar=0;toolbar=0;fullscreen=1;");
        }

        #endregion

    }
}
