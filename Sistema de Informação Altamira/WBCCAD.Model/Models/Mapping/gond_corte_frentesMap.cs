using System.ComponentModel.DataAnnotations.Schema;
using System.Data.Entity.ModelConfiguration;

namespace WBCCAD.Model.Models.Mapping
{
    public class gond_corte_frentesMap : EntityTypeConfiguration<gond_corte_frentes>
    {
        public gond_corte_frentesMap()
        {
            // Primary Key
            this.HasKey(t => t.idGondCorteFrentes);

            // Properties
            this.Property(t => t.frentes)
                .HasMaxLength(30);

            // Table & Column Mappings
            this.ToTable("gond_corte_frentes");
            this.Property(t => t.idcorte).HasColumnName("idcorte");
            this.Property(t => t.frentes).HasColumnName("frentes");
            this.Property(t => t.idGondCorteFrentes).HasColumnName("idGondCorteFrentes");
        }
    }
}
