using System.ComponentModel.DataAnnotations.Schema;
using System.Data.Entity.ModelConfiguration;

namespace WBCCAD.Model.Models.Mapping
{
    public class gab_gabutlMap : EntityTypeConfiguration<gab_gabutl>
    {
        public gab_gabutlMap()
        {
            // Primary Key
            this.HasKey(t => t.idGabGabutl);

            // Properties
            this.Property(t => t.gabinete)
                .HasMaxLength(20);

            this.Property(t => t.utilizacao)
                .HasMaxLength(40);

            // Table & Column Mappings
            this.ToTable("gab_gabutl");
            this.Property(t => t.gabinete).HasColumnName("gabinete");
            this.Property(t => t.utilizacao).HasColumnName("utilizacao");
            this.Property(t => t.idGabGabutl).HasColumnName("idGabGabutl");
        }
    }
}
