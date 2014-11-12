using System;
using System.Collections.ObjectModel;
using System.ComponentModel;
using System.Linq;
using System.Windows;
using System.Xml.Linq;
using GestaoApp.Helpers;
using GestaoApp.Models.Sales;
using GestaoApp.View.Sales;
using GestaoApp.ViewModel.Contact;
using GestaoApp.ViewModel.Location;
using SilverlightMessageBoxLibrary;

namespace GestaoApp.ViewModel.Sales
{
    public class ClientViewModel : SearchViewModel<Client>
    {
        #region Attributes

        private AddressViewModel addressviewmodel = new AddressViewModel();

        private FoneViewModel foneviewmodel = new FoneViewModel();

        private EmailViewModel emailviewmodel = new EmailViewModel();

        private PersonViewModel personviewmodel = new PersonViewModel();

        #endregion

        #region Properties
        public override Client SelectedItem
        {
            get
            {
                return selectedItem;
            }
            set
            {
                if ((object.ReferenceEquals(this.selectedItem, value) != true))
                {
                    selectedItem = value;

                    if (selectedItem != null)
                    {
                        AddressViewModel.SearchResultList = SelectedItem.LocationAddress;
                        AddressViewModel.Vendor = SelectedItem.Vendor;
                        FoneViewModel.SearchResultList = SelectedItem.ContactFone;
                        EmailViewModel.SearchResultList = SelectedItem.ContactEmail;
                        PersonViewModel.SearchResultList = SelectedItem.ContactPerson;
                    }
                    else
                    {
                        AddressViewModel.SearchResultList = null;
                        FoneViewModel.SearchResultList = null;
                        EmailViewModel.SearchResultList = null;
                        PersonViewModel.SearchResultList = null;
                    }

                    if (value != null)
                    {
                        this.CanEdit = true;
                        this.CanDelete = true;
                    }
                    else
                    {
                        this.CanEdit = false;
                        this.CanDelete = false;
                    }

                    OnPropertyChanged("SelectedItem");
                }
            }
        }

        public AddressViewModel AddressViewModel
        {
            get
            {
                return addressviewmodel;
            }
            set
            {
                if ((object.ReferenceEquals(this.addressviewmodel, value) != true))
                {
                    addressviewmodel = value;
                    OnPropertyChanged("AddressViewModel");
                }
            }
        }

        public FoneViewModel FoneViewModel
        {
            get
            {
                return foneviewmodel;
            }
            set
            {
                if ((object.ReferenceEquals(this.foneviewmodel, value) != true))
                {
                    foneviewmodel = value;
                    OnPropertyChanged("FoneViewModel");
                }
            }
        }

        public EmailViewModel EmailViewModel
        {
            get
            {
                return emailviewmodel;
            }
            set
            {
                if ((object.ReferenceEquals(this.emailviewmodel, value) != true))
                {
                    emailviewmodel = value;
                    OnPropertyChanged("EmailViewModel");
                }
            }
        }

        public PersonViewModel PersonViewModel
        {
            get
            {
                return personviewmodel;
            }
            set
            {
                if ((object.ReferenceEquals(this.personviewmodel, value) != true))
                {
                    personviewmodel = value;
                    OnPropertyChanged("PersonViewModel");
                }
            }
        }

        #endregion

        #region Constructor
        public ClientViewModel(string parameter)
        {
            CanAdd = true;
            CanSearch = true;

            if (!DesignerProperties.GetIsInDesignMode(Application.Current.RootVisual))
                Search(parameter);
        }

