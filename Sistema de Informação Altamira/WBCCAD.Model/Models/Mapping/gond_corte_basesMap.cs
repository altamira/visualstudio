using System.ComponentModel.DataAnnotations.Schema;
using System.Data.Entity.ModelConfiguration;

namespace WBCCAD.Model.Models.Mapping
{
    public class gond_corte_basesMap : EntityTypeConfiguration<gond_corte_bases>
    {
        public gond_corte_basesMap()
        {
            // Primary Key
            this.HasKey(t => t.idGondCorteBases);

            // Properties
            this.Property(t => t.@base)
                .HasMaxLength(50);

            // Table & Column Mappings
            this.ToTable("gond_corte_bases");
            this.Property(t => t.idcorte).HasColumnName("idcorte");
            this.Property(t => t.@base).HasColumnName("base");
            this.Property(t => t.id_corte_base).HasColumnName("id_corte_base");
            this.Property(t => t.altura_base).HasColumnName("altura_base");
            this.Property(t => t.idGondCorteBases).HasColumnName("idGondCorteBases");
        }
    }
}
