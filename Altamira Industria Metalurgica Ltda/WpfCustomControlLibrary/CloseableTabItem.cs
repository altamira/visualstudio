using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Windows;
using System.Windows.Controls;
using System.Windows.Data;
using System.Windows.Documents;
using System.Windows.Input;
using System.Windows.Media;
using System.Windows.Media.Imaging;
using System.Windows.Navigation;
using System.Windows.Shapes;
using System.Collections.ObjectModel;

namespace SA.WpfCustomControlLibrary
{
    public class CloseableTab : TabControl
    {
        static CloseableTab()
        {
            //This OverrideMetadata call tells the system that this element wants to provide a style that is different than its base class.
            //This style is defined in themes\generic.xaml
            //DefaultStyleKeyProperty.OverrideMetadata(typeof(CloseableTab),
            //    new FrameworkPropertyMetadata(typeof(CloseableTab)));
        }

        //public override void OnApplyTemplate()
        //{
        //    base.OnApplyTemplate();
        //}

    }
    /// <summary>
    /// http://www.c-sharpcorner.com/uploadfile/dpatra/closable-tab-control-in-wpf/
    /// TODO: http://www.blogs.intuidev.com/post/2010/02/10/TabControlStyling_PartThree.aspx
    /// http://www.blogs.intuidev.com/image.axd?picture=2010%2f2%2fSAP_tPoc_L.jpg
    /// </summary>
    public class CloseableTabItem : TabItem
    {
        static CloseableTabItem()
        {
            //This OverrideMetadata call tells the system that this element wants to provide a style that is different than its base class.
            //This style is defined in themes\generic.xaml
            DefaultStyleKeyProperty.OverrideMetadata(typeof(CloseableTabItem),
                new FrameworkPropertyMetadata(typeof(CloseableTabItem)));
        }

        public static readonly RoutedEvent CloseTabEvent =
            EventManager.RegisterRoutedEvent("CloseTab", RoutingStrategy.Bubble,
                typeof(RoutedEventHandler), typeof(CloseableTabItem));

        public event RoutedEventHandler CloseTab
        {
            add { AddHandler(CloseTabEvent, value); }
            remove { RemoveHandler(CloseTabEvent, value); }
        }

        public override void OnApplyTemplate()
        {
            base.OnApplyTemplate();

            Button closeButton = base.GetTemplateChild("PART_Close") as Button;
            if (closeButton != null)
                closeButton.Click += new System.Windows.RoutedEventHandler(closeButton_Click);
        }

        void closeButton_Click(object sender, System.Windows.RoutedEventArgs e)
        {
            this.RaiseEvent(new RoutedEventArgs(CloseTabEvent, this));
        }
    }
}
