using System.ComponentModel.DataAnnotations.Schema;
using System.Data.Entity.ModelConfiguration;

namespace WBCCAD.Model.Models.Mapping
{
    public class mob_cadastroMap : EntityTypeConfiguration<mob_cadastro>
    {
        public mob_cadastroMap()
        {
            // Primary Key
            this.HasKey(t => t.idMobCadastro);

            // Properties
            this.Property(t => t.descricao)
                .HasMaxLength(50);

            this.Property(t => t.cod_direito)
                .HasMaxLength(50);

            this.Property(t => t.cod_esquerdo)
                .HasMaxLength(50);

            this.Property(t => t.desenho)
                .HasMaxLength(100);

            this.Property(t => t.complemento)
                .HasMaxLength(20);

            this.Property(t => t.bandeira)
                .HasMaxLength(50);

            this.Property(t => t.familia)
                .HasMaxLength(50);

            this.Property(t => t.corte)
                .HasMaxLength(50);

            this.Property(t => t.grupo_cor)
                .HasMaxLength(50);

            this.Property(t => t.nome_eqpto)
                .HasMaxLength(50);

            this.Property(t => t.opcao)
                .HasMaxLength(1);

            this.Property(t => t.consumo_tipo)
                .HasMaxLength(50);

            this.Property(t => t.subgrupo)
                .HasMaxLength(50);

            this.Property(t => t.tipo_cobrar)
                .HasMaxLength(50);

            this.Property(t => t.codigo_montavel)
                .HasMaxLength(20);

            this.Property(t => t.desenho_montavel)
                .HasMaxLength(20);

            this.Property(t => t.grupo_caracteristica)
                .HasMaxLength(20);

            this.Property(t => t.texto_p_corte)
                .HasMaxLength(60);

            this.Property(t => t.corte_montavel)
                .HasMaxLength(50);

            this.Property(t => t.grupo_restricao)
                .HasMaxLength(50);

            this.Property(t => t.mensagem_ao_inserir)
                .HasMaxLength(50);

            // Table & Column Mappings
            this.ToTable("mob_cadastro");
            this.Property(t => t.descricao).HasColumnName("descricao");
            this.Property(t => t.cod_direito).HasColumnName("cod_direito");
            this.Property(t => t.cod_esquerdo).HasColumnName("cod_esquerdo");
            this.Property(t => t.desenho).HasColumnName("desenho");
            this.Property(t => t.comp_padrao).HasColumnName("comp_padrao");
            this.Property(t => t.comp_min).HasColumnName("comp_min");
            this.Property(t => t.comp_max).HasColumnName("comp_max");
            this.Property(t => t.prof_padrao).HasColumnName("prof_padrao");
            this.Property(t => t.prof_min).HasColumnName("prof_min");
            this.Property(t => t.prof_max).HasColumnName("prof_max");
            this.Property(t => t.alt_padrao).HasColumnName("alt_padrao");
            this.Property(t => t.alt_min).HasColumnName("alt_min");
            this.Property(t => t.alt_max).HasColumnName("alt_max");
            this.Property(t => t.alt_solo).HasColumnName("alt_solo");
            this.Property(t => t.complemento).HasColumnName("complemento");
            this.Property(t => t.visivel).HasColumnName("visivel");
            this.Property(t => t.bandeira).HasColumnName("bandeira");
            this.Property(t => t.familia).HasColumnName("familia");
            this.Property(t => t.corte).HasColumnName("corte");
            this.Property(t => t.grupo_cor).HasColumnName("grupo_cor");
            this.Property(t => t.nome_eqpto).HasColumnName("nome_eqpto");
            this.Property(t => t.opcao).HasColumnName("opcao");
            this.Property(t => t.consumo_eletrico).HasColumnName("consumo_eletrico");
            this.Property(t => t.consumo_tipo).HasColumnName("consumo_tipo");
            this.Property(t => t.subgrupo).HasColumnName("subgrupo");
            this.Property(t => t.travar_representante).HasColumnName("travar_representante");
            this.Property(t => t.tipo_cobrar).HasColumnName("tipo_cobrar");
            this.Property(t => t.codigo_montavel).HasColumnName("codigo_montavel");
            this.Property(t => t.desenho_montavel).HasColumnName("desenho_montavel");
            this.Property(t => t.grupo_caracteristica).HasColumnName("grupo_caracteristica");
            this.Property(t => t.texto_p_corte).HasColumnName("texto_p_corte");
            this.Property(t => t.corte_montavel).HasColumnName("corte_montavel");
            this.Property(t => t.parte_reta).HasColumnName("parte_reta");
            this.Property(t => t.angulo).HasColumnName("angulo");
            this.Property(t => t.grupo_restricao).HasColumnName("grupo_restricao");
            this.Property(t => t.prioridade).HasColumnName("prioridade");
            this.Property(t => t.mensagem_ao_inserir).HasColumnName("mensagem_ao_inserir");
            this.Property(t => t.idMobCadastro).HasColumnName("idMobCadastro");
        }
    }
}
