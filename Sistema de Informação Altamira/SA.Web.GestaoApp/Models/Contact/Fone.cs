using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Xml.Linq;
using GestaoApp.Models.Location;

namespace GestaoApp.Models.Contact
{
    public class Fone : Base
    {
        #region Attributes

        private Dictionary<string, List<string>> ErrorMessages = new Dictionary<string, List<string>>();    

        private Country country;
        private string areacode;
        private string prefix;
        private string number;
        private string accesscode;
        private FoneType fonetype;

        #endregion

        #region Properties

        [Required(AllowEmptyStrings = false, ErrorMessage = "O País é obrigatório.")]
        [DisplayAttribute(Name = "País")]
        public Country Country
        {
            get
            {
                if (country == null)
                    country = Country.Collection.Where(c => c.Name == "BRASIL").FirstOrDefault();
                return country;
            }
            set
            {
                if ((object.ReferenceEquals(this.country, value) != true))
                {
                    //Validator.ValidateProperty(value, new ValidationContext(this, null, null) { MemberName = "Country" });
                    country = value;
                    OnPropertyChanged("Country");
                    //NotifyPropertyChanged(() => AreaCode);
                }
            }
        }

        /*[Required(AllowEmptyStrings=false, ErrorMessage="O Código de Área é obrigatório.")]
        [DisplayAttribute(Name = "Código de Área")]
        [StringLength(3, MinimumLength=2, ErrorMessage="Código de Área inválido, deve ter entre 2 e 3 dígitos.")]
        [RegularExpression(@"[0-9]{2,3}$", ErrorMessage = "Código de Área somente números, mínimo 2 e máximo 3 dígitos.")]*/
        public string AreaCode
        {
            get
            {
                if (areacode == null)
                    areacode = "11";
                return areacode;
            }
            set
            {
                if ((object.ReferenceEquals(this.areacode, value) != true))
                {
                    //Validator.ValidateProperty(value, new ValidationContext(this, null, null) { MemberName = "AreaCode" });
                    areacode = value;
                    OnPropertyChanged("AreaCode");
                    //NotifyPropertyChanged(() => AreaCode);
                }
            }
        }

        [Required(AllowEmptyStrings = false, ErrorMessage = "O Prefixo é obrigatório.")]
        [DisplayAttribute(Name = "Prefixo")]
        [Range(100, 99999)]
        [StringLength(4, MinimumLength = 3, ErrorMessage = "Prefixo inválido, mínimo 3 e máximo 5 dígitos.")]
        [RegularExpression(@"[0-9]{3,5}$", ErrorMessage="Prefixo só aceita números, mínimo 3 e máximo 5 dígitos.")]
        public string Prefix
        {
            get
            {
                if (prefix == null)
                    prefix = "";
                return prefix;
            }
            set
            {
                if ((object.ReferenceEquals(this.prefix, value) != true))
                {
                    //Validator.ValidateProperty(value, new ValidationContext(this, null, null) { MemberName = "Prefix" });
                    prefix = value;
                    OnPropertyChanged("Prefix");
                    //NotifyPropertyChanged(() => Prefix);
                }
            }
        }

