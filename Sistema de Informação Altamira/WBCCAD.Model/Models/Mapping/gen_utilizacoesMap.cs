using System.ComponentModel.DataAnnotations.Schema;
using System.Data.Entity.ModelConfiguration;

namespace WBCCAD.Model.Models.Mapping
{
    public class gen_utilizacoesMap : EntityTypeConfiguration<gen_utilizacoes>
    {
        public gen_utilizacoesMap()
        {
            // Primary Key
            this.HasKey(t => t.idGenUtilizacoes);

            // Properties
            this.Property(t => t.descricao)
                .HasMaxLength(50);

            // Table & Column Mappings
            this.ToTable("gen_utilizacoes");
            this.Property(t => t.descricao).HasColumnName("descricao");
            this.Property(t => t.idGenUtilizacoes).HasColumnName("idGenUtilizacoes");
        }
    }
}
