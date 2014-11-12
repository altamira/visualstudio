﻿using System;
using System.Collections.ObjectModel;
using System.ComponentModel.DataAnnotations;
using System.Xml.Linq;
using GestaoApp.Helpers;
using System.Windows;
using SilverlightMessageBoxLibrary;
using System.Linq;

namespace GestaoApp.Models.Contact
{
    public class Media : Base
    {
        #region Attributes

        private string description;

        private static ObservableCollection<Media> collection;

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

        /*public static void LoadCollection()
        {
            collection = new ObservableCollection<Media>()
            { 
                new Media() { Id = 1, Description = "Internet" },
                new Media() { Id = 2, Description = "Google" }, 
                new Media() { Id = 3, Description = "Indicação" }, 
                new Media() { Id = 4, Description = "Feiras" },
                new Media() { Id = 5, Description = "Outros..." },
                new Media() { Id = 6, Description = "Exposições" },
                new Media() { Id = 7, Description = "Outros meios de divulgação" },
                new Media() { Id = 8, Description = "Revistas" } 
            };
        }*/

        public static ObservableCollection<Media> Collection
        {
            get
            {
                if (collection == null)
                    collection = new ObservableCollection<Media>();
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

        public Media Clone()
        {
            return new Media()
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
                        new Uri(string.Format("http://{0}:{1}/Contact.Media.List", Application.Current.Host.Source.Host, Application.Current.Host.Source.Port)),
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
                        collection = new ObservableCollection<Media>
                                    (from media in xParse.Descendants("Media")
                                     select new Media() { ToXML = media });

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
                return new XElement("Media",
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
