using System.Collections.Generic;

namespace SA.PivotGrid.Models
{
    /// <summary>
    ///     Sample model for a user, also returns a list
    /// </summary>
    public class UserModel
    {

        private static readonly List<UserModel> _userModels
            = new List<UserModel>
                    {
                        new UserModel {Id = 1, Name = "John Smith"},
                        new UserModel {Id = 2, Name = "Jane Doe"},
                        new UserModel {Id = 3, Name = "Ken Johnson"},
                        new UserModel {Id = 4, Name = "Sue Daily"},
                        new UserModel {Id = 5, Name = "Fred Simmons"}
                    };

        public static List<UserModel> UserModels
        {
            get { return _userModels;  }
        }    

        public UserModel()
        {
            Roles = new List<RoleModel>();                       
        }


        public int Id { get; set; }
        public string Name { get; set; }
        public List<RoleModel> Roles { get; private set; }
        

        public override bool Equals(object obj)
        {
            return obj is UserModel && (((UserModel) obj).Id.Equals(Id));
        }

        public override int GetHashCode()
        {
            return Id.GetHashCode();
        }
    }
}