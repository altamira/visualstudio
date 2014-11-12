using System.ComponentModel.DataAnnotations.Schema;
using System.Data.Entity.ModelConfiguration;

namespace WBCCAD.Model.Models.Mapping
{
    public class mez_tipo_cargasMap : EntityTypeConfiguration<mez_tipo_cargas>
    {
        public mez_tipo_cargasMap()
        {
            // Primary Key
            this.HasKey(t => t.id);

            // Properties
            this.Property(t => t.carga)
                .HasMaxLength(50);

            this.Property(t => t.id)
                .HasDatabaseGeneratedOption(DatabaseGeneratedOption.None);

            // Table & Column Mappings
            this.ToTable("mez_tipo_cargas");
            this.Property(t => t.carga).HasColumnName("carga");
            this.Property(t => t.id).HasColumnName("id");
        }
    }
}
