using System;
using System.Collections.ObjectModel;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Windows;
using System.Xml.Linq;
using GestaoApp.Helpers;
using GestaoApp.Models.Contact;
using GestaoApp.Models.Location;
using SilverlightMessageBoxLibrary;

namespace GestaoApp.Models.Sales
{
    public class Vendor : Base
    {
        #region Attributes

        private string code;
        private string name;

        private ObservableCollection<Fone> contactfone;
        private ObservableCollection<Email> contactemail;

        private bool blankpassword;

        private static ObservableCollection<Vendor> collection;

        #endregion

        #region Properties

        [Required(AllowEmptyStrings = false, ErrorMessage = "Código é obrigatório.")]
        [DisplayAttribute(Name = "Código")]
        [RegularExpression(@"^[0-9]{1,3}$", ErrorMessage="Código só aceita números.")]
        [StringLength(3,MinimumLength=3, ErrorMessage="Código deve ter 3 dígitos.")]
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

        [Required(AllowEmptyStrings=false, ErrorMessage="Nome é obrigatório.")]
        [DisplayAttribute(Name = "Nome")]
        [StringLength(50, MinimumLength=3, ErrorMessage="Tamanho mínimo para o Nome são 3 caracteres")]
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

        public bool BlankPassword
        {
            get
            {
                return blankpassword;
            }
            set
            {
                if (blankpassword != value)
                {
                    blankpassword = value;
                    OnPropertyChanged("BlankPassword");
                }
            }
        }

        [DisplayAttribute(AutoGenerateField = false)]
        public static ObservableCollection<Vendor> Collection
        {
            get
            {
                if (collection == null)
                    collection = new ObservableCollection<Vendor>();
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

        public Vendor Clone()
        {
            Vendor v = new Vendor()
            {
                Id = this.Id,
                Selected = this.Selected,
                HasChanges = this.HasChanges,
                Code = this.code,
                Name = this.name,
            };

            foreach (Fone f in ContactFone)
                v.ContactFone.Add(f.Clone());

            foreach (Email e in ContactEmail)
                v.ContactEmail.Add(e.Clone());

            return v;
        }

        public override string ToString()
        {
            return Code + " " + Name;
        }

        #endregion

        #region Events
        #endregion

        #region Commands
        public static EventHandler LoadCompleted;

        public static void LoadCollectionAsync()
        {
            try
            {
                HttpRequestHelper httpRequest =
                    new HttpRequestHelper(
                        new Uri(string.Format("http://{0}:{1}/Sales.Vendor.List", Application.Current.Host.Source.Host, Application.Current.Host.Source.Port)),
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
                        collection = new ObservableCollection<Vendor>
                                    (from vendor in xParse.Descendants("Vendor")
                                     select new Vendor() { ToXML = vendor });

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

        #region Events
        #endregion

        #region XML

        [DisplayAttribute(AutoGenerateField = false)]
        public override XElement ToXML
        {
            get
            {
                return new XElement("Vendor",
                                            new XAttribute("Id", Id),
                                            new XElement("Code", Code.Trim()),
                                            new XElement("Name", Name.Trim()),
                                            new XElement("ContactFone", ContactFone.Select(c => c.ToXML)),
                                            new XElement("ContactEmail", ContactEmail.Select(c => c.ToXML))
                                    );
            }
            set
            {
                Id = value.Attribute("Id") != null ? int.Parse(value.Attribute("Id").Value) : 0;
                Code = value.Element("Code") != null ? value.Element("Code").Value.Trim() : "";
                Name = value.Element("Name") != null ? value.Element("Name").Value.Trim() : "";

                if (value.Element("ContactFone") != null)
                {
                    ContactFone = new ObservableCollection<Fone>
                                        (from fone in value.Elements("ContactFone").Elements("Fone")
                                         where fone.Element("Prefix").Value.Trim().Length > 0 &&
                                         fone.Element("Number").Value.Trim().Length > 0
                                         select new Fone() { ToXML = fone });
                }

                if (value.Element("ContactEmail") != null)
                {
                    ContactEmail = new ObservableCollection<Email>
                                        (from email in value.Elements("ContactEmail").Elements("Email")
                                         where email.Element("Address").Value.Trim().Length > 0
                                         select new Email() { ToXML = email });
                }

                BlankPassword = value.Element("BlankPassword") != null ? (int.Parse(value.Element("BlankPassword").Value) == 1 ? true : false) : true;
            }
        }

        #endregion
    }
}
