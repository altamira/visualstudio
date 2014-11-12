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
    public class State : Base
    {
        #region Attributes

        private Country country;
        private string acronym;
        private string name;
        private City capital;
        //private Image flag;
        private string flag;

        private static ObservableCollection<State> collection;

        #endregion

        #region Properties

        [DisplayAttribute(Name = "País")]
        public Country Country
        {
            get
            {
                if (collection == null)
                    collection = new ObservableCollection<State>();
                return country;
            }
            set
            {
                if ((object.ReferenceEquals(this.country, value) != true))
                {
                    //Validator.ValidateProperty(value, new ValidationContext(this, null, null) { MemberName = "Country" });
                    country = value;
                    OnPropertyChanged("Country");
                }
            }
        }

        [DisplayAttribute(Name = "Sigla")]
        public string Acronym
        {
            get
            {
                if (acronym == null)
                    acronym = "";
                return acronym;
            }
            set
            {
                if ((object.ReferenceEquals(this.acronym, value) != true))
                {
                    //Validator.ValidateProperty(value, new ValidationContext(this, null, null) { MemberName = "Acronym" });
                    acronym = value;
                    OnPropertyChanged("Acronym");
                }
            }
        }

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
                    //Validator.ValidateProperty(value, new ValidationContext(this, null, null) { MemberName = "Name" });
                    name = value;
                    OnPropertyChanged("Name");
                }
            }
        }

        [DisplayAttribute(Name = "Capital")]
        public City Capital
        {
            get
            {
                if (capital == null)
                    capital = City.Collection.Where(s => s.Name == "SAO PAULO").FirstOrDefault();
                return capital;
            }
            set
            {
                if ((object.ReferenceEquals(this.capital, value) != true))
                {
                    //Validator.ValidateProperty(value, new ValidationContext(this, null, null) { MemberName = "Capital" });
                    capital = value;
                    OnPropertyChanged("Capital");
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
                    //Validator.ValidateProperty(value, new ValidationContext(this, null, null) { MemberName = "Flag" });
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
                    //Validator.ValidateProperty(value, new ValidationContext(this, null, null) { MemberName = "Flag" });
                    flag = value;
                    OnPropertyChanged("Flag");
                }
            }
        }

        public override String ToString()
        {
            return Name;
        }

        public static ObservableCollection<State> Collection
        {
            get
            {
                if (collection == null)
                    collection = new ObservableCollection<State>();
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
        
        #endregion

        #region Commands
        public static EventHandler LoadCompleted;

        public static void LoadCollectionAsync()
        {
            try
            {
                HttpRequestHelper httpRequest =
                    new HttpRequestHelper(
                        new Uri(string.Format("http://{0}:{1}/Location.State.List", Application.Current.Host.Source.Host, Application.Current.Host.Source.Port)),
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
                        collection = new ObservableCollection<State>
                                    (from state in xParse.Descendants("State")
                                     select new State() { ToXML = state });

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
                return new XElement("State",
                                            new XAttribute("Id", Id),
                                            new XElement("Name", Name.Trim()),
                                            new XElement("Acronym", Acronym.Trim()),
                                            new XElement("Flag", Flag),
                                            new XElement("Capital", new XAttribute("Id", Capital != null ? Capital.Id.ToString() : "0"), Capital != null ? Capital.Name : ""),
                                            new XElement(Country.ToXML)
                                    );
            }
            set
            {
                Id = value.Attribute("Id").Value != null ? int.Parse(value.Attribute("Id").Value) : 0;
                Name = value.Element("Name") != null ? value.Element("Name").Value.Trim() : "";
                Acronym = value.Element("Acronym") != null ? value.Element("Acronym").Value.Trim() : "";
                Flag = value.Element("Flag") != null ? value.Element("Flag").Value : "";

                if (value.Element("Capital") != null)
                {
                    if (City.Collection.Any(c => c.Id == int.Parse(value.Element("Capital").Attribute("Id").Value)))
                        Capital = City.Collection.First(c => c.Id == int.Parse(value.Element("Capital").Attribute("Id").Value));
                    else
                        Capital = new City() { ToXML = value.Element("Capital") };
                }

                if (value.Element("Country") != null)
                {
                    if (Country.Collection.Any(c => c.Id == int.Parse(value.Element("Country").Attribute("Id").Value)))
                        Country = Country.Collection.First(c => c.Id == int.Parse(value.Element("Country").Attribute("Id").Value));
                    else
                        throw new Exception("Erro ao carregar o País, contate suporte !");
                }
            }
        }

        #endregion
    }
}