        /*[Required(AllowEmptyStrings = false, ErrorMessage = "O Número é obrigatório.")]
        [DisplayAttribute(Name = "Número")]
        [Range(100, 9999)]
        [StringLength(4, MinimumLength = 4, ErrorMessage = "Número inválido, mínimo 3 e máximo 4 dígitos.")]
        [RegularExpression(@"[0-9]{3,4}$", ErrorMessage = "Número do Telefone só aceita números, mínimo 3 e máximo 4 dígitos.")]*/
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
                    /*if (Number == string.Empty || Number == null)
                        AddErrorForProperty("Number", "Funcionou validação.");
                    else
                        RemoveErrorsForProperty("Number");*/
                    //Validator.ValidateProperty(value, new ValidationContext(this, null, null) { MemberName = "Number" });
                    number = value;
                    OnPropertyChanged("Number");
                    //NotifyPropertyChanged(() => Number);
                }
            }
        }

        [DisplayAttribute(Name = "Código de Acesso")]
        [RegularExpression(@"[0-9]{1,5}$", ErrorMessage = "Código de Acesso/Ramal só aceita números, máximo 5 dígitos.")]
        public string AccessCode
        {
            get
            {
                if (accesscode == null)
                    accesscode = "";
                return accesscode;
            }
            set
            {
                if ((object.ReferenceEquals(this.accesscode, value) != true))
                {
                    //Validator.ValidateProperty(value, new ValidationContext(this, null, null) { MemberName = "AccessCode" });
                    accesscode = value;
                    OnPropertyChanged("AccessCode");
                    //NotifyPropertyChanged(() => AccessCode);
                }
            }
        }

        [Required(AllowEmptyStrings = false, ErrorMessage = "O Tipo de Fone é obrigatório.")]
        [DisplayAttribute(Name = "Tipo de Fone")]
        public FoneType FoneType
        {
            get
            {
                if (fonetype == null)
                    fonetype = FoneType.Collection.Where(f => f.Description == "Telefone").FirstOrDefault();
                return fonetype;
            }
            set
            {
                if ((object.ReferenceEquals(this.fonetype, value) != true))
                {
                    //Validator.ValidateProperty(value, new ValidationContext(this, null, null) { MemberName = "FoneType" });
                    fonetype = value;
                    OnPropertyChanged("FoneType");
                    //NotifyPropertyChanged(() => FoneType);
                }
            }
        }

        public Fone Clone()
        {
            return new Fone()
            {
                Guid = this.Guid,
                Selected = this.Selected,
                HasChanges = this.HasChanges,
                Country = this.Country,
                AreaCode = this.AreaCode,
                Prefix = this.Prefix,
                Number = this.Number,
                AccessCode = this.AccessCode,
                FoneType = this.FoneType 
            };
        }
        #endregion

        #region XML

        [DisplayAttribute(AutoGenerateField = false)]
        public override XElement ToXML
        {
            get
            {
                return new XElement("Fone",
                                            new XAttribute("Guid", Guid.ToString()),
                                            new XElement("AreaCode", AreaCode.Trim()),
                                            new XElement("Prefix", Prefix.Trim()),
                                            new XElement("Number", Number.Trim()),
                                            new XElement("AccessCode", AccessCode.Trim()),
                                            new XElement("FoneType", new XAttribute("Id", FoneType != null ? FoneType.Id.ToString() : "0"), FoneType != null ? FoneType.Description : ""),
                                            new XElement("Country", new XAttribute("Id", Country != null ? Country.Id.ToString() : "0"), Country != null ? Country.Name : "")
                                    );
            }
            set
            {
                Guid = value.Attribute("Guid") != null ? Guid.Parse(value.Attribute("Guid").Value) : System.Guid.NewGuid();
                AreaCode = value.Element("AreaCode") != null ? value.Element("AreaCode").Value.Trim() : "";
                Prefix = value.Element("Prefix") != null ? value.Element("Prefix").Value.Trim() : "";
                Number = value.Element("Number") != null ? value.Element("Number").Value.Trim() : "";
                AccessCode = value.Element("AccessCode") != null ? value.Element("AccessCode").Value.Trim() : "";
                FoneType = value.Element("FoneType") != null ? new FoneType() { ToXML = value.Element("FoneType") } : new FoneType();

                if (value.Element("FoneType") != null)
                {
                    if (FoneType.Collection.Any(c => c.Id == int.Parse(value.Element("FoneType").Attribute("Id").Value)))
                        FoneType = FoneType.Collection.First(c => c.Id == int.Parse(value.Element("FoneType").Attribute("Id").Value));
                    else
                        throw new Exception("Erro ao carregar o Tipo de Telefone, contate suporte !");
                }

                if (value.Element("Country") != null)
                {
                    if (Country.Collection.Any(c => c.Id == int.Parse(value.Element("Country").Attribute("Id").Value)))
                        Country = Country.Collection.First(c => c.Id == int.Parse(value.Element("Country").Attribute("Id").Value));
                    else
                        throw new Exception("Erro ao carregar o País, contate suporte !");
                }
            }
        }

        #endregion
    }
}
