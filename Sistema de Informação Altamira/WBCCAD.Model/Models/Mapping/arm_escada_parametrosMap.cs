using System.ComponentModel.DataAnnotations.Schema;
using System.Data.Entity.ModelConfiguration;

namespace WBCCAD.Model.Models.Mapping
{
    public class arm_escada_parametrosMap : EntityTypeConfiguration<arm_escada_parametros>
    {
        public arm_escada_parametrosMap()
        {
            // Primary Key
            this.HasKey(t => t.permitir_patamar);

            // Properties
            // Table & Column Mappings
            this.ToTable("arm_escada_parametros");
            this.Property(t => t.altura_degrau_minimo).HasColumnName("altura_degrau_minimo");
            this.Property(t => t.altura_degrau_maximo).HasColumnName("altura_degrau_maximo");
            this.Property(t => t.altura_degrau_padrao).HasColumnName("altura_degrau_padrao");
            this.Property(t => t.largura_degrau_minimo).HasColumnName("largura_degrau_minimo");
            this.Property(t => t.largura_degrau_maximo).HasColumnName("largura_degrau_maximo");
            this.Property(t => t.largura_degrau_padrao).HasColumnName("largura_degrau_padrao");
            this.Property(t => t.comprimento_degrau_maximo).HasColumnName("comprimento_degrau_maximo");
            this.Property(t => t.Altura_maxima_simples).HasColumnName("Altura_maxima_simples");
            this.Property(t => t.Altura_maxima_com_patamar).HasColumnName("Altura_maxima_com_patamar");
            this.Property(t => t.permitir_patamar).HasColumnName("permitir_patamar");
        }
    }
}
