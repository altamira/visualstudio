using System.Collections.Generic;

namespace SA.PivotGrid.Models
{
    /// <summary>
    ///     Sample model for a role, also returns a list
    /// </summary>
    public class RoleModel
    {
        private static readonly List<RoleModel> _roleModels
            = new List<RoleModel>
                    {
                        new RoleModel {Id = 1, Name = "User"},
                        new RoleModel {Id = 2, Name = "Administrator"},
                        new RoleModel {Id = 3, Name = "Contributor"},
                        new RoleModel {Id = 4, Name = "Operator"},
                        new RoleModel {Id = 5, Name = "Reporter"}
                    };
                                                

        public int Id { get; set; }
        public string Name { get; set; }

        public static IEnumerable<RoleModel> RoleModels
        {
            get
            {
                return _roleModels;
            }
        }

        public override bool Equals(object obj)
        {
            return obj is RoleModel && (((RoleModel) obj).Id.Equals(Id));
        }

        public override int GetHashCode()
        {
            return Id.GetHashCode();
        }
    }
}