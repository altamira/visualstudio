using System;
using System.Collections.ObjectModel;
using System.Linq;
using System.Windows;
using System.Windows.Input;
using System.Xml.Linq;
using GestaoApp.Helpers;
using GestaoApp.Models.Location;
using GestaoApp.View;
using GestaoApp.View.Location;
using SilverlightMessageBoxLibrary;
using GestaoApp.Models.Sales;

namespace GestaoApp.ViewModel.Location
{
    public class AddressViewModel : SearchViewModel<Address>
    {
        #region Attributes

        private FilterAsyncParameters filterState = null;
        private bool Onfilter = false;

        private Vendor vendor = null;
        private ObservableCollection<City> citylist = null;

        #endregion

        #region Properties

        public override Address SelectedItem
        {
            get
            {
                return selectedItem;
            }
            set
            {
                if ((object.ReferenceEquals(this.selectedItem, value) != true))
                {
                    if (value != null)
                    {
                        selectedItem = value;
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

        public ObservableCollection<City> CityList
        {
            get 
            {
                return citylist;
            }
            set
            {
                if ((object.ReferenceEquals(this.selectedItem, value) != true))
                {
                    citylist = value;
                    OnPropertyChanged("CityList");
                }
            }
        }

        public Vendor Vendor
        {
            get
            {
                if (vendor == null)
                    vendor = new Vendor();
                return vendor;
            }
            set
            {
                if ((object.ReferenceEquals(this.vendor, value) != true))
                {
                    vendor = value;
                    OnPropertyChanged("Vendor");
                }
            }
        }
        #endregion

        #region Commands

        //AddressFormView childWindow;
        //Address PendingChanges;

        public override void Add(object parameter)
        {
            AddressViewModel viewmodel = new AddressViewModel();
            viewmodel.SelectedItem = new Address();
            if (vendor != null)
                viewmodel.SelectedItem.Vendor = vendor;
            viewmodel.SelectedItem.City = City.Collection.Where(c => c.Name == "SAO PAULO").FirstOrDefault();
            AddressFormView childWindow = new AddressFormView();
            childWindow.DataContext = viewmodel;
            childWindow.OnSave = new EventHandler(OnAddComplete);
            childWindow.Show();
        }

        public void OnAddComplete(object sender, EventArgs e)
        {
            if (sender is AddressFormView)
                if ((sender as AddressFormView).DataContext is AddressViewModel)
                {
                    SearchResultList.Add(((sender as AddressFormView).DataContext as AddressViewModel).SelectedItem);
                    SelectedItem = ((sender as AddressFormView).DataContext as AddressViewModel).SelectedItem;
                }
        }

        public override void Edit(object parameter)
        {
            AddressViewModel viewmodel = new AddressViewModel();
            viewmodel.SelectedItem = SelectedItem.Clone();
            AddressFormView childWindow = new AddressFormView();
            childWindow.DataContext = viewmodel;
            childWindow.OnSave = new EventHandler(OnEditComplete);
            childWindow.Show();
        }

        public void OnEditComplete(object sender, EventArgs e)
        {
            int i = SearchResultList.IndexOf(SelectedItem);
            if (i >= 0)
            {
                SearchResultList.RemoveAt(i);
                SearchResultList.Insert(i, ((sender as AddressFormView).DataContext as AddressViewModel).SelectedItem);
            }
            else
                SearchResultList.Add(((sender as AddressFormView).DataContext as AddressViewModel).SelectedItem);

            SelectedItem = ((sender as AddressFormView).DataContext as AddressViewModel).SelectedItem;
        }

        #endregion

        #region AutoCompleteBox Filter Async

        public ICommand FilterAsyncCommand
        {
            get;
            private set;
        }

        private void ExecuteFilterAsync(FilterAsyncParameters args)
        {
            if (Onfilter)
                return;

            filterState = args;

            try
            {
                HttpRequestHelper httpRequest =
                    new HttpRequestHelper(
                        new Uri(string.Format("http://{0}:{1}/Location.Address.Search", Application.Current.Host.Source.Host, Application.Current.Host.Source.Port)),
                        "POST",
                        new XDocument
                        (
                            new XElement("querystring", args.FilterCriteria)
                        ));

                httpRequest.ResponseComplete += new HttpResponseCompleteEventHandler(FilterCompleted);
                httpRequest.Execute();
            }
            catch (Exception ex)
            {
                MessageBox.Show(ex.Message);
            }

        }

        private void FilterCompleted(HttpResponseCompleteEventArgs e)
        {
            if (System.Windows.Deployment.Current.Dispatcher.CheckAccess())
            {
                if (e.Error == null)
                {
                    XDocument xParse = e.XmlResponse;

                    Error error = (from c in xParse.Descendants("error")
                                   select new Error()
                                   {
                                       Id = Convert.ToInt32(c.Attribute("id").Value),
                                       Message = c.Element("message").Value,
                                   }).FirstOrDefault();

                    if (error == null)
                    {
                        SearchResultList = new ObservableCollection<Address>
                            (from l in xParse.Descendants("l")
                             select new Address()
                             {
                                 //Street = enc.GetString(Encoding.Convert(Encoding.UTF8, enc, Encoding.UTF8.GetBytes(l.Attribute("n").Value))),
                                 Street = l.Attribute("n").Value,
                                 District = l.Attribute("b").Value,
                                 City = City.Collection.FirstOrDefault(c => c.Name == l.Attribute("c").Value),
                                 /*{
                                     //Name = enc.GetString(Encoding.Convert(Encoding.UTF8, enc, Encoding.UTF8.GetBytes(l.Attribute("c").Value)))
                                     Name = l.Attribute("c").Value
                                 },*/
                                 PostalCode = l.Attribute("p").Value
                             });
                        Onfilter = false;
                        if (filterState != null)
                            filterState.FilterComplete();

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
                System.Windows.Deployment.Current.Dispatcher.BeginInvoke(new Action<HttpResponseCompleteEventArgs>(FilterCompleted), e);
        }

        #endregion

        #region Constructor
        public AddressViewModel() : base()
        {
            //if (!base.IsDesignTime)
                //FilterAsyncCommand = new RelayCommand<FilterAsyncParameters>(ExecuteFilterAsync);
        }
        #endregion
    }
}
