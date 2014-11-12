using System.ComponentModel.DataAnnotations.Schema;
using System.Data.Entity.ModelConfiguration;

namespace WBCCAD.Model.Models.Mapping
{
    public class idmprdMap : EntityTypeConfiguration<idmprd>
    {
        public idmprdMap()
        {
            // Primary Key
            this.HasKey(t => t.IdIdmprd);

            // Properties
            this.Property(t => t.idioma)
                .HasMaxLength(12);

            this.Property(t => t.produto)
                .HasMaxLength(20);

            this.Property(t => t.descricao)
                .HasMaxLength(50);

            this.Property(t => t.unidade)
                .HasMaxLength(2);

            // Table & Column Mappings
            this.ToTable("idmprd");
            this.Property(t => t.idioma).HasColumnName("idioma");
            this.Property(t => t.produto).HasColumnName("produto");
            this.Property(t => t.descricao).HasColumnName("descricao");
            this.Property(t => t.unidade).HasColumnName("unidade");
            this.Property(t => t.IdIdmprd).HasColumnName("IdIdmprd");
        }
    }
}
