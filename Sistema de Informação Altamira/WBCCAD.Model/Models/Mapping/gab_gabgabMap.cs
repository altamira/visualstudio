using System.ComponentModel.DataAnnotations.Schema;
using System.Data.Entity.ModelConfiguration;

namespace WBCCAD.Model.Models.Mapping
{
    public class gab_gabgabMap : EntityTypeConfiguration<gab_gabgab>
    {
        public gab_gabgabMap()
        {
            // Primary Key
            this.HasKey(t => t.idGabGabgab);

            // Properties
            this.Property(t => t.corte)
                .HasMaxLength(20);

            this.Property(t => t.corte_compativel)
                .HasMaxLength(20);

            // Table & Column Mappings
            this.ToTable("gab_gabgab");
            this.Property(t => t.corte).HasColumnName("corte");
            this.Property(t => t.corte_compativel).HasColumnName("corte_compativel");
            this.Property(t => t.idGabGabgab).HasColumnName("idGabGabgab");
        }
    }
}
