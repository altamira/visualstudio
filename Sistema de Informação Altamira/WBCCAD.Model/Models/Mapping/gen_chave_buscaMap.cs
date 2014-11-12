using System.ComponentModel.DataAnnotations.Schema;
using System.Data.Entity.ModelConfiguration;

namespace WBCCAD.Model.Models.Mapping
{
    public class gen_chave_buscaMap : EntityTypeConfiguration<gen_chave_busca>
    {
        public gen_chave_buscaMap()
        {
            // Primary Key
            this.HasKey(t => t.indice);

            // Properties
            this.Property(t => t.nome)
                .HasMaxLength(50);

            this.Property(t => t.sigla)
                .HasMaxLength(50);

            // Table & Column Mappings
            this.ToTable("gen_chave_busca");
            this.Property(t => t.indice).HasColumnName("indice");
            this.Property(t => t.nome).HasColumnName("nome");
            this.Property(t => t.sigla).HasColumnName("sigla");
            this.Property(t => t.descritivoTecnico).HasColumnName("descritivoTecnico");
            this.Property(t => t.EsconderOrcamento).HasColumnName("EsconderOrcamento");
        }
    }
}
