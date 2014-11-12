using System.Collections.ObjectModel;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Xml.Linq;

namespace GestaoApp.Models.Contact
{
    public class Person : Base
    {
        #region Attributes

        private string name;
        private string department;
        private ObservableCollection<Fone> contactfone;
        private ObservableCollection<Email> contactemail;

        #endregion

        #region Properties

        [Required(AllowEmptyStrings=false, ErrorMessage="O Nome é obrigatório.")]
        [DisplayAttribute(Name = "Nome")]
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
                    //Validator.ValidateProperty(value, new ValidationContext(this, null, null) { MemberName = "FirstName" });
                    name = value;
                    OnPropertyChanged("Name");
                }
            } 
        }

        [DisplayAttribute(Name = "Departamento")]
        public string Department 
        { 
            get 
            {
                if (department == null)
                    department = "";
                return department; 
            } 
            set 
            {
                if ((object.ReferenceEquals(this.department, value) != true))
                {
                    //Validator.ValidateProperty(value, new ValidationContext(this, null, null) { MemberName = "LastName" });
                    department = value;
                    OnPropertyChanged("Department");
                }
            } 
        }

        [DisplayAttribute(AutoGenerateField = false)]
        public ObservableCollection<Fone> ContactFone
        {
            get
            {
                if (contactfone == null)
                    contactfone = new ObservableCollection<Fone>();
                return contactfone;
            }
            set
            {
                if ((object.ReferenceEquals(this.contactfone, value) != true))
                {
                    contactfone = value;
                    OnPropertyChanged("ContactFone");
                }
            }
        }

        [DisplayAttribute(AutoGenerateField = false)]
        public ObservableCollection<Email> ContactEmail
        {
            get
            {
                if (contactemail == null)
                    contactemail = new ObservableCollection<Email>();
                return contactemail;
            }
            set
            {
                if ((object.ReferenceEquals(this.contactemail, value) != true))
                {
                    contactemail = value;
                    OnPropertyChanged("ContactEmail");
                }
            }
        }

        public Person Clone()
        {
            Person p = new Person()
            {
                Guid = this.Guid,
                Selected = this.Selected,
                HasChanges = this.HasChanges,
                Name = this.Name,
                Department = this.Department,
            };

            foreach (Fone f in ContactFone)
                p.ContactFone.Add(f.Clone());

            foreach (Email e in ContactEmail)
                p.ContactEmail.Add(e.Clone());

            return p;

        }

        public override string ToString()
        {
            return Name.Trim();
        }
        #endregion

        #region Events
        #endregion

        #region Commands
        #endregion

        #region XML

        [DisplayAttribute(AutoGenerateField = false)]
        public override XElement ToXML
        {
            get
            {
                return new XElement("Person",
                                            new XAttribute("Guid", Guid.ToString()),
                                            new XElement("Name", Name.Trim()),
                                            new XElement("Department", Department.Trim()),
                                            new XElement("ContactFone", ContactFone.Select(c => c.ToXML)),
                                            new XElement("ContactEmail", ContactEmail.Select(c => c.ToXML))                                            
                                    );
            }
            set
            {
                Guid = value.Attribute("Guid") != null ? System.Guid.Parse(value.Attribute("Guid").Value) : System.Guid.NewGuid();
                Name = value.Element("Name") != null ? value.Element("Name").Value.Trim() : "";
                Department = value.Element("Department") != null ? value.Element("Department").Value.Trim() : "";

                if (value.Element("ContactFone") != null)
                {
                    ContactFone = new ObservableCollection<Fone>
                                        (from fone in value.Element("ContactFone").Descendants("Fone")
                                         where fone.Element("Prefix").Value.Trim().Length > 0 &&
                                         fone.Element("Number").Value.Trim().Length > 0
                                         select new Fone() { ToXML = fone });
                }

                if (value.Element("ContactEmail") != null)
                {
                    ContactEmail = new ObservableCollection<Email>
                                        (from email in value.Element("ContactEmail").Descendants("Email")
                                         where email.Element("Address").Value.Trim().Length > 0
                                         select new Email() { ToXML = email });
                }
            }
        }

        #endregion
    }
}
