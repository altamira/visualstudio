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
using System.ComponentModel;

namespace SA.WPF.CustomControlLibrary
{
    /// <summary>
    /// Follow steps 1a or 1b and then 2 to use this custom control in a XAML file.
    ///
    /// Step 1a) Using this custom control in a XAML file that exists in the current project.
    /// Add this XmlNamespace attribute to the root element of the markup file where it is 
    /// to be used:
    ///
    ///     xmlns:MyNamespace="clr-namespace:WpfCustomControlLibrary"
    ///
    ///
    /// Step 1b) Using this custom control in a XAML file that exists in a different project.
    /// Add this XmlNamespace attribute to the root element of the markup file where it is 
    /// to be used:
    ///
    ///     xmlns:MyNamespace="clr-namespace:WpfCustomControlLibrary;assembly=WpfCustomControlLibrary"
    ///
    /// You will also need to add a project reference from the project where the XAML file lives
    /// to this project and Rebuild to avoid compilation errors:
    ///
    ///     Right click on the target project in the Solution Explorer and
    ///     "Add Reference"->"Projects"->[Select this project]
    ///
    ///
    /// Step 2)
    /// Go ahead and use your control in the XAML file.
    ///
    ///     <MyNamespace:CustomControl1/>
    ///
    /// </summary>
    public class FieldName : Control, INotifyPropertyChanged 
    {
        Label FieldCaption;
        TextBox FieldValue;

        static FieldName()
        {
            DefaultStyleKeyProperty.OverrideMetadata(typeof(FieldName), new FrameworkPropertyMetadata(typeof(FieldName)));
        }

        #region DependencyProperty Content

        /// <summary>
        /// Registers a dependency property as backing store for the Content property
        /// </summary>
        public static readonly DependencyProperty ContentProperty =
            DependencyProperty.Register("Content", typeof(object), typeof(FieldName),
            new FrameworkPropertyMetadata(null,
                  FrameworkPropertyMetadataOptions.AffectsRender |
                  FrameworkPropertyMetadataOptions.AffectsParentMeasure));

        /// <summary>
        /// Gets or sets the Content.
        /// </summary>
        /// <value>The Content.</value>
        public object Content
        {
            get { return (object)GetValue(ContentProperty); }
            set { SetValue(ContentProperty, value); }
        }

        // Dependency Property
        public static readonly DependencyProperty CaptionProperty =
             DependencyProperty.Register("Caption", typeof(String), typeof(FieldName),
             new FrameworkPropertyMetadata(string.Empty,
                FrameworkPropertyMetadataOptions.AffectsRender |
                  FrameworkPropertyMetadataOptions.AffectsParentMeasure));

        // .NET Property wrapper
        public String Caption
        {
            get { return (String)GetValue(CaptionProperty); }
            set { SetValue(CaptionProperty, value); }
        }

        // Dependency Property
        public static readonly DependencyProperty CaptionWidthProperty =
             DependencyProperty.Register("CaptionWidth", typeof(System.Windows.GridLength), typeof(FieldName), new UIPropertyMetadata(System.Windows.GridLength.Auto));

        // .NET Property wrapper
        public System.Windows.GridLength CaptionWidth
        {
            get { return (System.Windows.GridLength)GetValue(CaptionWidthProperty); }
            set 
            { 
                SetValue(CaptionWidthProperty, value);
                //ColumnDefinition column = this.Template.FindName("CaptionColumn", this) as ColumnDefinition;
                //if (column != null)
                //    column.Width = value;
            }
        }

        // Dependency Property
        public static DependencyProperty ValueProperty =
             DependencyProperty.Register("Value", typeof(String), typeof(FieldName),
             /*new UIPropertyMetadata(string.Empty, new PropertyChangedCallback(OnValuePropertyChanged)));*/
             new FrameworkPropertyMetadata(string.Empty,
                FrameworkPropertyMetadataOptions.BindsTwoWayByDefault
                /*FrameworkPropertyMetadataOptions.AffectsRender |
                  FrameworkPropertyMetadataOptions.AffectsParentMeasure, new PropertyChangedCallback(OnValuePropertyChanged)*/));

        DependencyPropertyDescriptor textDescr = DependencyPropertyDescriptor.FromProperty(TextBox.TextProperty, typeof(TextBox));

        // .NET Property wrapper
        public String Value
        {
            get { return (String)GetValue(ValueProperty); }
            set 
            { 
                SetValue(ValueProperty, value);
                //SetCurrentValue(ValueProperty, value);
                //TextBox t = this.Template.FindName("FieldValue", this) as TextBox;
                //if (t != null)
                //    t.GetBindingExpression(TextBox.TextProperty).UpdateTarget();
                //// Implement INotifyPropertyChanged to update the TextBox.
                //if (PropertyChanged != null)
                //    PropertyChanged(this, new PropertyChangedEventArgs("Value"));
                //OnPropertyChanged("Value");
            }
        }

        private static void OnValuePropertyChanged(DependencyObject sender, DependencyPropertyChangedEventArgs e)
        {
            //((FieldName)sender).Value = (String)e.NewValue;
            //FieldName f = sender as FieldName;
            //if (f != null)
            //    f.OnPropertyChanged("Value");
        }

        #endregion

        #region PropertyChanged

        public event PropertyChangedEventHandler PropertyChanged;
        
        protected void OnPropertyChanged(string propertyName)
        {
            if (PropertyChanged != null)
            {
                PropertyChanged(this, new PropertyChangedEventArgs(propertyName));
            }
        }

        #endregion

        #region Template

        public override void OnApplyTemplate()
        {
            base.OnApplyTemplate();

            if (this.Template != null)
            {
                TextBox fieldValue = this.Template.FindName("FieldValueTextBox", this) as TextBox;
                if (fieldValue != FieldValue)
                {
                    //First unhook existing handler
                    if (FieldValue != null)
                    {
                        FieldValue.GotFocus -= new RoutedEventHandler(FieldValue_GotFocus);
                        FieldValue.LostFocus -= new RoutedEventHandler(FieldValue_LostFocus);
                    }
                    FieldValue = fieldValue;
                    if (FieldValue != null)
                    {
                        FieldValue.GotFocus += new RoutedEventHandler(FieldValue_GotFocus);
                        FieldValue.LostFocus += new RoutedEventHandler(FieldValue_LostFocus);
                    }
                }

                FieldCaption = this.Template.FindName("FieldCaption", this) as Label;

            }
        }

        void FieldValue_GotFocus(object sender, EventArgs e)
        {
            TextBox thisFieldValue = sender as TextBox;
            if (thisFieldValue != null)
            {
                BrushConverter b = new BrushConverter();
                thisFieldValue.Background = (Brush)b.ConvertFrom("#FFFAE55A");

                thisFieldValue.SelectAll();

                //thisBorder.Background = new SolidColorBrush(Colors.Red);
                //if (Body != null)
                //{
                //    Run r = new Run("Mouse Left!");
                //    r.Foreground = new SolidColorBrush(Colors.White);
                //    Body.Content = r;
                //}
            }
        }

        void FieldValue_LostFocus(object sender, EventArgs e)
        {
            TextBox thisFieldValue = sender as TextBox;
            if (thisFieldValue != null)
            {
                thisFieldValue.Background = Brushes.White;
            }
        }

        #endregion
    }
}
