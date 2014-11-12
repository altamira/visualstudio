using System.ComponentModel.DataAnnotations.Schema;
using System.Data.Entity.ModelConfiguration;

namespace WBCCAD.Model.Models.Mapping
{
    public class mez_inerciasMap : EntityTypeConfiguration<mez_inercias>
    {
        public mez_inerciasMap()
        {
            // Primary Key
            this.HasKey(t => t.id);

            // Properties
            this.Property(t => t.inercia)
                .HasMaxLength(50);

            this.Property(t => t.id)
                .HasDatabaseGeneratedOption(DatabaseGeneratedOption.None);

            // Table & Column Mappings
            this.ToTable("mez_inercias");
            this.Property(t => t.inercia).HasColumnName("inercia");
            this.Property(t => t.id).HasColumnName("id");
        }
    }
}
