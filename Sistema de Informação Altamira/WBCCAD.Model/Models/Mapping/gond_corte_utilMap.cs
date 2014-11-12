using System.ComponentModel.DataAnnotations.Schema;
using System.Data.Entity.ModelConfiguration;

namespace WBCCAD.Model.Models.Mapping
{
    public class gond_corte_utilMap : EntityTypeConfiguration<gond_corte_util>
    {
        public gond_corte_utilMap()
        {
            // Primary Key
            this.HasKey(t => t.idGondCorteUtil);

            // Properties
            this.Property(t => t.util)
                .HasMaxLength(50);

            // Table & Column Mappings
            this.ToTable("gond_corte_util");
            this.Property(t => t.idcorte).HasColumnName("idcorte");
            this.Property(t => t.util).HasColumnName("util");
            this.Property(t => t.idGondCorteUtil).HasColumnName("idGondCorteUtil");
        }
    }
}
