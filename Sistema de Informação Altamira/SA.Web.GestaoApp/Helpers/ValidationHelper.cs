using System;
using System.Net;
using System.Windows;
using System.Windows.Controls;
using System.Windows.Documents;
using System.Windows.Ink;
using System.Windows.Input;
using System.Windows.Media;
using System.Windows.Media.Animation;
using System.Windows.Shapes;
using System.ComponentModel;
using System.ComponentModel.DataAnnotations;
using System.Collections.Generic;
using System.Text;
using System.Linq;
using Telerik.Windows.Controls;

namespace GestaoApp.Helpers
{
    public static class ValidatorHelper
    {    
        public static bool IsValid(DependencyObject parent)
        {    
            if (Validation.GetHasError(parent))        
                return false;    

            // Validate all the bindings on the children    
            for (int i = 0; i != VisualTreeHelper.GetChildrenCount(parent); ++i)    
            {        
                DependencyObject child = VisualTreeHelper.GetChild(parent, i);

                switch (child.GetType().ToString())
                {
                    case "System.Windows.Controls.TabControl":
                        TabControl tabControl = child as TabControl;
                        if (tabControl.Items.Count > 0)
                        {
                            var selectedIndex = tabControl.SelectedIndex;
                            foreach (TabItem item in tabControl.Items)
                            {
                                tabControl.SelectedItem = item;
                                tabControl.UpdateLayout();

                                //validationErrors.AddRange(GetValidationErrorsFromChildren(element));
                                if (!IsValid(child))
                                    return false;
                            }
                            tabControl.SelectedIndex = selectedIndex;
                        }
                        break;

                    case "Telerik.Windows.Controls.RadTabControl":
                        RadTabControl radTabControl = child as RadTabControl;
                        if (radTabControl.Items.Count > 0)
                        {
                            var selectedIndex = radTabControl.SelectedIndex;
                            foreach (RadTabItem item in radTabControl.Items)
                            {
                                radTabControl.SelectedItem = item;
                                radTabControl.UpdateLayout();

                                //validationErrors.AddRange(GetValidationErrorsFromChildren(element));
                                if (!IsValid(child))
                                    return false;
                            }
                            radTabControl.SelectedIndex = selectedIndex;
                        }
                        break;

                    default:
                        /*validationErrors.AddRange(GetValidationErrorsFromChildren(element));

                        if (element is FrameworkElement)
                        {
                            validationErrors.AddRange(Validation.GetErrors(element));
                        }*/
                        if (!IsValid(child))
                            return false; 

                        break;
                }
            }    
            return true;
        }

        //public static bool IsValid(DependencyObject parent)    
        //{        
        //    // Validate all the bindings on the parent        
        //    bool valid = true;        
        //    LocalValueEnumerator localValues = parent.GetLocalValueEnumerator();       
        //    while (localValues.MoveNext())        
        //    {            
        //        LocalValueEntry entry = localValues.Current;            
        //        if (BindingOperations.IsDataBound(parent, entry.Property))            
        //        {                
        //            Binding binding = BindingOperations.GetBinding(parent, entry.Property);                
        //            foreach (ValidationRule rule in binding.ValidationRules)                
        //            {                    
        //                ValidationResult result = rule.Validate(parent.GetValue(entry.Property), null);                    
        //                if (!result.IsValid)                    
        //                {                        
        //                    BindingExpression expression = BindingOperations.GetBindingExpression(parent, entry.Property);                        
        //                    System.Windows.Controls.Validation.MarkInvalid(expression, new ValidationError(rule, expression, result.ErrorContent, null));                        
        //                    valid = false;                    
        //                }                
        //            }            
        //        }        
        //    }        
        //    // Validate all the bindings on the children        
        //    for (int i = 0; i != VisualTreeHelper.GetChildrenCount(parent); ++i)        
        //    {            
        //        DependencyObject child = VisualTreeHelper.GetChild(parent, i);            
        //        if (!IsValid(child)) 
        //        { 
        //            valid = false; 
        //        }        
        //    }        
        //    return valid;    
        //}
    }

    public class ValidationHelper
    {
        private readonly INotifyPropertyChanged _instance;
        private bool _isDirty = true;
        private readonly ValidationResultCollection _results = new ValidationResultCollection();

        public ValidationHelper(INotifyPropertyChanged instance)
        {
            if (instance == null)
                throw new ArgumentNullException("instance");
            _instance = instance;
            _instance.PropertyChanged += delegate
            {
                _isDirty = true;
            };
        }

        public ValidationResultCollection Results
        {
            get
            {
                if (_isDirty)
                {
                    Validate();
                    _isDirty = false;
                }
                return _results;
            }
        }

        public ValidationResultCollection ResultsForMemberName(string memberName)
        {
            var results = Results.Where(r => r.MemberNames.Contains(memberName));
            return new ValidationResultCollection(results);
        }

        private void Validate()
        {
            _results.Clear();
            Validator.TryValidateObject(_instance, new ValidationContext(_instance, null, null), _results, true);
        }
    }

    public class ValidationResultCollection : List<ValidationResult>
    {
        public ValidationResultCollection()
            : base()
        { }

        public ValidationResultCollection(IEnumerable<ValidationResult> results)
            : base(results)
        { }

        public override string ToString()
        {
            if (this.Count == 0)
            {
                return null;
            }
            StringBuilder sb = new StringBuilder();
            for (int i = 0; i < this.Count; i++)
            {
                sb.Append(this[i]);
                if (i < this.Count - 1)
                {
                    sb.AppendLine();
                }
            }
            return sb.ToString();
        }
    }
}
