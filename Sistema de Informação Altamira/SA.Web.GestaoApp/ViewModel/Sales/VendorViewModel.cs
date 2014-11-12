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
using GestaoApp.Command;
using System.Windows.Input;

namespace GestaoApp.ViewModel.Sales
{
    public class VendorViewModel : SearchViewModel<Vendor>
    {
        #region Attributes

        private AddressViewModel addressviewmodel = new AddressViewModel();

        private FoneViewModel foneviewmodel = new FoneViewModel();

        private EmailViewModel emailviewmodel = new EmailViewModel();

        private PersonViewModel personviewmodel = new PersonViewModel();

        #endregion

        #region Properties
        public override Vendor SelectedItem
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
                        FoneViewModel.SearchResultList = SelectedItem.ContactFone;
                        EmailViewModel.SearchResultList = SelectedItem.ContactEmail;
                    }
                    else
                    {
                        FoneViewModel.SearchResultList = null;
                        EmailViewModel.SearchResultList = null;
                    }

                    if (value != null)
                    {
                        this.CanEdit = true;
                        //this.CanDelete = true;
                        this.CanResetPassword = true;
                    }
                    else
                    {
                        this.CanEdit = false;
                        //this.CanDelete = false;
                        this.CanResetPassword = false;
                    }

                    OnPropertyChanged("SelectedItem");
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
        
        #endregion

        #region Constructor
        public VendorViewModel(string parameter)
        {
            CanSearch = true;

            if (!DesignerProperties.GetIsInDesignMode(Application.Current.RootVisual))
                Search(parameter);
        }

