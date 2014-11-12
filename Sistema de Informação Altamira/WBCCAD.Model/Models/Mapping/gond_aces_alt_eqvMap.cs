using System.ComponentModel.DataAnnotations.Schema;
using System.Data.Entity.ModelConfiguration;

namespace WBCCAD.Model.Models.Mapping
{
    public class gond_aces_alt_eqvMap : EntityTypeConfiguration<gond_aces_alt_eqv>
    {
        public gond_aces_alt_eqvMap()
        {
            // Primary Key
            this.HasKey(t => t.idGondAcesAltEqv);

            // Properties
            this.Property(t => t.acessorio)
                .HasMaxLength(50);

            this.Property(t => t.altura_gond)
                .HasMaxLength(50);

            this.Property(t => t.altura_real)
                .HasMaxLength(50);

            // Table & Column Mappings
            this.ToTable("gond_aces_alt_eqv");
            this.Property(t => t.acessorio).HasColumnName("acessorio");
            this.Property(t => t.altura_gond).HasColumnName("altura_gond");
            this.Property(t => t.altura_real).HasColumnName("altura_real");
            this.Property(t => t.idGondAcesAltEqv).HasColumnName("idGondAcesAltEqv");
        }
    }
}
