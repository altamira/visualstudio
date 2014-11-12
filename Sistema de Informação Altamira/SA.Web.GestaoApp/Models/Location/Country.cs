using System;
using System.Collections.ObjectModel;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Windows;
using System.Xml.Linq;
using GestaoApp.Helpers;
using SilverlightMessageBoxLibrary;

namespace GestaoApp.Models.Location
{
    public class Country : Base
    {
        #region Attribute

        private string name;
        private string isocountrycodech2;
        private string isocountrycodech3;
        //private Image flag;
        private string flag;

        private static ObservableCollection<Country> collection;

        #endregion

        #region Properties

        [Required(AllowEmptyStrings = false, ErrorMessage = "O Nome é obrigatório.")]
        [DisplayAttribute(Name = "Nome")]
        public string Name
        {
            get
            {
                if (name == null)
                    name = "";
                return name;
            }
            set
            {
                if ((object.ReferenceEquals(this.name, value) != true))
                {
                    name = value;
                    OnPropertyChanged("Name");
                }
            }
        }

        [DisplayAttribute(Name = "ISOCódigo2")]
        public string ISOCountryCodeCh2
        {
            get
            {
                if (isocountrycodech2 == null)
                    isocountrycodech2 = "";
                return isocountrycodech2;
            }
            set
            {
                if ((object.ReferenceEquals(this.isocountrycodech2, value) != true))
                {
                    isocountrycodech2 = value;
                    OnPropertyChanged("ISOCountryCodeCh2");
                }
            }
        }

        [DisplayAttribute(Name = "ISOCódigo3")]
        public string ISOCountryCodeCh3
        {
            get
            {
                if (isocountrycodech3 == null)
                    isocountrycodech3 = "";
                return isocountrycodech3;
            }
            set
            {
                if ((object.ReferenceEquals(this.isocountrycodech3, value) != true))
                {
                    isocountrycodech3 = value;
                    OnPropertyChanged("ISOCountryCodeCh3");
                }
            }
        }

        /*[DisplayAttribute(Name = "Bandeira")]
        public Image Flag
        {
            get
            {
                return flag;
            }
            set
            {
                if ((object.ReferenceEquals(this.flag, value) != true))
                {
                    flag = value;
                    OnPropertyChanged("Flag");
                }
            }
        }*/
        
        [DisplayAttribute(Name = "Bandeira")]
        public string Flag
        {
            get
            {
                if (flag == null)
                    flag = "";
                return flag;
            }
            set
            {
                if ((object.ReferenceEquals(this.flag, value) != true))
                {
                    flag = value;
                    OnPropertyChanged("Flag");
                }
            }
        }

        public static ObservableCollection<Country> Collection
        {
            get
            {
                if (collection == null)
                    collection = new ObservableCollection<Country>();
                return collection;
            }
            set
            {
                if ((object.ReferenceEquals(collection, value) != true))
                {
                    collection = value;
                }
            }
        }

        public override String ToString()
        {
            return Name;
        }

        #endregion

        #region Commands
        public static EventHandler LoadCompleted;

        public static void LoadCollectionAsync()
        {
            try
            {
                HttpRequestHelper httpRequest =
                    new HttpRequestHelper(
                        new Uri(string.Format("http://{0}:{1}/Location.Country.List", Application.Current.Host.Source.Host, Application.Current.Host.Source.Port)),
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

        public static void OnReceiveCompleted(HttpResponseCompleteEventArgs e)
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
                        collection = new ObservableCollection<Country>
                                    (from country in xParse.Descendants("Country")
                                     select new Country() { ToXML = country });

                        if (LoadCompleted != null)
                            LoadCompleted(null, new EventArgs());
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

        #region XML

        [DisplayAttribute(AutoGenerateField = false)]
        public override XElement ToXML
        {
            get
            {
                return new XElement("Country",
                                            new XAttribute("Id", Id),
                                            new XElement("Name", Name.Trim()),
                                            new XElement("Flag", Flag.Trim())
                                    );
            }
            set
            {
                Id = value.Attribute("Id") != null ? int.Parse(value.Attribute("Id").Value) : 0;
                Name = value.Element("Name") != null ? value.Element("Name").Value.Trim() : "";
                Flag = value.Element("Flag") != null ? value.Element("Flag").Value.Trim() : "";
            }
        }

        #endregion
    }
}
