using System;
using System.Collections.ObjectModel;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Windows;
using System.Xml.Linq;
using GestaoApp.Helpers;

namespace GestaoApp.Models.Bid
{
    public class PurchaseType : Base
    {
        #region Attributes

        private string description;

        private static ObservableCollection<PurchaseType> collection;

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

        public PurchaseType Clone()
        {
            return new PurchaseType()
            {
                Id = this.Id,
                Selected = this.Selected,
                HasChanges = this.HasChanges,
                Description = this.Description
            };
        }
        public static void LoadCollection()
        {
            collection = new ObservableCollection<PurchaseType>()
            { 
                new PurchaseType() { Id = 1, Description = "EXPORTACAO" },
                new PurchaseType() { Id = 2, Description = "MERCANTIL" }, 
                new PurchaseType() { Id = 3, Description = "NAO CONTRIBUINTE" }, 
                new PurchaseType() { Id = 4, Description = "ZONA FRANCA" },
            };
        }

        public static ObservableCollection<PurchaseType> Collection
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

        #region Commands
        #endregion

        #region XML

        [DisplayAttribute(AutoGenerateField = false)]
        public override XElement ToXML
        {
            get
            {
                return new XElement("Status",
                                            new XAttribute("Id", Id),
                                            new XElement("Description", Description.Trim())
                                    );
            }
            set
            {
                Id = value.Attribute("Id") != null ? int.Parse(value.Attribute("Id").Value) : 0;
                Description = value.Element("Description") != null ? value.Element("Description").Value.Trim() : "";
            }
        }

        #endregion
    }
}