        public ClientViewModel()
        {
            CanAdd = true;
            CanSearch = true;

            /*SearchResultList = new ObservableCollection<Models.Client>()
            {
                new Models.Client()
                {
                    Id = 1,
                    Code = "123",
                    Name = "Alessandro",
                    ContactEmail = new ObservableCollection<Email>()
                    {
                        new Email()
                        {
                            Address = "alessandro@teste.com.br"
                        }
                    },
                    ContactFone = new ObservableCollection<Fone>()
                    {
                        new Fone()
                        {
                            Country = new Country()
                            {
                                Id = 1,
                                Name = "Brasil"
                            },
                            Prefix = "4562",
                            Number = "9985",
                            AccessCode = "1234",
                            FoneType = new FoneType()
                            {
                                Id = 1,
                                Description = "Celular"
                            }
                        }
                    },
                    LocationAddress = new ObservableCollection<Address>()
                    {
                        new Address()
                        {
                            Street = "Rua Jose de Andrade",
                            Number = "486",
                            Complement = "casa 1",
                            Neighborhood = "Jd. Santa Francisca",
                            District = "Centro",
                            City = new City()
                            {
                                Name = "Guarulhos"
                            },
                            State = new State()
                            {
                                Name = "São Paulo",
                                Acronym = "SP",
                            },
                            Country = new Country()
                            {
                                Id = 1,
                                Name = "Brasil"
                            }
                        }
                    },
                    ContactPerson = new ObservableCollection<Models.Person>()
                    {
                        new Models.Person()
                        {
                            Id = 1,
                            FirstName = "Person Creiton",
                            LastName = "Holanda",
                            ContactEmail = new ObservableCollection<Email>()
                            {
                                new Email()
                                {
                                    Address = "Creiton@gmail.com"
                                }
                            },
                            ContactFone = new ObservableCollection<Fone>()
                            {
                                new Fone()
                                {
                                    Id = 1,
                                    Country = new Country()
                                    {
                                        Id = 1,
                                        Name = "Brasil"
                                    },
                                    AreaCode = "11",
                                    Prefix = "9999",
                                    Number = "8888",
                                    AccessCode = "1234",
                                    FoneType = new FoneType()
                                    {
                                        Id = 1,
                                        Description = "Nextel"
                                    }
                                }
                            }
                        }
                    }
                },
                new Models.Client()
                {
                    Id = 1,
                    Code = "345",
                    Name = "Marcelo",
                    ContactEmail = new ObservableCollection<Email>()
                    {
                        new Email()
                        {
                            Address = "marcelo@teste.com.br"
                        }
                    },
                    ContactFone = new ObservableCollection<Fone>()
                    {
                        new Fone()
                        {
                            Country = new Country()
                            {
                                Id = 1,
                                Name = "Brasil"
                            },
                            AreaCode = "11",
                            Prefix = "4562",
                            Number = "9985",
                            AccessCode = "1234",
                            FoneType = new FoneType()
                            {
                                Id = 1,
                                Description = "Celular"
                            }
                        }
                    },
                    ContactPerson = new ObservableCollection<Models.Person>()
                    {
                        new Models.Person()
                        {
                            Id = 1,
                            FirstName = "Marcelo",
                            LastName = "Holanda",
                            ContactEmail = new ObservableCollection<Email>()
                            {
                                new Email()
                                {
                                    Address = "marcelo@gmail.com"
                                }
                            },
                            ContactFone = new ObservableCollection<Fone>()
                            {
                                new Fone()
                                {
                                    Id = 1,
                                    Country = new Country()
                                    {
                                        Id = 1,
                                        Name = "Brasil"
                                    },
                                    AreaCode = "11",
                                    Prefix = "4562",
                                    Number = "9985",
                                    AccessCode = "1234",
                                    FoneType = new FoneType()
                                    {
                                        Id = 1,
                                        Description = "Celular"
                                    }
                                }
                            }
                        }
                    }
                }
            };*/

        }

        #endregion

        #region Events
        #endregion

        #region Commands

        ClientFormView childWindow;
        Client PendingChanges;

        public event EventHandler SearchCompleted;
        public event EventHandler AddCompleted;

        public override void Add(object parameter)
        {
            ClientViewModel viewmodel = new ClientViewModel();
            viewmodel.SelectedItem = new Client();
            childWindow = new ClientFormView();
            childWindow.OnSave = new EventHandler(OnAddComplete);
            childWindow.DataContext = viewmodel;
            childWindow.Show();
        }

