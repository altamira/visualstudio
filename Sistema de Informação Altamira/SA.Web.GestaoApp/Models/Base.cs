using System;
using System.Collections;
using System.Collections.Generic;
using System.ComponentModel;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Linq.Expressions;
using System.Xml.Linq;

namespace GestaoApp.Models
{
    public class Base : INotifyPropertyChanged, INotifyDataErrorInfo
    {
        #region Attributes

        protected int id = 0;
        protected Guid guid = Guid.NewGuid();

        protected bool selected = false;
        protected bool haschanges = false;

        #endregion

        #region Properties

        [DisplayAttribute(AutoGenerateField = false)]
        public int Id
        {
            get
            {
                return id;
            }
            set
            {
                if ((object.ReferenceEquals(this.id, value) != true))
                {
                    id = value;
                    OnPropertyChanged("Id");
                }
            }
        }

        [DisplayAttribute(AutoGenerateField = false)]
        public Guid Guid
        {
            get
            {
                if (guid == null)
                    guid = Guid.NewGuid();
                return guid;
            }
            set
            {
                if ((object.ReferenceEquals(this.guid, value) != true))
                {
                    guid = value;
                    OnPropertyChanged("Guid");
                }
            }
        }

        [DisplayAttribute(AutoGenerateField = false)]
        public bool Selected
        {
            get
            {
                return selected;
            }
            set
            {
                if ((object.ReferenceEquals(this.selected, value) != true))
                {
                    selected = value;
                    OnPropertyChanged("Selected");
                }
            }
        }

        [DisplayAttribute(AutoGenerateField = false)]
        public bool HasChanges
        {
            get
            {
                return haschanges;
            }
            set
            {
                if ((object.ReferenceEquals(this.haschanges, value) != true))
                {
                    haschanges = value;
                    OnPropertyChanged("HasChanges");
                }
            }
        }


        #endregion

        #region Constructor

        public Base()
        {
            Errors = new List<ValidationResult>();
        }

        #endregion

        #region INotifyPropertyChanged Interface

        public event PropertyChangedEventHandler PropertyChanged;

        public void OnPropertyChanged(string propertyName)
        {
            if (this.PropertyChanged != null)
            {
                PropertyChanged(this, new PropertyChangedEventArgs(propertyName));
            }
        }
        #endregion

        #region INotifyDataErrorInfo Interface

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

        protected void Validate(string propertyName)
        {
            var value = GetPropertyValue(propertyName);
            RemoveErrorsForProperty(propertyName);
            Validator.TryValidateProperty(value, new ValidationContext(this, null, null) { MemberName = propertyName }, Errors);
            OnErrorsChanged(propertyName);
        }

        protected void NotifyPropertyChanged(Expression<Func<object>> propertyExpression)
        {
            if (propertyExpression == null)
                throw new ArgumentNullException("propertyExpression");

            var propertyName = GetPropertyName(propertyExpression);
            if (PropertyChanged != null)
                PropertyChanged(this, new PropertyChangedEventArgs(propertyName));
            Validate(propertyName);
            OnNotifyPropertyChanged();
        }

        protected virtual void OnNotifyPropertyChanged() { }

        private string GetPropertyName(Expression<Func<object>> propertyExpression)
        {
            var unaryExpression = propertyExpression.Body as UnaryExpression;
            var memberExpression = unaryExpression == null ? (MemberExpression)propertyExpression.Body : (MemberExpression)unaryExpression.Operand;

            var propertyName = memberExpression.Member.Name;

            return propertyName;
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

        protected void RemoveErrorsForProperty(string propertyName)
        {
            var validationResults = Errors.Where(result => result.MemberNames.Contains(propertyName)).ToList();
            foreach (var result in validationResults)
                Errors.Remove(result);
        }

        #endregion

        #region XML

        [DisplayAttribute(AutoGenerateField = false)]
        public virtual XElement ToXML
        {
            get
            {
                throw new NotImplementedException();
            }
            set
            {
                throw new NotImplementedException();
            }
        }

        #endregion
    }
}
