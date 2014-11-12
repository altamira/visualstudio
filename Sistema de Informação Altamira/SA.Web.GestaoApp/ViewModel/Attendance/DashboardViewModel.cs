using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Linq;
using System.Windows;
using System.Xml.Linq;
using GestaoApp.Helpers;
using GestaoApp.Models.Contact;
using SilverlightMessageBoxLibrary;
using System.Collections.ObjectModel;
using System.ComponentModel.DataAnnotations;
using GestaoApp.Command;
using System.Windows.Input;

namespace GestaoApp.ViewModel.Attendance 
{
    public class DashboardViewModel : ViewModelBase
    {
        #region Data Axis Class

        public class Day : INotifyPropertyChanged
        {
            private object DateField;
            private double YAxisField;
            private double X1AxisField;
            private double X2AxisField;
            private double X3AxisField;
            private double X4AxisField;

            public object Data
            {
                get
                {
                    return this.DateField;
                }
                set
                {
                    if ((object.ReferenceEquals(this.DateField, value) != true))
                    {
                        this.DateField = value;
                        this.OnPropertyChanged("Data");
                    }
                }
            }

            public double Total
            {
                get
                {
                    return this.YAxisField;
                }
                set
                {
                    if ((this.YAxisField.Equals(value) != true))
                    {
                        this.YAxisField = value;
                        this.OnPropertyChanged("Total");
                    }
                }
            }

            public double Atendimento
            {
                get
                {
                    return this.X1AxisField;
                }
                set
                {
                    if ((this.X1AxisField.Equals(value) != true))
                    {
                        this.X1AxisField = value;
                        this.OnPropertyChanged("Atendimento");
                    }
                }
            }

            public double Orcamento
            {
                get
                {
                    return this.X2AxisField;
                }
                set
                {
                    if ((this.X2AxisField.Equals(value) != true))
                    {
                        this.X2AxisField = value;
                        this.OnPropertyChanged("Orcamento");
                    }
                }
            }

            public double Negociacao
            {
                get
                {
                    return this.X3AxisField;
                }
                set
                {
                    if ((this.X3AxisField.Equals(value) != true))
                    {
                        this.X3AxisField = value;
                        this.OnPropertyChanged("Negociacao");
                    }
                }
            }

            public double Reclamacao
            {
                get
                {
                    return this.X4AxisField;
                }
                set
                {
                    if ((this.X4AxisField.Equals(value) != true))
                    {
                        this.X4AxisField = value;
                        this.OnPropertyChanged("Reclamacao");
                    }
                }
            }

            public event PropertyChangedEventHandler PropertyChanged;

            public void OnPropertyChanged(string propertyName)
            {
                if (this.PropertyChanged != null)
                {
                    PropertyChanged(this, new PropertyChangedEventArgs(propertyName));
                }
            }
        }

        public class Vendor : INotifyPropertyChanged
        {
            private double YAxisField = 0;
            private string XAxisField = "";

            [Display(Name = "Representante")]
            public string Representante
            {
                get
                {
                    return this.XAxisField;
                }
                set
                {
                    if ((this.XAxisField.Equals(value) != true))
                    {
                        this.XAxisField = value;
                        this.RaisePropertyChanged("Representante");
                    }
                }
            }

            [Display(Name = "Quantidade")]
            public double Total
            {
                get
                {
                    return this.YAxisField;
                }
                set
                {
                    if ((this.YAxisField.Equals(value) != true))
                    {
                        this.YAxisField = value;
                        this.RaisePropertyChanged("Total");
                    }
                }
            }

            public event System.ComponentModel.PropertyChangedEventHandler PropertyChanged;

            protected void RaisePropertyChanged(string propertyName)
            {
                System.ComponentModel.PropertyChangedEventHandler propertyChanged = this.PropertyChanged;
                if ((propertyChanged != null))
                {
                    propertyChanged(this, new System.ComponentModel.PropertyChangedEventArgs(propertyName));
                }
            }

        }