        public void OnAddComplete(object sender, EventArgs e)
        {
            if (sender is ClientFormView)
                if ((sender as ClientFormView).DataContext is ClientViewModel)
                {
                    PendingChanges = ((sender as ClientFormView).DataContext as ClientViewModel).selectedItem as Client;

                    try
                    {
                        HttpRequestHelper httpRequest =
                            new HttpRequestHelper(
                                new Uri(string.Format("http://{0}:{1}/Sales.Client.CommitChanges?{2}", Application.Current.Host.Source.Host, Application.Current.Host.Source.Port, Session.Guid)),
                                "POST",
                                new XDocument(PendingChanges.ToXML));

                        httpRequest.ResponseComplete += new HttpResponseCompleteEventHandler(OnAddRequestComplete);
                        httpRequest.Execute();
                    }
                    catch (Exception ex)
                    {
                        MessageBox.Show(ex.Message);
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
                            Client.Collection.Add(PendingChanges);
                            SearchResultList.Add(PendingChanges);
                            SelectedItem = PendingChanges;

                            if (childWindow != null)
                                childWindow.DialogResult = true;

                            if (AddCompleted != null)
                                AddCompleted(this, new EventArgs());
                        }

                    }
                    else
                    {
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
            ClientViewModel viewmodel = new ClientViewModel();
            viewmodel.SelectedItem = SelectedItem.Clone();
            childWindow = new ClientFormView();
            childWindow.OnSave = new EventHandler(OnEditComplete);
            childWindow.DataContext = viewmodel;
            childWindow.Show();
        }

        public void OnEditComplete(object sender, EventArgs e)
        {
            if (sender is ClientFormView)
                if ((sender as ClientFormView).DataContext is ClientViewModel)
                {
                    PendingChanges = ((sender as ClientFormView).DataContext as ClientViewModel).selectedItem as Client;

                    try
                    {
                        HttpRequestHelper httpRequest =
                            new HttpRequestHelper(
                                new Uri(string.Format("http://{0}:{1}/Sales.Client.CommitChanges?{2}", Application.Current.Host.Source.Host, Application.Current.Host.Source.Port, Session.Guid)),
                                "POST",
                                new XDocument(PendingChanges.ToXML));

                        httpRequest.ResponseComplete += new HttpResponseCompleteEventHandler(OnEditRequestComplete);
                        httpRequest.Execute();
                    }
                    catch (Exception ex)
                    {
                        MessageBox.Show(ex.Message);
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

                            /*int i = Client.Collection.IndexOf(Client.Collection.Where(c => c.Id == SelectedItem.Id).First());
                            if (i >= 0)
                            {
                                Client.Collection.RemoveAt(i);
                                Client.Collection.Insert(i, PendingChanges);
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
                                throw new Exception("Dados do Cliente inconsistente !");

                            SelectedItem = PendingChanges;

                            if (childWindow != null)
                                childWindow.DialogResult = true;
                        }
                    }
                    else
                    {
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
                        new Uri(string.Format("http://{0}:{1}/Sales.Client.Search?{2}", Application.Current.Host.Source.Host, Application.Current.Host.Source.Port, Session.Guid)),
                        "POST",
                        new XDocument
                        (
                            new XElement("querystring", parameter) 
                        ));

                httpRequest.ResponseComplete += new HttpResponseCompleteEventHandler(OnSearchRequestCompleted);
                httpRequest.Execute();
            }
            catch (Exception ex)
            {
                MessageBox.Show(ex.Message);
            }
        }

        public void OnSearchRequestCompleted(HttpResponseCompleteEventArgs e)
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
                        //ObservableCollection<Client> newClients = new ObservableCollection<Client>
                        //    (from client in xParse.Descendants("Client")
                        //     where Client.Collection.Any(c => c.Id == int.Parse(client.Attribute("Id").Value)) == false
                        //     select new Client()
                        //     {
                        //         ToXML = client,
                        //     });

                        //Client.Collection.Concat(newClients);
                        
                        //SearchResultList.Clear();

                        //foreach (XElement client in xParse.Descendants("Client"))
                        //{
                        //    Client cl = Client.Collection.Where(c => c.Id == int.Parse(client.Attribute("Id").Value)).First();
                        //    if (cl != null)
                        //    {
                        //        cl.ToXML = client;
                        //        SearchResultList.Add(cl);
                        //    }
                        //    else
                        //        throw new Exception("Resultado da consulta inconsistente. Contate o Suporte Técnico !");
                        //}

                        SearchResultList = new ObservableCollection<Client>
                            (from client in xParse.Descendants("Client")
                             select new Client()
                             {
                                 ToXML = client,
                             });

                        if (SearchCompleted != null)
                            SearchCompleted(this, new EventArgs());
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
                System.Windows.Deployment.Current.Dispatcher.BeginInvoke(new Action<HttpResponseCompleteEventArgs>(OnSearchRequestCompleted), e);
        }
        #endregion

    }
}
