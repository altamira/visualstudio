using System;
using System.Collections.ObjectModel;
using System.ComponentModel.DataAnnotations;
using System.Xml.Linq;
using System.Globalization;

namespace GestaoApp.Models.Shipping
{
    public class Material : Base
    {
        #region Attributes

        private string code;
        private string description;
        private int quantity;
        private decimal weight;

        #endregion

        #region Properties

        [DisplayAttribute(Name = "Código")]
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

        [DisplayAttribute(Name = "Código")]
        public string Value { get; set; }

        public override String ToString()
        {
            return Description;
        }

        public Material Clone()
        {
            return new Material()
            {
                Guid = this.Guid,
                Selected = this.Selected,
                HasChanges = this.HasChanges,
                Code = this.Code,
                Description = this.Description,
                Quantity = this.Quantity,
                Weight = this.Weight
            };
        }

        #endregion

        #region XML

        [DisplayAttribute(AutoGenerateField = false)]
        public override XElement ToXML
        {
            get
            {
                return new XElement("Material",
                                            new XAttribute("Guid", Guid.ToString()),
                                            new XElement("Code", Code),
                                            new XElement("Description", Description),
                                            new XElement("Quantity", Quantity.ToString()),
                                            new XElement("Weight", Weight.ToString())                
                                    );
            }
            set
            {
                Guid = value.Attribute("Guid") != null ? Guid.Parse(value.Attribute("Guid").Value) : System.Guid.NewGuid();
                Code = value.Element("Code") != null ? value.Element("Code").Value : "";
                Description = value.Element("Description") != null ? value.Element("Description").Value : "";
                Quantity = value.Element("Quantity") != null ? int.Parse(value.Element("Quantity").Value) : 0;
                Weight = value.Element("Weight") != null ? decimal.Parse(value.Element("Weight").Value, new CultureInfo("en-US")) : 0;
            }
        }

        #endregion
    }
}
