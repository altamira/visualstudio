using System.ComponentModel.DataAnnotations.Schema;
using System.Data.Entity.ModelConfiguration;

namespace WBCCAD.Model.Models.Mapping
{
    public class mob_textosMap : EntityTypeConfiguration<mob_textos>
    {
        public mob_textosMap()
        {
            // Primary Key
            this.HasKey(t => t.idMobTextos);

            // Properties
            this.Property(t => t.tipo_texto)
                .HasMaxLength(2);

            // Table & Column Mappings
            this.ToTable("mob_textos");
            this.Property(t => t.tipo_texto).HasColumnName("tipo_texto");
            this.Property(t => t.idMobTextos).HasColumnName("idMobTextos");
        }
    }
}
