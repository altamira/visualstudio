﻿using FirstFloor.ModernUI.Windows;
using FirstFloor.ModernUI.Windows.Navigation;
using MefMuiApp.ViewModels;
using System;
using System.Collections.Generic;
using System.ComponentModel.Composition;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows;
using System.Windows.Controls;
using System.Windows.Data;
using System.Windows.Documents;
using System.Windows.Input;
using System.Windows.Media;
using System.Windows.Media.Imaging;
using System.Windows.Shapes;

namespace MefMuiApp.Pages
{
    /// <summary>
    /// Interaction logic for Home.xaml
    /// </summary>
    [Content("/Home")]
    public partial class Home : UserControl, IContent, IPartImportsSatisfiedNotification
    {
        public Home()
        {
            InitializeComponent();
        }

        [Import]
        private HomeViewModel HomeVM { get; set; }

        public void OnImportsSatisfied()
        {
            this.DataContext = this.HomeVM;
        }

        public void OnFragmentNavigation(FragmentNavigationEventArgs e)
        {
        }

        public void OnNavigatedFrom(NavigationEventArgs e)
        {
        }

        public void OnNavigatedTo(NavigationEventArgs e)
        {
        }

        public void OnNavigatingFrom(NavigatingCancelEventArgs e)
        {
        }
    }
}
