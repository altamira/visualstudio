using System;
using System.Collections.ObjectModel;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Xml.Linq;
using GestaoApp.Models.Contact;
using GestaoApp.Models.Location;
using System.Globalization;
using GestaoApp.Models.Sales;

namespace GestaoApp.Models.Bid
{
    public class Register : Base
    {
        public class Item : Base
        {
            #region Attributes
            private string code;
            private string description;
            private string color;
            private int quantity;
            private decimal weight;
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
                        code = value;
                        OnPropertyChanged("Code");
                    }
                }
            }

            [DisplayAttribute(Name = "Descrição")]
            public string Description
            {
                get
                {
                    if (description == null)
                        description = "";
                    return description;
                }
                set
                {
                    if ((object.ReferenceEquals(this.description, value) != true))
                    {
                        description = value;
                        OnPropertyChanged("Description");
                    }
                }
            }

            [DisplayAttribute(Name = "Cor")]
            public string Color
            {
                get
                {
                    if (color == null)
                        color = "";
                    return color;
                }
                set
                {
                    if ((object.ReferenceEquals(this.color, value) != true))
                    {
                        color = value;
                        OnPropertyChanged("Color");
                    }
                }
            }

            [DisplayAttribute(Name = "Quantidade")]
            public int Quantity
            {
                get
                {
                    return quantity;
                }
                set
                {
                    if ((object.ReferenceEquals(this.quantity, value) != true))
                    {
                        quantity = value;
                        OnPropertyChanged("Quantity");
                    }
                }
            }

            [DisplayAttribute(Name = "Peso")]
            public decimal Weight
            {
                get
                {
                    return weight;
                }
                set
                {
                    if ((object.ReferenceEquals(this.weight, value) != true))
                    {
                        weight = value;
                        OnPropertyChanged("Weight");
                    }
                }
            }
            #endregion

            #region XML

            [DisplayAttribute(AutoGenerateField = false)]
            public override XElement ToXML
            {
                get
                {
                    return new XElement("Item",
                            new XElement("Code", Code),
                            new XElement("Description", Description),
                            new XElement("Color", Color),
                            new XElement("Quantity", Quantity),
                            new XElement("Weight", Weight));
;
                }
                set
                {
                    Code = value.Element("Code") != null ? value.Element("Code").Value.Trim() : "";
                    Description = value.Element("Description") != null ? value.Element("Description").Value.Trim() : "";
                    Color = value.Element("Color") != null ? value.Element("Color").Value.Trim() : "";
                    Quantity = value.Element("Quantity") != null ? int.Parse(value.Element("Quantity").Value) : 0;
                    Weight = value.Element("Weight") != null ? decimal.Parse(value.Element("Weight").Value, new CultureInfo("en-US")) : 0;
                }
            }
            #endregion

        }

        #region Attributes

        private DateTime datetime = DateTime.Now;
        private string number;
        private string revision;
        private Client client;
        private Vendor vendor;
        private DateTime statusdatetime = DateTime.Now;
        private String status;
        private PurchaseType purchasetype;
        private Person contactperson;
        private ObservableCollection<Person> contactpersoncopyto;
        private Address locationaddress;
        private string comments;
        private string wbccadcomments;

        private ObservableCollection<Document> documents;
        private ObservableCollection<Document> projects;
        private ObservableCollection<Item> items;
        private ObservableCollection<Register> revisions;
        private ObservableCollection<Order> orders;

        #endregion

        #region Properties

        [DisplayAttribute(Name = "Número")]
        public string Number
        {
            get
            {
                if (number == null)
                    number = "";
                return number;
            }
            set
            {
                if ((object.ReferenceEquals(this.number, value) != true))
                {
                    number = value;
                    OnPropertyChanged("Number");
                }
            }
        }

        [DisplayAttribute(Name = "Revisão")]
        public string Revision
        {
            get
            {
                if (revision == null)
                    revision = "";
                return revision;
            }
            set
            {
                if ((object.ReferenceEquals(this.revision, value) != true))
                {
                    revision = value;
                    OnPropertyChanged("Revision");
                }
            }
        }

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

                    //if (client != null)
                        //Vendor = client.Vendor;
                    //else
                    //    Vendor = null;
                }
            }
        }

        [DisplayAttribute(Name = "Data Situação")]
        [DisplayFormat(DataFormatString = "{0:d}", ApplyFormatInEditMode = true)]
        public DateTime StatusDateTime
        {
            get
            {
                if (statusdatetime == null)
                    statusdatetime = DateTime.Now.Date;
                return statusdatetime;
            }
            //set
            //{
            //    if ((object.ReferenceEquals(this.statusdatetime, value) != true))
            //    {
            //        statusdatetime = value;
            //        OnPropertyChanged("StatusDateTime");
            //    }
            //}
        }

        [DisplayAttribute(Name = "Situação")]
        public string Status
        {
            get
            {
                if (status == null)
                    status = "";
                return status;
            }
        }

        [DisplayAttribute(Name = "Pedido")]
        public string OrderNumber
        {
            get
            {
                string number = "";
                foreach (Order o in Orders)
                {
                    number += (number.Trim().Length > 0 ? ", " : "") + o.Number.ToString();
                }
                return number;
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

        [DisplayAttribute(Name = "Contato")]
        public Person ContactPerson
        {
            get
            {
                if (contactperson == null)
                    contactperson = new Person();
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

        [DisplayAttribute(Name = "Tipo de Venda")]
        public PurchaseType PurchaseType
        {
            get
            {
                if (purchasetype == null)
                    purchasetype = PurchaseType.Collection.Where(p => p.Id == 2).First();
                return purchasetype;
            }
            set
            {
                if ((object.ReferenceEquals(this.purchasetype, value) != true))
                {
                    purchasetype = value;
                    OnPropertyChanged("PurchaseType");
                }
            }
        }

        [DisplayAttribute(AutoGenerateField = false)]
        public ObservableCollection<Person> ContactPersonCopyTo
        {
            get
            {
                if (contactpersoncopyto == null)
                    contactpersoncopyto = new ObservableCollection<Person>();
                return contactpersoncopyto;
            }
            set
            {
                if ((object.ReferenceEquals(this.contactpersoncopyto, value) != true))
                {
                    contactpersoncopyto = value;
                    OnPropertyChanged("ContactPersonCopyTo");
                }
            }
        }

        [DisplayAttribute(Name = "Endereço")]
        public Address LocationAddress
        {
            get
            {
                if (locationaddress == null)
                    locationaddress = new Address();
                return locationaddress;
            }
            set
            {
                if ((object.ReferenceEquals(this.locationaddress, value) != true))
                {
                    locationaddress = value;
                    OnPropertyChanged("LocationAddress");

                    if (locationaddress != null)
                        Vendor = locationaddress.Vendor;
                    //else
                    //    Vendor = null;
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

        [DisplayAttribute(Name = "Observação WBCCAD")]
        public string WBCCADComments
        {
            get
            {
                if (wbccadcomments == null)
                    wbccadcomments = "";
                return wbccadcomments;
            }
            set
            {
                if ((object.ReferenceEquals(this.wbccadcomments, value) != true))
                {
                    wbccadcomments = value;
                    OnPropertyChanged("WBCCADComments");
                }
            }
        }

        [DisplayAttribute(AutoGenerateField = false)]
        public ObservableCollection<Item> Items
        {
            get
            {
                if (items == null)
                    items = new ObservableCollection<Item>();
                return items;
            }
            set
            {
                if ((object.ReferenceEquals(this.items, value) != true))
                {
                    items = value;
                    OnPropertyChanged("Items");
                }
            }
        }

        [DisplayAttribute(AutoGenerateField = false)]
        public ObservableCollection<Document> Documents
        {
            get
            {
                if (documents == null)
                    documents = new ObservableCollection<Document>();
                return documents;
            }
            set
            {
                if ((object.ReferenceEquals(this.documents, value) != true))
                {
                    documents = value;
                    OnPropertyChanged("Documents");
                }
            }
        }

        [DisplayAttribute(AutoGenerateField = false)]
        public ObservableCollection<Document> Projects
        {
            get
            {
                if (projects == null)
                    projects = new ObservableCollection<Document>();
                return projects;
            }
            set
            {
                if ((object.ReferenceEquals(this.projects, value) != true))
                {
                    projects = value;
                    OnPropertyChanged("Projects");
                }
            }
        }

        [DisplayAttribute(AutoGenerateField = false)]
        public ObservableCollection<Register> Revisions
        {
            get
            {
                if (revisions == null)
                    revisions = new ObservableCollection<Register>();
                return revisions;
            }
            set
            {
                if ((object.ReferenceEquals(this.revisions, value) != true))
                {
                    revisions = value;
                    OnPropertyChanged("Revisions");
                }
            }
        }

        [DisplayAttribute(AutoGenerateField = false)]
        public Order Order
        {
            get
            {
                if (orders == null)
                    orders = new ObservableCollection<Order>();
                return orders.FirstOrDefault();
            }
        }

        [DisplayAttribute(AutoGenerateField = false)]
        public ObservableCollection<Order> Orders
        {
            get
            {
                if (orders == null)
                    orders = new ObservableCollection<Order>();
                return orders;
            }
            set
            {
                if ((object.ReferenceEquals(this.orders, value) != true))
                {
                    orders = value;
                    OnPropertyChanged("Orders");
                }
            }
        }

        public override string ToString()
        {
            //return base.ToString();
            return Number.ToString();
        }

        public Register Clone()
        {
            Register v = new Register()
            {
                Id = this.Id,
                Selected = this.Selected,
                HasChanges = this.HasChanges,
                DateTime = this.DateTime,
                Number = this.Number,
                status = this.Status,
                Client = this.Client.Clone(), //Client.Collection.Where(c => c.Id == this.Client.Id).First().Clone(),
                Orders = this.Orders,
                ContactPerson = this.ContactPerson.Clone(),
                LocationAddress = this.LocationAddress.Clone(),
                PurchaseType = this.PurchaseType,
                Comments = this.Comments,
                WBCCADComments = this.WBCCADComments,
                Items = this.Items,
                Vendor = this.Vendor //Vendor.Collection.Where(c => c.Id == this.Vendor.Id).First().Clone(),
            };
            if (Client == null)
                throw new Exception("Os dados do Cliente não estão consistentes !");

            if (Vendor == null)
                throw new Exception("Os dados do Representante não estão consistentes !");

            foreach (Person p in ContactPersonCopyTo)
            {
                Person i = v.Client.ContactPerson.Where(x => x.Guid == p.Guid).First();
                if (i != null)
                    v.ContactPersonCopyTo.Add(i);
            }

            /*if (LocationAddress.Count > 1)
                throw new Exception("Mais de 1 Endereço foi selecionado no Orçamento !");

            foreach (Address a in LocationAddress)
            {
                Address i = v.Client.LocationAddress.Where(x => x.Guid == a.Guid).FirstOrDefault();
                if (i != null)
                    v.LocationAddress.Add(i);
            }*/

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
                if (Client == null)
                    throw new Exception("O Cliente não foi selecionado !");
                if (Vendor == null)
                    throw new Exception("O Vendedor não foi selecionado !");

                return  new XElement("Register",   
                        new XAttribute("Id", Id),
                        new XElement("DateTime", DateTime),
                        new XElement("Number", Number.Trim()),
                        new XElement(Client.ToXML),
                        new XElement(Vendor.ToXML),
                        new XElement("ContactPerson", ContactPerson.ToXML),
                        new XElement("PurchaseType", new XAttribute("Id", PurchaseType != null ? PurchaseType.Id.ToString() : "0"), PurchaseType != null ? PurchaseType.Description : ""),
                        new XElement("ContactPersonCopyTo", ContactPersonCopyTo.Select(c => c.ToXML)),
                        new XElement("LocationAddress", LocationAddress.ToXML),
                        new XElement("Comments", Comments.Trim()));
            }
            set
            {
                Id = value.Attribute("Id") != null ? int.Parse(value.Attribute("Id").Value) : 0;
                DateTime = value.Element("DateTime") != null ? DateTime.Parse(value.Element("DateTime").Value) : DateTime.Now;
                Number = value.Element("Number") != null ? value.Element("Number").Value.Trim() : "";
                Revision = value.Element("Revision") != null ? value.Element("Revision").Value.Trim() : "";

                if (value.Element("Client") != null)
                {
                    /*if (Models.Sales.Client.Collection.Any(c => c.Id == int.Parse(value.Element("Client").Attribute("Id").Value)))
                        Client = Models.Sales.Client.Collection.First(c => c.Id == int.Parse(value.Element("Client").Attribute("Id").Value));
                    else
                    {*/
                        client = new Client() { ToXML = value.Element("Client") };
                        //Models.Sales.Client.Collection.Add(Client);
                    //}
                }

                if (value.Element("PurchaseType") != null)
                {
                    if (PurchaseType.Collection.Any(c => c.Id == int.Parse(value.Element("PurchaseType").Attribute("Id").Value)))
                        PurchaseType = PurchaseType.Collection.First(c => c.Id == int.Parse(value.Element("PurchaseType").Attribute("Id").Value));
                    else
                        PurchaseType = new PurchaseType() { ToXML = value.Element("PurchaseType") };
                }

                if (value.Element("ContactPerson") != null)
                {
                    if (value.Element("ContactPerson").Elements("Person").Any())
                    {
                        if (Client.ContactPerson.Any(c => c.Guid == Guid.Parse(value.Element("ContactPerson").Element("Person").Attribute("Guid").Value)))
                            ContactPerson = Client.ContactPerson.First(c => c.Guid == Guid.Parse(value.Element("ContactPerson").Element("Person").Attribute("Guid").Value));
                        else
                            ContactPerson = new Person() { ToXML = value.Element("ContactPerson").Element("Person") };
                    }
                }

                foreach (Person p in Client.ContactPerson)
                {
                    if (value.Element("ContactPersonCopyTo").Elements("Person").Where(x => System.Guid.Parse(x.Attribute("Guid").Value) == p.Guid).Any())
                        ContactPersonCopyTo.Add(p);
                }

                /*if (value.Element("LocationAddress") != null)
                    foreach (Address a in Client.LocationAddress)
                    {
                        if (value.Element("LocationAddress").Elements("Address").Where(x => System.Guid.Parse(x.Attribute("Guid").Value) == a.Guid).Any())
                            LocationAddress.Add(a);
                    }

                if (LocationAddress.Count > 1)
                    throw new Exception("Existe mais de 1 endereço de Atendimento selecionado !");*/

                if (value.Element("LocationAddress") != null)
                {
                    if (value.Element("LocationAddress").Elements("Address").Any())
                    {
                        if (Client.LocationAddress.Any(c => c.Guid == Guid.Parse(value.Element("LocationAddress").Element("Address").Attribute("Guid").Value)))
                            locationaddress = Client.LocationAddress.First(c => c.Guid == Guid.Parse(value.Element("LocationAddress").Element("Address").Attribute("Guid").Value));
                        else
                            locationaddress = new Address() { ToXML = value.Element("LocationAddress").Element("Address") };
                    }
                }

                Comments = value.Element("Comments") != null ? value.Element("Comments").Value.Trim() : "";

                if (value.Elements("WBCCAD").Any())
                {
                    if (value.Element("WBCCAD").Elements("Status").Any())
                    {
                        if (value.Element("WBCCAD").Element("Status").Attribute("DateTime") != null)
                            statusdatetime = DateTime.Parse(value.Element("WBCCAD").Element("Status").Attribute("DateTime").Value).Date;
                        status = value.Element("WBCCAD").Element("Status").Value.Trim();
                    }
                    else
                    {
                        statusdatetime = DateTime.Now.Date;
                        status = "";
                    }
                    if (value.Element("WBCCAD").Elements("Comments").Any())
                        foreach (XElement e in value.Element("WBCCAD").Elements("Comments"))
                        {
                            WBCCADComments += (WBCCADComments.Length > 0 ? "\n" : "") + e.Value.Trim();
                        }
                    
                }

                if (value.Elements("Items").Any())
                    Items = new ObservableCollection<Item>
                        (from item in value.Element("Items").Elements("Item")
                         select new Item()
                         {
                             ToXML = item,
                         });

                if (value.Elements("Revisions").Any())
                    Revisions = new ObservableCollection<Register>
                        (from bid in value.Element("Revisions").Elements("Register")
                            select new Register()
                            {
                                ToXML = bid,
                            });

                if (value.Elements("Documents").Any())
                    Documents = new ObservableCollection<Document>
                        (from document in value.Element("Documents").Elements("Document")
                         select new Document()
                         {
                             ToXML = document,
                         });

                if (value.Elements("Projects").Any())
                    Projects = new ObservableCollection<Document>
                        (from document in value.Element("Projects").Elements("Document")
                         select new Document()
                         {
                             ToXML = document,
                         });

                if (value.Elements("Order").Any())
                    Orders = new ObservableCollection<Order>
                        (from order in value.Elements("Order")
                         select new Order()
                         {
                             ToXML = order,
                         });

                if (value.Element("Vendor") != null)
                {
                    if (Vendor.Collection.Any(c => c.Id == int.Parse(value.Element("Vendor").Attribute("Id").Value)))
                        Vendor = Vendor.Collection.First(c => c.Id == int.Parse(value.Element("Vendor").Attribute("Id").Value));
                    else
                        Vendor = new Vendor() { ToXML = value.Element("Vendor") };
                }
            }
        }
        #endregion
    }
}