        public class Origin : INotifyPropertyChanged
        {
            private double YAxisField = 0;
            private string XAxisField = "";
            private double ZAxisField = 0;
            private double QtdField = 0;

            [Display(Name = "Origem")]
            public string Descricao
            {
                get
                {
                    return this.XAxisField;
                }
                set
                {
                    if ((this.XAxisField.Equals(value) != true))
                    {
                        this.XAxisField = value;
                        this.RaisePropertyChanged("Descricao");
                    }
                }
            }

            [Display(Name = "Quantidade")]
            public double Quantidade
            {
                get
                {
                    return this.QtdField;
                }
                set
                {
                    if ((this.QtdField.Equals(value) != true))
                    {
                        this.QtdField = value;
                        this.RaisePropertyChanged("Quantidade");
                    }
                }
            }

            [Display(Name = "Percentual (%)")]
            [DisplayFormat(DataFormatString = "{0:p}")]
            public double Total
            {
                get
                {
                    return this.YAxisField;
                }
                set
                {
                    if ((this.YAxisField.Equals(value) != true))
                    {
                        this.YAxisField = value;
                        this.RaisePropertyChanged("Total");
                    }
                }
            }

            [DisplayAttribute(AutoGenerateField = false)]
            public double ZAxis
            {
                get
                {
                    return this.ZAxisField;
                }
                set
                {
                    if ((this.ZAxisField.Equals(value) != true))
                    {
                        this.ZAxisField = value;
                        this.RaisePropertyChanged("ZAxis");
                    }
                }
            }

            public event System.ComponentModel.PropertyChangedEventHandler PropertyChanged;

            protected void RaisePropertyChanged(string propertyName)
            {
                System.ComponentModel.PropertyChangedEventHandler propertyChanged = this.PropertyChanged;
                if ((propertyChanged != null))
                {
                    propertyChanged(this, new System.ComponentModel.PropertyChangedEventArgs(propertyName));
                }
            }
        }
        #endregion

        #region Attributes
        private bool isUpdateFromTimeNavSelectionQueued = false;

        private ObservableCollection<Day> dayslist = new ObservableCollection<Day>();
        public ObservableCollection<Day> DaysList 
        {
            get
            {
                return dayslist;
            }
            set
            {
                if (dayslist != value)
                {
                    dayslist = value;
                    OnPropertyChanged("DaysList");
                }
            }
        }

        private ObservableCollection<Day> typeslist = new ObservableCollection<Day>();
        public ObservableCollection<Day> TypesList
        {
            get
            {
                return typeslist;
            }
            set
            {
                if (typeslist != value)
                {
                    typeslist = value;
                    OnPropertyChanged("TypesList");
                }
            }
        }

        private ObservableCollection<Vendor> vendorslist = new ObservableCollection<Vendor>();
        public ObservableCollection<Vendor> VendorsList
        {
            get
            {
                return vendorslist;
            }
            set
            {
                if (vendorslist != value)
                {
                    vendorslist = value;
                    OnPropertyChanged("VendorsList");
                }
            }
        }

        private ObservableCollection<Origin> originslist = new ObservableCollection<Origin>();
        public ObservableCollection<Origin> OriginsList
        {
            get
            {
                return originslist;
            }
            set
            {
                if (originslist != value)
                {
                    originslist = value;
                    OnPropertyChanged("OriginsList");
                }
            }
        }
        
        #endregion

        #region TimeNav Properties

        private DateTime _StartDateTime = DateTime.Now.Date;
        private DateTime _EndDateTime = DateTime.Now.Date;
        private DateTime _VisibleStartDateTime = DateTime.Now.Date;
        private DateTime _VisibleEndDateTime = DateTime.Now.Date;
        private DateTime _SelectionStartDateTime = DateTime.Now.Date;
        private DateTime _SelectionEndDateTime = DateTime.Now.Date;

