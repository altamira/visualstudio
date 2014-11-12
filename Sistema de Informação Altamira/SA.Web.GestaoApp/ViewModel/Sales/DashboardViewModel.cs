using System;
using System.Collections.Generic;
using System.Collections.ObjectModel;
using System.ComponentModel.DataAnnotations;
using System.Globalization;
using System.Linq;
using System.Threading;
using System.Windows;
using System.Xml.Linq;
using GestaoApp.Helpers;
using System.ComponentModel;
using SilverlightMessageBoxLibrary;

namespace GestaoApp.ViewModel.Sales
{
    public class DashboardViewModel : ViewModelBase
    {
        #region Data Axis Class
        public class Gauge : INotifyPropertyChanged
        {
            private double MinField;
            private double MaxField;
            private double ValField;
            private int QtdField;
            private double ValPercField;
            private double ValPercInRealField;
            private double QtdPercField;
            private double QtdPercInRealField;

            [Display(Name = "Mínimo")]
            public double Minimum
            {
                get
                {
                    return this.MinField;
                }
                set
                {
                    if ((this.MinField.Equals(value) != true))
                    {
                        this.MinField = value;
                        this.OnPropertyChanged("Minimum");
                    }
                }
            }

            [Display(Name = "Máximo")]
            public double Maximum
            {
                get
                {
                    return this.MaxField;
                }
                set
                {
                    if ((this.MaxField.Equals(value) != true))
                    {
                        this.MaxField = value;
                        this.OnPropertyChanged("Maximum");
                    }
                }
            }

            [Display(Name = "Total")]
            [DisplayFormat(DataFormatString = "{0:C}")]
            public double Value
            {
                get
                {
                    return this.ValField;
                }
                set
                {
                    if ((this.ValField.Equals(value) != true))
                    {
                        this.ValField = value;
                        this.OnPropertyChanged("Value");
                        this.OnPropertyChanged("ValueToString");
                    }
                }
            }

            [Display(Name = "Total (%)")]
            [DisplayFormat(DataFormatString = "{0:p}")]
            public double ValPercentage
            {
                get
                {
                    return this.ValPercField;
                }
                set
                {
                    if ((this.ValPercField.Equals(value) != true))
                    {
                        this.ValPercField = value;
                        this.OnPropertyChanged("ValPercentage");
                        this.OnPropertyChanged("PercentageToString");
                    }
                }
            }

            [DisplayAttribute(AutoGenerateField = false)]
            [DisplayFormat(DataFormatString = "{0:p}")]
            public double ValPercentageInReal
            {
                get
                {
                    return this.ValPercInRealField;
                }
                set
                {
                    if ((this.ValPercInRealField.Equals(value) != true))
                    {
                        this.ValPercInRealField = value;
                        this.OnPropertyChanged("ValPercentageInReal");
                        this.OnPropertyChanged("PercentageToString");
                    }
                }
            }

