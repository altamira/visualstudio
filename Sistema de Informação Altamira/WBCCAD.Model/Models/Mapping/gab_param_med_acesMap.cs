using System.ComponentModel.DataAnnotations.Schema;
using System.Data.Entity.ModelConfiguration;

namespace WBCCAD.Model.Models.Mapping
{
    public class gab_param_med_acesMap : EntityTypeConfiguration<gab_param_med_aces>
    {
        public gab_param_med_acesMap()
        {
            // Primary Key
            this.HasKey(t => t.identificacao);

            // Properties
            this.Property(t => t.acessorio)
                .HasMaxLength(50);

            this.Property(t => t.codigo)
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
            this.ToTable("gab_param_med_aces");
            this.Property(t => t.identificacao).HasColumnName("identificacao");
            this.Property(t => t.acessorio).HasColumnName("acessorio");
            this.Property(t => t.medida).HasColumnName("medida");
            this.Property(t => t.codigo).HasColumnName("codigo");
            this.Property(t => t.qtde_por_nivel_min).HasColumnName("qtde_por_nivel_min");
            this.Property(t => t.qtde_por_nivel_max).HasColumnName("qtde_por_nivel_max");
            this.Property(t => t.qtde_por_nivel_pad).HasColumnName("qtde_por_nivel_pad");
            this.Property(t => t.potencia).HasColumnName("potencia");
            this.Property(t => t.sequencia_edicao).HasColumnName("sequencia_edicao");
            this.Property(t => t.tipo_med).HasColumnName("tipo_med");
            this.Property(t => t.v_tensao).HasColumnName("v_tensao");
            this.Property(t => t.v_frequencia).HasColumnName("v_frequencia");
            this.Property(t => t.v_condensacao).HasColumnName("v_condensacao");
            this.Property(t => t.v_par4).HasColumnName("v_par4");
            this.Property(t => t.v_par5).HasColumnName("v_par5");
            this.Property(t => t.potencia_orvalho).HasColumnName("potencia_orvalho");
            this.Property(t => t.potencia_iluminacao).HasColumnName("potencia_iluminacao");
        }
    }
}
