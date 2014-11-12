using System.ComponentModel.DataAnnotations.Schema;
using System.Data.Entity.ModelConfiguration;

namespace WBCCAD.Model.Models.Mapping
{
    public class tipo_tipoMap : EntityTypeConfiguration<tipo_tipo>
    {
        public tipo_tipoMap()
        {
            // Primary Key
            this.HasKey(t => t.idTipoTipo);

            // Properties
            this.Property(t => t.Tipo)
                .HasMaxLength(255);

            // Table & Column Mappings
            this.ToTable("tipo_tipo");
            this.Property(t => t.idTipoTipo).HasColumnName("idTipoTipo");
            this.Property(t => t.Tipo).HasColumnName("Tipo");
        }
    }
}
