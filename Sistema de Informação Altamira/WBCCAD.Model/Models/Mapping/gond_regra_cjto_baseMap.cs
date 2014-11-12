using System.ComponentModel.DataAnnotations.Schema;
using System.Data.Entity.ModelConfiguration;

namespace WBCCAD.Model.Models.Mapping
{
    public class gond_regra_cjto_baseMap : EntityTypeConfiguration<gond_regra_cjto_base>
    {
        public gond_regra_cjto_baseMap()
        {
            // Primary Key
            this.HasKey(t => t.apenas_um_para_base);

            // Properties
            // Table & Column Mappings
            this.ToTable("gond_regra_cjto_base");
            this.Property(t => t.apenas_um_para_base).HasColumnName("apenas_um_para_base");
        }
    }
}
