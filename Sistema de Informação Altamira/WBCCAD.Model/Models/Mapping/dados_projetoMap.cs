using System.ComponentModel.DataAnnotations.Schema;
using System.Data.Entity.ModelConfiguration;

namespace WBCCAD.Model.Models.Mapping
{
    public class dados_projetoMap : EntityTypeConfiguration<dados_projeto>
    {
        public dados_projetoMap()
        {
            // Primary Key
            this.HasKey(t => new { t.numeroOrcamento, t.DADOS_PROJETO_CHAVE });

            // Properties
            this.Property(t => t.numeroOrcamento)
                .IsRequired()
                .HasMaxLength(9);

            this.Property(t => t.DADOS_PROJETO_CHAVE)
                .IsRequired()
                .HasMaxLength(30);

            this.Property(t => t.DADOS_PROJETO_VALOR)
                .HasMaxLength(255);

            // Table & Column Mappings
            this.ToTable("dados_projeto");
            this.Property(t => t.numeroOrcamento).HasColumnName("numeroOrcamento");
            this.Property(t => t.DADOS_PROJETO_CHAVE).HasColumnName("DADOS_PROJETO_CHAVE");
            this.Property(t => t.DADOS_PROJETO_VALOR).HasColumnName("DADOS_PROJETO_VALOR");
        }
    }
}
