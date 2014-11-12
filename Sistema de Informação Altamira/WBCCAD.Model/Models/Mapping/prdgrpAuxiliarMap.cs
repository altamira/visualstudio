using System.ComponentModel.DataAnnotations.Schema;
using System.Data.Entity.ModelConfiguration;

namespace WBCCAD.Model.Models.Mapping
{
    public class prdgrpAuxiliarMap : EntityTypeConfiguration<prdgrpAuxiliar>
    {
        public prdgrpAuxiliarMap()
        {
            // Primary Key
            this.HasKey(t => t.idPrdGrp);

            // Properties
            this.Property(t => t.Subgrupo)
                .HasMaxLength(2);

            this.Property(t => t.Descricao)
                .HasMaxLength(50);

            this.Property(t => t.Tipo_cad)
                .HasMaxLength(4);

            this.Property(t => t.Proposta_descricao)
                .HasMaxLength(50);

            this.Property(t => t.Proposta_imagem)
                .HasMaxLength(255);

            this.Property(t => t.Proposta_texto_item)
                .HasMaxLength(150);

            this.Property(t => t.Proposta_texto_base)
                .HasMaxLength(150);

            this.Property(t => t.Agrupamento)
                .HasMaxLength(255);

            this.Property(t => t.Tipo_produto)
                .HasMaxLength(30);

            this.Property(t => t.BancoUsar)
                .HasMaxLength(50);

            this.Property(t => t.GrupoBusca)
                .HasMaxLength(50);

            this.Property(t => t.@base)
                .HasMaxLength(50);

            this.Property(t => t.RTFCAMPOSNORMAIS)
                .HasMaxLength(100);

            this.Property(t => t.RTFCAMPOSESPECIAIS)
                .HasMaxLength(100);

            this.Property(t => t.RTFCAMINHO)
                .HasMaxLength(50);

            this.Property(t => t.PRDGRP_IMPRIMIR_PELO)
                .HasMaxLength(20);

            this.Property(t => t.DSCFAT)
                .HasMaxLength(150);

            this.Property(t => t.TABELA_CORTE)
                .HasMaxLength(50);

            this.Property(t => t.TABELA_COMPR)
                .HasMaxLength(50);

            // Table & Column Mappings
            this.ToTable("prdgrpAuxiliar");
            this.Property(t => t.Grupo).HasColumnName("Grupo");
            this.Property(t => t.Subgrupo).HasColumnName("Subgrupo");
            this.Property(t => t.Descricao).HasColumnName("Descricao");
            this.Property(t => t.Tipo_cad).HasColumnName("Tipo_cad");
            this.Property(t => t.Proposta_ordem).HasColumnName("Proposta_ordem");
            this.Property(t => t.Proposta_grupo).HasColumnName("Proposta_grupo");
            this.Property(t => t.Proposta_descricao).HasColumnName("Proposta_descricao");
            this.Property(t => t.Proposta_imagem).HasColumnName("Proposta_imagem");
            this.Property(t => t.Proposta_texto_item).HasColumnName("Proposta_texto_item");
            this.Property(t => t.Proposta_texto_base).HasColumnName("Proposta_texto_base");
            this.Property(t => t.Agrupamento).HasColumnName("Agrupamento");
            this.Property(t => t.Imprimir_sempre).HasColumnName("Imprimir_sempre");
            this.Property(t => t.Preco_cor).HasColumnName("Preco_cor");
            this.Property(t => t.Data_preco_cor).HasColumnName("Data_preco_cor");
            this.Property(t => t.Tipo_produto).HasColumnName("Tipo_produto");
            this.Property(t => t.listar_dtc_produtos).HasColumnName("listar_dtc_produtos");
            this.Property(t => t.BancoUsar).HasColumnName("BancoUsar");
            this.Property(t => t.GrupoBusca).HasColumnName("GrupoBusca");
            this.Property(t => t.dividir_qtde_por_dois).HasColumnName("dividir_qtde_por_dois");
            this.Property(t => t.@base).HasColumnName("base");
            this.Property(t => t.suprimir_impressao_itens).HasColumnName("suprimir_impressao_itens");
            this.Property(t => t.VARUSR).HasColumnName("VARUSR");
            this.Property(t => t.RTFOPCAO).HasColumnName("RTFOPCAO");
            this.Property(t => t.RTFCAMPOSNORMAIS).HasColumnName("RTFCAMPOSNORMAIS");
            this.Property(t => t.RTFCAMPOSESPECIAIS).HasColumnName("RTFCAMPOSESPECIAIS");
            this.Property(t => t.RTFCAMINHO).HasColumnName("RTFCAMINHO");
            this.Property(t => t.GRUPO_CHECK).HasColumnName("GRUPO_CHECK");
            this.Property(t => t.PRDGRPIMPRESSAOOPCOES).HasColumnName("PRDGRPIMPRESSAOOPCOES");
            this.Property(t => t.LIMITEVALOR).HasColumnName("LIMITEVALOR");
            this.Property(t => t.PRDGRP_IMPRIMIR_PELO).HasColumnName("PRDGRP_IMPRIMIR_PELO");
            this.Property(t => t.PRDGRP_QTDE_MOD).HasColumnName("PRDGRP_QTDE_MOD");
            this.Property(t => t.PRDGRP_AGRUPAR_QTDE_MOD).HasColumnName("PRDGRP_AGRUPAR_QTDE_MOD");
            this.Property(t => t.PRDGRP_IMP_COMP_QTDE).HasColumnName("PRDGRP_IMP_COMP_QTDE");
            this.Property(t => t.DSCFAT).HasColumnName("DSCFAT");
            this.Property(t => t.TABELA_CORTE).HasColumnName("TABELA_CORTE");
            this.Property(t => t.TABELA_COMPR).HasColumnName("TABELA_COMPR");
            this.Property(t => t.PRDGRP_OUTROS).HasColumnName("PRDGRP_OUTROS");
            this.Property(t => t.PRDGRPCMPMULT).HasColumnName("PRDGRPCMPMULT");
            this.Property(t => t.imprimir_utilizacao).HasColumnName("imprimir_utilizacao");
            this.Property(t => t.idPrdGrp).HasColumnName("idPrdGrp");
        }
    }
}
