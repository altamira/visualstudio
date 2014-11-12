using System;
using System.Collections.ObjectModel;
using System.ComponentModel.DataAnnotations;
using System.Windows.Controls;
using System.Windows.Media.Imaging;
using System.Xml.Linq;

namespace GestaoApp.Models.Contact
{
    public class FoneType : Base
    {
        #region Attributes

        private string description;
        private Image image;

        private static ObservableCollection<FoneType> collection;

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

        [DisplayAttribute(Name = "Imagem")]
        public Image Image
        {
            get
            {
                if (image == null)
                    image = new Image();
                return image;
            }
            set
            {
                if ((object.ReferenceEquals(this.image, value) != true))
                {
                    image = value;
                    OnPropertyChanged("Image");
                }
            }
        }

        public override String ToString()
        {
            return Description;
        }

        public static void LoadCollection()
        {
            collection = new ObservableCollection<FoneType>()
            { 
                new FoneType() { Id = 1, Description = "Telefone", Image = new Image() { Source = new BitmapImage(new Uri(@"/GestaoApp;component/Images/fone.jpg", UriKind.Relative)) } },
                new FoneType() { Id = 2, Description = "Fax", Image = new Image() { Source = new BitmapImage(new Uri(@"/GestaoApp;component/Images/fax.jpg", UriKind.Relative)) } }, 
                new FoneType() { Id = 3, Description = "Fone/Fax", Image = new Image() { Source = new BitmapImage(new Uri(@"/GestaoApp;component/Images/fax.jpg", UriKind.Relative)) } }, 
                new FoneType() { Id = 4, Description = "Celular", Image = new Image() { Source = new BitmapImage(new Uri(@"/GestaoApp;component/Images/cel.jpg", UriKind.Relative)) } },
                new FoneType() { Id = 5, Description = "PABX", Image = new Image() { Source = new BitmapImage(new Uri(@"/GestaoApp;component/Images/pabx.jpg", UriKind.Relative)) } },
                new FoneType() { Id = 6, Description = "DDR (Discagem direta ao Ramal)", Image = new Image() { Source = new BitmapImage(new Uri(@"/GestaoApp;component/Images/ddr2.jpg", UriKind.Relative)) } },
                new FoneType() { Id = 7, Description = "Nextel/Radio", Image = new Image() { Source = new BitmapImage(new Uri(@"/GestaoApp;component/Images/nextel2.jpg", UriKind.Relative)) } },
                new FoneType() { Id = 8, Description = "Pager", Image = new Image() { Source = new BitmapImage(new Uri(@"/GestaoApp;component/Images/pager.jpg", UriKind.Relative)) } } 
            };
        }

        public static ObservableCollection<FoneType> Collection
        {
            get
            {
                if (collection == null)
                    LoadCollection();
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

        #region XML

        [DisplayAttribute(AutoGenerateField = false)]
        public override XElement ToXML
        {
            get
            {
                return new XElement("FoneType",
                                            new XAttribute("Id", Id),
                                            new XElement("Description", Description.Trim()),
                                            new XElement("Image", "")
                                    );
            }
            set
            {
                Id = value.Attribute("Id") != null ? int.Parse(value.Attribute("Id").Value) : 0;
                Description = value.Element("Description") != null ? value.Element("Description").Value.Trim() : "";
                Image = new Image();
            }
        }

        #endregion
    }
}
