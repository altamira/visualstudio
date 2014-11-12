using System;
using System.Linq;
using System.Windows;
using System.Xml.Linq;
using GestaoApp.Helpers;
using GestaoApp.Models.Attendance.Message;
using GestaoApp.View.Attendance;
using SilverlightMessageBoxLibrary;
using System.Windows.Controls;

namespace GestaoApp.ViewModel.Attendance
{
    public class MessageViewModel : ViewModelBase
    {
        #region Attributes

        private SMS selectedItem;

        #endregion

        #region Properties

        public SMS SelectedItem
        {
            get
            {
                return selectedItem;
            }
            set
            {
                if ((object.ReferenceEquals(this.selectedItem, value) != true))
                {
                    selectedItem = value;
                    OnPropertyChanged("SelectedItem");
                }
            }
        }
        #endregion

        #region Commands

        MessageFormView childWindow;

        public void Edit(object parameter)
        {
            MessageViewModel viewmodel = new MessageViewModel();
            viewmodel.SelectedItem = SelectedItem;
            childWindow = new MessageFormView();
            childWindow.DataContext = viewmodel;
            childWindow.OnEditComplete = new EventHandler(OnEditComplete);
            childWindow.Show();
        }

        public void OnEditComplete(object sender, EventArgs e)
        {
            if (SelectedItem.Text.Length > 140)
            {
                CustomMessage msg = new CustomMessage("A mensagem não pode ter mais que 140 caracteres. Modifique a mensagem para que não ultrapasse o tamanho máximo.!", CustomMessage.MessageType.Info);

                msg.Show();
            }
            else
            {
                try
                {
                    HttpRequestHelper httpRequest =
                        new HttpRequestHelper(
                            new Uri(string.Format("http://{0}:{1}/Attendance.Message.SMS.Send?{2}", Application.Current.Host.Source.Host, Application.Current.Host.Source.Port, Session.Guid)),
                            "POST",
                            new XDocument
                            (
                                SelectedItem.ToXML("Attendance.Message")
                            ));

                    httpRequest.ResponseComplete += new HttpResponseCompleteEventHandler(OnEditRequestComplete);
                    httpRequest.Execute();
                }
                catch (Exception ex)
                {
                    MessageBox.Show(ex.Message);
                }
            }
        }

        public void OnEditRequestComplete(HttpResponseCompleteEventArgs e)
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
                        Error message = (from c in xParse.Descendants("Message")
                                        select new Error()
                                        {
                                            Message = c.Value,
                                        }).FirstOrDefault();

                        if (message != null)
                        {
                            CustomMessage msg = new CustomMessage(message.Message, CustomMessage.MessageType.Info);
                            msg.Show();

                            if (childWindow != null)
                                childWindow.DialogResult = true;
                        }
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
                System.Windows.Deployment.Current.Dispatcher.BeginInvoke(new Action<HttpResponseCompleteEventArgs>(OnEditRequestComplete), e);
        }

        #endregion
    }
}
