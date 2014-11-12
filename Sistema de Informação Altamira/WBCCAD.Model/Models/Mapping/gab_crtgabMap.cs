using System.ComponentModel.DataAnnotations.Schema;
using System.Data.Entity.ModelConfiguration;

namespace WBCCAD.Model.Models.Mapping
{
    public class gab_crtgabMap : EntityTypeConfiguration<gab_crtgab>
    {
        public gab_crtgabMap()
        {
            // Primary Key
            this.HasKey(t => new { t.p_par4, t.p_par5, t.idGabCrtgab });

            // Properties
            this.Property(t => t.codigo)
                .HasMaxLength(20);

            this.Property(t => t.linha)
                .HasMaxLength(30);

            this.Property(t => t.tipo)
                .HasMaxLength(30);

            this.Property(t => t.resfriamento)
                .HasMaxLength(20);

            this.Property(t => t.grp_cor)
                .HasMaxLength(30);

            this.Property(t => t.inclinacao)
                .HasMaxLength(40);

            this.Property(t => t.inclusao_usuario)
                .HasMaxLength(30);

            this.Property(t => t.alteracao_usuario)
                .HasMaxLength(30);

            this.Property(t => t.prefixo_desenho)
                .HasMaxLength(20);

            this.Property(t => t.situacao)
                .HasMaxLength(20);

            this.Property(t => t.grupo_degelo)
                .HasMaxLength(50);

            this.Property(t => t.dia_liquidos)
                .HasMaxLength(10);

            this.Property(t => t.dia_succao)
                .HasMaxLength(10);

            this.Property(t => t.prefixo_sgrupo)
                .HasMaxLength(5);

            this.Property(t => t.gab_int_temperatura)
                .HasMaxLength(20);

            this.Property(t => t.idGabCrtgab)
                .HasDatabaseGeneratedOption(DatabaseGeneratedOption.Identity);

            // Table & Column Mappings
            this.ToTable("gab_crtgab");
            this.Property(t => t.codigo).HasColumnName("codigo");
            this.Property(t => t.linha).HasColumnName("linha");
            this.Property(t => t.tipo).HasColumnName("tipo");
            this.Property(t => t.profundidade).HasColumnName("profundidade");
            this.Property(t => t.kcal).HasColumnName("kcal");
            this.Property(t => t.potencia).HasColumnName("potencia");
            this.Property(t => t.resfriamento).HasColumnName("resfriamento");
            this.Property(t => t.grp_cor).HasColumnName("grp_cor");
            this.Property(t => t.inclinacao).HasColumnName("inclinacao");
            this.Property(t => t.inclusao_usuario).HasColumnName("inclusao_usuario");
            this.Property(t => t.inclusao_data).HasColumnName("inclusao_data");
            this.Property(t => t.inclusao_horario).HasColumnName("inclusao_horario");
            this.Property(t => t.alteracao_usuario).HasColumnName("alteracao_usuario");
            this.Property(t => t.alteracao_data).HasColumnName("alteracao_data");
            this.Property(t => t.alteracao_horario).HasColumnName("alteracao_horario");
            this.Property(t => t.prefixo_desenho).HasColumnName("prefixo_desenho");
            this.Property(t => t.altura_util).HasColumnName("altura_util");
            this.Property(t => t.situacao).HasColumnName("situacao");
            this.Property(t => t.esconder_orcamento).HasColumnName("esconder_orcamento");
            this.Property(t => t.p_tensao).HasColumnName("p_tensao");
            this.Property(t => t.p_frequencia).HasColumnName("p_frequencia");
            this.Property(t => t.p_condensacao).HasColumnName("p_condensacao");
            this.Property(t => t.p_par4).HasColumnName("p_par4");
            this.Property(t => t.p_par5).HasColumnName("p_par5");
            this.Property(t => t.altura).HasColumnName("altura");
            this.Property(t => t.alt_min_incl).HasColumnName("alt_min_incl");
            this.Property(t => t.mult_modulacao).HasColumnName("mult_modulacao");
            this.Property(t => t.alt_max_incl).HasColumnName("alt_max_incl");
            this.Property(t => t.vlr_estr_int).HasColumnName("vlr_estr_int");
            this.Property(t => t.grupo_degelo).HasColumnName("grupo_degelo");
            this.Property(t => t.numero_modulos_eqv_mec).HasColumnName("numero_modulos_eqv_mec");
            this.Property(t => t.numero_modulos_eqv_eletr).HasColumnName("numero_modulos_eqv_eletr");
            this.Property(t => t.temperatura_trabalho).HasColumnName("temperatura_trabalho");
            this.Property(t => t.temperatura_trabalho2).HasColumnName("temperatura_trabalho2");
            this.Property(t => t.dia_liquidos).HasColumnName("dia_liquidos");
            this.Property(t => t.dia_succao).HasColumnName("dia_succao");
            this.Property(t => t.possui_espelho).HasColumnName("possui_espelho");
            this.Property(t => t.prefixo_sgrupo).HasColumnName("prefixo_sgrupo");
            this.Property(t => t.travar_representante).HasColumnName("travar_representante");
            this.Property(t => t.t_chave).HasColumnName("t_chave");
            this.Property(t => t.t_cor).HasColumnName("t_cor");
            this.Property(t => t.fechamento_duplo).HasColumnName("fechamento_duplo");
            this.Property(t => t.gab_int_temperatura).HasColumnName("gab_int_temperatura");
            this.Property(t => t.quant_fc).HasColumnName("quant_fc");
            this.Property(t => t.idGabCrtgab).HasColumnName("idGabCrtgab");
        }
    }
}
