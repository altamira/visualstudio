using System.ComponentModel.DataAnnotations.Schema;
using System.Data.Entity.ModelConfiguration;

namespace WBCCAD.Model.Models.Mapping
{
    public class OrcDetMap : EntityTypeConfiguration<OrcDet>
    {
        public OrcDetMap()
        {
            // Primary Key
            this.HasKey(t => t.ORCDET_COUNTER);

            // Properties
            this.Property(t => t.numeroOrcamento)
                .HasMaxLength(9);

            this.Property(t => t.orcdet_subgrupo)
                .HasMaxLength(2);

            this.Property(t => t.orcdet_corte)
                .HasMaxLength(50);

            this.Property(t => t.orcdet_nr_seq_crt)
                .HasMaxLength(50);

            this.Property(t => t.orcdet_codigo)
                .HasMaxLength(100);

            this.Property(t => t.orcdet_cor)
                .HasMaxLength(20);

            this.Property(t => t.DEPARTAMENTO)
                .HasMaxLength(50);

            this.Property(t => t.orcdet_acessorio)
                .HasMaxLength(255);

            this.Property(t => t.ORCDET_AGRUPAMENTO)
                .HasMaxLength(255);

            this.Property(t => t.orcdet_chb)
                .HasMaxLength(50);

            this.Property(t => t.ORCDET_CODIGO_ORI)
                .HasMaxLength(100);

            this.Property(t => t.ORCDET_CORESADC)
                .HasMaxLength(100);

            this.Property(t => t.orcdet_identificador)
                .HasMaxLength(2);

            this.Property(t => t.orcdet_obs)
                .HasMaxLength(40);

            this.Property(t => t.orcdet_onde_incluir)
                .HasMaxLength(50);

            this.Property(t => t.orcdetbase)
                .HasMaxLength(50);

            this.Property(t => t.orcdetcorpesquisa)
                .HasMaxLength(20);

            this.Property(t => t.OrcDetProdutoImagem)
                .HasMaxLength(255);

            this.Property(t => t.OrcDetTipoProduto)
                .HasMaxLength(20);

            this.Property(t => t.SETOR)
                .HasMaxLength(50);

            this.Property(t => t.UTILIZACAO)
                .HasMaxLength(50);

            this.Property(t => t.controleCad)
                .HasMaxLength(255);

            this.Property(t => t.vizatras)
                .HasMaxLength(50);

            this.Property(t => t.vizinicial)
                .HasMaxLength(50);

            this.Property(t => t.vizfinal)
                .HasMaxLength(50);

            this.Property(t => t.orcdet_item)
                .HasMaxLength(20);

            // Table & Column Mappings
            this.ToTable("OrcDet");
            this.Property(t => t.numeroOrcamento).HasColumnName("numeroOrcamento");
            this.Property(t => t.orcdet_grupo).HasColumnName("orcdet_grupo");
            this.Property(t => t.orcdet_subgrupo).HasColumnName("orcdet_subgrupo");
            this.Property(t => t.orcdet_corte).HasColumnName("orcdet_corte");
            this.Property(t => t.orcdet_nr_seq).HasColumnName("orcdet_nr_seq");
            this.Property(t => t.orcdet_nr_seq_crt).HasColumnName("orcdet_nr_seq_crt");
            this.Property(t => t.orcdet_codigo).HasColumnName("orcdet_codigo");
            this.Property(t => t.orcdet_cor).HasColumnName("orcdet_cor");
            this.Property(t => t.orcdet_qtde).HasColumnName("orcdet_qtde");
            this.Property(t => t.dep_alt).HasColumnName("dep_alt");
            this.Property(t => t.dep_compr).HasColumnName("dep_compr");
            this.Property(t => t.dep_prof).HasColumnName("dep_prof");
            this.Property(t => t.DEPARTAMENTO).HasColumnName("DEPARTAMENTO");
            this.Property(t => t.IDCJTO).HasColumnName("IDCJTO");
            this.Property(t => t.MATERIALEXTRA).HasColumnName("MATERIALEXTRA");
            this.Property(t => t.orcdet_acessorio).HasColumnName("orcdet_acessorio");
            this.Property(t => t.ORCDET_AGRUPAMENTO).HasColumnName("ORCDET_AGRUPAMENTO");
            this.Property(t => t.orcdet_Altura).HasColumnName("orcdet_Altura");
            this.Property(t => t.orcdet_chb).HasColumnName("orcdet_chb");
            this.Property(t => t.ORCDET_CODIGO_ORI).HasColumnName("ORCDET_CODIGO_ORI");
            this.Property(t => t.orcdet_Comprimento).HasColumnName("orcdet_Comprimento");
            this.Property(t => t.ORCDET_CORESADC).HasColumnName("ORCDET_CORESADC");
            this.Property(t => t.orcdet_fator_ref).HasColumnName("orcdet_fator_ref");
            this.Property(t => t.orcdet_flag_imprimir).HasColumnName("orcdet_flag_imprimir");
            this.Property(t => t.orcdet_flag_suprimir).HasColumnName("orcdet_flag_suprimir");
            this.Property(t => t.orcdet_identificador).HasColumnName("orcdet_identificador");
            this.Property(t => t.orcdet_obs).HasColumnName("orcdet_obs");
            this.Property(t => t.orcdet_onde_incluir).HasColumnName("orcdet_onde_incluir");
            this.Property(t => t.orcdet_peso).HasColumnName("orcdet_peso");
            this.Property(t => t.ORCDET_PRC_ALTURA).HasColumnName("ORCDET_PRC_ALTURA");
            this.Property(t => t.ORCDET_PRC_COMPRIMENTO).HasColumnName("ORCDET_PRC_COMPRIMENTO");
            this.Property(t => t.ORCDET_PRC_FORMULA).HasColumnName("ORCDET_PRC_FORMULA");
            this.Property(t => t.ORCDET_PRC_LARGURA).HasColumnName("ORCDET_PRC_LARGURA");
            this.Property(t => t.orcdet_prd_ref).HasColumnName("orcdet_prd_ref");
            this.Property(t => t.orcdet_preco_lista).HasColumnName("orcdet_preco_lista");
            this.Property(t => t.orcdet_Profundidade).HasColumnName("orcdet_Profundidade");
            this.Property(t => t.ORCDETBASALT).HasColumnName("ORCDETBASALT");
            this.Property(t => t.orcdetbase).HasColumnName("orcdetbase");
            this.Property(t => t.ORCDETBASPRF1).HasColumnName("ORCDETBASPRF1");
            this.Property(t => t.ORCDETBASPRF2).HasColumnName("ORCDETBASPRF2");
            this.Property(t => t.ORCDETBASPRFEST).HasColumnName("ORCDETBASPRFEST");
            this.Property(t => t.ORCDETBASQTD).HasColumnName("ORCDETBASQTD");
            this.Property(t => t.orcdetcorpesquisa).HasColumnName("orcdetcorpesquisa");
            this.Property(t => t.OrcDetPrecoLista).HasColumnName("OrcDetPrecoLista");
            this.Property(t => t.OrcDetProdutoImagem).HasColumnName("OrcDetProdutoImagem");
            this.Property(t => t.ORCDETPROPOSTAGRUPO).HasColumnName("ORCDETPROPOSTAGRUPO");
            this.Property(t => t.OrcDetTipoProduto).HasColumnName("OrcDetTipoProduto");
            this.Property(t => t.ori_alt).HasColumnName("ori_alt");
            this.Property(t => t.ori_compr).HasColumnName("ori_compr");
            this.Property(t => t.ori_prof).HasColumnName("ori_prof");
            this.Property(t => t.SETOR).HasColumnName("SETOR");
            this.Property(t => t.UTILIZACAO).HasColumnName("UTILIZACAO");
            this.Property(t => t.varusr).HasColumnName("varusr");
            this.Property(t => t.ORCDETCMPMULTI).HasColumnName("ORCDETCMPMULTI");
            this.Property(t => t.ORCDET_COUNTER).HasColumnName("ORCDET_COUNTER");
            this.Property(t => t.ORCDET_EXP_FLAG_CMP).HasColumnName("ORCDET_EXP_FLAG_CMP");
            this.Property(t => t.ORCDET_EXP_FLAG_ALT).HasColumnName("ORCDET_EXP_FLAG_ALT");
            this.Property(t => t.ORCDET_EXP_FLAG_LRG).HasColumnName("ORCDET_EXP_FLAG_LRG");
            this.Property(t => t.ORCDET_KCAL).HasColumnName("ORCDET_KCAL");
            this.Property(t => t.controleCad).HasColumnName("controleCad");
            this.Property(t => t.vizatras).HasColumnName("vizatras");
            this.Property(t => t.orcdet_area).HasColumnName("orcdet_area");
            this.Property(t => t.vizinicial).HasColumnName("vizinicial");
            this.Property(t => t.vizfinal).HasColumnName("vizfinal");
            this.Property(t => t.quantidadeOriginal).HasColumnName("quantidadeOriginal");
            this.Property(t => t.orcdet_item).HasColumnName("orcdet_item");
        }
    }
}
