using System.ComponentModel.DataAnnotations.Schema;
using System.Data.Entity.ModelConfiguration;

namespace WBCCAD.Model.Models.Mapping
{
    public class cam_prtMap : EntityTypeConfiguration<cam_prt>
    {
        public cam_prtMap()
        {
            // Primary Key
            this.HasKey(t => t.inativo);

            // Properties
            this.Property(t => t.prt_descricao)
                .HasMaxLength(40);

            this.Property(t => t.prt_codigo_esquerdo)
                .HasMaxLength(20);

            this.Property(t => t.prt_codigo_direito)
                .HasMaxLength(20);

            this.Property(t => t.prt_desenho)
                .HasMaxLength(255);

            this.Property(t => t.prt_fabricante)
                .HasMaxLength(50);

            this.Property(t => t.TEXTO_PLANTA)
                .HasMaxLength(50);

            this.Property(t => t.SUFIXO_DESENHO)
                .HasMaxLength(20);

            this.Property(t => t.TIPO_CAD)
                .HasMaxLength(10);

            this.Property(t => t.compl_desenho)
                .HasMaxLength(10);

            this.Property(t => t.tipo_porta)
                .HasMaxLength(10);

            // Table & Column Mappings
            this.ToTable("cam_prt");
            this.Property(t => t.prt_descricao).HasColumnName("prt_descricao");
            this.Property(t => t.prt_codigo_esquerdo).HasColumnName("prt_codigo_esquerdo");
            this.Property(t => t.prt_codigo_direito).HasColumnName("prt_codigo_direito");
            this.Property(t => t.prt_desenho).HasColumnName("prt_desenho");
            this.Property(t => t.prt_comprimento_pad).HasColumnName("prt_comprimento_pad");
            this.Property(t => t.prt_comprimento_min).HasColumnName("prt_comprimento_min");
            this.Property(t => t.prt_comprimento_max).HasColumnName("prt_comprimento_max");
            this.Property(t => t.prt_altura_pad).HasColumnName("prt_altura_pad");
            this.Property(t => t.prt_altura_min).HasColumnName("prt_altura_min");
            this.Property(t => t.prt_altura_max).HasColumnName("prt_altura_max");
            this.Property(t => t.mult_modulo).HasColumnName("mult_modulo");
            this.Property(t => t.prt_fabricante).HasColumnName("prt_fabricante");
            this.Property(t => t.TEXTO_PLANTA).HasColumnName("TEXTO_PLANTA");
            this.Property(t => t.ALTURA_SOLO).HasColumnName("ALTURA_SOLO");
            this.Property(t => t.SUFIXO_DESENHO).HasColumnName("SUFIXO_DESENHO");
            this.Property(t => t.potencia_degelo).HasColumnName("potencia_degelo");
            this.Property(t => t.kcal_porta).HasColumnName("kcal_porta");
            this.Property(t => t.TIPO_CAD).HasColumnName("TIPO_CAD");
            this.Property(t => t.compl_desenho).HasColumnName("compl_desenho");
            this.Property(t => t.tipo_porta).HasColumnName("tipo_porta");
            this.Property(t => t.altura_minima_solo).HasColumnName("altura_minima_solo");
            this.Property(t => t.inativo).HasColumnName("inativo");
        }
    }
}