        private void SetTimeNav()
        {
            this.StartDateTime = DateTime.Now.AddYears(-1).Date;
            this.EndDateTime = DateTime.Now.Date.AddDays(1).AddMinutes(-1);
            this.VisibleStartDateTime = DateTime.Now.AddDays(-30).Date;
            this.VisibleEndDateTime = DateTime.Now.Date.AddDays(1).AddMinutes(-1);
            this.SelectionStartDateTime = DateTime.Now.Date;
            this.SelectionEndDateTime = DateTime.Now.Date.AddDays(1).AddMinutes(-1);
        }

        public DateTime StartDateTime
        {
            get
            {
                return _StartDateTime;
            }
            set
            {

                if (this._StartDateTime == value)
                    return;

                this._StartDateTime = value;
                this.OnPropertyChanged("StartDateTime");
            }
        }

        public DateTime EndDateTime
        {
            get
            {
                return _EndDateTime;
            }
            set
            {
                if (this._EndDateTime == value)
                    return;

                this._EndDateTime = value;
                this.OnPropertyChanged("EndDateTime");
            }
        }

        public DateTime VisibleStartDateTime
        {
            get
            {
                return _VisibleStartDateTime;
            }
            set
            {

                if (this._VisibleStartDateTime == value)
                    return;

                this._VisibleStartDateTime = value;
                this.OnPropertyChanged("VisibleStartDateTime");
            }
        }

        public DateTime VisibleEndDateTime
        {
            get
            {
                return _VisibleEndDateTime;
            }
            set
            {

                if (this._VisibleEndDateTime == value)
                    return;

                this._VisibleEndDateTime = value;
                this.OnPropertyChanged("VisibleEndDateTime");
            }
        }

        public DateTime SelectionStartDateTime
        {
            get
            {
                return _SelectionStartDateTime;
            }
            set
            {

                if (this._SelectionStartDateTime == value)
                    return;

                this._SelectionStartDateTime = value;
                this.OnPropertyChanged("SelectionStartDateTime");
                this.OnPropertyChanged("SubTitle");
            }
        }

        public DateTime SelectionEndDateTime
        {
            get
            {
                return _SelectionEndDateTime;
            }
            set
            {

                if (this._SelectionEndDateTime == value)
                    return;

                this._SelectionEndDateTime = value;
                this.OnPropertyChanged("SelectionEndDateTime");
                this.OnPropertyChanged("SubTitle");
            }
        }

        public String SubTitle
        {
            get
            {
                return string.Format("{0} a {1}", 
                    SelectionStartDateTime.ToShortDateString(),
                    SelectionEndDateTime.ToShortDateString());
            }
        }

        #endregion

        #region Constructor
        public DashboardViewModel()
        {
            SetTimeNav();
            GetTimeNavChartData();
        }
        #endregion

        #region Events
        #endregion

        #region Commands
        protected RelayCommand loadcommand;

        public bool CanLoadCommand(object parameter)
        {
            return true; 
        }

        public ICommand LoadCommand
        {
            get
            {
                if (loadcommand == null)
                {
                    loadcommand = new RelayCommand(Load, CanLoadCommand);
                }
                return loadcommand;
            }
        }

        public virtual void Load(object parameter)
        {
            if (!isUpdateFromTimeNavSelectionQueued)
            {
                isUpdateFromTimeNavSelectionQueued = true;
                GetTimeNavChartData();
            }
        }

        private void GetTimeNavChartData()
        {
            try
            {
                HttpRequestHelper httpRequest =
                    new HttpRequestHelper(
                        new Uri(string.Format("http://{0}:{1}/Attendance.Dashboard?{2}", Application.Current.Host.Source.Host, Application.Current.Host.Source.Port, Session.Guid)),
                        "POST",
                        new XDocument(
                            new XElement("Dashboard", 
                                new XElement("StartDate", DateTime.SpecifyKind(SelectionStartDateTime, DateTimeKind.Utc).ToString()),
                                new XElement("EndDate", DateTime.SpecifyKind(SelectionEndDateTime, DateTimeKind.Utc).ToString()))));

                httpRequest.ResponseComplete -= new HttpResponseCompleteEventHandler(OnReceiveCompleted);
                httpRequest.ResponseComplete += new HttpResponseCompleteEventHandler(OnReceiveCompleted);
                httpRequest.Execute();

            }
            catch (Exception ex)
            {
                CustomMessage msg = new CustomMessage(ex.Message, CustomMessage.MessageType.Error);
                msg.Show();
            }
        }

