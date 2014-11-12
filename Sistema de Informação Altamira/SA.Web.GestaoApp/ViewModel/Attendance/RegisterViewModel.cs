using System;
using System.Collections.ObjectModel;
using System.ComponentModel;
using System.Linq;
using System.Windows;
using System.Windows.Controls;
using System.Xml.Linq;
using GestaoApp.Helpers;
using GestaoApp.Models.Attendance;
using GestaoApp.Models.Sales;
using GestaoApp.View.Attendance;
using GestaoApp.ViewModel.Sales;
using SilverlightMessageBoxLibrary;

namespace GestaoApp.ViewModel.Attendance
{
    public class RegisterViewModel : SearchViewModel<Register>
    {
        #region Attributes

        private ClientViewModel clientviewmodel;

        #endregion

        #region TimeNav Properties

        private DateTime _StartDate = DateTime.Now.Date;
        private DateTime _EndDate = DateTime.Now.Date;
        private DateTime _VisibleStartDate = DateTime.Now.Date.AddMonths(-1);
        private DateTime _VisibleEndDate = DateTime.Now.Date;
        private DateTime _SelectionStartDate = DateTime.Now.Date.AddYears(-1);
        private DateTime _SelectionEndDate = DateTime.Now.Date;

        private void SetDataContent()
        {
            this.StartDate = DateTime.Now.AddYears(-1).Date;
            this.EndDate = DateTime.Now.Date.AddDays(1);
            this.VisibleStartDate = DateTime.Now.AddDays(-30).Date;
            this.VisibleEndDate = DateTime.Now.Date.AddDays(1).AddMinutes(-1);
            this.SelectionStartDate = DateTime.Now.Date;
            this.SelectionEndDate = DateTime.Now.Date.AddDays(1).AddMinutes(-1);
        }

        public DateTime StartDate
        {
            get
            {
                return _StartDate;
            }
            set
            {

                if (this._StartDate == value)
                    return;

                this._StartDate = value;
                this.OnPropertyChanged("StartDate");
            }
        }

        public DateTime EndDate
        {
            get
            {
                return _EndDate;
            }
            set
            {
                if (this._EndDate == value)
                    return;

                this._EndDate = value;
                this.OnPropertyChanged("EndDate");
            }
        }

        public DateTime VisibleStartDate
        {
            get
            {
                return _VisibleStartDate;
            }
            set
            {

                if (this._VisibleStartDate == value)
                    return;

                this._VisibleStartDate = value;
                this.OnPropertyChanged("VisibleStartDate");
            }
        }

        public DateTime VisibleEndDate
        {
            get
            {
                return _VisibleEndDate;
            }
            set
            {

                if (this._VisibleEndDate == value)
                    return;

                this._VisibleEndDate = value;
                this.OnPropertyChanged("VisibleEndDate");
            }
        }

        public DateTime SelectionStartDate
        {
            get
            {
                return _SelectionStartDate;
            }
            set
            {

                if (this._SelectionStartDate == value)
                    return;

                this._SelectionStartDate = value;
                this.OnPropertyChanged("SelectionStartDate");
                this.OnPropertyChanged("TimeTitle");
            }
        }

        public DateTime SelectionEndDate
        {
            get
            {
                return _SelectionEndDate;
            }
            set
            {

                if (this._SelectionEndDate == value)
                    return;

                this._SelectionEndDate = value;
                this.OnPropertyChanged("SelectionEndDate");
                this.OnPropertyChanged("TimeTitle");
            }
        }

        public String TimeTitle
        {
            get
            {
                return string.Format("Período de consulta {0} {1} a {2} {3}", SelectionStartDate.ToShortDateString(), SelectionStartDate.ToShortTimeString(), SelectionEndDate.ToShortDateString(), SelectionEndDate.ToShortTimeString());
            }
        }
        #endregion

        #region Properties
        public override Register SelectedItem
        {
            get
            {
                if (selectedItem == null)
                    selectedItem = new Register();
                return selectedItem;
            }
            set
            {
                if ((object.ReferenceEquals(this.selectedItem, value) != true))
                {
                    selectedItem = value;

                    if (selectedItem != null)
                        ClientViewModel.SelectedItem = SelectedItem.Client;
                    else
                        ClientViewModel.SelectedItem = null;

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

                    OnPropertyChanged("SelectedItem");
                }
            }
        }

