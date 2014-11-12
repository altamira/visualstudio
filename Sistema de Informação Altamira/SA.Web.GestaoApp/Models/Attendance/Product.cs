using System;
using System.Collections.ObjectModel;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Windows;
using System.Xml.Linq;
using GestaoApp.Helpers;
using SilverlightMessageBoxLibrary;

namespace GestaoApp.Models.Attendance
{
    public class Product : Base
    {
        #region Attributes

        private string description;

        private static ObservableCollection<Product> collection;

        #endregion

        #region Properties

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

        public override String ToString()
        {
            return Description;
        }

        //public static void LoadCollection()
        //{
        //    collection = new ObservableCollection<Product>()
        //    { 
        //        new Product() { Guid = Guid.Parse("{A8A4EB24-3B04-4AC0-9C41-716611D7AB37}"), Description = "Estantes/Bancões" },
        //        new Product() { Guid = Guid.Parse("{44432AB2-0705-4980-8563-1C39BE17F628}"), Description = "Porta-Pallet" }, 
        //        new Product() { Guid = Guid.Parse("{B0E5FA99-2DB4-42A7-BDC0-7551338FE3B2}"), Description = "Mezanino" }, 
        //        new Product() { Guid = Guid.Parse("{840D0C17-CEC2-4812-A0D2-1254A92DF1D7}"), Description = "Paineis/Divisórias" },
        //        new Product() { Guid = Guid.Parse("{71407BA4-379A-4CB3-BE8C-5ACC27EB4F1E}"), Description = "Drive-In" },
        //        new Product() { Guid = Guid.Parse("{80FE7761-98E8-479D-AA7D-F5978EFE827E}"), Description = "Produtos Diversos" },
        //        new Product() { Guid = Guid.Parse("{8FC7DE38-3D6A-429F-A455-98843852FF48}"), Description = "Prestação de Serviço" },
        //        new Product() { Guid = Guid.Parse("{B070C500-8D6A-42FB-B423-F679C0CCC22C}"), Description = "Prateleiras" },
        //        new Product() { Guid = Guid.Parse("{AAEDE85C-6D35-408F-868A-C51782BBDBA1}"), Description = "Não Especificado" } 
        //    };
        //}

        public static ObservableCollection<Product> Collection
        {
            get
            {
                if (collection == null)
                    collection = new ObservableCollection<Product>();
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

        public Product Clone()
        {
            return new Product()
            {
                Id = this.Id,
                Guid = this.Guid,
                Selected = this.Selected,
                HasChanges = this.HasChanges,
                Description = this.Description
            };
        }

        public static ObservableCollection<Product> CollectionClone()
        {
            ObservableCollection<Product> products = new ObservableCollection<Product>();

            foreach (Product p in Product.Collection)
                products.Add(p.Clone());

            return products;
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
                        new Uri(string.Format("http://{0}:{1}/Attendance.Product.List", Application.Current.Host.Source.Host, Application.Current.Host.Source.Port)),
                        "POST", new XDocument(), false);

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
                        collection = new ObservableCollection<Product>
                                    (from product in xParse.Descendants("Product")
                                     select new Product() { ToXML = product });

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
                return new XElement("Product",
                                            new XAttribute("Id", Id),
                                            //new XAttribute("Guid", Guid.ToString()),
                                            new XElement("Description", Description.Trim())
                                    );
            }
            set
            {
                Id = value.Attribute("Id") != null ? int.Parse(value.Attribute("Id").Value) : 0;
                //Guid = value.Attribute("Guid") != null ? Guid.Parse(value.Attribute("Guid").Value) : System.Guid.NewGuid();
                Description = value.Element("Description") != null ? value.Element("Description").Value.Trim() : "";
            }
        }

        #endregion
    }
}