        private void OnReceiveCompleted(HttpResponseCompleteEventArgs e)
        {
            if (System.Windows.Deployment.Current.Dispatcher.CheckAccess())
            {

                if (e.Error == null)
                {
                    XDocument xParse = e.XmlResponse;

                    Error error = (from c in xParse.Descendants("Message")
                                   select new Error()
                                   {
                                       Id = Convert.ToInt32(c.Attribute("Id").Value),
                                       Message = c.Value,
                                   }).FirstOrDefault();

                    if (error == null)
                    {

                        DaysList = new ObservableCollection<Day>(from o in xParse.Descendants("Day")
                                    select new Day()
                                         {
                                             Data = DateTime.Parse(o.Attribute("Date").Value),
                                             Total = double.Parse(o.Attribute("y").Value),
                                             Atendimento = double.Parse(o.Attribute("x1").Value),
                                             Orcamento = double.Parse(o.Attribute("x2").Value),
                                             Negociacao = double.Parse(o.Attribute("x3").Value),
                                             Reclamacao = double.Parse(o.Attribute("x4").Value),
                                         });

                        TypesList = new ObservableCollection<Day>(from o in xParse.Descendants("Type")
                                     select new Day()
                                     {
                                         Data = DateTime.Parse(o.Attribute("Date").Value),
                                         Total = double.Parse(o.Attribute("y").Value),
                                         Atendimento = double.Parse(o.Attribute("x1").Value),
                                         Orcamento = double.Parse(o.Attribute("x2").Value),
                                         Negociacao = double.Parse(o.Attribute("x3").Value),
                                         Reclamacao = double.Parse(o.Attribute("x4").Value),
                                     });

                        VendorsList = new ObservableCollection<Vendor>(from o in xParse.Descendants("Vendor")
                                       select new Vendor()
                                       {
                                           Total = double.Parse(o.Attribute("y").Value),
                                           Representante = o.Attribute("x").Value
                                       });

                        double Total = (from o in xParse.Descendants("Origin")
                                        select double.Parse(o.Attribute("y").Value)).Sum();

                        OriginsList = new ObservableCollection<Origin>(from o in xParse.Descendants("Origin")
                                       select new Origin()
                                       {
                                           Quantidade = double.Parse(o.Attribute("y").Value),
                                           Total = double.Parse(o.Attribute("y").Value) / Total,
                                           Descricao = o.Attribute("x").Value,
                                           ZAxis = 25
                                       });


                        /*StartDateTime = (from o in xParse.Descendants("Day")
                                            select DateTime.Parse(o.Attribute("Date").Value)).Min();
                        EndDateTime = (from o in xParse.Descendants("Day")
                                          select DateTime.Parse(o.Attribute("Date").Value)).Max();*/

                        /*if (VisibleStartDateTime < StartDateTime || VisibleStartDateTime > EndDateTime)
                            VisibleStartDateTime = EndDateTime;

                        if (VisibleEndDateTime > EndDateTime || VisibleEndDateTime < StartDateTime)
                            VisibleEndDateTime = EndDateTime;

                        if (SelectionStartDateTime < StartDateTime || SelectionStartDateTime > EndDateTime)
                            SelectionStartDateTime = EndDateTime;

                        if (SelectionEndDateTime > EndDateTime || SelectionEndDateTime < StartDateTime)
                            SelectionEndDateTime = EndDateTime;*/


                        isUpdateFromTimeNavSelectionQueued = false;
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

    }
}
