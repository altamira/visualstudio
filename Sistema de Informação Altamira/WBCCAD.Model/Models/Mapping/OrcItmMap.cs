using System.ComponentModel.DataAnnotations.Schema;
using System.Data.Entity.ModelConfiguration;

namespace WBCCAD.Model.Models.Mapping
{
    public class OrcItmMap : EntityTypeConfiguration<OrcItm>
    {
        public OrcItmMap()
        {
            // Primary Key
            this.HasKey(t => t.idOrcItm);

            // Properties
            this.Property(t => t.numeroOrcamento)
                .IsFixedLength()
                .HasMaxLength(9);

            this.Property(t => t.orcitm_dtc)
                .HasMaxLength(250);

            this.Property(t => t.ORCITM_REFERENCIA)
                .HasMaxLength(8);

            this.Property(t => t.orcitm_subgrupo)
                .HasMaxLength(2);

            this.Property(t => t.proposta_descricao)
                .HasMaxLength(50);

            this.Property(t => t.proposta_imagem)
                .HasMaxLength(255);

            this.Property(t => t.proposta_texto_base)
                .HasMaxLength(150);

            this.Property(t => t.proposta_texto_item)
                .HasMaxLength(150);

            this.Property(t => t.orcitm_item)
                .HasMaxLength(20);

            // Table & Column Mappings
            this.ToTable("OrcItm");
            this.Property(t => t.numeroOrcamento).HasColumnName("numeroOrcamento");
            this.Property(t => t.orcitm_altura).HasColumnName("orcitm_altura");
            this.Property(t => t.orcitm_comprimento).HasColumnName("orcitm_comprimento");
            this.Property(t => t.OrcItm_Desc_Destacado).HasColumnName("OrcItm_Desc_Destacado");
            this.Property(t => t.OrcItm_Desconto_Grupo).HasColumnName("OrcItm_Desconto_Grupo");
            this.Property(t => t.OrcItm_Diferenca).HasColumnName("OrcItm_Diferenca");
            this.Property(t => t.orcitm_dtc).HasColumnName("orcitm_dtc");
            this.Property(t => t.OrcItm_Encargos).HasColumnName("OrcItm_Encargos");
            this.Property(t => t.OrcItm_Frete).HasColumnName("OrcItm_Frete");
            this.Property(t => t.orcitm_grupo).HasColumnName("orcitm_grupo");
            this.Property(t => t.OrcItm_IPI).HasColumnName("OrcItm_IPI");
            this.Property(t => t.orcitm_largura).HasColumnName("orcitm_largura");
            this.Property(t => t.OrcItm_Preco_Lista).HasColumnName("OrcItm_Preco_Lista");
            this.Property(t => t.OrcItm_Preco_Lista_Sem).HasColumnName("OrcItm_Preco_Lista_Sem");
            this.Property(t => t.orcitm_qtde).HasColumnName("orcitm_qtde");
            this.Property(t => t.ORCITM_REFERENCIA).HasColumnName("ORCITM_REFERENCIA");
            this.Property(t => t.orcitm_subgrupo).HasColumnName("orcitm_subgrupo");
            this.Property(t => t.orcitm_suprimir_itens).HasColumnName("orcitm_suprimir_itens");
            this.Property(t => t.ORCITM_TOTAL).HasColumnName("ORCITM_TOTAL");
            this.Property(t => t.OrcItm_ValGrupoComDesc).HasColumnName("OrcItm_ValGrupoComDesc");
            this.Property(t => t.orcitm_valor_total).HasColumnName("orcitm_valor_total");
            this.Property(t => t.proposta_descricao).HasColumnName("proposta_descricao");
            this.Property(t => t.proposta_grupo).HasColumnName("proposta_grupo");
            this.Property(t => t.proposta_imagem).HasColumnName("proposta_imagem");
            this.Property(t => t.proposta_ordem).HasColumnName("proposta_ordem");
            this.Property(t => t.proposta_texto_base).HasColumnName("proposta_texto_base");
            this.Property(t => t.proposta_texto_item).HasColumnName("proposta_texto_item");
            this.Property(t => t.idOrcItm).HasColumnName("idOrcItm");
            this.Property(t => t.orcitm_item).HasColumnName("orcitm_item");
        }
    }
}
