using System.ComponentModel.DataAnnotations.Schema;
using System.Data.Entity.ModelConfiguration;

namespace WBCCAD.Model.Models.Mapping
{
    public class gond_acessMap : EntityTypeConfiguration<gond_acess>
    {
        public gond_acessMap()
        {
            // Primary Key
            this.HasKey(t => t.idGondAcess);

            // Properties
            this.Property(t => t.descricao)
                .HasMaxLength(50);

            this.Property(t => t.grupo_acab)
                .HasMaxLength(50);

            this.Property(t => t.qtde_p_nivel)
                .HasMaxLength(50);

            this.Property(t => t.inc_no_mod)
                .HasMaxLength(50);

            this.Property(t => t.alt_conceito)
                .HasMaxLength(50);

            this.Property(t => t.compr_conceito)
                .HasMaxLength(50);

            this.Property(t => t.TEXTO_CORTE)
                .HasMaxLength(255);

            this.Property(t => t.qtde_p_nivel_formula)
                .HasMaxLength(250);

            // Table & Column Mappings
            this.ToTable("gond_acess");
            this.Property(t => t.descricao).HasColumnName("descricao");
            this.Property(t => t.grupo_acab).HasColumnName("grupo_acab");
            this.Property(t => t.qtde_p_nivel).HasColumnName("qtde_p_nivel");
            this.Property(t => t.inc_no_mod).HasColumnName("inc_no_mod");
            this.Property(t => t.alt_conceito).HasColumnName("alt_conceito");
            this.Property(t => t.alt_valor).HasColumnName("alt_valor");
            this.Property(t => t.compr_conceito).HasColumnName("compr_conceito");
            this.Property(t => t.compr_valor).HasColumnName("compr_valor");
            this.Property(t => t.desenhar).HasColumnName("desenhar");
            this.Property(t => t.dist_compr).HasColumnName("dist_compr");
            this.Property(t => t.dist_fundo).HasColumnName("dist_fundo");
            this.Property(t => t.qtde_p_nivel_valor).HasColumnName("qtde_p_nivel_valor");
            this.Property(t => t.TEXTO_CORTE).HasColumnName("TEXTO_CORTE");
            this.Property(t => t.CODIGO_DEPENDE_COR).HasColumnName("CODIGO_DEPENDE_COR");
            this.Property(t => t.Nao_montar_chave_altura).HasColumnName("Nao_montar_chave_altura");
            this.Property(t => t.Nao_montar_chave_profundidade).HasColumnName("Nao_montar_chave_profundidade");
            this.Property(t => t.Nao_montar_chave_comprimento).HasColumnName("Nao_montar_chave_comprimento");
            this.Property(t => t.nao_utilizar_compr_parametro).HasColumnName("nao_utilizar_compr_parametro");
            this.Property(t => t.qtde_p_nivel_formula).HasColumnName("qtde_p_nivel_formula");
            this.Property(t => t.utilizar_carga_total).HasColumnName("utilizar_carga_total");
            this.Property(t => t.agrupar_acessorio).HasColumnName("agrupar_acessorio");
            this.Property(t => t.idGondAcess).HasColumnName("idGondAcess");
        }
    }
}
