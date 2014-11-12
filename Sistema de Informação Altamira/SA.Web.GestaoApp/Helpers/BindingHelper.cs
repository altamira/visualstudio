﻿/// <summary>
/// Supports a PropertyChanged-Trigger for DataBindings
/// in Silverlight. Works just for TextBoxes
/// (C) Thomas Claudius Huber 2009
/// http://www.thomasclaudiushuber.com
/// </summary>
using System.Windows;
using System.Windows.Controls;

namespace GestaoApp.Helpers
{

    public class BindingHelper
    {
        public static bool GetUpdateSourceOnChange
          (DependencyObject obj)
        {
            return (bool)obj.GetValue(UpdateSourceOnChangeProperty);
        }

        public static void SetUpdateSourceOnChange
          (DependencyObject obj, bool value)
        {
            obj.SetValue(UpdateSourceOnChangeProperty, value);
        }

        // Using a DependencyProperty as the backing store for …
        public static readonly DependencyProperty
          UpdateSourceOnChangeProperty =
            DependencyProperty.RegisterAttached(
            "UpdateSourceOnChange",
            typeof(bool),
            typeof(BindingHelper),
            new PropertyMetadata(false, OnPropertyChanged));

        private static void OnPropertyChanged
          (DependencyObject obj,
          DependencyPropertyChangedEventArgs e)
        {
            var txt = obj as ListBox;
            if (txt == null)
                return;
            if ((bool)e.NewValue)
            {
                txt.SelectionChanged += OnSelectionChanged;
            }
            else
            {
                txt.SelectionChanged -= OnSelectionChanged;
            }
        }
        static void OnSelectionChanged(object sender,
          SelectionChangedEventArgs e)
        {
            var txt = sender as ListBox;
            if (txt == null)
                return;
            var be = txt.GetBindingExpression(ListBox.SelectedItemProperty);
            if (be != null)
            {
                be.UpdateSource();
            }
        }
    }
}