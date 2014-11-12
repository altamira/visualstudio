using System.Collections.ObjectModel;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Xml.Linq;
using GestaoApp.Models.Contact;
using GestaoApp.Models.Sales;

namespace GestaoApp.Models.Attendance.Message
{
    public class SMS : Base
    {
        #region Attributes

        private Vendor vendor;
        private ObservableCollection<Fone> fone;
        private string text;

        #endregion

        #region Properties

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
                    if (vendor != null)
                        Fone = new ObservableCollection<Fone>(vendor.ContactFone.Where(f => f.FoneType.Description == "Celular"));

                    OnPropertyChanged("Vendor");
                }
            }
        }

        [DisplayAttribute(AutoGenerateField = false)]
        public ObservableCollection<Fone> Fone
        {
            get
            {
                if (fone == null)
                    fone = new ObservableCollection<Fone>();
                return fone;
            }
            set
            {
                if ((object.ReferenceEquals(this.fone, value) != true))
                {
                    fone = value;
                    OnPropertyChanged("Fone");
                }
            }
        }

        [DisplayAttribute(Name = "Texto")]
        public string Text
        {
            get
            {
                if (text == null)
                    text = "";
                return text;
            }
            set
            {
                if ((object.ReferenceEquals(this.text, value) != true))
                {
                    text = value;
                    OnPropertyChanged("Text");
                }
            }
        }

        #endregion

        #region Commands
        #endregion

        #region XML

        [DisplayAttribute(AutoGenerateField = false)]
        public new XElement ToXML(string From)
        {
            return
                new XElement("SMS", 
                    new XAttribute("From", From), 
                    Fone.Select(f => f.ToXML), 
                    new XElement("Text", Text.Trim()));
        }

        #endregion
    }
}
