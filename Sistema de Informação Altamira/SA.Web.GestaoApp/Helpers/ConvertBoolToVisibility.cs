using System.Windows.Data;
using System.Windows;
using System;
using System.Windows.Controls;

namespace GestaoApp.Helpers
{
    public class ConvertBoolToVisibility : IValueConverter
    {
        public object Convert(object value, Type targetType, object parameter, System.Globalization.CultureInfo culture)
        {
            if (value != null)
                if (value.GetType() == typeof(bool))
                {
                    bool canvisible = (bool)value;

                    if (canvisible)
                        return Visibility.Visible;
                }

            return Visibility.Collapsed;
        }

        public object ConvertBack(object value, Type targetType, object parameter, System.Globalization.CultureInfo culture)
        {
            throw new NotImplementedException();
        }


        /*public static class DialogHelper
        {
            ///
            /// Recursively processes a given dependency object and all its
            /// children, and updates sources of all objects that use a
            /// binding expression on a given property.
            ///
            /// The dependency object that marks a starting
            /// point. This could be a dialog window or a panel control that
            /// hosts bound controls.
            /// The properties to be updated if
            ///  or one of its childs provide it along
            /// with a binding expression.
            public static void UpdateBindingSources(DependencyObject obj)
            {
                IEnumerable props = obj.EnumerateDependencyProperties();
                foreach (DependencyProperty p in props)
                {
                    Binding b = BindingOperations.GetBinding(obj, p);
                    if (b.UpdateSourceTrigger == UpdateSourceTrigger.Explicit)
                    {
                        //check whether the submitted object provides a bound property
                        //that matches the property parameters
                        BindingExpression be =
                          BindingOperations.GetBindingExpression(obj, p);
                        if (be != null) be.UpdateSource();
                    }
                }

                int count = VisualTreeHelper.GetChildrenCount(obj);
                for (int i = 0; i < count; i++)
                {
                    //process child items recursively
                    DependencyObject childObject = VisualTreeHelper.GetChild(obj, i);
                    UpdateBindingSources(childObject);
                }
            }

            public static void UpdateAllSources(this Control w)
            {
                UpdateBindingSources(w);
            }
        }*/

        /*public static class DependencyObjectExtensions
        {
            public static IEnumerable EnumerateDependencyProperties(this DependencyObject element)
            {
                LocalValueEnumerator lve = element.GetLocalValueEnumerator();

                while (lve.MoveNext())
                {
                    LocalValueEntry entry = lve.Current;
                    if (BindingOperations.IsDataBound(element, entry.Property))
                    {
                        yield return entry.Property;
                    }
                }
            }

        }*/
    }
}
