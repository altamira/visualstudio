using System.ComponentModel.DataAnnotations.Schema;
using System.Data.Entity.ModelConfiguration;

namespace WBCCAD.Model.Models.Mapping
{
    public class idmorcMap : EntityTypeConfiguration<idmorc>
    {
        public idmorcMap()
        {
            // Primary Key
            this.HasKey(t => t.idIdmOrc);

            // Properties
            this.Property(t => t.idioma)
                .HasMaxLength(12);

            this.Property(t => t.layout)
                .HasMaxLength(2);

            this.Property(t => t.variavel)
                .HasMaxLength(100);

            this.Property(t => t.traducao)
                .HasMaxLength(100);

            // Table & Column Mappings
            this.ToTable("idmorc");
            this.Property(t => t.idioma).HasColumnName("idioma");
            this.Property(t => t.layout).HasColumnName("layout");
            this.Property(t => t.variavel).HasColumnName("variavel");
            this.Property(t => t.traducao).HasColumnName("traducao");
            this.Property(t => t.idIdmOrc).HasColumnName("idIdmOrc");
        }
    }
}