        public ClientViewModel ClientViewModel
        {
            get
            {
                if (clientviewmodel == null)
                    clientviewmodel = new ClientViewModel();
                return clientviewmodel;
            }
            set
            {
                if ((object.ReferenceEquals(this.clientviewmodel, value) != true))
                {
                    clientviewmodel = value;
                    OnPropertyChanged("ClientViewModel");
                }
            }
        }

        #endregion

        #region Constructor
        public RegisterViewModel(string parameter)
        {
            CanAdd = true;
            CanSearch = true;

            SetDataContent();

            if (!DesignerProperties.GetIsInDesignMode(Application.Current.RootVisual))
                Search(parameter);
        }

        public RegisterViewModel()
        {
            CanAdd = true;
            CanSearch = true;

            SetDataContent();
        }

        #endregion

        #region Events
        #endregion

        #region Commands

        RegisterFormView childWindow;
        Register PendingChanges;

        public override void Add(object parameter)
        {
            RegisterViewModel viewmodel = new RegisterViewModel();
            viewmodel.SelectedItem = new Register();
            childWindow = new RegisterFormView();
            childWindow.OnSave = new EventHandler(OnAddComplete);
            childWindow.DataContext = viewmodel;
            childWindow.Show();
        }

        public void OnAddComplete(object sender, EventArgs e)
        {
            if (sender is RegisterFormView)
            {
                PendingChanges = ((sender as ChildWindow).DataContext as RegisterViewModel).selectedItem as Register;
                PendingChanges.ToSMS();
            }

            if (PendingChanges != null)
            {
                if (PendingChanges.SMS.Text.Length > 140)
                {
                    CustomMessage msg = new CustomMessage("A mensagem não pode ter mais que 140 caracteres.", CustomMessage.MessageType.Info);

                    msg.OKButton.Click += (obj, args) =>
                    {
                        MessageViewModel viewmodel = new MessageViewModel();
                        viewmodel.SelectedItem = PendingChanges.SMS;
                        MessageFormView childWindowMessage = new MessageFormView();
                        childWindowMessage.VendorAutoCompleteComboBox.IsEnabled = false;
                        childWindowMessage.OnEditComplete = new EventHandler(OnAddComplete);
                        childWindowMessage.DataContext = viewmodel;
                        childWindowMessage.UpdateBinding();
                        childWindowMessage.Show();
                    };

                    msg.Show();
                }
                else
                {
                    try
                    {
                        HttpRequestHelper httpRequest =
                            new HttpRequestHelper(
                                new Uri(string.Format("http://{0}:{1}/Attendance.Register.CommitChanges?{2}", Application.Current.Host.Source.Host, Application.Current.Host.Source.Port, Session.Guid)),
                                "POST",
                                new XDocument(PendingChanges.ToXML));

                        httpRequest.ResponseComplete += new HttpResponseCompleteEventHandler(OnAddRequestComplete);
                        httpRequest.Execute();
                    }
                    catch (Exception ex)
                    {
                        CustomMessage msg = new CustomMessage(ex.Message, CustomMessage.MessageType.Error);
                        msg.Show();
                    }
                }
            }
        }

