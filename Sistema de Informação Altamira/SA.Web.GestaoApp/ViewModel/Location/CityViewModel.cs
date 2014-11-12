using System;
using System.Collections.ObjectModel;
using System.ComponentModel;
using System.Linq;
using System.Windows;
using System.Xml.Linq;
using GestaoApp.Helpers;
using GestaoApp.Models.Location;
using SilverlightMessageBoxLibrary;

namespace GestaoApp.ViewModel.Location
{
    public class CityViewModel : ViewModelBase
    {
        #region Attributes

        private ObservableCollection<City> citylist = new ObservableCollection<City>();

        #endregion

        #region Properties
        public ObservableCollection<City> CityList
        {
            get
            {
                return citylist;
            }
            set
            {
                if ((object.ReferenceEquals(citylist, value) != true))
                {
                    citylist = value;
                    OnPropertyChanged("CityList");
                }
            }
        }
        #endregion

        #region Constructor
        public CityViewModel()
        {
            if (!DesignerProperties.GetIsInDesignMode(Application.Current.RootVisual))
                GetCityListAsync();
        }
        #endregion

        #region Commands
        public EventHandler LoadCompleted;

        private void GetCityListAsync()
        {
            try
            {
                HttpRequestHelper httpRequest =
                    new HttpRequestHelper(
                        new Uri(string.Format("http://{0}:{1}/Location.City.List", Application.Current.Host.Source.Host, Application.Current.Host.Source.Port)),
                        "POST",
                        new XDocument
                        (
                    //new XElement("")
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
                        CityList = new ObservableCollection<City>
                                    (from city in xParse.Descendants("City")
                                     select new City() { ToXML = city });

                        if (LoadCompleted != null)
                            LoadCompleted(this, new EventArgs());
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
        #endregion

    }
}
