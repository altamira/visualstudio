using System.ComponentModel.DataAnnotations.Schema;
using System.Data.Entity.ModelConfiguration;

namespace WBCCAD.Model.Models.Mapping
{
    public class prdorcMap : EntityTypeConfiguration<prdorc>
    {
        public prdorcMap()
        {
            // Primary Key
            this.HasKey(t => t.indice);

            // Properties
            this.Property(t => t.Produto)
                .HasMaxLength(20);

            this.Property(t => t.Descricao)
                .HasMaxLength(70);

            this.Property(t => t.Unidade)
                .HasMaxLength(2);

            this.Property(t => t.Familia)
                .HasMaxLength(30);

            this.Property(t => t.Cor_padrao)
                .HasMaxLength(50);

            this.Property(t => t.Situacao)
                .HasMaxLength(20);

            this.Property(t => t.PrdOrcImagem)
                .HasMaxLength(255);

            this.Property(t => t.PRDORCVARIAVEIS)
                .HasMaxLength(255);

            this.Property(t => t.ORIGEM)
                .HasMaxLength(1);

            this.Property(t => t.PRDORC_FORNECEDOR)
                .HasMaxLength(20);

            this.Property(t => t.PRDORC_GRUPOCORESADC)
                .HasMaxLength(255);

            this.Property(t => t.PRDORC_GRUPOCOR)
                .HasMaxLength(50);

            this.Property(t => t.PRDDSCORC)
                .HasMaxLength(100);

            this.Property(t => t.PRDCRTADC)
                .HasMaxLength(5);

            this.Property(t => t.codigoIntegracao)
                .HasMaxLength(255);

            // Table & Column Mappings
            this.ToTable("prdorc");
            this.Property(t => t.indice).HasColumnName("indice");
            this.Property(t => t.Produto).HasColumnName("Produto");
            this.Property(t => t.Descricao).HasColumnName("Descricao");
            this.Property(t => t.Unidade).HasColumnName("Unidade");
            this.Property(t => t.Peso).HasColumnName("Peso");
            this.Property(t => t.Familia).HasColumnName("Familia");
            this.Property(t => t.Cor_padrao).HasColumnName("Cor_padrao");
            this.Property(t => t.Situacao).HasColumnName("Situacao");
            this.Property(t => t.Altura).HasColumnName("Altura");
            this.Property(t => t.Comprimento).HasColumnName("Comprimento");
            this.Property(t => t.Largura).HasColumnName("Largura");
            this.Property(t => t.PrdOrcImagem).HasColumnName("PrdOrcImagem");
            this.Property(t => t.Preco).HasColumnName("Preco");
            this.Property(t => t.PRDORCVARIAVEIS).HasColumnName("PRDORCVARIAVEIS");
            this.Property(t => t.IMPORTARESTRUTURA).HasColumnName("IMPORTARESTRUTURA");
            this.Property(t => t.ORIGEM).HasColumnName("ORIGEM");
            this.Property(t => t.TRAVAR_REPRESENTANTE).HasColumnName("TRAVAR_REPRESENTANTE");
            this.Property(t => t.PRDORCCHK).HasColumnName("PRDORCCHK");
            this.Property(t => t.ITEMFATURADO).HasColumnName("ITEMFATURADO");
            this.Property(t => t.ATUALIZADOEM).HasColumnName("ATUALIZADOEM");
            this.Property(t => t.IMPORTADOEM).HasColumnName("IMPORTADOEM");
            this.Property(t => t.PRDORC_FORNECEDOR).HasColumnName("PRDORC_FORNECEDOR");
            this.Property(t => t.PRDORC_GRUPOCORESADC).HasColumnName("PRDORC_GRUPOCORESADC");
            this.Property(t => t.PRDORC_GRUPOCOR).HasColumnName("PRDORC_GRUPOCOR");
            this.Property(t => t.PRDORC_PRC_FORMULA).HasColumnName("PRDORC_PRC_FORMULA");
            this.Property(t => t.PRDORC_PRC_COMPRIMENTO).HasColumnName("PRDORC_PRC_COMPRIMENTO");
            this.Property(t => t.PRDORC_PRC_ALTURA).HasColumnName("PRDORC_PRC_ALTURA");
            this.Property(t => t.PRDORC_PRC_LARGURA).HasColumnName("PRDORC_PRC_LARGURA");
            this.Property(t => t.PRDDSCORC).HasColumnName("PRDDSCORC");
            this.Property(t => t.PRDCRTADC).HasColumnName("PRDCRTADC");
            this.Property(t => t.PRDORC_PRIORIDADE).HasColumnName("PRDORC_PRIORIDADE");
            this.Property(t => t.PRDORC_PESO_FIX).HasColumnName("PRDORC_PESO_FIX");
            this.Property(t => t.PRDORC_PESO_CMP).HasColumnName("PRDORC_PESO_CMP");
            this.Property(t => t.PRDORC_PESO_ALT).HasColumnName("PRDORC_PESO_ALT");
            this.Property(t => t.PRDORC_PESO_PRF).HasColumnName("PRDORC_PESO_PRF");
            this.Property(t => t.PRDORC_EXP_FLAG_CMP).HasColumnName("PRDORC_EXP_FLAG_CMP");
            this.Property(t => t.PRDORC_EXP_FLAG_ALT).HasColumnName("PRDORC_EXP_FLAG_ALT");
            this.Property(t => t.PRDORC_EXP_FLAG_LRG).HasColumnName("PRDORC_EXP_FLAG_LRG");
            this.Property(t => t.prdorc_semcentavos).HasColumnName("prdorc_semcentavos");
            this.Property(t => t.codigoIntegracao).HasColumnName("codigoIntegracao");
        }
    }
}
