using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Linq;
using System.Windows;
using SA.PivotGrid.Models;

namespace SA.PivotGrid.ViewModels
{
    public class MainViewModel : INotifyPropertyChanged 
    {
        public class UserModelWithPermissions : UserModel
        {            
            public IEnumerable<UserRole> UserRoles
            {
                get
                {
                    return from ur in UserRole.UserRoles
                            orderby ur.Role.Name
                            where ur.User.Id == Id
                            select ur;
                }
            }
        }

        public MainViewModel()
        {
            //SizeSynchronizationBehavior.RegisterForCallback("MainGrid", _MainGridResized);
        }

        //private void _MainGridResized(Size size)
        //{
        //    var dispatcher = Deployment.Current.Dispatcher;
        //    if (dispatcher.CheckAccess())
        //    {
        //        Width = size.Width;
        //    }
        //    else
        //    {
        //        dispatcher.BeginInvoke(() => Width = size.Width);
        //    }
        //}

        private double _width;
        public double Width
        {
            get { return _width; }
            set
            {
                if (value <= 0) return;

                _width = value;
                NotifyPropertyChanged("Width");
                NotifyPropertyChanged("ColumnWidth");
            }
        }

        public double ColumnWidth
        {
            get
            {
                var calc = Width/(Roles.Count() + 1);
                return calc > 0 ? calc : 100.0;
            }
        }

        public IEnumerable<RoleModel> Roles
        {
            get
            {
                return (from ur in RoleModel.RoleModels
                        orderby ur.Name
                        select ur).Distinct();
            }
        }

        public IEnumerable<UserModelWithPermissions> Users
        {
            get
            {
                return UserModel.UserModels.Select(user => new UserModelWithPermissions
                                                                {
                                                                    Id = user.Id,
                                                                    Name = user.Name
                                                                });
            }
        }

        public event PropertyChangedEventHandler PropertyChanged;

        protected void NotifyPropertyChanged(string propertyName)
        {
            var handler = PropertyChanged;
            if (handler != null)
            {
                handler(this, new PropertyChangedEventArgs(propertyName));
            }
        }
    }
}