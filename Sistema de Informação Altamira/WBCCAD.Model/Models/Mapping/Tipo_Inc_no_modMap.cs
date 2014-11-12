using System.ComponentModel.DataAnnotations.Schema;
using System.Data.Entity.ModelConfiguration;

namespace WBCCAD.Model.Models.Mapping
{
    public class Tipo_Inc_no_modMap : EntityTypeConfiguration<Tipo_Inc_no_mod>
    {
        public Tipo_Inc_no_modMap()
        {
            // Primary Key
            this.HasKey(t => t.idTipoIncNoMod);

            // Properties
            this.Property(t => t.inc_no_mod)
                .HasMaxLength(100);

            // Table & Column Mappings
            this.ToTable("Tipo_Inc_no_mod");
            this.Property(t => t.idTipoIncNoMod).HasColumnName("idTipoIncNoMod");
            this.Property(t => t.inc_no_mod).HasColumnName("inc_no_mod");
        }
    }
}