            [Display(Name = "Quantidade")]
            public int Qtd
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
                        this.OnPropertyChanged("Qtd");
                        this.OnPropertyChanged("ValueToString");
                    }
                }
            }

            [Display(Name = "Quantidade (%)")]
            [DisplayFormat(DataFormatString = "{0:p}")]
            public double QtdPercentage
            {
                get
                {
                    return this.QtdPercField;
                }
                set
                {
                    if ((this.QtdPercField.Equals(value) != true))
                    {
                        this.QtdPercField = value;
                        this.OnPropertyChanged("QtdPercentage");
                        this.OnPropertyChanged("PercentageToString");
                    }
                }
            }

            [DisplayAttribute(AutoGenerateField = false)]
            [DisplayFormat(DataFormatString = "{0:p}")]
            public double QtdPercentageInReal
            {
                get
                {
                    return this.QtdPercInRealField;
                }
                set
                {
                    if ((this.QtdPercInRealField.Equals(value) != true))
                    {
                        this.QtdPercInRealField = value;
                        this.OnPropertyChanged("QtdPercentageInReal");
                        this.OnPropertyChanged("PercentageToString");
                    }
                }
            }

            public string ValueToString
            {
                get
                {
                    return String.Format("{0:C} / {1}", Value, Qtd);
                }
            }

            public string PercentageToString
            {
                get
                {
                    return String.Format("{0:p} / {1:p}", ValPercentageInReal, QtdPercentageInReal);
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

        public class Bid : INotifyPropertyChanged
        {
            private String CodeField;
            private String DescField;
            private double QtdField;
            private double ValField;
            private double QtdPercField;
            private double ValPercField;
            private double QtdPercInRealField;  // Real Number
            private double ValPercInRealField;  // Real Number
            private int ZAxisField = 10;

            [Display(Name = "Código")]
            public String Code
            {
                get
                {
                    return this.CodeField;
                }
                set
                {
                    if ((object.ReferenceEquals(this.CodeField, value) != true))
                    {
                        this.CodeField = value;
                        this.OnPropertyChanged("Code");
                    }
                }
            }

            [Display(Name = "Descrição")]
            public String Descricao
            {
                get
                {
                    return this.DescField;
                }
                set
                {
                    if ((object.ReferenceEquals(this.DescField, value) != true))
                    {
                        this.DescField = value;
                        this.OnPropertyChanged("Descricao");
                    }
                }
            }

            [Display(Name = "Quantidade")]
            public double Qtd
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
                        this.OnPropertyChanged("Qtd");
                    }
                }
            }

            [Display(Name = "Total")]
            [DisplayFormat(DataFormatString = "{0:C}")]
            public double Val
            {
                get
                {
                    return this.ValField;
                }
                set
                {
                    if ((this.ValField.Equals(value) != true))
                    {
                        this.ValField = value;
                        this.OnPropertyChanged("ValField");
                    }
                }
            }

            [Display(Name = "Qtd (%)")]
            [DisplayFormat(DataFormatString = "{0:p}")]
            public double QtdPerc
            {
                get
                {
                    return this.QtdPercField;
                }
                set
                {
                    if ((this.QtdPercField.Equals(value) != true))
                    {
                        this.QtdPercField = value;
                        this.OnPropertyChanged("QtdPerc");
                    }
                }
            }

            [Display(Name = "Total (%)")]
            [DisplayFormat(DataFormatString = "{0:p}")]
            public double ValPerc
            {
                get
                {
                    return this.ValPercField;
                }
                set
                {
                    if ((this.ValPercField.Equals(value) != true))
                    {
                        this.ValPercField = value;
                        this.OnPropertyChanged("ValPercField");
                    }
                }
            }

            [DisplayAttribute(AutoGenerateField = false)]
            [DisplayFormat(DataFormatString = "{0:p}")]
            public double QtdPercInReal
            {
                get
                {
                    return this.QtdPercInRealField;
                }
                set
                {
                    if ((this.QtdPercInRealField.Equals(value) != true))
                    {
                        this.QtdPercInRealField = value;
                        this.OnPropertyChanged("QtdPercInReal");
                    }
                }
            }

            [DisplayAttribute(AutoGenerateField = false)]
            [DisplayFormat(DataFormatString = "{0:p}")]
            public double ValPercInReal
            {
                get
                {
                    return this.ValPercInRealField;
                }
                set
                {
                    if ((this.ValPercInRealField.Equals(value) != true))
                    {
                        this.ValPercInRealField = value;
                        this.OnPropertyChanged("ValPercInRealField");
                    }
                }
            }

            [DisplayAttribute(AutoGenerateField = false)]
            public int ZAxis
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
                        this.OnPropertyChanged("ZAxis");
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

        public class Sale : INotifyPropertyChanged
        {
            private object DateField;
            private double QtdField;
            private double ValField;

            [Display(Name = "Data")]
            [DisplayFormat(ApplyFormatInEditMode = true, DataFormatString = "{0:d}")]
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

            [Display(Name = "Quantidade")]
            public double Qtd
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
                        this.OnPropertyChanged("Qtd");
                    }
                }
            }

            [Display(Name = "Total")]
            [DisplayFormat(DataFormatString = "{0:C}")]
            public double Val
            {
                get
                {
                    return this.ValField;
                }
                set
                {
                    if ((this.ValField.Equals(value) != true))
                    {
                        this.ValField = value;
                        this.OnPropertyChanged("ValField");
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

        public class Day : INotifyPropertyChanged
        {
            private object DateField;
            private double YAxisField;
            private double X1AxisField;
            private double X2AxisField;
            private double X3AxisField;
            private double X4AxisField;

            [DisplayFormat(ApplyFormatInEditMode = true, DataFormatString = "{0:d}")]
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

        public class Days
        {
            public System.Collections.Generic.List<Day> DaysList { get; set; }
        }

        public class Vendor : INotifyPropertyChanged
        {
            private string NameField;
            private double QtdField;
            private double ValField;

            [Display(Name = "Vendedor")]
            [DisplayFormat(ApplyFormatInEditMode = true, DataFormatString = "{0:d}")]
            public string Name
            {
                get
                {
                    return this.NameField;
                }
                set
                {
                    if ((object.ReferenceEquals(this.NameField, value) != true))
                    {
                        this.NameField = value;
                        this.OnPropertyChanged("Vendedor");
                    }
                }
            }

            [Display(Name = "Quantidade")]
            public double Qtd
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
                        this.OnPropertyChanged("Qtd");
                    }
                }
            }

            [Display(Name = "Total")]
            [DisplayFormat(DataFormatString = "{0:C}")]
            public double Val
            {
                get
                {
                    return this.ValField;
                }
                set
                {
                    if ((this.ValField.Equals(value) != true))
                    {
                        this.ValField = value;
                        this.OnPropertyChanged("ValField");
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

        public class Origin : INotifyPropertyChanged
        {
            private double YAxisField = 0;
            private string XAxisField = "";
            private double ZAxisField = 0;

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

        private bool isUpdateFromTimeNavSelectionQueued = false;

        private Gauge bidsend = new Gauge();
        public Gauge BidSend
        {
            get
            {
                return bidsend;
            }
            set
            {
                if (bidsend != value)
                {
                    bidsend = value;
                    OnPropertyChanged("BidSend");
                }
            }
        }

        private Gauge bidapproved = new Gauge();
        public Gauge BidApproved
        {
            get
            {
                return bidapproved;
            }
            set
            {
                if (bidapproved != value)
                {
                    bidapproved = value;
                    OnPropertyChanged("BidApproved");
                }
            }
        }

        private ObservableCollection<Sale> dayslist = new ObservableCollection<Sale>();
        public ObservableCollection<Sale> DaysList
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

        private ObservableCollection<Bid> statuslist = new ObservableCollection<Bid>();
        public ObservableCollection<Bid> StatusList
        {
            get
            {
                return statuslist;
            }
            set
            {
                if (statuslist != value)
                {
                    statuslist = value;
                    OnPropertyChanged("StatusList");
                }
            }
        }

        private ObservableCollection<Sales.DashboardViewModel.Vendor> vendorlist = new ObservableCollection<Sales.DashboardViewModel.Vendor>();
        public ObservableCollection<Sales.DashboardViewModel.Vendor> VendorList
        {
            get
            {
                return vendorlist;
            }
            set
            {
                if (vendorlist != value)
                {
                    vendorlist = value;
                    OnPropertyChanged("VendorList");
                }
            }
        }

        public DashboardViewModel()
        {
            int Total = 1;

            BidSend.Maximum = 100;
            BidSend.Minimum = 0;
            BidSend.Value = Total;
            BidSend.Qtd = Total;
            BidSend.ValPercentage = 100;
            BidSend.QtdPercentage = 100;

            BidApproved.Maximum = 100;
            BidApproved.Minimum = 0;
            BidApproved.Value = 1;
            BidSend.Qtd = Total;
            BidApproved.ValPercentage = 0;
            BidApproved.QtdPercentage = 0;

            //StartTime = EndTime = SelectedStartTime = SelectedEndTime = 
            //ViewportStartTime = ViewportEndTime = DateTime.Now;

            QueueUpdateFromTimeNavSelection();
        }

        #region TimeNavigator Panel

        public void QueueUpdateFromTimeNavSelection()
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
                if (SelectedStartTime >= SelectedEndTime)
                {
                    isUpdateFromTimeNavSelectionQueued = false;
                    return;
                }

                HttpRequestHelper httpRequest =
                    new HttpRequestHelper(
                        new Uri(string.Format("http://{0}:{1}/Sales.Dashboard?{2}", Application.Current.Host.Source.Host, Application.Current.Host.Source.Port, Session.Guid)),
                        "POST",
                        new XDocument(
                            new XElement("Dashboard",
                                new XElement("StartDate", DateTime.SpecifyKind(SelectedStartTime, DateTimeKind.Utc).ToString()),
                                new XElement("EndDate", DateTime.SpecifyKind(SelectedEndTime, DateTimeKind.Utc).ToString()))));

                httpRequest.ResponseComplete -= new HttpResponseCompleteEventHandler(OnReceiveCompleted);
                httpRequest.ResponseComplete += new HttpResponseCompleteEventHandler(OnReceiveCompleted);
                httpRequest.Execute();
            }
            catch (Exception ex)
            {
                MessageBox.Show("Error on send your request !\n\nError:" + ex.Message);
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

                        DaysList = new ObservableCollection<Sale>(from o in xParse.Descendants("Day")
                                                                  select new Sale()
                                                                  {
                                                                      Data = DateTime.Parse(o.Attribute("Date").Value),
                                                                      Qtd = int.Parse(o.Attribute("Quantity").Value),
                                                                      Val = double.Parse(o.Attribute("Value").Value, new System.Globalization.CultureInfo("en-US")),
                                                                  });

                        CultureInfo culture = Thread.CurrentThread.CurrentCulture;

                        double TotalVal = (from o in xParse.Descendants("Status")
                                           select double.Parse(o.Attribute("Value").Value, new System.Globalization.CultureInfo("en-US"))).Sum();

                        double TotalQtd = (from o in xParse.Descendants("Status")
                                           select double.Parse(o.Attribute("Quantity").Value, new System.Globalization.CultureInfo("en-US"))).Sum();

                        BidSend.Value = (from o in xParse.Descendants("Status")
                                         where o.Attribute("Code").Value == "40"
                                         select double.Parse(o.Attribute("Value").Value, new System.Globalization.CultureInfo("en-US"))).FirstOrDefault();

                        BidSend.Qtd = (from o in xParse.Descendants("Status")
                                       where o.Attribute("Code").Value == "40"
                                       select int.Parse(o.Attribute("Quantity").Value, new System.Globalization.CultureInfo("en-US"))).FirstOrDefault();

                        BidApproved.Value = (from o in xParse.Descendants("Status")
                                             where o.Attribute("Code").Value == "60"
                                             select double.Parse(o.Attribute("Value").Value, new System.Globalization.CultureInfo("en-US"))).FirstOrDefault();

                        BidApproved.Qtd = (from o in xParse.Descendants("Status")
                                           where o.Attribute("Code").Value == "60"
                                           select int.Parse(o.Attribute("Quantity").Value, new System.Globalization.CultureInfo("en-US"))).FirstOrDefault();

                        if (BidSend.Value > 0)
                        {
                            BidApproved.ValPercentage = (BidApproved.Value / BidSend.Value) * 100;
                            BidApproved.ValPercentageInReal = (BidApproved.Value / BidSend.Value);
                            BidApproved.QtdPercentage = ((double)BidApproved.Qtd / (double)BidSend.Qtd) * 100;
                            BidApproved.QtdPercentageInReal = ((double)BidApproved.Qtd / (double)BidSend.Qtd);
                        }

                        StatusList = new ObservableCollection<Bid>(from o in xParse.Descendants("Status")
                                      select new Bid()
                                      {
                                          Code = o.Attribute("Code").Value,
                                          Descricao = o.Attribute("Description").Value,
                                          Qtd = int.Parse(o.Attribute("Quantity").Value),
                                          Val = double.Parse(o.Attribute("Value").Value, new System.Globalization.CultureInfo("en-US")),
                                          QtdPerc = double.Parse(o.Attribute("Quantity").Value) / TotalQtd,
                                          ValPerc = double.Parse(o.Attribute("Value").Value, new System.Globalization.CultureInfo("en-US")) / TotalVal
                                      });

                        VendorList = new ObservableCollection<Vendor>(from v in xParse.Descendants("Vendor")
                                                                      select new Sales.DashboardViewModel.Vendor()
                                                                      {
                                                                          Name = v.Attribute("Name").Value,
                                                                          Qtd = int.Parse(v.Attribute("Quantity").Value),
                                                                          Val = double.Parse(v.Attribute("Value").Value, new System.Globalization.CultureInfo("en-US")),
                                                                      });

                        object StartDate = (from o in xParse.Descendants("Day")
                                            select DateTime.Parse(o.Attribute("Date").Value)).Min();
                        object EndDate = (from o in xParse.Descendants("Day")
                                          select DateTime.Parse(o.Attribute("Date").Value)).Max();

                        StartTime = (DateTime)StartDate;
                        EndTime = (DateTime)EndDate;
                        //SelectedStartTime = ((DateTime)EndDate).AddMonths(-1);
                        //SelectedEndTime = (DateTime)EndDate;
                        //TimeSpan Interval = EndTime - StartTime;

                        if (ViewportStartTime < StartTime || ViewportStartTime > EndTime)
                            ViewportStartTime = EndTime;

                        if (ViewportEndTime > EndTime || ViewportEndTime < StartTime)
                            ViewportEndTime = EndTime;

                        if (SelectedStartTime < StartTime || SelectedStartTime > EndTime)
                            SelectedStartTime = EndTime;

                        if (SelectedEndTime > EndTime || SelectedEndTime < StartTime)
                            SelectedEndTime = EndTime;

                        //ViewportStartTime = ((DateTime)EndDate).AddDays(Interval.Days / -2);
                        //ViewportEndTime = (DateTime)EndDate;

                        /*StartTime = Days.First().Date;
                        EndTime = DataPoints.Last().Date;
                        SelectedStartTime = DataPoints[days / 2 - 5].Date;
                        SelectedEndTime = DataPoints[days / 2 + 5].Date;*/

                        UpdateFromTimeNavSelection();
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

        private string subtitle = "Principais indicadores";
        public string SubTitle
        {
            get
            {
                return subtitle;
            }
            set
            {
                if (subtitle != null)
                {
                    subtitle = value;
                    OnPropertyChanged("SubTitle");
                }
            }
        }

        private void UpdateFromTimeNavSelection()
        {
            if (!isUpdateFromTimeNavSelectionQueued)
                return;

            isUpdateFromTimeNavSelectionQueued = false;

            //DateTime startTime = SelectedStartTime;
            //DateTime endTime = SelectedEndTime;

            //string formatString = "MMMM yyyy";
            string startMonth = SelectedStartTime.ToShortDateString(); // startTime.ToString(formatString);
            string endMonth = SelectedEndTime.AddTicks(-1).ToShortDateString(); // endTime.AddTicks(-1).ToString(formatString);

            string selectedRange = startMonth == endMonth
                ? startMonth
                : String.Format("{0} - {1}", startMonth, endMonth);

            SubTitle = selectedRange;

            //MetricsPanel.SubTitle = selectedRange;
            //ProjectionsPanel.SubTitle = selectedRange;
            //AnalysisPanel.SubTitle = selectedRange;
            //TrendPanel.SubTitle = selectedRange;

            //GetMetricsPanelData();
            //GetProjectionsPanelData();
            //GetAnalysisPanelData();
            //GetTrendPanelData();

            try
            {
                //TimeNavChart.DataSource = DaysList;
                //AttendanceTypeGrid.ItemsSource = TypesList;
                //AttendanceTypeChart.DataSource = TypesList;
                //VendorChart.DataSource = VendorsList;
                //VendorGrid.ItemsSource = VendorsList;
                //OriginPieChart.DataSource = OriginsList;
                //OriginGrid.ItemsSource = OriginsList;
            }
            catch /*(Exception e)*/
            {
                // throw e;
                // Do nothing
            }

        }

        #endregion TimeNavigator Panel

        public void LoadData(int days)
        {
            /*DataPoints = new DemoDataValues();
            Random r = new Random(DateTime.Now.Millisecond);
            for (int i = 0; i < days; i++)
            {
                DataPoints.Add(new DemoDataValue
                {
                    Date = DateTime.Now.AddDays(i),
                    Y = r.NextDouble() * 100
                });
            }
            StartTime = DataPoints.First().Date;
            EndTime = DataPoints.Last().Date;
            SelectedStartTime = DataPoints[days / 2 - 5].Date;
            SelectedEndTime = DataPoints[days / 2 + 5].Date;*/
        }

        /*#region AverageValue (INotifyPropertyChanged Property)
        private double _averageValue;

        public double AverageValue
        {
            get
            {
                double total = 0;
                int count = 0;

                foreach (DemoDataValue t in DataPoints.Where(t => t.Date >= SelectedStartTime && t.Date <= SelectedEndTime))
                {
                    //total += t.Y;
                    count++;
                }
                AverageValue = (count > 0) ? total / count : _averageValue;
                return _averageValue;
            }
            set
            {
                if (_averageValue != value)
                {
                    _averageValue = value;
                    RaisePropertyChanged("AverageValue");
                }
            }
        }
        #endregion*/

        #region SelectedStartTime (INotifyPropertyChanged Property)
        private DateTime _selectedStartTime = DateTime.Now.AddMonths(-1);

        public DateTime SelectedStartTime
        {
            get { return _selectedStartTime; }
            set
            {
                if (_selectedStartTime != value)
                {
                    _selectedStartTime = value;
                    OnPropertyChanged("SelectedStartTime");
                    //double a = AverageValue; // cause AverageValue update.
                    if (_selectedStartTime != null && _selectedEndTime != null)
                        QueueUpdateFromTimeNavSelection();
                }
            }
        }
        #endregion

        #region SelectedEndTime (INotifyPropertyChanged Property)
        private DateTime _selectedEndTime = DateTime.Now;

        public DateTime SelectedEndTime
        {
            get { return _selectedEndTime; }
            set
            {
                if (_selectedEndTime != value)
                {
                    _selectedEndTime = value;
                    OnPropertyChanged("SelectedEndTime");
                    //double a = AverageValue; // cause AverageValue update.
                    if (_selectedStartTime != null && _selectedEndTime != null)
                        QueueUpdateFromTimeNavSelection();
                }
            }
        }
        #endregion

        #region StartTime (INotifyPropertyChanged Property)
        private DateTime _startTime = DateTime.Now.AddMonths(-12);

        public DateTime StartTime
        {
            get { return _startTime; }
            set
            {
                if (_startTime != value)
                {
                    _startTime = value;
                    OnPropertyChanged("StartTime");
                }
            }
        }
        #endregion

        #region EndTime (INotifyPropertyChanged Property)
        private DateTime _endTime = DateTime.Now;

        public DateTime EndTime
        {
            get { return _endTime; }
            set
            {
                if (_endTime != value)
                {
                    _endTime = value;
                    OnPropertyChanged("EndTime");
                }
            }
        }
        #endregion

        #region ViewportStartTime (INotifyPropertyChanged Property)
        private DateTime _ViewportstartTime = DateTime.Now.AddMonths(-6);

        public DateTime ViewportStartTime
        {
            get { return _ViewportstartTime; }
            set
            {
                if (_ViewportstartTime != value)
                {
                    _ViewportstartTime = value;
                    OnPropertyChanged("ViewportStartTime");
                }
            }
        }
        #endregion

        #region ViewportEndTime (INotifyPropertyChanged Property)
        private DateTime _ViewportendTime = DateTime.Now;

        public DateTime ViewportEndTime
        {
            get { return _ViewportendTime; }
            set
            {
                if (_ViewportendTime != value)
                {
                    _ViewportendTime = value;
                    OnPropertyChanged("ViewportEndTime");
                }
            }
        }
        #endregion

        /*#region DataPoints (INotifyPropertyChanged Property)
        private DemoDataValues _dataPoints;

        public DemoDataValues DataPoints
        {
            get { return _dataPoints; }
            set
            {
                if (_dataPoints != value)
                {
                    _dataPoints = value;
                    RaisePropertyChanged("DataPoints");
                }
            }
        }
        #endregion*/

    }
}
