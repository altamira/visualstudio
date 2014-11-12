using System.ComponentModel.DataAnnotations.Schema;
using System.Data.Entity.ModelConfiguration;

namespace WBCCAD.Model.Models.Mapping
{
    public class gond_tipoMap : EntityTypeConfiguration<gond_tipo>
    {
        public gond_tipoMap()
        {
            // Primary Key
            this.HasKey(t => t.idGondTipo);

            // Properties
            this.Property(t => t.tipo)
                .HasMaxLength(50);

            // Table & Column Mappings
            this.ToTable("gond_tipo");
            this.Property(t => t.tipo).HasColumnName("tipo");
            this.Property(t => t.idGondTipo).HasColumnName("idGondTipo");
        }
    }
}
