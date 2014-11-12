using System.ComponentModel.DataAnnotations.Schema;
using System.Data.Entity.ModelConfiguration;

namespace WBCCAD.Model.Models.Mapping
{
    public class gond_dados_corteMap : EntityTypeConfiguration<gond_dados_corte>
    {
        public gond_dados_corteMap()
        {
            // Primary Key
            this.HasKey(t => t.idcorte);

            // Properties
            this.Property(t => t.Nome_corte)
                .HasMaxLength(50);

            this.Property(t => t.Tipo_corte)
                .HasMaxLength(50);

            this.Property(t => t.lista)
                .HasMaxLength(50);

            this.Property(t => t.desenho_planta)
                .HasMaxLength(20);

            this.Property(t => t.posicao)
                .HasMaxLength(1);

            this.Property(t => t.sufixo_estrutura)
                .HasMaxLength(10);

            // Table & Column Mappings
            this.ToTable("gond_dados_corte");
            this.Property(t => t.Nome_corte).HasColumnName("Nome_corte");
            this.Property(t => t.Tipo_corte).HasColumnName("Tipo_corte");
            this.Property(t => t.lista).HasColumnName("lista");
            this.Property(t => t.idcorte).HasColumnName("idcorte");
            this.Property(t => t.altura_base).HasColumnName("altura_base");
            this.Property(t => t.desenho_planta).HasColumnName("desenho_planta");
            this.Property(t => t.posicao).HasColumnName("posicao");
            this.Property(t => t.corte_config).HasColumnName("corte_config");
            this.Property(t => t.ALturaMinima).HasColumnName("ALturaMinima");
            this.Property(t => t.passo).HasColumnName("passo");
            this.Property(t => t.prof_estr).HasColumnName("prof_estr");
            this.Property(t => t.travar_representante).HasColumnName("travar_representante");
            this.Property(t => t.sobra_modulo).HasColumnName("sobra_modulo");
            this.Property(t => t.sufixo_estrutura).HasColumnName("sufixo_estrutura");
            this.Property(t => t.trat_base).HasColumnName("trat_base");
            this.Property(t => t.alt_max_ins).HasColumnName("alt_max_ins");
            this.Property(t => t.tratar_como_triplo).HasColumnName("tratar_como_triplo");
            this.Property(t => t.compl_comprimento).HasColumnName("compl_comprimento");
            this.Property(t => t.somente_manter_regra).HasColumnName("somente_manter_regra");
            this.Property(t => t.nao_deixar_modulo_central).HasColumnName("nao_deixar_modulo_central");
            this.Property(t => t.nao_deixar_modulo_parede).HasColumnName("nao_deixar_modulo_parede");
            this.Property(t => t.GOND_UTILIZADO_EM).HasColumnName("GOND_UTILIZADO_EM");
        }
    }
}
