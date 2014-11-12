using System.ComponentModel.DataAnnotations.Schema;
using System.Data.Entity.ModelConfiguration;

namespace WBCCAD.Model.Models.Mapping
{
    public class OrcGridMap : EntityTypeConfiguration<OrcGrid>
    {
        public OrcGridMap()
        {
            // Primary Key
            this.HasKey(t => t.orcgrid_counter);

            // Properties
            this.Property(t => t.numeroOrcamento)
                .HasMaxLength(9);

            this.Property(t => t.acessorio)
                .HasMaxLength(255);

            this.Property(t => t.codigo)
                .HasMaxLength(100);

            this.Property(t => t.conjunto)
                .HasMaxLength(50);

            this.Property(t => t.cor)
                .HasMaxLength(50);

            this.Property(t => t.corte)
                .HasMaxLength(50);

            this.Property(t => t.departamento)
                .HasMaxLength(50);

            this.Property(t => t.descritivo)
                .HasMaxLength(50);

            this.Property(t => t.grupo_descricao)
                .HasMaxLength(50);

            this.Property(t => t.id_cad)
                .HasMaxLength(50);

            this.Property(t => t.lista)
                .HasMaxLength(50);

            this.Property(t => t.n_grupo)
                .HasMaxLength(50);

            this.Property(t => t.n_subgrupo)
                .HasMaxLength(50);

            this.Property(t => t.onde_incluir)
                .HasMaxLength(50);

            this.Property(t => t.ORCGRID_CODIGO_ORI)
                .HasMaxLength(100);

            this.Property(t => t.orcgridbase)
                .HasMaxLength(50);

            this.Property(t => t.orcgridcorpesquisa)
                .HasMaxLength(20);

            this.Property(t => t.OrcGridProdutoImagem)
                .HasMaxLength(255);

            this.Property(t => t.OrcGridTipoProduto)
                .HasMaxLength(20);

            this.Property(t => t.posicao_modulo)
                .HasMaxLength(50);

            this.Property(t => t.setor)
                .HasMaxLength(50);

            this.Property(t => t.total)
                .HasMaxLength(50);

            this.Property(t => t.utilizacao)
                .HasMaxLength(50);

            this.Property(t => t.vizatras)
                .HasMaxLength(50);

            this.Property(t => t.vizfinal)
                .HasMaxLength(50);

            this.Property(t => t.vizinicial)
                .HasMaxLength(50);

            this.Property(t => t.controleCad)
                .HasMaxLength(255);

            // Table & Column Mappings
            this.ToTable("OrcGrid");
            this.Property(t => t.numeroOrcamento).HasColumnName("numeroOrcamento");
            this.Property(t => t.acessorio).HasColumnName("acessorio");
            this.Property(t => t.altura).HasColumnName("altura");
            this.Property(t => t.codigo).HasColumnName("codigo");
            this.Property(t => t.comprimento).HasColumnName("comprimento");
            this.Property(t => t.conjunto).HasColumnName("conjunto");
            this.Property(t => t.controle).HasColumnName("controle");
            this.Property(t => t.cor).HasColumnName("cor");
            this.Property(t => t.corte).HasColumnName("corte");
            this.Property(t => t.dep_alt).HasColumnName("dep_alt");
            this.Property(t => t.dep_compr).HasColumnName("dep_compr");
            this.Property(t => t.dep_prof).HasColumnName("dep_prof");
            this.Property(t => t.departamento).HasColumnName("departamento");
            this.Property(t => t.descritivo).HasColumnName("descritivo");
            this.Property(t => t.flag_imprimir).HasColumnName("flag_imprimir");
            this.Property(t => t.grupo_descricao).HasColumnName("grupo_descricao");
            this.Property(t => t.id_cad).HasColumnName("id_cad");
            this.Property(t => t.IDCJTO).HasColumnName("IDCJTO");
            this.Property(t => t.item).HasColumnName("item");
            this.Property(t => t.lista).HasColumnName("lista");
            this.Property(t => t.MATERIALEXTRA).HasColumnName("MATERIALEXTRA");
            this.Property(t => t.n_grupo).HasColumnName("n_grupo");
            this.Property(t => t.n_subgrupo).HasColumnName("n_subgrupo");
            this.Property(t => t.onde_incluir).HasColumnName("onde_incluir");
            this.Property(t => t.ORCGRID_CODIGO_ORI).HasColumnName("ORCGRID_CODIGO_ORI");
            this.Property(t => t.ORCGRID_PRC_ALTURA).HasColumnName("ORCGRID_PRC_ALTURA");
            this.Property(t => t.ORCGRID_PRC_COMPRIMENTO).HasColumnName("ORCGRID_PRC_COMPRIMENTO");
            this.Property(t => t.ORCGRID_PRC_FORMULA).HasColumnName("ORCGRID_PRC_FORMULA");
            this.Property(t => t.ORCGRID_PRC_LARGURA).HasColumnName("ORCGRID_PRC_LARGURA");
            this.Property(t => t.orcgridbase).HasColumnName("orcgridbase");
            this.Property(t => t.orcgridcorpesquisa).HasColumnName("orcgridcorpesquisa");
            this.Property(t => t.OrcGridPeso).HasColumnName("OrcGridPeso");
            this.Property(t => t.OrcGridPrecoLista).HasColumnName("OrcGridPrecoLista");
            this.Property(t => t.OrcGridProdutoImagem).HasColumnName("OrcGridProdutoImagem");
            this.Property(t => t.OrcGridTipoProduto).HasColumnName("OrcGridTipoProduto");
            this.Property(t => t.ori_alt).HasColumnName("ori_alt");
            this.Property(t => t.ori_compr).HasColumnName("ori_compr");
            this.Property(t => t.ori_prof).HasColumnName("ori_prof");
            this.Property(t => t.posicao_modulo).HasColumnName("posicao_modulo");
            this.Property(t => t.profundidade).HasColumnName("profundidade");
            this.Property(t => t.qtde).HasColumnName("qtde");
            this.Property(t => t.setor).HasColumnName("setor");
            this.Property(t => t.total).HasColumnName("total");
            this.Property(t => t.utilizacao).HasColumnName("utilizacao");
            this.Property(t => t.valor).HasColumnName("valor");
            this.Property(t => t.valor_unitario).HasColumnName("valor_unitario");
            this.Property(t => t.varusr).HasColumnName("varusr");
            this.Property(t => t.vizatras).HasColumnName("vizatras");
            this.Property(t => t.vizfinal).HasColumnName("vizfinal");
            this.Property(t => t.vizinicial).HasColumnName("vizinicial");
            this.Property(t => t.orcgrid_counter).HasColumnName("orcgrid_counter");
            this.Property(t => t.orcgrid_kcal).HasColumnName("orcgrid_kcal");
            this.Property(t => t.controleCad).HasColumnName("controleCad");
            this.Property(t => t.quantidadeOriginal).HasColumnName("quantidadeOriginal");
        }
    }
}
