using System.ComponentModel;
using GestaoApp.Helpers;
using System;
using System.Windows;
using System.Collections.Generic;
using System.Collections;
using System.Linq;
using System.ComponentModel.DataAnnotations;

namespace GestaoApp.ViewModel
{
    public class ViewModelBase : INotifyPropertyChanged, INotifyDataErrorInfo
    {
        #region Properties

        static private Session session = new Session();
        public static Session Session 
        { 
            get 
            { 
                return session; 
            } 
            set 
            {
                if ((object.ReferenceEquals(session, value) != true))
                {
                    session = value;
                    session.OnPropertyChanged("Session");
                }
            } 
        }

        public bool IsDesignTime
        {
            get
            {
                return (Application.Current == null) || (Application.Current.GetType() == typeof(Application));
            }
        }
        #endregion

        #region PropertyChanged Event
        // Declare the PropertyChanged event
        public event PropertyChangedEventHandler PropertyChanged;

        // OnPropertyChanged will raise the PropertyChanged event passing the
        // source property that is being updated.
        public void OnPropertyChanged(string propertyName)
        {
            if (this.PropertyChanged != null)
            {
                PropertyChanged(this, new PropertyChangedEventArgs(propertyName));
            }
            //Validate(propertyName);

        }
        #endregion

        #region INotifyDataErrorInfo
        protected readonly List<ValidationResult> Errors;

        public event EventHandler<DataErrorsChangedEventArgs> ErrorsChanged;

        [DisplayAttribute(AutoGenerateField = false)]
        public bool HasErrors
        {
            get
            {
                return Errors.Any();
            }
        }

        public IEnumerable GetErrors(string propertyName)
        {
            return Errors.Where(c => c.MemberNames.Contains(propertyName));
        }

        protected void OnErrorsChanged(string propertyName)
        {
            if (ErrorsChanged != null)
            {
                ErrorsChanged(this, new DataErrorsChangedEventArgs(propertyName));
            }
        }
        #endregion

        #region Validation
        protected void Validate(string propertyName) 
        { 
            var value = GetPropertyValue(propertyName); 
            RemoveErrorsForProperty(propertyName);
            Validator.TryValidateProperty(value, new ValidationContext(this, null, null) { MemberName = propertyName }, Errors); 
            OnErrorsChanged(propertyName); 
        } 
        protected void Validate() 
        {
            Errors.Clear();
            Validator.TryValidateObject(this, new ValidationContext(this, null, null), Errors, true);
            foreach (var result in Errors)        
                OnErrorsChanged(result.MemberNames.First()); 
        } 
        private object GetPropertyValue(string propertyName) 
        { 
            var type = this.GetType(); 
            var propertyInfo = type.GetProperty(propertyName); 
            if (propertyInfo == null) 
            { 
                throw new ArgumentException(string.Format("Couldn't find any property called {0} on type {1}", propertyName, type)); 
            } 
            return propertyInfo.GetValue(this, null); 
        }
        // Assyncronous validation
        protected void AddErrorForProperty(string propertyName, string errorMessage) 
        {
            if (Errors.Where(result => result.ErrorMessage.Contains(errorMessage) && result.MemberNames.Contains(propertyName)).Any())        
                return;
            Errors.Add(new ValidationResult(errorMessage, new List<string> { propertyName })); 
            OnErrorsChanged(propertyName); 
        }
        private void RemoveErrorsForProperty(string propertyName) 
        {
            var validationResults = Errors.Where(result => result.MemberNames.Contains(propertyName)).ToList(); 
            foreach (var result in validationResults)
                Errors.Remove(result); 
        }
        #endregion

        #region Constructor
        public ViewModelBase()
        {
            Errors = new List<ValidationResult>();
        }
        #endregion
    }
}
