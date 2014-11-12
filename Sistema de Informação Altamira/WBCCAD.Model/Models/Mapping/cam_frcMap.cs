using System.ComponentModel.DataAnnotations.Schema;
using System.Data.Entity.ModelConfiguration;

namespace WBCCAD.Model.Models.Mapping
{
    public class cam_frcMap : EntityTypeConfiguration<cam_frc>
    {
        public cam_frcMap()
        {
            // Primary Key
            this.HasKey(t => new { t.possui_resistencia, t.frc_central });

            // Properties
            this.Property(t => t.frc_descricao)
                .HasMaxLength(40);

            this.Property(t => t.frc_codigo)
                .HasMaxLength(20);

            this.Property(t => t.frc_desenho)
                .HasMaxLength(255);

            this.Property(t => t.frc_regime)
                .HasMaxLength(20);

            this.Property(t => t.frc_fabricante)
                .HasMaxLength(40);

            this.Property(t => t.frc_grupo_degelo)
                .HasMaxLength(50);

            this.Property(t => t.RTF_PADRAO)
                .HasMaxLength(50);

            this.Property(t => t.fase_resist)
                .HasMaxLength(2);

            this.Property(t => t.fase_moto)
                .HasMaxLength(2);

            this.Property(t => t.Tipo_degelo)
                .HasMaxLength(20);

            this.Property(t => t.dim_a)
                .HasMaxLength(5);

            this.Property(t => t.dim_b)
                .HasMaxLength(5);

            this.Property(t => t.dim_c)
                .HasMaxLength(5);

            this.Property(t => t.dim_d)
                .HasMaxLength(5);

            this.Property(t => t.dim_e)
                .HasMaxLength(5);

            // Table & Column Mappings
            this.ToTable("cam_frc");
            this.Property(t => t.frc_descricao).HasColumnName("frc_descricao");
            this.Property(t => t.frc_codigo).HasColumnName("frc_codigo");
            this.Property(t => t.frc_desenho).HasColumnName("frc_desenho");
            this.Property(t => t.frc_kva).HasColumnName("frc_kva");
            this.Property(t => t.frc_hp).HasColumnName("frc_hp");
            this.Property(t => t.frc_comprimento).HasColumnName("frc_comprimento");
            this.Property(t => t.frc_kcal).HasColumnName("frc_kcal");
            this.Property(t => t.frc_regime).HasColumnName("frc_regime");
            this.Property(t => t.frc_fabricante).HasColumnName("frc_fabricante");
            this.Property(t => t.frc_temperatura).HasColumnName("frc_temperatura");
            this.Property(t => t.frc_grupo_degelo).HasColumnName("frc_grupo_degelo");
            this.Property(t => t.RTF_PADRAO).HasColumnName("RTF_PADRAO");
            this.Property(t => t.possui_resistencia).HasColumnName("possui_resistencia");
            this.Property(t => t.carga_gas).HasColumnName("carga_gas");
            this.Property(t => t.carga_oleo).HasColumnName("carga_oleo");
            this.Property(t => t.frc_central).HasColumnName("frc_central");
            this.Property(t => t.multiplo_fixacao).HasColumnName("multiplo_fixacao");
            this.Property(t => t.fase_resist).HasColumnName("fase_resist");
            this.Property(t => t.fase_moto).HasColumnName("fase_moto");
            this.Property(t => t.Alt_max_insercao).HasColumnName("Alt_max_insercao");
            this.Property(t => t.Tipo_degelo).HasColumnName("Tipo_degelo");
            this.Property(t => t.dim_a).HasColumnName("dim_a");
            this.Property(t => t.dim_b).HasColumnName("dim_b");
            this.Property(t => t.dim_c).HasColumnName("dim_c");
            this.Property(t => t.dim_d).HasColumnName("dim_d");
            this.Property(t => t.dim_e).HasColumnName("dim_e");
            this.Property(t => t.frc_vazao).HasColumnName("frc_vazao");
            this.Property(t => t.frc_num_vent).HasColumnName("frc_num_vent");
        }
    }
}
