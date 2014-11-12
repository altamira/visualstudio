using System.ComponentModel.DataAnnotations.Schema;
using System.Data.Entity.ModelConfiguration;

namespace WBCCAD.Model.Models.Mapping
{
    public class OrcMatDetMap : EntityTypeConfiguration<OrcMatDet>
    {
        public OrcMatDetMap()
        {
            // Primary Key
            this.HasKey(t => t.idOrcMatDet);

            // Properties
            this.Property(t => t.idSubGrupo)
                .HasMaxLength(70);

            this.Property(t => t.codigoProduto)
                .HasMaxLength(70);

            this.Property(t => t.codigoProdutoPai)
                .HasMaxLength(70);

            this.Property(t => t.descricao)
                .HasMaxLength(255);

            this.Property(t => t.cor)
                .HasMaxLength(100);

            this.Property(t => t.corPreco)
                .HasMaxLength(100);

            this.Property(t => t.unidade)
                .HasMaxLength(20);

            this.Property(t => t.situacaoProduto)
                .HasMaxLength(100);

            this.Property(t => t.baseProduto)
                .HasMaxLength(255);

            this.Property(t => t.numeroOrcamento)
                .IsFixedLength()
                .HasMaxLength(9);

            // Table & Column Mappings
            this.ToTable("OrcMatDet");
            this.Property(t => t.idOrcMatDet).HasColumnName("idOrcMatDet");
            this.Property(t => t.idGrupo).HasColumnName("idGrupo");
            this.Property(t => t.idSubGrupo).HasColumnName("idSubGrupo");
            this.Property(t => t.codigoProduto).HasColumnName("codigoProduto");
            this.Property(t => t.codigoProdutoPai).HasColumnName("codigoProdutoPai");
            this.Property(t => t.descricao).HasColumnName("descricao");
            this.Property(t => t.cor).HasColumnName("cor");
            this.Property(t => t.corPreco).HasColumnName("corPreco");
            this.Property(t => t.quantidade).HasColumnName("quantidade");
            this.Property(t => t.precoLista).HasColumnName("precoLista");
            this.Property(t => t.preco1).HasColumnName("preco1");
            this.Property(t => t.preco2).HasColumnName("preco2");
            this.Property(t => t.preco3).HasColumnName("preco3");
            this.Property(t => t.preco4).HasColumnName("preco4");
            this.Property(t => t.preco5).HasColumnName("preco5");
            this.Property(t => t.precoSemDesconto).HasColumnName("precoSemDesconto");
            this.Property(t => t.unidade).HasColumnName("unidade");
            this.Property(t => t.altura).HasColumnName("altura");
            this.Property(t => t.comprimento).HasColumnName("comprimento");
            this.Property(t => t.largura).HasColumnName("largura");
            this.Property(t => t.peso).HasColumnName("peso");
            this.Property(t => t.qtdeM2).HasColumnName("qtdeM2");
            this.Property(t => t.situacaoProduto).HasColumnName("situacaoProduto");
            this.Property(t => t.baseProduto).HasColumnName("baseProduto");
            this.Property(t => t.formulaPreco).HasColumnName("formulaPreco");
            this.Property(t => t.divisorPreco).HasColumnName("divisorPreco");
            this.Property(t => t.numeroOrcamento).HasColumnName("numeroOrcamento");
        }
    }
}
