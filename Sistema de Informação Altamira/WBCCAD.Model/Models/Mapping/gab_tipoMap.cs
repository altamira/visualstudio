using System.ComponentModel.DataAnnotations.Schema;
using System.Data.Entity.ModelConfiguration;

namespace WBCCAD.Model.Models.Mapping
{
    public class gab_tipoMap : EntityTypeConfiguration<gab_tipo>
    {
        public gab_tipoMap()
        {
            // Primary Key
            this.HasKey(t => t.indice);

            // Properties
            this.Property(t => t.codigo)
                .HasMaxLength(30);

            // Table & Column Mappings
            this.ToTable("gab_tipo");
            this.Property(t => t.indice).HasColumnName("indice");
            this.Property(t => t.codigo).HasColumnName("codigo");
            this.Property(t => t.travar_representante).HasColumnName("travar_representante");
        }
    }
}
