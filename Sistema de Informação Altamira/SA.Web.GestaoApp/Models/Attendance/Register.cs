using System;
using System.Collections.ObjectModel;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Xml.Linq;
using GestaoApp.Models.Attendance.Message;
using GestaoApp.Models.Contact;
using GestaoApp.Models.Location;
using GestaoApp.Models.Sales;

namespace GestaoApp.Models.Attendance
{
    public class Register : Base
    {
        #region Attributes

        private DateTime datetime = DateTime.Now;
        private Client client;
        private Vendor vendor;
        private Type type;
        private Status status;
        private bool send = true;
        private SMS sms;
        private string comments;
        private History history;
        private bool canchange = true;

        private ObservableCollection<Person> contactperson;
        private ObservableCollection<Address> locationaddress;
        private ObservableCollection<Product> products;
        private ObservableCollection<History> histories;

        #endregion

        #region Properties

        [Required(AllowEmptyStrings = false, ErrorMessage = "A Data é obrigatória.")]
        [DisplayAttribute(Name = "Data/Hora")]
        public DateTime DateTime
        {
            get
            {
                if (datetime == null)
                    datetime = DateTime.Now;
                return datetime;
            }
            set
            {
                if ((object.ReferenceEquals(this.datetime, value) != true))
                {
                    datetime = value;
                    OnPropertyChanged("DateTime");
                }
            }
        }

        [DisplayAttribute(Name = "Cliente")]
        public Client Client
        {
            get
            {
                if (client == null)
                    client = new Client();
                return client;
            }
            set
            {
                if ((object.ReferenceEquals(this.client, value) != true))
                {
                    client = value;
                    OnPropertyChanged("Client");

                    if (client != null)
                    {
                        Vendor = client.Vendor;
                    }
                    else
                    {
                        Vendor = null;
                    }
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
                    if (vendor != null)
                    {
                        SMS.Vendor = vendor;
                    }

                    OnPropertyChanged("Vendor");
                }
            }
        }

        [DisplayAttribute(Name = "Tipo")]
        public Type Type
        {
            get
            {
                if (type == null)
                    type = new Type();
                return type;
            }
            set
            {
                if ((object.ReferenceEquals(this.type, value) != true))
                {
                    type = value;
                    OnPropertyChanged("Type");
                }
            }
        }

        [DisplayAttribute(Name = "Situação")]
        public Status Status
        {
            get
            {
                if (status == null)
                    status = new Status();
                return status;
            }
            set
            {
                if ((object.ReferenceEquals(this.status, value) != true))
                {
                    status = value;
                    OnPropertyChanged("Status");
                }
            }
        }

