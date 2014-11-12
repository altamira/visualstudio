using System.ComponentModel.DataAnnotations.Schema;
using System.Data.Entity.ModelConfiguration;

namespace WBCCAD.Model.Models.Mapping
{
    public class SecaoMap : EntityTypeConfiguration<Secao>
    {
        public SecaoMap()
        {
            // Primary Key
            this.HasKey(t => t.idSecao);

            // Properties
            this.Property(t => t.Secao1)
                .HasMaxLength(255);

            this.Property(t => t.Observacoes)
                .HasMaxLength(255);

            // Table & Column Mappings
            this.ToTable("Secao");
            this.Property(t => t.idSecao).HasColumnName("idSecao");
            this.Property(t => t.Secao1).HasColumnName("Secao");
            this.Property(t => t.Ordem).HasColumnName("Ordem");
            this.Property(t => t.Observacoes).HasColumnName("Observacoes");
            this.Property(t => t.Ativa).HasColumnName("Ativa");
        }
    }
}
