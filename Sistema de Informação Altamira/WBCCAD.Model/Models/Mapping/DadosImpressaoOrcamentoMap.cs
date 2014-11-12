using System.ComponentModel.DataAnnotations.Schema;
using System.Data.Entity.ModelConfiguration;

namespace WBCCAD.Model.Models.Mapping
{
    public class DadosImpressaoOrcamentoMap : EntityTypeConfiguration<DadosImpressaoOrcamento>
    {
        public DadosImpressaoOrcamentoMap()
        {
            // Primary Key
            this.HasKey(t => t.idDadosOrcamento);

            // Properties
            this.Property(t => t.Chave)
                .HasMaxLength(255);

            this.Property(t => t.Descricao)
                .HasMaxLength(255);

            this.Property(t => t.valorPadrao)
                .HasMaxLength(255);

            this.Property(t => t.Referente)
                .HasMaxLength(255);

            this.Property(t => t.DescricaoGrupo)
                .HasMaxLength(255);

            // Table & Column Mappings
            this.ToTable("DadosImpressaoOrcamento");
            this.Property(t => t.idDadosOrcamento).HasColumnName("idDadosOrcamento");
            this.Property(t => t.Chave).HasColumnName("Chave");
            this.Property(t => t.Descricao).HasColumnName("Descricao");
            this.Property(t => t.Valores).HasColumnName("Valores");
            this.Property(t => t.valorPadrao).HasColumnName("valorPadrao");
            this.Property(t => t.Referente).HasColumnName("Referente");
            this.Property(t => t.Ativo).HasColumnName("Ativo");
            this.Property(t => t.DescricaoGrupo).HasColumnName("DescricaoGrupo");
        }
    }
}
