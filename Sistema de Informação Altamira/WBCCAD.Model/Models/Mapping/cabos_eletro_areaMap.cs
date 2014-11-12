using System.ComponentModel.DataAnnotations.Schema;
using System.Data.Entity.ModelConfiguration;

namespace WBCCAD.Model.Models.Mapping
{
    public class cabos_eletro_areaMap : EntityTypeConfiguration<cabos_eletro_area>
    {
        public cabos_eletro_areaMap()
        {
            // Primary Key
            this.HasKey(t => t.aceitar_automatico);

            // Properties
            this.Property(t => t.tipo_eletro)
                .HasMaxLength(50);

            // Table & Column Mappings
            this.ToTable("cabos_eletro_area");
            this.Property(t => t.tipo_eletro).HasColumnName("tipo_eletro");
            this.Property(t => t.area_eletro).HasColumnName("area_eletro");
            this.Property(t => t.area_maxima).HasColumnName("area_maxima");
            this.Property(t => t.aceitar_automatico).HasColumnName("aceitar_automatico");
        }
    }
}
