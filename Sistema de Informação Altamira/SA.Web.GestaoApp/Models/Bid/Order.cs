using System;
using System.Collections.ObjectModel;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Windows;
using System.Xml.Linq;
using GestaoApp.Helpers;
using SilverlightMessageBoxLibrary;
using System.Globalization;
using GestaoApp.Models.Sales;

namespace GestaoApp.Models.Bid
{
    public class Order : Base
    {
        public class PaymentCondition : Base
        {
            #region Attributes
            private string condition;
            private string description;
            #endregion

            #region Properties

            [DisplayAttribute(Name = "Condição")]
            public string Condition
            {
                get
                {
                    if (condition == null)
                        condition = "";
                    return condition;
                }
                set
                {
                    if ((object.ReferenceEquals(this.condition, value) != true))
                    {
                        condition = value;
                        OnPropertyChanged("Condition");
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

            public new string ToString
            {
                get
                {
                    return condition + "(" + description + ")\n";
                }
            }
            #endregion

            #region XML

            [DisplayAttribute(AutoGenerateField = false)]
            public override XElement ToXML
            {
                get
                {
                    return new XElement("PaymentOption",
                            new XElement("Condition", Condition),
                            new XElement("Description", Description));
                    ;
                }
                set
                {
                    Condition = value.Element("Condition") != null ? value.Element("Condition").Value.Trim() : "";
                    Description = value.Element("Description") != null ? value.Element("Description").Value.Trim() : "";
                }
            }
            #endregion
            
        }

        public class Item : Base
        {
            #region Attributes
            private string code;
            private string description;
            private string color;
            private decimal quantity;
            private decimal weight;
            private decimal price;
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
            public decimal Quantity
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

            [DisplayAttribute(Name = "Preço")]
            public decimal Price
            {
                get
                {
                    return price;
                }
                set
                {
                    if ((object.ReferenceEquals(this.price, value) != true))
                    {
                        price = value;
                        OnPropertyChanged("Value");
                    }
                }
            }

            [DisplayAttribute(Name = "Sub Total")]
            public decimal SubTotal
            {
                get
                {
                    return Price * Quantity;
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
                            new XElement("Weight", Weight),
                            new XElement("Value", Weight));
                    ;
                }
                set
                {
                    Code = value.Element("Code") != null ? value.Element("Code").Value.Trim() : "";
                    Description = value.Element("Description") != null ? value.Element("Description").Value.Trim() : "";
                    Color = value.Element("Color") != null ? value.Element("Color").Value.Trim() : "";
                    Quantity = value.Element("Quantity") != null ? decimal.Parse(value.Element("Quantity").Value, new CultureInfo("en-US")) : 0;
                    Weight = value.Element("Weight") != null ? decimal.Parse(value.Element("Weight").Value, new CultureInfo("en-US")) : 0;
                    Price = value.Element("Price") != null ? decimal.Parse(value.Element("Price").Value, new CultureInfo("en-US")) : 0;
                }
            }
            #endregion
        }

        #region Attributes

        private DateTime orderdate;
        private DateTime shipdate;
        private int number;
        private Client client;
        private decimal comissionpercent;
        private decimal comissionvalue;
        private ObservableCollection<PaymentCondition> paymentconditions;
        private ObservableCollection<Item> items;

        private static ObservableCollection<Order> collection;

        #endregion

        #region Properties

        [DisplayAttribute(Name = "Data Pedido")]
        public DateTime OrderDate
        {
            get
            {
                if (orderdate == null)
                    orderdate = DateTime.Now;
                return orderdate;
            }
            set
            {
                if ((object.ReferenceEquals(this.orderdate, value) != true))
                {
                    orderdate = value;
                    OnPropertyChanged("OrderDate");
                }
            }
        }

        [DisplayAttribute(Name = "Data Entrega")]
        public DateTime ShipDate
        {
            get
            {
                if (shipdate == null)
                    shipdate = DateTime.Now;
                return shipdate;
            }
            set
            {
                if ((object.ReferenceEquals(this.shipdate, value) != true))
                {
                    shipdate = value;
                    OnPropertyChanged("ShipDate");
                }
            }
        }

        [DisplayAttribute(Name = "Número")]
        public int Number
        {
            get
            {
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

        [DisplayAttribute(Name = "Cliente")]
        public Client Client
        {
            get
            {
                if (client == null)
                    client = new Client();
                return client;
            }
        }

        [DisplayAttribute(Name = "Comissão")]
        public decimal ComissionPercent
        {
            get
            {
                return comissionpercent;
            }
            set
            {
                if ((object.ReferenceEquals(this.comissionpercent, value) != true))
                {
                    comissionpercent = value;
                    OnPropertyChanged("ComissionPercent");
                }
            }
        }

        [DisplayAttribute(Name = "Valor Comissão")]
        public decimal ComissionValue
        {
            get
            {
                return comissionvalue;
            }
            set
            {
                if ((object.ReferenceEquals(this.comissionvalue, value) != true))
                {
                    comissionvalue = value;
                    OnPropertyChanged("ComissionValue");
                }
            }
        }

        [DisplayAttribute(Name = "Forma Pagto")]
        public ObservableCollection<PaymentCondition> PaymentConditions
        {
            get
            {
                if (paymentconditions == null)
                    paymentconditions = new ObservableCollection<PaymentCondition>();
                return paymentconditions;
            }
            set
            {
                if ((object.ReferenceEquals(this.paymentconditions, value) != true))
                {
                    paymentconditions = value;
                    OnPropertyChanged("PaymentConditions");
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

        public override String ToString()
        {
            return Number.ToString();
        }

        public Order Clone()
        {
            return new Order()
            {
                Id = this.Id,
                Selected = this.Selected,
                HasChanges = this.HasChanges,
                Number = this.Number
            };
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
                        new Uri(string.Format("http://{0}:{1}/Sales.Order.List", Application.Current.Host.Source.Host, Application.Current.Host.Source.Port)),
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
                        collection = new ObservableCollection<Order>
                                    (from order in xParse.Descendants("Order")
                                     select new Order() { ToXML = order });

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
                return new XElement("Order",
                                            new XAttribute("Number", Number),
                                            new XElement(client.ToXML)
                                    );
            }
            set
            {
                OrderDate = value.Element("OrderDate") != null ? DateTime.Parse(value.Element("OrderDate").Value) : DateTime.Now;
                ShipDate = value.Element("ShipDate") != null ? DateTime.Parse(value.Element("ShipDate").Value) : DateTime.Now;
                Number = value.Attribute("Number") != null ? int.Parse(value.Attribute("Number").Value) : 0;

                client = new Client() { ToXML = value.Element("Client") };

                ComissionPercent = value.Element("ComissionPercent") != null ? decimal.Parse(value.Element("ComissionPercent").Value, new CultureInfo("en-US")) : 0;
                ComissionValue = value.Element("ComissionValue") != null ? decimal.Parse(value.Element("ComissionValue").Value, new CultureInfo("en-US")) : 0;

                if (value.Elements("PaymentCondition").Any())
                {
                    string[] s = value.Element("PaymentCondition").Value.Trim().Split(';');
                    PaymentConditions = new ObservableCollection<PaymentCondition>();
                    foreach(string i in s)
                    {
                        if (i.Trim().Split('|').Length > 1)
                        {
                            PaymentCondition p = new PaymentCondition();
                            p.Condition = i.Split('|')[0];
                            p.Description = i.Split('|')[1];
                            PaymentConditions.Add(p);
                        }
                     
                    }
                }

                //PaymentOption = value.Element("PaymentOption") != null ? value.Element("PaymentOption").Value : "";

                if (value.Elements("Items").Any())
                    Items = new ObservableCollection<Item>
                        (from item in value.Element("Items").Elements("Item")
                         select new Item()
                         {
                             ToXML = item,
                         });
            }
        }

        #endregion
    }
}
