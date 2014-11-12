using System.ComponentModel.DataAnnotations.Schema;
using System.Data.Entity.ModelConfiguration;

namespace WBCCAD.Model.Models.Mapping
{
    public class gab_param_med_crtMap : EntityTypeConfiguration<gab_param_med_crt>
    {
        public gab_param_med_crtMap()
        {
            // Primary Key
            this.HasKey(t => t.identificacao);

            // Properties
            this.Property(t => t.codigo)
                .HasMaxLength(50);

            this.Property(t => t.Corte)
                .HasMaxLength(50);

            this.Property(t => t.tipo_med)
                .HasMaxLength(50);

            this.Property(t => t.v_tensao)
                .HasMaxLength(10);

            this.Property(t => t.v_frequencia)
                .HasMaxLength(10);

            this.Property(t => t.v_condensacao)
                .HasMaxLength(10);

            this.Property(t => t.v_par4)
                .HasMaxLength(10);

            this.Property(t => t.v_par5)
                .HasMaxLength(10);

            // Table & Column Mappings
            this.ToTable("gab_param_med_crt");
            this.Property(t => t.identificacao).HasColumnName("identificacao");
            this.Property(t => t.medida).HasColumnName("medida");
            this.Property(t => t.codigo).HasColumnName("codigo");
            this.Property(t => t.potencia).HasColumnName("potencia");
            this.Property(t => t.Corte).HasColumnName("Corte");
            this.Property(t => t.sequencia_edicao).HasColumnName("sequencia_edicao");
            this.Property(t => t.tipo_med).HasColumnName("tipo_med");
            this.Property(t => t.medida_reta_corte).HasColumnName("medida_reta_corte");
            this.Property(t => t.medida_p_reta_corte).HasColumnName("medida_p_reta_corte");
            this.Property(t => t.v_tensao).HasColumnName("v_tensao");
            this.Property(t => t.v_frequencia).HasColumnName("v_frequencia");
            this.Property(t => t.v_condensacao).HasColumnName("v_condensacao");
            this.Property(t => t.v_par4).HasColumnName("v_par4");
            this.Property(t => t.v_par5).HasColumnName("v_par5");
            this.Property(t => t.potencia_orvalho).HasColumnName("potencia_orvalho");
            this.Property(t => t.potencia_iluminacao).HasColumnName("potencia_iluminacao");
            this.Property(t => t.travar_representante).HasColumnName("travar_representante");
            this.Property(t => t.potencia_2).HasColumnName("potencia_2");
            this.Property(t => t.potencia_resistencia_degelo_2).HasColumnName("potencia_resistencia_degelo_2");
            this.Property(t => t.potencia_orvalho_2).HasColumnName("potencia_orvalho_2");
            this.Property(t => t.potencia_iluminacao_2).HasColumnName("potencia_iluminacao_2");
        }
    }
}
