using System.ComponentModel.DataAnnotations.Schema;
using System.Data.Entity.ModelConfiguration;

namespace WBCCAD.Model.Models.Mapping
{
    public class gab_medgabMap : EntityTypeConfiguration<gab_medgab>
    {
        public gab_medgabMap()
        {
            // Primary Key
            this.HasKey(t => t.indice);

            // Properties
            this.Property(t => t.tipo)
                .HasMaxLength(50);

            // Table & Column Mappings
            this.ToTable("gab_medgab");
            this.Property(t => t.indice).HasColumnName("indice");
            this.Property(t => t.medida).HasColumnName("medida");
            this.Property(t => t.tipo).HasColumnName("tipo");
        }
    }
}
