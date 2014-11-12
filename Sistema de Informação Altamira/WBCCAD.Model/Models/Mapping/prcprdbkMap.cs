using System.ComponentModel.DataAnnotations.Schema;
using System.Data.Entity.ModelConfiguration;

namespace WBCCAD.Model.Models.Mapping
{
    public class prcprdbkMap : EntityTypeConfiguration<prcprdbk>
    {
        public prcprdbkMap()
        {
            // Primary Key
            this.HasKey(t => new { t.Prcprdcab_descricao, t.Produto, t.Sigla_Cor });

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

            // Table & Column Mappings
            this.ToTable("prcprdbk");
            this.Property(t => t.Prcprdcab_descricao).HasColumnName("Prcprdcab_descricao");
            this.Property(t => t.Produto).HasColumnName("Produto");
            this.Property(t => t.Sigla_Cor).HasColumnName("Sigla_Cor");
            this.Property(t => t.Preco).HasColumnName("Preco");
            this.Property(t => t.Ipi).HasColumnName("Ipi");
            this.Property(t => t.Icms).HasColumnName("Icms");
            this.Property(t => t.PRCPRD_ADICIONAL).HasColumnName("PRCPRD_ADICIONAL");
            this.Property(t => t.LP_PRCPRD_COMPRIMENTO).HasColumnName("LP_PRCPRD_COMPRIMENTO");
            this.Property(t => t.LP_PRCPRD_ALTURA).HasColumnName("LP_PRCPRD_ALTURA");
            this.Property(t => t.LP_PRCPRD_PROFUNDIDADE).HasColumnName("LP_PRCPRD_PROFUNDIDADE");
            this.Property(t => t.PRECOFAB).HasColumnName("PRECOFAB");
            this.Property(t => t.PRECOFABADC).HasColumnName("PRECOFABADC");
            this.Property(t => t.PRECOFABADCCMP).HasColumnName("PRECOFABADCCMP");
            this.Property(t => t.PRECOFABADCALT).HasColumnName("PRECOFABADCALT");
            this.Property(t => t.PRECOFABADCPRF).HasColumnName("PRECOFABADCPRF");
        }
    }
}
