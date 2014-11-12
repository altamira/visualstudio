using System;
using System.Collections.ObjectModel;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Windows;
using System.Xml.Linq;
using GestaoApp.Helpers;
using GestaoApp.Models.Contact;
using GestaoApp.Models.Location;
using SilverlightMessageBoxLibrary;

namespace GestaoApp.Models.Sales
{
    public class Client : Base
    {
        #region Attributes

        private string code;
        private string codename;
        private string name;

        //private ObservableCollection<Fone> contactfone;
        //private ObservableCollection<Email> contactemail;
        private ObservableCollection<GestaoApp.Models.Contact.Person> contactperson;
        private ObservableCollection<Address> locationaddress;

        private Vendor vendor;
        private Media media;

        private static ObservableCollection<Client> collection;

        #endregion

        #region Properties

        [DisplayAttribute(Name = "Codigo")]
        public string Code
        {
            get
            {
                if (code == null)
                    code = "";
                return code;
            }
            set
            {
                if ((object.ReferenceEquals(this.code, value) != true))
                {
                    //Validator.ValidateProperty(value, new ValidationContext(this, null, null) { MemberName = "Name" });
                    code = value;
                    OnPropertyChanged("Code");
                }
            }
        }

        [Required(AllowEmptyStrings = false, ErrorMessage = "Nome é obrigatório.")]
        [DisplayAttribute(Name = "CodeNome")]
        [StringLength(50, MinimumLength = 3, ErrorMessage = "Tamanho mínimo para o CodeNome são 3 caracteres")]
        [RegularExpression("^[a-zA-Z''-'\\s]{1,50}$", ErrorMessage = "Números e caracteres especiais não são permitidos no CodeNome.")]
        public string CodeName
        {
            get
            {
                if (codename == null)
                    codename = "";
                return codename;
            }
            set
            {
                if ((object.ReferenceEquals(this.codename, value) != true))
                {
                    //Validator.ValidateProperty(value, new ValidationContext(this, null, null) { MemberName = "Name" });
                    codename = value;
                    OnPropertyChanged("CodeName");
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

        [DisplayAttribute(AutoGenerateField = false)]
        public ObservableCollection<Fone> ContactFone
        {
            get
            {
                //if (contactfone == null)
                //    contactfone = new ObservableCollection<Fone>();
                //return contactfone;

                ObservableCollection<Fone> fones = new ObservableCollection<Fone>();
                foreach (Person p in ContactPerson)
                    foreach (Fone f in p.ContactFone)
                        fones.Add(f);
                return fones;
                        
            }
            //set
            //{
            //    if ((object.ReferenceEquals(this.contactfone, value) != true))
            //    {
            //        contactfone = value;
            //        OnPropertyChanged("ContactFone");
            //    }
            //}
        }

        [DisplayAttribute(AutoGenerateField = false)]
        public ObservableCollection<Email> ContactEmail
        {
            get
            {
                //if (contactemail == null)
                //    contactemail = new ObservableCollection<Email>();
                //return contactemail;

                ObservableCollection<Email> emails = new ObservableCollection<Email>();
                foreach (Person p in ContactPerson)
                    foreach (Email e in p.ContactEmail)
                        emails.Add(e);
                return emails;
            }
            //set
            //{
            //    if ((object.ReferenceEquals(this.contactemail, value) != true))
            //    {
            //        contactemail = value;
            //        OnPropertyChanged("ContactEmail");
            //    }
            //}
        }

        [DisplayAttribute(AutoGenerateField = false)]
        public ObservableCollection<Person> ContactPerson
        {
            get
            {
                if (contactperson == null)
                    contactperson = new ObservableCollection<Contact.Person>();
                return contactperson;
            }
            set
            {
                //if ((object.ReferenceEquals(this.contactperson, value) != true))
                //{
                    contactperson = value;
                    OnPropertyChanged("ContactPerson");
                //}
            }
        }

        [DisplayAttribute(AutoGenerateField = false)]
        public ObservableCollection<Address> LocationAddress
        {
            get
            {
                if (locationaddress == null)
                    locationaddress = new ObservableCollection<Address>();
                return locationaddress;
            }
            set
            {
                if ((object.ReferenceEquals(this.locationaddress, value) != true))
                {
                    locationaddress = value;
                    OnPropertyChanged("LocationAddress");
                }
            }
        }

        [DisplayAttribute(Name = "Representante")]
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

        [DisplayAttribute(Name = "Mídia")]
        public Media Media
        {
            get
            {
                if (media == null)
                    media = Media.Collection.FirstOrDefault();
                return media;
            }
            set
            {
                if ((object.ReferenceEquals(this.media, value) != true))
                {
                    media = value;
                    OnPropertyChanged("Media");
                }
            }
        }

        [DisplayAttribute(AutoGenerateField = false)]
        public static ObservableCollection<Client> Collection
        {
            get
            {
                if (collection == null)
                    collection = new ObservableCollection<Client>();
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

        public Client Clone()
        {
            Client v = new Client()
            {
                Id = this.Id,
                Selected = this.Selected,
                HasChanges = this.HasChanges,
                CodeName = this.CodeName,
                vendor = this.Vendor,
                Media = this.Media
            };

            foreach (Fone f in ContactFone)
                v.ContactFone.Add(f.Clone());

            foreach (Email e in ContactEmail)
                v.ContactEmail.Add(e.Clone());

            foreach (Person p in ContactPerson)
                v.ContactPerson.Add(p.Clone());

            foreach (Address a in LocationAddress)
                v.LocationAddress.Add(a.Clone());

            return v;
        }

        public override string ToString()
        {
            return CodeName;
        }

        #endregion

        #region Events
        #endregion

        #region Commands
        public static EventHandler LoadCompleted;

        public static void LoadCollectionAsync()
        {
            try
            {
                HttpRequestHelper httpRequest =
                    new HttpRequestHelper(
                        new Uri(string.Format("http://{0}:{1}/Sales.Client.List", Application.Current.Host.Source.Host, Application.Current.Host.Source.Port)),
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
                        collection = new ObservableCollection<Client>
                                    (from client in xParse.Descendants("Client")
                                     select new Client() { ToXML = client });

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

        #region Events
        #endregion

        #region XML

        [DisplayAttribute(AutoGenerateField = false)]
        public override XElement ToXML
        {
            get
            {
                return new XElement("Client", new XAttribute("Id", Id),
                                    new XElement("CodeName", CodeName),
                                    new XElement("Vendor", new XAttribute("Id", Vendor != null ? Vendor.Id.ToString() : "0"), Vendor != null ? Vendor.Name : ""),
                                    new XElement("Media", new XAttribute("Id", Media != null ? Media.Id.ToString() : "0"), Media != null ? Media.Description : ""),
                                    //new XElement("ContactFone", null /*ContactFone.Select(c => c.ToXML)*/),
                                    //new XElement("ContactEmail", null /*ContactEmail.Select(c => c.ToXML)*/),
                                    new XElement("ContactPerson", ContactPerson.Select(c => c.ToXML)),
                                    new XElement("LocationAddress", LocationAddress.Select(c => c.ToXML)));
            }
            set
            {
                Id = value.Attribute("Id") != null ? int.Parse(value.Attribute("Id").Value) : 0;
                Code = value.Element("Code") != null ? value.Element("Code").Value.Trim() : "";
                CodeName = value.Element("CodeName") != null ? value.Element("CodeName").Value.Trim() : "";
                Name = value.Element("Name") != null ? value.Element("Name").Value.Trim() : "";

                if (value.Element("Vendor") != null)
                {
                    if (Vendor.Collection.Any(c => c.Id == int.Parse(value.Element("Vendor").Attribute("Id").Value)))
                        Vendor = Vendor.Collection.First(c => c.Id == int.Parse(value.Element("Vendor").Attribute("Id").Value));
                    else
                        Vendor = new Vendor() { ToXML = value.Element("Vendor") };
                }

                if (value.Element("Media") != null)
                {
                    if (Media.Collection.Any(c => c.Id == int.Parse(value.Element("Media").Attribute("Id").Value)))
                        Media = Media.Collection.First(c => c.Id == int.Parse(value.Element("Media").Attribute("Id").Value));
                    else
                        Media = new Media() { ToXML = value.Element("Media") };
                }

                //if (value.Element("ContactFone") != null)
                //    ContactFone = new ObservableCollection<Fone>
                //                        (from fone in value.Element("ContactPerson").Descendants("Fone")
                //                         /*where fone.Element("Prefix").Value.Trim().Length > 0 &&
                //                        fone.Element("Number").Value.Trim().Length > 0*/
                //                        select new Fone() { ToXML = fone });

                //if (value.Element("ContactEmail") != null)
                //    ContactEmail = new ObservableCollection<Email>
                //                    (from email in value.Element("ContactPerson").Descendants("Email")
                //                     //where email.Element("Address").Value.Trim().Length > 0
                //                     select new Email() { ToXML = email });

                if (value.Element("ContactPerson") != null)
                {
                    ContactPerson = new ObservableCollection<GestaoApp.Models.Contact.Person>
                                    (from person in value.Element("ContactPerson").Elements("Person")
                                     //where person.Element("Name").Value.Trim().Length > 0
                                     select new GestaoApp.Models.Contact.Person() { ToXML = person });

                    //ContactFone = new ObservableCollection<Fone>
                    //                (from fone in value.Element("ContactPerson").Descendants("Fone")
                    //                    /*where fone.Element("Prefix").Value.Trim().Length > 0 &&
                    //                fone.Element("Number").Value.Trim().Length > 0*/
                    //                    select new Fone() { ToXML = fone });

                    //ContactEmail = new ObservableCollection<Email>
                    //                (from email in value.Element("ContactPerson").Descendants("Email")
                    //                 //where email.Element("Address").Value.Trim().Length > 0
                    //                 select new Email() { ToXML = email });
                }

                if (value.Element("LocationAddress") != null)
                    LocationAddress = new ObservableCollection<Address>
                    (from address in value.Element("LocationAddress").Elements("Address")
                     //where address.Element("Street").Value.Trim().Length > 0
                     select new Address() { ToXML = address });
            }
        }
        #endregion
    }
}
