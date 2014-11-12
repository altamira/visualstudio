using System;
using System.Windows;
using System.Threading;
using System.Collections.ObjectModel;

// Toolkit namespace
using SimpleMvvmToolkit;

namespace View.WPF
{
    /// <summary>
    /// This class contains properties that a View can data bind to.
    /// <para>
    /// Use the <strong>mvvmprop</strong> snippet to add bindable properties to this ViewModel.
    /// </para>
    /// </summary>
    public class MainPageViewModel : ViewModelBase<MainPageViewModel>
    {
        // Default ctor
        public MainPageViewModel() { }

        // TODO: Add events to notify the view or obtain data from the view
        public event EventHandler<NotificationEventArgs<Exception>> ErrorNotice;

        // Add properties using the mvvmprop code snippet

        private string _bannerText = "Hello Simple MVVM Toolkit";
        public string BannerText
        {
            get
            {
                if (this.IsInDesignMode()) return "Banner";
                return _bannerText;
            }
            set
            {
                _bannerText = value;
                NotifyPropertyChanged(m => m.BannerText);
            }
        }

        // TODO: Add methods that will be called by the view

        // TODO: Optionally add callback methods for async calls to the service agent

        // Helper method to notify View of an error
        private void NotifyError(string message, Exception error)
        {
            // Notify view of an error
            Notify(ErrorNotice, new NotificationEventArgs<Exception>(message, error));
        }
    }
}