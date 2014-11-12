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
    public class Status : Base
    {
        #region Attributes

        private string description;

        private static ObservableCollection<Status> collection;

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

        public static ObservableCollection<Status> Collection
        {
            get
            {
                if (collection == null)
                    collection = new ObservableCollection<Status>();
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

        public Status Clone()
        {
            return new Status()
            {
                Id = this.Id,
                Selected = this.Selected,
                HasChanges = this.HasChanges,
                Description = this.Description
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
                        new Uri(string.Format("http://{0}:{1}/Attendance.Status.List", Application.Current.Host.Source.Host, Application.Current.Host.Source.Port)),
                        "POST",
                        new XDocument(), false);

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
                        collection = new ObservableCollection<Status>
                                    (from status in xParse.Descendants("Status")
                                     select new Status() { ToXML = status });

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
