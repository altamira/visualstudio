using System.ComponentModel.DataAnnotations.Schema;
using System.Data.Entity.ModelConfiguration;

namespace WBCCAD.Model.Models.Mapping
{
    public class gen_acabMap : EntityTypeConfiguration<gen_acab>
    {
        public gen_acabMap()
        {
            // Primary Key
            this.HasKey(t => t.indice);

            // Properties
            this.Property(t => t.nome)
                .HasMaxLength(50);

            this.Property(t => t.sigla)
                .HasMaxLength(10);

            this.Property(t => t.GenGrpPrecoCodigo)
                .HasMaxLength(50);

            this.Property(t => t.cor_cad)
                .HasMaxLength(5);

            this.Property(t => t.integracao)
                .HasMaxLength(255);

            // Table & Column Mappings
            this.ToTable("gen_acab");
            this.Property(t => t.indice).HasColumnName("indice");
            this.Property(t => t.nome).HasColumnName("nome");
            this.Property(t => t.sigla).HasColumnName("sigla");
            this.Property(t => t.GenGrpPrecoCodigo).HasColumnName("GenGrpPrecoCodigo");
            this.Property(t => t.TRAVAR_REPRESENTANTE).HasColumnName("TRAVAR_REPRESENTANTE");
            this.Property(t => t.cor_cad).HasColumnName("cor_cad");
            this.Property(t => t.exibirOrcamento).HasColumnName("exibirOrcamento");
            this.Property(t => t.integracao).HasColumnName("integracao");
        }
    }
}