        public void OnAddRequestComplete(HttpResponseCompleteEventArgs e)
        {
            if (System.Windows.Deployment.Current.Dispatcher.CheckAccess())
            {
                if (e.Error == null)
                {
                    XDocument xParse = e.XmlResponse;

                    Error error = (from c in xParse.Descendants("Error")
                                   select new Error()
                                   {
                                       Id = Convert.ToInt32(c.Attribute("Id").Value),
                                       Message = c.Value,
                                   }).FirstOrDefault();

                    if (error == null)
                    {
                        Error result = (from c in xParse.Descendants("CommitChanges")
                                        select new Error()
                                        {
                                            Id = Convert.ToInt32(c.Attribute("Id").Value),
                                            Message = c.Value,
                                        }).FirstOrDefault();

                        if (result != null)
                        {
                            CustomMessage msg = new CustomMessage(result.Message, CustomMessage.MessageType.Info);
                            msg.Show();

                            PendingChanges.Id = result.Id;

                            SearchResultList.Insert(0, PendingChanges);
                            SelectedItem = PendingChanges;

                            if (childWindow != null)
                                childWindow.DialogResult = true;
                        }
                    }
                    else
                    {
                        if (childWindow != null)
                        {
                            childWindow.SaveButton.Content = "Gravar";
                            childWindow.SaveButton.IsEnabled = true;
                        }

                        CustomMessage msg = new CustomMessage(error.Message, CustomMessage.MessageType.Error);
                        msg.Show();
                    }

                    PendingChanges = null;
                }
                else
                {
                    CustomMessage msg = new CustomMessage("Erro na execução da operação:\n\n" + e.Error.Message.ToString() + "\n\n" + e.Error.Data.ToString() + "\n\n" + e.Error.ToString(), CustomMessage.MessageType.Error);
                    msg.Show();
                }
            }
            else
                System.Windows.Deployment.Current.Dispatcher.BeginInvoke(new Action<HttpResponseCompleteEventArgs>(OnAddRequestComplete), e);
        }

        public override void Edit(object parameter)
        {
            SelectedItem.Send = false;
            RegisterViewModel viewmodel = new RegisterViewModel();
            viewmodel.SelectedItem = SelectedItem.Clone();
            childWindow = new RegisterFormView();
            childWindow.DataContext = viewmodel;
            childWindow.OnSave = new EventHandler(OnEditComplete);
            childWindow.Show();

            childWindow.UpdateSelectionBinding();
        }

        public void OnEditComplete(object sender, EventArgs e)
        {
            if (sender is RegisterFormView)
            {
                PendingChanges = ((sender as ChildWindow).DataContext as RegisterViewModel).selectedItem as Register;
                PendingChanges.ToSMS();
            }

            if (PendingChanges != null)
            {
                if (PendingChanges.SMS.Text.Length > 140)
                {
                    CustomMessage msg = new CustomMessage("A mensagem não pode ter mais que 140 caracteres.", CustomMessage.MessageType.Info);

                    msg.OKButton.Click += (obj, args) =>
                    {
                        MessageViewModel viewmodel = new MessageViewModel();
                        viewmodel.SelectedItem = PendingChanges.SMS;
                        MessageFormView childWindowMessage = new MessageFormView();
                        childWindowMessage.VendorAutoCompleteComboBox.IsEnabled = false;
                        childWindowMessage.OnEditComplete = new EventHandler(OnEditComplete);
                        childWindowMessage.DataContext = viewmodel;
                        childWindowMessage.UpdateBinding();
                        childWindowMessage.Show();
                    };

                    msg.Show();
                }
                else
                {
                    try
                    {
                        HttpRequestHelper httpRequest =
                            new HttpRequestHelper(
                                new Uri(string.Format("http://{0}:{1}/Attendance.Register.CommitChanges?{2}", Application.Current.Host.Source.Host, Application.Current.Host.Source.Port, Session.Guid)),
                                "POST",
                                new XDocument(PendingChanges.ToXML));

                        httpRequest.ResponseComplete += new HttpResponseCompleteEventHandler(OnEditRequestComplete);
                        httpRequest.Execute();
                    }
                    catch (Exception ex)
                    {
                        CustomMessage msg = new CustomMessage(ex.Message, CustomMessage.MessageType.Error);
                        msg.Show();
                    }
                }
            }
        }

