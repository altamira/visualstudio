using System.ComponentModel.DataAnnotations.Schema;
using System.Data.Entity.ModelConfiguration;

namespace WBCCAD.Model.Models.Mapping
{
    public class tipo_Alt_conceitoMap : EntityTypeConfiguration<tipo_Alt_conceito>
    {
        public tipo_Alt_conceitoMap()
        {
            // Primary Key
            this.HasKey(t => t.idTipoAltConceito);

            // Properties
            this.Property(t => t.alt_conceito)
                .HasMaxLength(100);

            // Table & Column Mappings
            this.ToTable("tipo_Alt_conceito");
            this.Property(t => t.idTipoAltConceito).HasColumnName("idTipoAltConceito");
            this.Property(t => t.alt_conceito).HasColumnName("alt_conceito");
        }
    }
}
