using System.ComponentModel.DataAnnotations.Schema;
using System.Data.Entity.ModelConfiguration;

namespace WBCCAD.Model.Models.Mapping
{
    public class mob_aces_restMap : EntityTypeConfiguration<mob_aces_rest>
    {
        public mob_aces_restMap()
        {
            // Primary Key
            this.HasKey(t => t.idMobAcesRest);

            // Properties
            this.Property(t => t.acessorio)
                .HasMaxLength(50);

            this.Property(t => t.acessorio_rest)
                .HasMaxLength(50);

            // Table & Column Mappings
            this.ToTable("mob_aces_rest");
            this.Property(t => t.acessorio).HasColumnName("acessorio");
            this.Property(t => t.acessorio_rest).HasColumnName("acessorio_rest");
            this.Property(t => t.idMobAcesRest).HasColumnName("idMobAcesRest");
        }
    }
}
