using System;
using System.Globalization;
using System.Threading;
using System.Windows;
using Telerik.Windows.Controls;
using GestaoApp.ViewModel;
using GestaoApp.Helpers;

namespace GestaoApp
{
    public partial class App : Application
    {
        //MainPageViewModel mainPageViewModel;

        public App()
        {            
            Thread.CurrentThread.CurrentCulture = new CultureInfo("pt-BR");
            //Thread.CurrentThread.CurrentCulture.DateTimeFormat.ShortDatePattern = "D/m/yyyy"; 

            LocalizationManager.Manager = new LocalizationManager
            {
                ResourceManager = GestaoApp.ApplicationStrings.ResourceManager,
                //Culture = new System.Globalization.CultureInfo("en-US")
                Culture = new System.Globalization.CultureInfo("pt-BR")
            };

            InitializeComponent();

        }

        private void Application_Startup(object sender, StartupEventArgs e)
        {
            // This will enable you to bind controls in XAML files to WebContext.Current
            // properties
            //this.Resources.Add("WebContext", WebContext.Current);

            Models.Location.Country.LoadCompleted += new EventHandler(LoadCountryCompleted);
            Models.Location.Country.LoadCollectionAsync();

            // This will automatically authenticate a user when using windows authentication
            // or when the user chose "Keep me signed in" on a previous login attempt
            //WebContext.Current.Authentication.LoadUser(this.Application_UserLoaded, null);

            // Show some UI to the user while LoadUser is in progress
            this.InitializeRootVisual();
        }

        private void LoadCountryCompleted(object sender, EventArgs e)
        {
            Models.Location.State.LoadCompleted += new EventHandler(LoadStateCompleted);
            Models.Location.State.LoadCollectionAsync();
        }

        private void LoadStateCompleted(object sender, EventArgs e)
        {
            Models.Location.City.LoadCompleted += new EventHandler(LoadCityCompleted);
            Models.Location.City.LoadCollectionAsync();
        }

        private void LoadCityCompleted(object sender, EventArgs e)
        {
            Models.Contact.FoneType.LoadCollection();
            Models.Contact.Media.LoadCollectionAsync();
            Models.Bid.PurchaseType.LoadCollection();

            Models.Attendance.Product.LoadCollectionAsync();

            Models.Attendance.Status.LoadCollectionAsync();
            Models.Attendance.Type.LoadCollectionAsync();

            Models.Sales.Vendor.LoadCompleted += new EventHandler(LoadVendorCompleted);
            Models.Sales.Vendor.LoadCollectionAsync();
        }

        private void LoadVendorCompleted(object sender, EventArgs e)
        {
            //Models.Sales.Client.LoadCompleted += new EventHandler(LoadClientCompleted);
            //Models.Sales.Client.LoadCollectionAsync();
        }

        private void LoadClientCompleted(object sender, EventArgs e)
        {
        }

        /// <summary>
        /// Invoked when the <see cref="LoadUserOperation"/> completes. Use this
        /// event handler to switch from the "loading UI" you created in
        /// <see cref="InitializeRootVisual"/> to the "application UI"
        /// </summary>
        //private void Application_UserLoaded(LoadUserOperation operation)
        //{
        //}

        /// <summary>
        /// Initializes the <see cref="Application.RootVisual"/> property. The
        /// initial UI will be displayed before the LoadUser operation has completed
        /// (The LoadUser operation will cause user to be logged automatically if
        /// using windows authentication or if the user had selected the "keep
        /// me signed in" option on a previous login).
        /// </summary>
        protected virtual void InitializeRootVisual()
        {
            //MainPageViewModel ViewModel = new MainPageViewModel();
            MainPage MainPage = new MainPage();
            //View.DataContext = ViewModel;

            GestaoApp.ViewModel.ViewModelBase.Session = new Session();

            #if DEBUG
                //LoginViewModel.Submit();
                //LoginViewModel.Visible = Visibility.Collapsed;
            #endif

            /*System.Windows.Controls.BusyIndicator busyIndicator = new System.Windows.Controls.BusyIndicator();
            this.Resources.Add("MainProgress", busyIndicator);
            busyIndicator.BusyContent = "Loading, wait...";
            busyIndicator.Content = new MainPage();
            busyIndicator.HorizontalContentAlignment = HorizontalAlignment.Stretch;
            busyIndicator.VerticalContentAlignment = VerticalAlignment.Stretch;*/

            //this.RootVisual = busyIndicator;
            this.RootVisual = new MainPage();
        }

        private void Application_UnhandledException(object sender, ApplicationUnhandledExceptionEventArgs e)
        {
            // If the app is running outside of the debugger then report the exception using
            // a ChildWindow control.
            if (!System.Diagnostics.Debugger.IsAttached)
            {
                // NOTE: This will allow the application to continue running after an exception has been thrown
                // but not handled. 
                // For production applications this error handling should be replaced with something that will 
                // report the error to the website and stop the application.
                e.Handled = true;
                //ErrorWindow.CreateNew(e.ExceptionObject);
            }
        }

    }
}