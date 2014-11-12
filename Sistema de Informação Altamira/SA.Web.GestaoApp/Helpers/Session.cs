using System;
using System.ComponentModel;
using System.Linq;
using System.Windows;
using System.Xml.Linq;
using GestaoApp.Models.Sales;
using System.Windows.Browser;

namespace GestaoApp.Helpers
{
    public static class Cookie
    {
        public static bool Exists(string key, string value)
        {
            return HtmlPage.Document.Cookies.Contains(key + "=" + value);
        }

        public static string Read(string key)
        {
            string[] cookies = HtmlPage.Document.Cookies.Split(';');
            foreach (string cookie in cookies)
            {
                string[] keyValuePair = cookie.Split('=');
                if (keyValuePair.Length == 2 && key == keyValuePair[0].Trim())
                    return keyValuePair[1].Trim();
            }

            return null;
        }

        public static void Write(string key, string value, int expireDays)
        {
            // expireDays = 0, indicates a session cookie that will not be written to disk 
            // expireDays = -1, indicates that the cookie will not expire and will be permanent
            // expireDays = n, indicates that the cookie will expire in “n” days
            string expires = "";
            if (expireDays != 0)
            {
                DateTime expireDate = (expireDays > 0 ?
                DateTime.Now + TimeSpan.FromDays(expireDays) :
                DateTime.MaxValue);
                expires = ";expires=" + expireDate.ToString("R");
            }

            string cookie = key + "=" + value + expires;
            HtmlPage.Document.SetProperty("cookie", cookie);
        }

        public static void Delete(string key)
        {
            DateTime expireDate = DateTime.Now - TimeSpan.FromDays(1); // yesterday
            string expires = ";expires=" + expireDate.ToString("R");
            string cookie = key + "=" + expires;
            HtmlPage.Document.SetProperty("cookie", cookie);
        }
    }

    public class User : INotifyPropertyChanged
    {
        #region Properties

        private int id;
        private string firstname;
        private DateTime lastlogindate;
        private string rules;
        private bool blankpassword;

        public int Id
        {
            get
            {
                return id;
            }
            set
            {
                if (id != value)
                {
                    id = value;
                    OnPropertyChanged("Id");
                }
            }
        }

        public string FirstName 
        { 
            get 
            { 
                return firstname; 
            } 
            set 
            {
                if (firstname != value)
                {
                    firstname = value;
                    OnPropertyChanged("FirstName");
                }
            } 
        }

        public string Rules
        { 
            get 
            { 
                return rules; 
            } 
            set 
            {
                if (rules != value)
                {
                    rules = value;
                    OnPropertyChanged("Rules");
                }
            } 
        }

