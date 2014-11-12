using System.ComponentModel.DataAnnotations.Schema;
using System.Data.Entity.ModelConfiguration;

namespace WBCCAD.Model.Models.Mapping
{
    public class gen_temp_evaporacaoMap : EntityTypeConfiguration<gen_temp_evaporacao>
    {
        public gen_temp_evaporacaoMap()
        {
            // Primary Key
            this.HasKey(t => t.indice);

            // Properties
            this.Property(t => t.Regime)
                .HasMaxLength(50);

            // Table & Column Mappings
            this.ToTable("gen_temp_evaporacao");
            this.Property(t => t.indice).HasColumnName("indice");
            this.Property(t => t.evaporacao).HasColumnName("evaporacao");
            this.Property(t => t.Regime).HasColumnName("Regime");
        }
    }
}
