using System;
using System.ComponentModel.DataAnnotations;
using System.Xml.Linq;

namespace GestaoApp.Models.Contact
{
    public class Email : Base
    {
        #region Attribute

        private string address /*= ""*/;

        #endregion

        #region Properties

        [Required(AllowEmptyStrings=false, ErrorMessage="O Endereço do Email é obrigatório.")]
        [DisplayAttribute(Name = "Endereço")]
        [RegularExpression(@"^([a-zA-Z0-9_\-\.]+)@((\[[0-9]{1,3}" +
                              @"\.[0-9]{1,3}\.[0-9]{1,3}\.)|(([a-zA-Z0-9\-]+\" +
                              @".)+))([a-zA-Z]{2,4}|[0-9]{1,3})(\]?)$", ErrorMessage="Formato do email inválido.")]
        public string Address
        {
            get
            {
                if (address == null)
                    address = "";
                return address;
            }
            set
            {
                if ((object.ReferenceEquals(this.address, value) != true))
                {
                    //Validator.ValidateProperty(value, new ValidationContext(this, null, null) { MemberName = "Address" });
                    address = value;
                    OnPropertyChanged("Address");
                }
            }
        }

        public override String ToString()
        {
            return Address;
        }

        public Email Clone()
        {
            return new Email()
            {
                Guid = this.Guid,
                Selected = this.Selected,
                HasChanges = this.HasChanges,
                Address = this.Address 
            };
        }

        #endregion

        #region XML

        [DisplayAttribute(AutoGenerateField = false)]
        public override XElement ToXML
        {
            get
            {
                return new XElement("Email",
                                            new XAttribute("Guid", Guid.ToString()),
                                            new XElement("Address", Address.Trim())
                                    );
            }
            set
            {
                Guid = value.Attribute("Guid") != null ? Guid.Parse(value.Attribute("Guid").Value) : System.Guid.NewGuid();
                Address = value.Element("Address") != null ? value.Element("Address").Value.Trim() : "";
            }
        }

        #endregion
    }
}