        public DateTime LastLoginDate
        {
            get
            {
                return lastlogindate;
            }
            set
            {
                if (lastlogindate != value)
                {
                    lastlogindate = value;
                    OnPropertyChanged("LastLoginDate");
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

        public XElement ToXML
        {
            set
            {
                Id = value.Attribute("Id") != null ? int.Parse(value.Attribute("Id").Value) : 0;
                FirstName = value.Element("FirstName") != null ? value.Element("FirstName").Value : "";
                LastLoginDate = value.Element("LastLoginDate") != null ? DateTime.Parse(value.Element("LastLoginDate").Value) : DateTime.Now;
                Rules = value.Element("Rules") != null ? value.Element("Rules").Value : "";
                BlankPassword = value.Element("BlankPassword") != null ? (int.Parse(value.Element("BlankPassword").Value) == 1 ? true : false) : true;
            }
        }

        #endregion

        #region Events
        public event PropertyChangedEventHandler PropertyChanged;

        public void OnPropertyChanged(string propertyName)
        {
            if (this.PropertyChanged != null)
            {
                PropertyChanged(this, new PropertyChangedEventArgs(propertyName));
            }
        }
        #endregion
    }

    public class Session : INotifyPropertyChanged
    {
        #region Properties

        private Guid guid;
        private DateTime expiredate;
        private User user;
        private Vendor vendor;

        public Guid Guid
        {
            get
            {
                return guid;
            }
            set
            {
                if (guid != value)
                {
                    guid = value;
                    OnPropertyChanged("Guid");
                }
            }
        }

        public DateTime ExpireDate 
        { 
            get 
            { 
                return expiredate; 
            } 
            set 
            {
                if (expiredate != value)
                {
                    expiredate = value;
                    OnPropertyChanged("ExpireDate");
                }
            } 
        }

        public User User
        {
            get
            {
                return user;
            }
            set
            {
                if (user != value)
                {
                    user = value;
                    OnPropertyChanged("User");
                }
            }
        }

        public Vendor Vendor
        {
            get
            {
                return vendor;
            }
            set
            {
                if (vendor != value)
                {
                    vendor = value;
                    OnPropertyChanged("Vendor");
                }
            }
        }

        public string Rules
        {
            get
            {
                return User != null ? User.Rules : "Attendance Register, Client Register, Bid Register, Attendance Dashboard, Sales Dashboard";
            }
        }

        #endregion

        #region Events
        public delegate void OnAutenticateSuccessfullEventHandler(OnAutenticateSuccessfullEventArgs e);

        public event OnAutenticateSuccessfullEventHandler AutenticateSuccessfull;

        public class OnAutenticateSuccessfullEventArgs : EventArgs
        {
            public Session Session { get; set; }
        }

        public delegate void OnAutenticateErrorEventHandler(OnAutenticateErrorEventArgs e);

        public event OnAutenticateErrorEventHandler AutenticateError;

        public class OnAutenticateErrorEventArgs : EventArgs
        {
            public Error Error;
        }

        public delegate void OnChangePasswordSuccessfullEventHandler(OnChangePasswordSuccessfullEventArgs e);

        public event OnChangePasswordSuccessfullEventHandler ChangePasswordSuccessfull;

        public class OnChangePasswordSuccessfullEventArgs : EventArgs
        {
            public Session Session { get; set; }
        }

        public delegate void OnChangePasswordErrorEventHandler(OnChangePasswordErrorEventArgs e);

        public event OnChangePasswordErrorEventHandler ChangePasswordError;

        public class OnChangePasswordErrorEventArgs : EventArgs
        {
            public Error Error;
        }
        #endregion

        #region Command
        public void Autenticate(string UserName, string Password)
        {
            try
            {
                HttpRequestHelper httpRequest = 
                    new HttpRequestHelper(
                        new Uri(string.Format("http://{0}:{1}/Security.Session.Request", Application.Current.Host.Source.Host, Application.Current.Host.Source.Port)), 
                        "POST",
                        new XDocument
                        (
                            new XElement("User",
                                new XElement("Username", UserName),
                                new XElement("Password", Helpers.Cripto.GetSHA1Hash(Password)))
                        ));

                httpRequest.ResponseComplete += new HttpResponseCompleteEventHandler(OnAutenticateCompleted);
                httpRequest.Execute();
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

        private void OnAutenticateCompleted(HttpResponseCompleteEventArgs e)
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
                        ToXML = xParse.Element("Session");

                        if (AutenticateSuccessfull != null)
                            AutenticateSuccessfull(new OnAutenticateSuccessfullEventArgs() { Session = this });
                    }
                    else
                        if (AutenticateError != null)
                            AutenticateError(new OnAutenticateErrorEventArgs() { Error = error });
                }
                else
                    if (AutenticateError != null)
                        AutenticateError(new OnAutenticateErrorEventArgs()
                        {
                            Error = new Error()
                            {
                                Id = 0,
                                Message = "Error on process your request !.\n\n" + e.Error.Message.ToString(),
                                Detail = e.Error.Data.ToString() + "\n\n" + e.Error.ToString()
                            }
                        });
            }
            else
                System.Windows.Deployment.Current.Dispatcher.BeginInvoke(new Action<HttpResponseCompleteEventArgs>(OnAutenticateCompleted), e);
        }

        public void ChangePassword(string NewPassword)
        {
            try
            {
                HttpRequestHelper httpRequest;

                if (Vendor != null)
                {
                    httpRequest =
                        new HttpRequestHelper(
                            new Uri(string.Format("http://{0}:{1}/Security.Vendor.ChangePassword?{2}", Application.Current.Host.Source.Host, Application.Current.Host.Source.Port, Guid)),
                            "POST",
                            new XDocument
                            (
                                new XElement("Vendor",
                                    new XElement("NewPassword", Helpers.Cripto.GetSHA1Hash(NewPassword.Trim())))
                            ));
                }
                else
                {
                    httpRequest =
                        new HttpRequestHelper(
                            new Uri(string.Format("http://{0}:{1}/Security.User.ChangePassword?{2}", Application.Current.Host.Source.Host, Application.Current.Host.Source.Port, Guid)),
                            "POST",
                            new XDocument
                            (
                                new XElement("User",
                                    new XElement("NewPassword", Helpers.Cripto.GetSHA1Hash(NewPassword.Trim())))
                            ));

                }

                httpRequest.ResponseComplete += new HttpResponseCompleteEventHandler(OnChangePasswordCompleted);
                httpRequest.Execute();
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

        private void OnChangePasswordCompleted(HttpResponseCompleteEventArgs e)
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
                        if (ChangePasswordSuccessfull != null)
                            ChangePasswordSuccessfull(new OnChangePasswordSuccessfullEventArgs() { Session = this });
                    }
                    else
                        if (ChangePasswordError != null)
                            ChangePasswordError(new OnChangePasswordErrorEventArgs() { Error = error });
                }
                else
                    if (ChangePasswordError != null)
                        ChangePasswordError(new OnChangePasswordErrorEventArgs()
                        {
                            Error = new Error()
                            {
                                Id = 0,
                                Message = "Error on process your request !.\n\n" + e.Error.Message.ToString(),
                                Detail = e.Error.Data.ToString() + "\n\n" + e.Error.ToString()
                            }
                        });
            }
            else
                System.Windows.Deployment.Current.Dispatcher.BeginInvoke(new Action<HttpResponseCompleteEventArgs>(OnChangePasswordCompleted), e);
        }

        public XElement ToXML
        {
            set
            {
                Guid = value.Attribute("Guid") != null ? Guid.Parse(value.Attribute("Guid").Value) : System.Guid.NewGuid();
                ExpireDate = value.Element("ExpireDate") != null ? DateTime.Parse(value.Element("ExpireDate").Value) : DateTime.Now;
                User = value.Element("User") != null ? new User() { ToXML = value.Element("User") } : null;
                Vendor = value.Element("Vendor") != null ? new Vendor() { ToXML = value.Element("Vendor") } : null;
            }
        }
        #endregion 

        #region Events
        public event PropertyChangedEventHandler PropertyChanged;

        public void OnPropertyChanged(string propertyName)
        {
            if (this.PropertyChanged != null)
            {
                PropertyChanged(this, new PropertyChangedEventArgs(propertyName));
            }
        }
        #endregion

    }
}