        public VendorViewModel()
        {
            CanSearch = true;

            /*SearchResultList = new ObservableCollection<Models.Vendor>()
            {
                new Models.Vendor()
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
                                Name = "Brasil",
                                Flag = new Image() { Source = new BitmapImage(new Uri(@"/GestaoApp;component/Images/BRA.png", UriKind.Relative)) }
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
                                Name = "Brasil",
                                Flag = new Image() { Source = new BitmapImage(new Uri(@"/GestaoApp;component/Images/BRA.png", UriKind.Relative)) }
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
                                        Name = "Brasil",
                                        Flag = new Image() { Source = new BitmapImage(new Uri(@"/GestaoApp;component/Images/BRA.png", UriKind.Relative)) }
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
                new Models.Vendor()
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
                                Name = "Brasil",
                                Flag = new Image() { Source = new BitmapImage(new Uri(@"/GestaoApp;component/Images/BRA.png", UriKind.Relative)) }
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
                                        Name = "Brasil",
                                        Flag = new Image() { Source = new BitmapImage(new Uri(@"/GestaoApp;component/Images/BRA.png", UriKind.Relative)) }
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

        public override void Add(object parameter)
        {
            VendorViewModel viewmodel = new VendorViewModel();
            viewmodel.SelectedItem = new Vendor();
            VendorFormView childWindow = new VendorFormView();
            childWindow.OnSave = new EventHandler(OnAddComplete);
            childWindow.DataContext = viewmodel;
            childWindow.Show();
        }

        public void OnAddComplete(object sender, EventArgs e)
        {
            if (sender is VendorFormView)
                if ((sender as VendorFormView).DataContext is VendorViewModel)
                {
                    Vendor vendor = ((sender as VendorFormView).DataContext as VendorViewModel).selectedItem as Vendor;
                    SearchResultList.Add(vendor);
                    SelectedItem = vendor;
                }
        }

        public override void Edit(object parameter)
        {
            VendorViewModel viewmodel = new VendorViewModel();
            viewmodel.SelectedItem = SelectedItem.Clone();
            VendorFormView childWindow = new VendorFormView();
            childWindow.OnSave = new EventHandler(OnEditComplete);
            childWindow.DataContext = viewmodel;
            childWindow.Show();
        }

        public void OnEditComplete(object sender, EventArgs e)
        {
            if (sender is VendorFormView)
                if ((sender as VendorFormView).DataContext is VendorViewModel)
                {
                    int i = SearchResultList.IndexOf(SelectedItem);
                    if (i >= 0)
                    {
                        SearchResultList.RemoveAt(i);
                        SearchResultList.Insert(i, ((sender as VendorFormView).DataContext as VendorViewModel).selectedItem as Vendor);
                    }
                    else
                        SearchResultList.Add(((sender as VendorFormView).DataContext as VendorViewModel).selectedItem as Vendor);

                    SelectedItem = ((sender as VendorFormView).DataContext as VendorViewModel).selectedItem as Vendor;
                }
        }

        public override void Search(object parameter)
        {
            try
            {
                HttpRequestHelper httpRequest =
                    new HttpRequestHelper(
                        new Uri(string.Format("http://{0}:{1}/Sales.Vendor.Search?{2}", Application.Current.Host.Source.Host, Application.Current.Host.Source.Port, Session.Guid)),
                        "POST",
                        new XDocument
                        (
                            new XElement("querystring", parameter)
                        ));

                httpRequest.ResponseComplete += new HttpResponseCompleteEventHandler(OnReceiveCompleted);
                httpRequest.Execute();
            }
            catch (Exception ex)
            {
                MessageBox.Show(ex.Message);
            }
        }

        public void OnReceiveCompleted(HttpResponseCompleteEventArgs e)
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
                        SearchResultList = new ObservableCollection<Vendor>
                            (from vendor in xParse.Descendants("Vendor")                                               
                             select new Vendor() { ToXML = vendor });

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
                System.Windows.Deployment.Current.Dispatcher.BeginInvoke(new Action<HttpResponseCompleteEventArgs>(OnReceiveCompleted), e);
        }

        public override void ResetPassword(object parameter)
        {
            if (MessageBox.Show("A senha do Representante selecionado ficará em branco.\n\nO sistema ira solicitar ao Representante que cadastre uma nova senha no próximo acesso.\n\nConfirma a alteração da senha ?", "Senha de Acesso", MessageBoxButton.OKCancel) != MessageBoxResult.OK)
                return;

            try
            {
                HttpRequestHelper httpRequest =
                    new HttpRequestHelper(
                        new Uri(string.Format("http://{0}:{1}/Security.Vendor.ResetPassword?{2}", Application.Current.Host.Source.Host, Application.Current.Host.Source.Port, Session.Guid)),
                        "POST",
                        new XDocument
                            (
                                new XElement("Vendor",
                                    new XAttribute("Id", SelectedItem.Id.ToString()))
                                    //new XElement("NewPassword", Helpers.Cripto.GetSHA1Hash("")))
                            ));

                httpRequest.ResponseComplete += new HttpResponseCompleteEventHandler(OnResetPasswordComplete);
                httpRequest.Execute();
            }
            catch (Exception ex)
            {
                MessageBox.Show(ex.Message);
            }
        }

        public void OnResetPasswordComplete(HttpResponseCompleteEventArgs e)
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
                        GestaoApp.Helpers.Message r = (from c in xParse.Descendants("Message")
                                        select new GestaoApp.Helpers.Message()
                                        {
                                            //Id = Convert.ToInt32(c.Attribute("Id").Value),
                                            Detail = c.Value,
                                        }).FirstOrDefault();

                        CustomMessage msg = new CustomMessage(r.Detail.ToString(), CustomMessage.MessageType.Info);
                        msg.Show();

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
                System.Windows.Deployment.Current.Dispatcher.BeginInvoke(new Action<HttpResponseCompleteEventArgs>(OnResetPasswordComplete), e);

        }

        public EventHandler LoadCompleted;

        private void LoadAsync()
        {
            try
            {
                HttpRequestHelper httpRequest =
                    new HttpRequestHelper(
                        new Uri(string.Format("http://{0}:{1}/Sales.Vendor.List", Application.Current.Host.Source.Host, Application.Current.Host.Source.Port)),
                        "POST",
                        new XDocument());

                httpRequest.ResponseComplete += new HttpResponseCompleteEventHandler(OnReceiveCompleted);
                httpRequest.Execute();
            }
            catch (Exception ex)
            {
                MessageBox.Show(ex.Message);
            }
        }

        #endregion

    }
}