        [DisplayAttribute(AutoGenerateField = false)]
        public ObservableCollection<Person> ContactPerson
        {
            get
            {
                if (contactperson == null)
                    contactperson = new ObservableCollection<Person>();
                return contactperson;
            }
            set
            {
                if ((object.ReferenceEquals(this.contactperson, value) != true))
                {
                    contactperson = value;
                    OnPropertyChanged("ContactPerson");
                }
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

        [DisplayAttribute(AutoGenerateField = false)]
        public ObservableCollection<Product> Products
        {
            get
            {
                if (products == null)
                    products = Product.CollectionClone();
                return products;
            }
            set
            {
                if ((object.ReferenceEquals(this.products, value) != true))
                {
                    products = value;
                    OnPropertyChanged("Products");
                }
            }
        }

        [DisplayAttribute(AutoGenerateField = false)]
        public ObservableCollection<History> Histories
        {
            get
            {
                if (histories == null)
                    histories = new ObservableCollection<History>();
                return histories;
            }
            set
            {
                if ((object.ReferenceEquals(this.histories, value) != true))
                {
                    histories = value;
                    OnPropertyChanged("Histories");
                }
            }
        }

        [DisplayAttribute(AutoGenerateField = false)]
        public bool CanChange
        {
            get
            {
                return canchange;
            }
            set
            {
                if ((object.ReferenceEquals(this.canchange, value) != true))
                {
                    canchange = value;
                    OnPropertyChanged("CanChange");
                }
            }
        }

        [DisplayAttribute(AutoGenerateField = false)]
        public SMS SMS
        {
            get
            {
                if (sms == null)
                    sms = new SMS();
                return sms;
            }
            set
            {
                if ((object.ReferenceEquals(this.sms, value) != true))
                {
                    sms = value;
                    OnPropertyChanged("SMS");
                }
            }
        }

        [DisplayAttribute(Name = "Observação")]
        public string Comments
        {
            get
            {
                if (comments == null)
                    comments = "";
                return comments;
            }
            set
            {
                if ((object.ReferenceEquals(this.comments, value) != true))
                {
                    comments = value;
                    OnPropertyChanged("Comments");
                }
            }
        }

        [DisplayAttribute(AutoGenerateField = false)]
        public History History
        {
            get
            {
                if (history == null)
                    history = new History();
                return history;
            }
            set
            {
                if ((object.ReferenceEquals(this.history, value) != true))
                {
                    history = value;
                    OnPropertyChanged("History");
                }
            }
        }
        [DisplayAttribute(AutoGenerateField = false)]
        public bool Send
        {
            get
            {
                return send;
            }
            set
            {
                if ((object.ReferenceEquals(this.send, value) != true))
                {
                    send = value;
                    OnPropertyChanged("Send");
                }
            }
        }

        [DisplayAttribute(AutoGenerateField = false)]
        public string ToEmail
        {
            get
            {
                string msg = "";
                return msg;
            }
        }

        public int ToSMS()
        {
            if (!Send)
                return 0;

            SMS.Text = Client.CodeName.Trim();

            foreach (Person p in ContactPerson)
            {
                SMS.Text += p.Name.Trim().Length > 0 ? string.Format(" {0}", p.Name.Trim()) : "";
                SMS.Text += p.Department.Trim().Length > 0 ? string.Format("/{0}", p.Department.Trim()) : "";

                foreach (Fone f in p.ContactFone)
                    SMS.Text += string.Format(" Tel:{0} {1}-{2}{3}",
                                        Vendor.ContactFone.Any(x => x.AreaCode.Trim() == f.AreaCode.Trim()) ? "" : "(" + f.AreaCode.Trim() + ")",
                                        f.Prefix.Trim(),
                                        f.Number.Trim(),
                                        f.AccessCode.Trim().Length > 0 ? " R" + f.AccessCode.Trim() : "");
            }

            foreach (Address a in LocationAddress)
                SMS.Text += string.Format(" End:{0}{1}{2}{3}{4}",
                                    a.Street.Trim(), a.Number.Length > 0 ? "," + a.Number.Trim() : "",
                                    a.Complement.Trim().Length > 0 ? " " + a.Complement.Trim() : "",
                                    a.District.Trim().Length > 0 ? " " + a.District.Trim() : "",
                                    a.City.Name.Trim().Length > 0 ? " " + a.City.Name.Trim() : "");

            SMS.Text += Comments.Trim().Length > 0 ? " " + Comments.Trim() : "";

            return SMS.Text.Length;
        }

        public Register Clone()
        {
            Register v = new Register()
            {
                Id = this.Id,
                Selected = this.Selected,
                HasChanges = this.HasChanges,
                DateTime = this.DateTime,
                Client = Client.Clone(),
                Vendor = Vendor.Collection.Where(c => c.Id == this.Vendor.Id).First().Clone(),
                Type = this.Type,
                Status = this.Status,
                Send = this.Send,
                SMS = this.SMS,
                Comments = this.Comments,
                CanChange = this.CanChange
            };
            if (Client == null)
                throw new Exception("Os dados do Cliente não estão consistentes !");

            if (Vendor == null)
                throw new Exception("Os dados do Representante não estão consistentes !");

            foreach (Product p in v.Products)
                p.Selected = this.Products.Where(i => i.Guid == p.Guid && i.Selected).Any();

            foreach (Person p in ContactPerson)
            {
                Person i = v.Client.ContactPerson.Where(x => x.Guid == p.Guid).First();
                if (i != null)
                    v.ContactPerson.Add(i);
            }

            if (LocationAddress.Count > 1)
                throw new Exception("Existe mais de 1 endereço de Atendimento selecionado !");

            foreach (Address a in LocationAddress)
            {
                Address i = v.Client.LocationAddress.Where(x => x.Guid == a.Guid).FirstOrDefault();
                if (i != null)
                    v.LocationAddress.Add(i);
            }

            return v;
        }

        #endregion

        #region Events
        #endregion

        #region Commands
        #endregion

        #region Events
        #endregion

        #region XML

        [DisplayAttribute(AutoGenerateField = false)]
        public override XElement ToXML
        {
            get
            {
                return new XElement("Register",   
                        new XAttribute("Id", Id),
                        new XElement("DateTime", DateTime),
                        new XElement(Client.ToXML),
                        new XElement(Vendor.ToXML),
                        new XElement("Type", new XAttribute("Id", Type != null ? Type.Id.ToString() : "0"), Type != null ? Type.Description : ""),
                        new XElement("Status", new XAttribute("Id", Status != null ? Status.Id.ToString() : "0"), Status != null ? Status.Description : ""),
                        new XElement("ContactPerson", ContactPerson.Select(c => c.ToXML)),
                        new XElement("LocationAddress", LocationAddress.Select(l => l.ToXML)),
                        new XElement("Products", Products.Where(c => c.Selected == true).Select(c => c.ToXML)),
                        new XElement("Comments", Comments.Trim()),
                        new XElement(History.ToXML),
                        Send ? new XElement("Message", vendor.ContactEmail.Select(e => e.ToXML), new XElement(SMS.ToXML("Attendance.Register"))) : null);
            }
            set
            {
                Id = value.Attribute("Id") != null ? int.Parse(value.Attribute("Id").Value) : 0;
                DateTime = value.Element("DateTime") != null ? DateTime.Parse(value.Element("DateTime").Value) : DateTime.Now;

                CanChange = false;

                if (value.Element("Client") != null)
                {
                    /*if (Models.Sales.Client.Collection.Any(c => c.Id == int.Parse(value.Element("Client").Attribute("Id").Value)))
                        Client = Models.Sales.Client.Collection.First(c => c.Id == int.Parse(value.Element("Client").Attribute("Id").Value));
                    else
                    {*/
                        Client = new Client() { ToXML = value.Element("Client") };
                        Models.Sales.Client.Collection.Add(Client);
                    //}
                }

                if (value.Element("Vendor") != null)
                {
                    if (Vendor.Collection.Any(c => c.Id == int.Parse(value.Element("Vendor").Attribute("Id").Value)))
                        Vendor = Vendor.Collection.First(c => c.Id == int.Parse(value.Element("Vendor").Attribute("Id").Value));
                    else
                        Vendor = new Vendor() { ToXML = value.Element("Vendor") };
                }

                if (value.Element("Type") != null)
                {
                    if (Type.Collection.Any(c => c.Id == int.Parse(value.Element("Type").Attribute("Id").Value)))
                        Type = Type.Collection.First(c => c.Id == int.Parse(value.Element("Type").Attribute("Id").Value));
                    else
                        throw new Exception("Erro ao carregar as informações do Atendimento, o Tipo de Atendimento não esta cadastrado, contate suporte !");
                }

                if (value.Element("Status") != null)
                {
                    if (Status.Collection.Any(c => c.Id == int.Parse(value.Element("Status").Attribute("Id").Value)))
                        Status = Status.Collection.First(c => c.Id == int.Parse(value.Element("Status").Attribute("Id").Value));
                    else
                        throw new Exception("Erro ao carregar as informações do Atendimento, a Situação não esta esta cadastrado, contate suporte !");
                }

                if (value.Element("ContactPerson") != null)
                    foreach (Person p in Client.ContactPerson)
                    {
                        if (value.Element("ContactPerson").Elements("Person").Where(x => System.Guid.Parse(x.Attribute("Guid").Value) == p.Guid).Any())
                            ContactPerson.Add(p);
                    }

                if (value.Element("LocationAddress") != null)
                    foreach (Address a in Client.LocationAddress)
                    {
                        if (value.Element("LocationAddress").Elements("Address").Where(x => System.Guid.Parse(x.Attribute("Guid").Value) == a.Guid).Any())
                            LocationAddress.Add(a);
                    }

                if (LocationAddress.Count > 1)
                    throw new Exception("Existe mais de 1 endereço de Atendimento selecionado !");

                if (value.Element("Products") != null)
                {
                    foreach (Product p in Products)
                    {
                        //p.Selected = value.Element("Products").Elements("Product").Where(x => System.Guid.Parse(x.Attribute("Guid").Value) == p.Guid).Any();
                        p.Selected = value.Element("Products").Elements("Product").Where(x => int.Parse(x.Attribute("Id").Value) == p.Id).Any();
                    }
                }

                Comments = value.Element("Comments") != null ? value.Element("Comments").Value.Trim() : "";
            }
        }
        #endregion
    }
}
