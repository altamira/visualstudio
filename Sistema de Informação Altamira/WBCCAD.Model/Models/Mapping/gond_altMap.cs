using System.ComponentModel.DataAnnotations.Schema;
using System.Data.Entity.ModelConfiguration;

namespace WBCCAD.Model.Models.Mapping
{
    public class gond_altMap : EntityTypeConfiguration<gond_alt>
    {
        public gond_altMap()
        {
            // Primary Key
            this.HasKey(t => new { t.indice, t.vale_para_edicao });

            // Properties
            this.Property(t => t.indice)
                .HasDatabaseGeneratedOption(DatabaseGeneratedOption.Identity);

            this.Property(t => t.altura_real)
                .HasMaxLength(50);

            // Table & Column Mappings
            this.ToTable("gond_alt");
            this.Property(t => t.indice).HasColumnName("indice");
            this.Property(t => t.Altura).HasColumnName("Altura");
            this.Property(t => t.altura_real).HasColumnName("altura_real");
            this.Property(t => t.vale_para_edicao).HasColumnName("vale_para_edicao");
        }
    }
}
