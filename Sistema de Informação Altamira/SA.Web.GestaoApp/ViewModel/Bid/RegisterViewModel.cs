using System;
using System.Collections.ObjectModel;
using System.ComponentModel;
using System.Linq;
using System.Windows;
using System.Xml.Linq;
using GestaoApp.Helpers;
using GestaoApp.Models.Bid;
using GestaoApp.Models.Sales;
using GestaoApp.View.Bid;
using GestaoApp.ViewModel.Sales;
using SilverlightMessageBoxLibrary;
using GestaoApp.Command;
using System.Windows.Input;
using Telerik.Windows.Controls;
using GestaoApp.Models;
using System.Windows.Browser;

namespace GestaoApp.ViewModel.Bid
{
    public class RegisterViewModel : SearchViewModel<Register>
    {
        #region Attributes

        private DateTime _StartDate = DateTime.Now.Date;
        private DateTime _EndDate = DateTime.Now.Date;
        private DateTime _VisibleStartDate = DateTime.Now.Date.AddMonths(-1);
        private DateTime _VisibleEndDate = DateTime.Now.Date;
        private DateTime _SelectionStartDate = DateTime.Now.Date.AddYears(-1);
        private DateTime _SelectionEndDate = DateTime.Now.Date;

        private ClientViewModel clientviewmodel;

        #endregion

