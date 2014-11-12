using System;
using System.Collections.ObjectModel;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Windows;
using System.Windows.Controls;
using System.Xml.Linq;
using GestaoApp.Helpers;
using SilverlightMessageBoxLibrary;

namespace GestaoApp.Models.Location
{
    public class City : Base
    {
        #region Attribute

        private string name /*= ""*/;
        private State state;
        private Image flag;

        private static ObservableCollection<City> collection /*= new ObservableCollection<City>()*/;

        #endregion

        #region Properties

        [Required]
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

        [Required]
        [DisplayAttribute(Name = "Estado")]
        public State State
        {
            get
            {
                if (state == null)
                    state = State.Collection.Where(s => s.Name == "SAO PAULO").FirstOrDefault();

                return state;
            }
            set
            {
                if ((object.ReferenceEquals(this.state, value) != true))
                {
                    //Validator.ValidateProperty(value, new ValidationContext(this, null, null) { MemberName = "State" });
                    state = value;
                    OnPropertyChanged("State");
                }
            }
        }

        [DisplayAttribute(Name = "Bandeira")]
        public Image Flag
        {
            get
            {
                if (flag == null)
                    flag = new Image();
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

        public static ObservableCollection<City> Collection
        {
            get
            {
                if (collection == null)
                    collection = new ObservableCollection<City>();
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
            return Name + (state != null ? ", " + state.Name + " (" + state.Acronym + ")" : "");
        }

        #endregion

        #region Constructor
        public City()
        {
        }
        public City(int Id, String Name, State State, Image Flag)
        {
            id = Id;
            name = Name;
            state = State;
            flag = Flag;
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
                        new Uri(string.Format("http://{0}:{1}/Location.City.List", Application.Current.Host.Source.Host, Application.Current.Host.Source.Port)),
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
                        collection = new ObservableCollection<City>
                                    (from city in xParse.Descendants("City")
                                     select new City() { ToXML = city });

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
                return new XElement("City",
                                            new XAttribute("Id", Id),
                                            new XElement("Name", Name.Trim()),
                                            new XElement("Flag", ""),
                                            new XElement("State", new XAttribute("Id", State.Id), new XElement("Name", State.Name), new XElement("Country", new XAttribute("Id", State.Country.Id),  new XElement("Name", State.Country.Name)))
                                    );
            }
            set
            {
                Id = value.Attribute("Id") != null ? int.Parse(value.Attribute("Id").Value) : 0;
                Name = value.Element("Name") != null ? value.Element("Name").Value.Trim() : "";
                Flag = new Image();

                if (value.Element("State") != null)
                {
                    if (State.Collection.Any(c => c.Id == int.Parse(value.Element("State").Attribute("Id").Value)))
                        State = State.Collection.First(c => c.Id == int.Parse(value.Element("State").Attribute("Id").Value));
                    else
                        throw new Exception("Erro ao carregar o Estado, contate suporte !");
                }
            }
        }

        #endregion
    }
}
