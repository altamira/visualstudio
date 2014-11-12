using System.ComponentModel.DataAnnotations.Schema;
using System.Data.Entity.ModelConfiguration;

namespace WBCCAD.Model.Models.Mapping
{
    public class prcprdfatbkMap : EntityTypeConfiguration<prcprdfatbk>
    {
        public prcprdfatbkMap()
        {
            // Primary Key
            this.HasKey(t => new { t.Prcprdcab_descricao, t.Produto, t.Sigla_Cor, t.variavel });

            // Properties
            this.Property(t => t.Prcprdcab_descricao)
                .IsRequired()
                .HasMaxLength(20);

            this.Property(t => t.Produto)
                .IsRequired()
                .HasMaxLength(20);

            this.Property(t => t.Sigla_Cor)
                .IsRequired()
                .HasMaxLength(10);

            this.Property(t => t.variavel)
                .IsRequired()
                .HasMaxLength(50);

            // Table & Column Mappings
            this.ToTable("prcprdfatbk");
            this.Property(t => t.Prcprdcab_descricao).HasColumnName("Prcprdcab_descricao");
            this.Property(t => t.Produto).HasColumnName("Produto");
            this.Property(t => t.Sigla_Cor).HasColumnName("Sigla_Cor");
            this.Property(t => t.variavel).HasColumnName("variavel");
            this.Property(t => t.Preco).HasColumnName("Preco");
            this.Property(t => t.PRCPRD_ADICIONAL).HasColumnName("PRCPRD_ADICIONAL");
            this.Property(t => t.LP_PRCPRD_COMPRIMENTO).HasColumnName("LP_PRCPRD_COMPRIMENTO");
            this.Property(t => t.LP_PRCPRD_ALTURA).HasColumnName("LP_PRCPRD_ALTURA");
            this.Property(t => t.LP_PRCPRD_PROFUNDIDADE).HasColumnName("LP_PRCPRD_PROFUNDIDADE");
        }
    }
}