        #region TimeNav Properties
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
                        this.CanViewDocument = true;
                        this.CanViewProject = true;
                    }
                    else
                    {
                        this.CanEdit = false;
                        //this.CanDelete = false;
                        this.CanViewDocument = false;
                        this.CanViewProject = false;
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

        #region ViewCommands

        protected bool canviewdocument = false;
        protected bool canviewproject = false;

        protected RelayCommand viewdocumentcommand;
        protected RelayCommand viewprojectcommand;

        public bool CanViewDocument
        {
            get
            {
                return canviewdocument;
            }
            set
            {
                if ((object.ReferenceEquals(this.canviewdocument, value) != true))
                {
                    canviewdocument = value;
                    this.OnPropertyChanged("CanViewDocument");
                }
            }
        }

        public bool CanViewProject
        {
            get
            {
                return canviewproject;
            }
            set
            {
                if ((object.ReferenceEquals(this.canviewproject, value) != true))
                {
                    canviewproject = value;
                    this.OnPropertyChanged("CanViewProject");
                }
            }
        }

        public bool CanViewDocumentCommand(object parameter)
        {
            return true; // canadd;
        }

        public bool CanViewProjectCommand(object parameter)
        {
            return true; // canedit;
        }


        public ICommand ViewDocumentCommand
        {
            get
            {
                if (viewdocumentcommand == null)
                {
                    viewdocumentcommand = new RelayCommand(ViewDocument, CanViewDocumentCommand);
                }
                return viewdocumentcommand;
            }
        }

        public ICommand ViewProjectCommand
        {
            get
            {
                if (viewprojectcommand == null)
                {
                    viewprojectcommand = new RelayCommand(ViewProject, CanViewProjectCommand);
                }
                return viewprojectcommand;
            }
        }

        public virtual void ViewDocument(object parameter)
        {
            if (SelectedItem.Documents.Count == 0)
            {
                CustomMessage msg = new CustomMessage("Nenhum arquivo encontrado !", CustomMessage.MessageType.Info);
                msg.Show();
                return;
            } 
            else if (SelectedItem.Documents.Count == 1)
                OpenDocument(SelectedItem.Documents.First(), new EventArgs());
            else
            {
                DocumentViewModel viewmodel = new DocumentViewModel();
                viewmodel.SearchResultList = SelectedItem.Documents;

                DocumentView childDocument = new DocumentView();
                childDocument.DataContext = viewmodel;
                childDocument.OnSelect = new EventHandler(OpenDocument);
                childDocument.Show();
            }

        }

        private void OpenDocument(object sender, EventArgs e)
        {
            if ((sender as Document) == null)
                return;

            if (GestaoApp.ViewModel.ViewModelBase.Session.Rules != "*" &&
                !GestaoApp.ViewModel.ViewModelBase.Session.Rules.Contains("Bid Register"))
            {
                CustomMessage msg = new CustomMessage("Acesso negado !", CustomMessage.MessageType.Error);
                msg.Show();
                return;
            }

            foreach (RadPane p in ((MainPage)App.Current.RootVisual).radPaneGroup.Items)
            {
                if (p.Content != null)
                {
                    if (p.Content.GetType() == typeof(GestaoApp.View.HTMLHostView) &&
                        p.Header.ToString() == "Orçamento " + (sender as Document).Name.Trim())
                    {
                        p.IsSelected = true;
                        return;
                    }
                }
            }

            RadPane n = new RadPane();

            n.Header = "Orçamento " + (sender as Document).Name.Trim();

            GestaoApp.View.HTMLHostView view = new GestaoApp.View.HTMLHostView();
            //view.htmlHost.SourceUri = new Uri(string.Format("http://{0}:{1}/Sales.Bid.Document?guid={2}&id={3}&rev={4}&doc={5}", 
            view.htmlHost.SourceUri = new Uri(string.Format("http://{0}:{1}/Sales.Bid.Document?{2}&{3}&{4}&{5}", 
                Application.Current.Host.Source.Host, 
                Application.Current.Host.Source.Port,
                Session.Guid.ToString(),
                int.Parse(SelectedItem.Number).ToString(),
                HttpUtility.UrlEncode(SelectedItem.Revision.Trim()),
                HttpUtility.UrlEncode((sender as Document).Name.Trim())));

            n.Content = view;

            ((MainPage)App.Current.RootVisual).radPaneGroup.AddItem(n, Telerik.Windows.Controls.Docking.DockPosition.Center);
        }

        public virtual void ViewProject(object parameter)
        {
            if (SelectedItem.Projects.Count == 0)
            {
                CustomMessage msg = new CustomMessage("Nenhum arquivo encontrado !", CustomMessage.MessageType.Info);
                msg.Show();
                return;
            }
            else if (SelectedItem.Projects.Count == 1)
                OpenProject(SelectedItem.Projects.First(), new EventArgs());
            else
            {
                DocumentViewModel viewmodel = new DocumentViewModel();
                viewmodel.SearchResultList = SelectedItem.Projects;

                DocumentView childDocument = new DocumentView();
                childDocument.DataContext = viewmodel;
                childDocument.OnSelect = new EventHandler(OpenProject);
                childDocument.Show();
            }

        }

        public void OpenProject(object sender, EventArgs e)
        {
            if ((sender as Document) == null)
                return;

            if (GestaoApp.ViewModel.ViewModelBase.Session.Rules != "*" &&
                !GestaoApp.ViewModel.ViewModelBase.Session.Rules.Contains("Bid Register"))
            {
                CustomMessage msg = new CustomMessage("Acesso negado !", CustomMessage.MessageType.Error);
                msg.Show();
                return;
            }

            foreach (RadPane p in ((MainPage)App.Current.RootVisual).radPaneGroup.Items)
            {
                if (p.Content != null)
                {
                    if (p.Content.GetType() == typeof(GestaoApp.View.HTMLHostView) &&
                        p.Header.ToString() == "Projeto " + (sender as Document).Name.Trim())
                    {
                        p.IsSelected = true;
                        return;
                    }
                }
            }

            RadPane n = new RadPane();

            n.Header = "Projeto " + (sender as Document).Name.Trim();

            GestaoApp.View.HTMLHostView view = new GestaoApp.View.HTMLHostView();
            //view.htmlHost.SourceUri = new Uri(string.Format("http://{0}:{1}/Sales.Bid.Project?guid={2}&id={3}&rev={4}&doc={5}",
            view.htmlHost.SourceUri = new Uri(string.Format("http://{0}:{1}/Sales.Bid.Project?{2}&{3}&{4}&{5}",
                Application.Current.Host.Source.Host,
                Application.Current.Host.Source.Port,
                Session.Guid.ToString(),
                int.Parse(SelectedItem.Number).ToString(),
                HttpUtility.UrlEncode(SelectedItem.Revision.Trim()),
                HttpUtility.UrlEncode((sender as Document).Name.Trim())));

            n.Content = view;

            ((MainPage)App.Current.RootVisual).radPaneGroup.AddItem(n, Telerik.Windows.Controls.Docking.DockPosition.Center);
        }
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
                if ((sender as RegisterFormView).DataContext is RegisterViewModel)
                {
                    PendingChanges = ((sender as RegisterFormView).DataContext as RegisterViewModel).selectedItem as Register;

                    try
                    {
                        HttpRequestHelper httpRequest =
                            new HttpRequestHelper(
                                new Uri(string.Format("http://{0}:{1}/Sales.Bid.CommitChanges?{2}", Application.Current.Host.Source.Host, Application.Current.Host.Source.Port, Session.Guid)),
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
                            if (xParse.Descendants("CommitChanges").Any())
                                if (xParse.Descendants("CommitChanges").Attributes("Number").Any())
                                    PendingChanges.Number = xParse.Descendants("CommitChanges").First().Attribute("Number").Value;

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
                if ((sender as RegisterFormView).DataContext is RegisterViewModel)
                {
                    PendingChanges = ((sender as RegisterFormView).DataContext as RegisterViewModel).selectedItem as Register;

                    try
                    {
                        HttpRequestHelper httpRequest =
                            new HttpRequestHelper(
                                new Uri(string.Format("http://{0}:{1}/Sales.Bid.CommitChanges?{2}", Application.Current.Host.Source.Host, Application.Current.Host.Source.Port, Session.Guid)),
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
                                throw new Exception("Dados do Orçamento inconsistente !");

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
                        new Uri(string.Format("http://{0}:{1}/Sales.Bid.Search?{2}", Application.Current.Host.Source.Host, Application.Current.Host.Source.Port, Session.Guid)),
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
                            (from bid in xParse.Element("Bid").Elements("Register")
                            select new Register()
                            {
                                ToXML = bid,
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
