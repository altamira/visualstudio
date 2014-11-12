using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Xml.Linq;
using GestaoApp.Models.Sales;

namespace GestaoApp.Models.Location
{
    public class Address : Base
    {
        #region Attributes

        private DateTime datetime = DateTime.Now;
        private string code;
        private string cnpj;
        private string name;
        private string street;
        private string number;
        private string complement;
        private string district;
        private string reference;
        private string postalcode;
        private City city;
        private Vendor vendor;

        private Dictionary<string, string> errors = new Dictionary<string, string>();

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

        [Required(AllowEmptyStrings = false, ErrorMessage = "O Código é obrigatório.")]
        [DisplayAttribute(Name = "Código")]
        [StringLength(5, MinimumLength = 1, ErrorMessage = "Código deve ter no mínimo 1 e máximo 5 dígitos.")]
        [RegularExpression("^[0-9]{1,5}$", ErrorMessage = "Só números são permitidos no Código, mínimo 1 e máximo 5 dígitos.")]
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
                    //Validator.ValidateProperty(value, new ValidationContext(this, null, null) { MemberName = "Code" });
                    code = value;
                    OnPropertyChanged("Code");
                }
            }
        }

        [DisplayAttribute(Name = "CNPJ")]
        public string CNPJ
        {
            get
            {
                if (cnpj == null)
                    cnpj = "";
                return cnpj;
            }
            set
            {
                if ((object.ReferenceEquals(this.cnpj, value) != true))
                {
                    //Validator.ValidateProperty(value, new ValidationContext(this, null, null) { MemberName = "Code" });
                    cnpj = value;
                    OnPropertyChanged("CNPJ");
                }
            }
        }

        [Required(AllowEmptyStrings = false, ErrorMessage = "Nome é obrigatório.")]
        [DisplayAttribute(Name = "Razão Social")]
        [StringLength(50, MinimumLength = 3, ErrorMessage = "Tamanho mínimo para o Nome são 3 caracteres")]
        [RegularExpression("^[a-zA-Z''-'\\s]{1,50}$", ErrorMessage = "Números e caracteres especiais não são permitidos no Nome.")]
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

        [DisplayAttribute(Name = "Endereço")]
        [Required(AllowEmptyStrings=false, ErrorMessage = "Endereço é obrigatório")]
        [StringLength(150, ErrorMessage = "O Endereço deve ter no máximo 50 caracteres.")]
        public string Street
        {
            get
            {
                if (street == null)
                    street = "";
                return street;
            }
            set
            {
                if ((object.ReferenceEquals(this.street, value) != true))
                {
                    //Validator.ValidateProperty(value, new ValidationContext(this, null, null) { MemberName = "Street" });
                    street = value;
                    OnPropertyChanged("Street");
                    //NotifyPropertyChanged(() => Street);
                }
                //SetValue(ref street, value, "Street");
            }
        }

        [Required(ErrorMessage = "Número é obrigatório")]
        [DisplayAttribute(Name = "Número")]
        [RegularExpression(@"^[0-9]{1,5}$", ErrorMessage="Número só aceita dígitos, mínimo 1 e máximo 5 dígitos.")]
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
                    //Validator.ValidateProperty(value, new ValidationContext(this, null, null) { MemberName = "Number" });
                    number = value;
                    OnPropertyChanged("Number");
                    //NotifyPropertyChanged(() => Number);
                }
                //SetValue(ref number, value, "Number");
            }
        }

        [DisplayAttribute(Name = "Complemento")]
        public string Complement
        {
            get
            {
                if (complement == null)
                    complement = "";
                return complement;
            }
            set
            {
                if ((object.ReferenceEquals(this.complement, value) != true))
                {
                    //Validator.ValidateProperty(value, new ValidationContext(this, null, null) { MemberName = "Complement" });
                    complement = value;
                    OnPropertyChanged("Complement");
                    //NotifyPropertyChanged(() => Complement);
                }
                //SetValue(ref complement, value, "Complement");
            }
        }

        [DisplayAttribute(Name = "Bairro")]
        public string District
        {
            get
            {
                if (district == null)
                    district = "";
                return district;
            }
            set
            {
                if ((object.ReferenceEquals(this.district, value) != true))
                {
                    //Validator.ValidateProperty(value, new ValidationContext(this, null, null) { MemberName = "District" });
                    district = value;
                    OnPropertyChanged("District");
                    //NotifyPropertyChanged(() => District);
                }
                //SetValue(ref district, value, "District");
            }
        }

        [DisplayAttribute(Name = "Cidade")]
        [Required(ErrorMessage = "Cidade é obrigatório")]
        public City City
        {
            get
            {
                //if (city == null)
                    //city = City.Collection.Where(c => c.Name == "SAO PAULO").FirstOrDefault();
                return city;
            }
            set
            {
                if ((object.ReferenceEquals(this.city, value) != true))
                {
                    city = value;
                    OnPropertyChanged("City");
                    //NotifyPropertyChanged(() => City);
                }
                //SetValue(ref city, value, "City");
            }
        }

        [DisplayAttribute(Name = "CEP")]
        public string PostalCode
        {
            get
            {
                if (postalcode == null)
                    postalcode = "";
                return postalcode;
            }
            set
            {
                if ((object.ReferenceEquals(this.postalcode, value) != true))
                {
                    postalcode = value;
                    OnPropertyChanged("PostalCode");
                    //NotifyPropertyChanged(() => City);
                }
                //SetValue(ref postalcode, value, "PostalCode");
            }
        }

        /*[DisplayAttribute(Name = "Estado")]
        [Required(ErrorMessage = "Estado é obrigatório")]
        public State State
        {
            get
            {
                return state;
            }
            set
            {
                if ((object.ReferenceEquals(this.state, value) != true))
                {
                    state = value;
                    OnPropertyChanged("State");
                    //NotifyPropertyChanged(() => City);
                }
                //SetValue(ref state, value, "State");
            }
        }*/

        /*[DisplayAttribute(Name = "País")]
        [Required(ErrorMessage = "País é obrigatório")]
        public Country Country
        {
            get
            {
                return country;
            }
            set
            {
                if ((object.ReferenceEquals(this.country, value) != true))
                {
                    country = value;
                    OnPropertyChanged("Country");
                    //NotifyPropertyChanged(() => City);
                }
                //SetValue(ref country, value, "Country");
            }
        }*/

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

        [DisplayAttribute(Name = "Referência")]
        public string Reference
        {
            get
            {
                if (reference == null)
                    reference = "";
                return reference;
            }
            set
            {
                if ((object.ReferenceEquals(this.reference, value) != true))
                {
                    //Validator.ValidateProperty(value, new ValidationContext(this, null, null) { MemberName = "reference" });
                    reference = value;
                    OnPropertyChanged("Reference");
                    //NotifyPropertyChanged(() => reference);
                }
                //SetValue(ref reference, value, "reference");
            }
        }

        public Address Clone()
        {
            return new Address()
            {
                Guid = this.Guid,
                Selected = this.Selected,
                HasChanges = this.HasChanges,
                DateTime = this.DateTime,
                Code = this.Code,
                Name = this.Name,
                Vendor = this.Vendor,
                Street = this.Street,
                Number = this.Number,
                Complement = this.Complement,
                Reference = this.Reference,
                District = this.District,
                PostalCode = this.PostalCode,
                City = this.City
            };

        }

        public override string ToString()
        {
            string to = Street.Trim();

            to += (District.Length > 0 ? (to.Length > 0 ? ", " : "") + District.Trim() : "");
            if (City != null)
            {
                to += (to.Length > 0 ? ", " : "") + City.Name.Trim();
                to += City.State != null ? (to.Length > 0 ? ", " : "") + "(" + City.State.Acronym.Trim() + ")" : "";
            }
            to += PostalCode.Length > 0 ? (to.Length > 0 ? ", " : "") + PostalCode.Trim() : "";
            to += ", " + Vendor.Name.Trim();

            //return street;
            return to;
        }

        #endregion

        #region Constructor
        public Address()
        {

        }
        #endregion

        #region XML

        [DisplayAttribute(AutoGenerateField = false)]
        public override XElement ToXML
        {
            get
            {
                return new XElement("Address",
                                            new XAttribute("Guid", Guid.ToString()),
                                            new XElement("DateTime", DateTime.ToString()),
                                            new XElement("Code", Code),
                                            new XElement("CNPJ", CNPJ),
                                            new XElement("Name", Name),
                                            new XElement("Street", Street.Trim()),
                                            new XElement("Number", Number.Trim()),
                                            new XElement("Complement", Complement.Trim()),
                                            new XElement("Reference", Reference.Trim()),
                                            new XElement("District", District.Trim()),
                                            new XElement("PostalCode", PostalCode.Trim()),
                                            new XElement("City", new XAttribute("Id", City != null ? City.Id.ToString() : "0"), City != null ? City.Name : ""),
                                            new XElement("Vendor", new XAttribute("Id", Vendor != null ? Vendor.Id.ToString() : "0"), Vendor != null ? Vendor.Name : "")
                                    );
            }
            set
            {
                Guid = value.Attribute("Guid") != null ? Guid.Parse(value.Attribute("Guid").Value) : System.Guid.NewGuid();
                DateTime = value.Attribute("DateTime") != null ? DateTime.Parse(value.Attribute("DateTime").Value.Trim()) : DateTime.Parse("1990-01-01");
                Code = value.Element("Code") != null ? value.Element("Code").Value.Trim() : "";
                CNPJ = value.Element("CNPJ") != null ? value.Element("CNPJ").Value.Trim() : "";
                Name = value.Element("Name") != null ? value.Element("Name").Value.Trim() : "";
                Street = value.Element("Street") != null ? value.Element("Street").Value.Trim() : "";
                Number = value.Element("Number") != null ? value.Element("Number").Value.Trim() : "";
                Complement = value.Element("Complement") != null ? value.Element("Complement").Value.Trim() : "";
                Reference = value.Element("Reference") != null ? value.Element("Reference").Value.Trim() : "";
                District = value.Element("District") != null ? value.Element("District").Value.Trim() : "";
                PostalCode = value.Element("PostalCode") != null ? value.Element("PostalCode").Value.Trim() : "";

                if (value.Element("City") != null)
                {
                    if (City.Collection.Any(c => c.Id == int.Parse(value.Element("City").Attribute("Id").Value)))
                        City = City.Collection.First(c => c.Id == int.Parse(value.Element("City").Attribute("Id").Value));
                    //else
                        //throw new Exception("Erro ao carregar a Cidade, contate suporte !");
                    else
                        City = new City() { ToXML = value.Element("City") };
                }

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
