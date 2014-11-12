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
    public class History : Base
    {
        #region Attributes

        private Register register;
        private Status status;
        private Type type;
        private DateTime timestamp;
        private string comments;

        private static ObservableCollection<Product> collection;

        #endregion

        #region Properties

        public Register Register
        {
            get
            {
                if (register == null)
                    register = new Register();
                return register;
            }
            set
            {
                if ((object.ReferenceEquals(this.register, value) != true))
                {
                    register = value;
                    OnPropertyChanged("Register");
                }
            }
        }

        [DisplayAttribute(Name = "Tipo")]
        public Type Type
        {
            get
            {
                if (type == null)
                    type = new Type();
                return type;
            }
            set
            {
                if ((object.ReferenceEquals(this.type, value) != true))
                {
                    type = value;
                    OnPropertyChanged("Type");
                }
            }
        }

        [DisplayAttribute(Name = "Situação")]
        public Status Status
        {
            get
            {
                if (status == null)
                    status = new Status();
                return status;
            }
            set
            {
                if ((object.ReferenceEquals(this.status, value) != true))
                {
                    status = value;
                    OnPropertyChanged("Status");
                }
            }
        }

        [DisplayAttribute(Name = "Data/Hora")]
        public DateTime TimeStamp
        {
            get
            {
                if (timestamp == null)
                    timestamp = DateTime.Now;
                return timestamp;
            }
            set
            {
                if ((object.ReferenceEquals(this.timestamp, value) != true))
                {
                    timestamp = value;
                    OnPropertyChanged("TimeStamp");
                }
            }
        }

        [DisplayAttribute(Name = "Historico")]
        public string Comments
        {
            get
            {
                if (comments == null)
                    comments = "";
                return comments;
            }
            set
            {
                if ((object.ReferenceEquals(this.comments, value) != true))
                {
                    comments = value;
                    OnPropertyChanged("Comments");
                }
            }
        }

        public override String ToString()
        {
            return Comments;
        }

        public History Clone()
        {
            return new History()
            {
                Id = this.Id,
                Guid = this.Guid,
                Selected = this.Selected,
                HasChanges = this.HasChanges,
                Register = this.Register,
                Status = this.Status,
                Type = this.Type,
                timestamp = this.timestamp,
                Comments = this.Comments
            };
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
                return new XElement("History",
                                    new XAttribute("Id", Id),
                                    new XElement("Register", new XAttribute("Id", Register.Id)),
                                    new XElement("Type", new XAttribute("Id", Type.Id)),
                                    new XElement("Status", new XAttribute("Id", Status.Id)),
                                    new XAttribute("TimeStamp", TimeStamp),
                                    new XElement("Comments", Comments.Trim())
                                    );
            }
            set
            {
                Id = value.Attribute("Id") != null ? int.Parse(value.Attribute("Id").Value) : 0;
                Register = value.Attribute("Register") != null ? new Register() { ToXML = value.Element("Register") } : new Register();
                Type = value.Attribute("Type") != null ? new Type() { ToXML = value.Element("Type") } : new Type();
                Status = value.Attribute("Status") != null ? new Status() { ToXML = value.Element("Status") } : new Status();
                TimeStamp = value.Element("TimeStamp") != null ? DateTime.Parse(value.Element("TimeStamp").Value) : DateTime.Now;
                Comments = value.Element("Comments") != null ? value.Element("Comments").Value.Trim() : "";
            }
        }

        #endregion
    }
}
