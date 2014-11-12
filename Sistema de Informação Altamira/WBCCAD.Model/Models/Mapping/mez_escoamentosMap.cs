using System.ComponentModel.DataAnnotations.Schema;
using System.Data.Entity.ModelConfiguration;

namespace WBCCAD.Model.Models.Mapping
{
    public class mez_escoamentosMap : EntityTypeConfiguration<mez_escoamentos>
    {
        public mez_escoamentosMap()
        {
            // Primary Key
            this.HasKey(t => t.id);

            // Properties
            this.Property(t => t.escoamento)
                .HasMaxLength(50);

            this.Property(t => t.id)
                .HasDatabaseGeneratedOption(DatabaseGeneratedOption.None);

            // Table & Column Mappings
            this.ToTable("mez_escoamentos");
            this.Property(t => t.escoamento).HasColumnName("escoamento");
            this.Property(t => t.id).HasColumnName("id");
        }
    }
}
