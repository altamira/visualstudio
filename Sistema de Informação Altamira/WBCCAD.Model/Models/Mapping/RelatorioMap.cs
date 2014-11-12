using System.ComponentModel.DataAnnotations.Schema;
using System.Data.Entity.ModelConfiguration;

namespace WBCCAD.Model.Models.Mapping
{
    public class RelatorioMap : EntityTypeConfiguration<Relatorio>
    {
        public RelatorioMap()
        {
            // Primary Key
            this.HasKey(t => t.idRelatorio);

            // Properties
            this.Property(t => t.Relatorio1)
                .HasMaxLength(255);

            this.Property(t => t.RelatorioPai)
                .HasMaxLength(255);

            // Table & Column Mappings
            this.ToTable("Relatorio");
            this.Property(t => t.idRelatorio).HasColumnName("idRelatorio");
            this.Property(t => t.Relatorio1).HasColumnName("Relatorio");
            this.Property(t => t.RelatorioPai).HasColumnName("RelatorioPai");
            this.Property(t => t.Expressao).HasColumnName("Expressao");
            this.Property(t => t.Observacoes).HasColumnName("Observacoes");
            this.Property(t => t.Ativo).HasColumnName("Ativo");
            this.Property(t => t.Padrao).HasColumnName("Padrao");
        }
    }
}
