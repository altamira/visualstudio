using System.ComponentModel.DataAnnotations.Schema;
using System.Data.Entity.ModelConfiguration;

namespace WBCCAD.Model.Models.Mapping
{
    public class TABREGRAMap : EntityTypeConfiguration<TABREGRA>
    {
        public TABREGRAMap()
        {
            // Primary Key
            this.HasKey(t => t.idTABREGRA);

            // Properties
            this.Property(t => t.TipoVenda)
                .HasMaxLength(50);

            this.Property(t => t.GrupoImpostos)
                .HasMaxLength(50);

            this.Property(t => t.Natureza)
                .HasMaxLength(20);

            // Table & Column Mappings
            this.ToTable("TABREGRA");
            this.Property(t => t.TipoVenda).HasColumnName("TipoVenda");
            this.Property(t => t.GrupoImpostos).HasColumnName("GrupoImpostos");
            this.Property(t => t.GrupoProduto).HasColumnName("GrupoProduto");
            this.Property(t => t.IcmsFator).HasColumnName("IcmsFator");
            this.Property(t => t.IcmsRedutor).HasColumnName("IcmsRedutor");
            this.Property(t => t.IpiFator).HasColumnName("IpiFator");
            this.Property(t => t.Natureza).HasColumnName("Natureza");
            this.Property(t => t.PISCOFINSFATOR).HasColumnName("PISCOFINSFATOR");
            this.Property(t => t.VERIFICAR).HasColumnName("VERIFICAR");
            this.Property(t => t.PISFATOR).HasColumnName("PISFATOR");
            this.Property(t => t.COFINSFATOR).HasColumnName("COFINSFATOR");
            this.Property(t => t.TABREGRA_NODESCRITIVO).HasColumnName("TABREGRA_NODESCRITIVO");
            this.Property(t => t.ROYALTIES_CALCULO).HasColumnName("ROYALTIES_CALCULO");
            this.Property(t => t.CUSTO_CALCULO).HasColumnName("CUSTO_CALCULO");
            this.Property(t => t.REPASSE_CALCULO).HasColumnName("REPASSE_CALCULO");
            this.Property(t => t.FRETE_CALCULO).HasColumnName("FRETE_CALCULO");
            this.Property(t => t.INDICE_COMPRA).HasColumnName("INDICE_COMPRA");
            this.Property(t => t.INDICE_FATURAMENTO).HasColumnName("INDICE_FATURAMENTO");
            this.Property(t => t.IPI_NAO_INCLUSO).HasColumnName("IPI_NAO_INCLUSO");
            this.Property(t => t.idTABREGRA).HasColumnName("idTABREGRA");
        }
    }
}
