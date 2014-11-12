using System;
using System.Collections.ObjectModel;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Xml.Linq;
using GestaoApp.Models.Sales;
using GestaoApp.Models.Bid;

namespace GestaoApp.Models.Shipping
{
    public class PackingList : Base
    {
        #region Attributes

        //private DateTime datetime = DateTime.Now;
        private Client client;
        private Register bid;
        private GestaoApp.Models.Bid.Order order;
        private ObservableCollection<Material> items;
        private string comments;

        #endregion

        #region Properties

        /*[Required(AllowEmptyStrings = false, ErrorMessage = "A Data é obrigatória.")]
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
        }*/

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
                }
            }
        }

        //[DisplayAttribute(Name = "Cliente")]
        //public String Client
        //{
        //    get
        //    {
        //        if (client.Name == null)
        //            client = new Client();
        //        return client.Name;
        //    }
        //    set
        //    {
        //        if ((object.ReferenceEquals(this.client.Name, value) != true))
        //        {
        //            client.Name = value;
        //            OnPropertyChanged("Client");
        //        }
        //    }
        //}

        [DisplayAttribute(Name = "Orçamento")]
        public Register Bid
        {
            get
            {
                if (bid == null)
                    bid = new Register();
                return bid;
            }
            set
            {
                if ((object.ReferenceEquals(this.bid, value) != true))
                {
                    bid = value;
                    OnPropertyChanged("Bid");
                }
            }
        }

        [DisplayAttribute(Name = "Pedido")]
        public GestaoApp.Models.Bid.Order Order
        {
            get
            {
                if (order == null)
                    order = new GestaoApp.Models.Bid.Order();
                return order;
            }
            set
            {
                if ((object.ReferenceEquals(this.order, value) != true))
                {
                    order = value;
                    OnPropertyChanged("Order");
                }
            }
        }

        [DisplayAttribute(AutoGenerateField = false)]
        public ObservableCollection<Material> Items
        {
            get
            {
                if (items == null)
                    items = new ObservableCollection<Material>();
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

        public PackingList Clone()
        {
            PackingList v = new PackingList()
            {
                Id = this.Id,
                Selected = this.Selected,
                HasChanges = this.HasChanges,
                //DateTime = this.DateTime,
                client = Models.Sales.Client.Collection.Where(c => c.Id == this.client.Id).First().Clone(),
                Bid = this.Bid.Clone(),
                Comments = this.Comments
            };
            if (Client == null)
                throw new Exception("Os dados do Cliente não estão consistentes !");

            v.Items = new ObservableCollection<Material>(Items.Select(i => i.Clone()));

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
                return new XElement("PackingList",   
                    //new XAttribute("Id", Id),
                    //new XElement("DateTime", DateTime),
                    new XElement(Client.ToXML),
                    //new XElement("Client", client.Name),
                    new XElement("Bid.Register", Bid),
                    new XElement("Items", Items.Select(c => c.ToXML)),
                    new XElement("Comments", Comments));
            }
            set
            {
                //Id = value.Attribute("Id") != null ? int.Parse(value.Attribute("Id").Value) : 0;
                //DateTime = value.Element("DateTime") != null ? DateTime.Parse(value.Element("DateTime").Value) : DateTime.Now;

                if (value.Element("Client") != null)
                {
                    if (Models.Sales.Client.Collection.Any(c => c.Id == int.Parse(value.Element("Client").Attribute("Id").Value)))
                        client = Models.Sales.Client.Collection.First(c => c.Id == int.Parse(value.Element("Client").Attribute("Id").Value));
                    else
                        client = new Client() { ToXML = value.Element("Client") };
                }

                if (value.Element("Bid.Register") != null)
                    Bid = new Bid.Register() { ToXML = value.Element("Bid.Register") };

                if (value.Element("Order") != null)
                    Order = new GestaoApp.Models.Bid.Order() { ToXML = value.Element("Order") };

                Items = new ObservableCollection<Material>
                                (from material in value.Element("Items").Elements("Material")
                                 select new Material() { ToXML = material });

                Comments = value.Element("Comments") != null ? value.Element("Comments").Value : "";
            }
        }
        #endregion
    }
}
