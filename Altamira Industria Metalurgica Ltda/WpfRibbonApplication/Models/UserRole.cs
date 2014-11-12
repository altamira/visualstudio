using System;
using System.Collections.Generic;
using System.Linq;

namespace SA.PivotGrid.Models
{
    /// <summary>
    ///     Intersection of a role for a user
    /// </summary>
    public class UserRole
    {
        private static readonly Random _random = new Random((int)DateTime.Now.Ticks); 
      
        private static readonly List<UserRole> _userRoles = new List<UserRole>();


        public UserModel User { get; set; }
        public RoleModel Role { get; set; }
        public bool HasPermission { get; set; }

        public long Id
        {
            get
            {
                return (long) User.Id*int.MaxValue + Role.Id;
            }
        }

        private static bool _firstTime = true;

        public static IEnumerable<UserRole> UserRoles
        {
            get
            {
                if (_firstTime)
                {
                    foreach (var user in UserModel.UserModels)
                    {
                        foreach (var role in RoleModel.RoleModels)
                        {
                            var userRole = new UserRole { User = user, Role = role };

                            if (_random.NextDouble() < 0.5)
                            {
                                user.Roles.Add(role);
                                userRole.HasPermission = true;
                            }
                            _userRoles.Add(userRole);
                        }
                    }
                    _firstTime = false;
                }

                return _userRoles;
            }
        }

        public override bool Equals(object obj)
        {
            return obj is UserRole && ((UserRole) obj).Id.Equals(Id);
        }

        public override int GetHashCode()
        {
            return Id.GetHashCode();
        }
    }
}