        public void OnEditRequestComplete(HttpResponseCompleteEventArgs e)
        {
            if (System.Windows.Deployment.Current.Dispatcher.CheckAccess())
            {
                if (e.Error == null)
                {
                    XDocument xParse = e.XmlResponse;

                    Error error = (from c in xParse.Descendants("Error")
                                   select new Error()
                                   {
                                       Id = Convert.ToInt32(c.Attribute("Id").Value),
                                       Message = c.Value,
                                   }).FirstOrDefault();

                    if (error == null)
                    {
                        Error result = (from c in xParse.Descendants("CommitChanges")
                                        select new Error()
                                        {
                                            Id = Convert.ToInt32(c.Attribute("Id").Value),
                                            Message = c.Value,
                                        }).FirstOrDefault();

                        if (result != null)
                        {
                            CustomMessage msg = new CustomMessage(result.Message, CustomMessage.MessageType.Info);
                            msg.Show();

                            /*int i = Client.Collection.IndexOf(Client.Collection.Where(c => c.Id == SelectedItem.Client.Id).First());
                            if (i >= 0)
                            {
                                Client.Collection.RemoveAt(i);
                                Client.Collection.Insert(i, PendingChanges.Client);
                            }
                            else
                                throw new Exception("Dados do Cliente inconsistente !");*/

                            int i = SearchResultList.IndexOf(SearchResultList.Where(c => c.Id == SelectedItem.Id).First());
                            if (i >= 0)
                            {
                                SearchResultList.RemoveAt(i);
                                SearchResultList.Insert(i, PendingChanges);
                            }
                            else
                                throw new Exception("Dados do Atendimento inconsistente !");

                            SelectedItem = PendingChanges;

                            if (childWindow != null)
                                childWindow.DialogResult = true;
                        }
                    }
                    else
                    {
                        if (childWindow != null)
                        {
                            childWindow.SaveButton.Content = "Gravar";
                            childWindow.SaveButton.IsEnabled = true;
                        }

                        CustomMessage msg = new CustomMessage(error.Message, CustomMessage.MessageType.Error);
                        msg.Show();
                    }

                    PendingChanges = null;
                }
                else
                {
                    CustomMessage msg = new CustomMessage("Erro na execução da operação:\n\n" + e.Error.Message.ToString() + "\n\n" + e.Error.Data.ToString() + "\n\n" + e.Error.ToString(), CustomMessage.MessageType.Error);
                    msg.Show();
                }
            }
            else
                System.Windows.Deployment.Current.Dispatcher.BeginInvoke(new Action<HttpResponseCompleteEventArgs>(OnEditRequestComplete), e);
        }

        public override void Search(object parameter)
        {
            try
            {
                HttpRequestHelper httpRequest =
                    new HttpRequestHelper(
                        new Uri(string.Format("http://{0}:{1}/Attendance.Register.Search?{2}", Application.Current.Host.Source.Host, Application.Current.Host.Source.Port, Session.Guid)),
                        "POST",
                        new XDocument
                        (
                            new XElement("Query", new XAttribute("StartDate", SelectionStartDate), new XAttribute("EndDate", SelectionEndDate), SearchString)
                        ));

                httpRequest.ResponseComplete += new HttpResponseCompleteEventHandler(OnSearchCompleted);
                httpRequest.Execute();
            }
            catch (Exception ex)
            {
                CustomMessage msg = new CustomMessage(ex.Message, CustomMessage.MessageType.Error);
                msg.Show();
            }
        }

        public void OnSearchCompleted(HttpResponseCompleteEventArgs e)
        {
            if (System.Windows.Deployment.Current.Dispatcher.CheckAccess())
            {
                if (e.Error == null)
                {
                    XDocument xParse = e.XmlResponse;

                    Error error = (from c in xParse.Descendants("Error")
                                   select new Error()
                                   {
                                       Id = Convert.ToInt32(c.Attribute("Id").Value),
                                       Message = c.Value,
                                   }).FirstOrDefault();

                    if (error == null)
                    {
                        SearchResultList = new ObservableCollection<Register>
                            (from register in xParse.Descendants("Register")
                             select new Register()
                             {
                                 ToXML = register,
                             });

                    }
                    else
                    {
                        CustomMessage msg = new CustomMessage(error.Message, CustomMessage.MessageType.Error);
                        msg.Show();
                    }
                }
                else
                {
                    CustomMessage msg = new CustomMessage("Erro na execução da operação:\n\n" + e.Error.Message.ToString() + "\n\n" + e.Error.Data.ToString() + "\n\n" + e.Error.ToString(), CustomMessage.MessageType.Error);
                    msg.Show();
                }
            }
            else
                System.Windows.Deployment.Current.Dispatcher.BeginInvoke(new Action<HttpResponseCompleteEventArgs>(OnSearchCompleted), e);
        }
        #endregion
    }
}
