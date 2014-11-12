using System.ComponentModel.DataAnnotations.Schema;
using System.Data.Entity.ModelConfiguration;

namespace WBCCAD.Model.Models.Mapping
{
    public class gab_utilMap : EntityTypeConfiguration<gab_util>
    {
        public gab_utilMap()
        {
            // Primary Key
            this.HasKey(t => t.indice);

            // Properties
            this.Property(t => t.utilizacao)
                .HasMaxLength(40);

            // Table & Column Mappings
            this.ToTable("gab_util");
            this.Property(t => t.indice).HasColumnName("indice");
            this.Property(t => t.utilizacao).HasColumnName("utilizacao");
        }
    }
}
