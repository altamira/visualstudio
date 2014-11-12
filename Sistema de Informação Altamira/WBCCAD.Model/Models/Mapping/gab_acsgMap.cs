using System.ComponentModel.DataAnnotations.Schema;
using System.Data.Entity.ModelConfiguration;

namespace WBCCAD.Model.Models.Mapping
{
    public class gab_acsgMap : EntityTypeConfiguration<gab_acsg>
    {
        public gab_acsgMap()
        {
            // Primary Key
            this.HasKey(t => t.idGabAcsg);

            // Properties
            this.Property(t => t.acessorio)
                .HasMaxLength(40);

            this.Property(t => t.inmgab_codigo)
                .HasMaxLength(30);

            this.Property(t => t.grp_cor)
                .HasMaxLength(20);

            this.Property(t => t.desenho)
                .HasMaxLength(50);

            this.Property(t => t.codigo)
                .HasMaxLength(50);

            this.Property(t => t.SIGLACHB)
                .HasMaxLength(50);

            this.Property(t => t.mensagem_ao_inserir)
                .HasMaxLength(50);

            // Table & Column Mappings
            this.ToTable("gab_acsg");
            this.Property(t => t.acessorio).HasColumnName("acessorio");
            this.Property(t => t.flag_obrigatorio).HasColumnName("flag_obrigatorio");
            this.Property(t => t.inmgab_codigo).HasColumnName("inmgab_codigo");
            this.Property(t => t.grp_cor).HasColumnName("grp_cor");
            this.Property(t => t.pad_qtde_minima).HasColumnName("pad_qtde_minima");
            this.Property(t => t.pad_qtde_maxima).HasColumnName("pad_qtde_maxima");
            this.Property(t => t.pad_opcional).HasColumnName("pad_opcional");
            this.Property(t => t.pad_dependencia).HasColumnName("pad_dependencia");
            this.Property(t => t.pad_qtde_default).HasColumnName("pad_qtde_default");
            this.Property(t => t.pad_altura_util).HasColumnName("pad_altura_util");
            this.Property(t => t.pad_potencia).HasColumnName("pad_potencia");
            this.Property(t => t.pad_visivel).HasColumnName("pad_visivel");
            this.Property(t => t.pad_prioridade).HasColumnName("pad_prioridade");
            this.Property(t => t.pad_esconder_orcamento).HasColumnName("pad_esconder_orcamento");
            this.Property(t => t.p_tensao).HasColumnName("p_tensao");
            this.Property(t => t.p_frequencia).HasColumnName("p_frequencia");
            this.Property(t => t.p_condensacao).HasColumnName("p_condensacao");
            this.Property(t => t.p_par4).HasColumnName("p_par4");
            this.Property(t => t.p_par5).HasColumnName("p_par5");
            this.Property(t => t.desenho).HasColumnName("desenho");
            this.Property(t => t.codigo).HasColumnName("codigo");
            this.Property(t => t.potencia).HasColumnName("potencia");
            this.Property(t => t.qpn_valor_min).HasColumnName("qpn_valor_min");
            this.Property(t => t.qpn_valor_max).HasColumnName("qpn_valor_max");
            this.Property(t => t.qpn_valor_default).HasColumnName("qpn_valor_default");
            this.Property(t => t.t_chave).HasColumnName("t_chave");
            this.Property(t => t.t_cor).HasColumnName("t_cor");
            this.Property(t => t.SIGLACHB).HasColumnName("SIGLACHB");
            this.Property(t => t.t_corte).HasColumnName("t_corte");
            this.Property(t => t.p_gas).HasColumnName("p_gas");
            this.Property(t => t.nao_mostrar_p_configurar).HasColumnName("nao_mostrar_p_configurar");
            this.Property(t => t.possui_dep_arraste).HasColumnName("possui_dep_arraste");
            this.Property(t => t.def_qtde_p_arraste_de_outro).HasColumnName("def_qtde_p_arraste_de_outro");
            this.Property(t => t.mensagem_ao_inserir).HasColumnName("mensagem_ao_inserir");
            this.Property(t => t.idGabAcsg).HasColumnName("idGabAcsg");
        }
    }
}
