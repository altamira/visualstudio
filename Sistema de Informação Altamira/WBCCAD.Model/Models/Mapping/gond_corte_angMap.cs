using System.ComponentModel.DataAnnotations.Schema;
using System.Data.Entity.ModelConfiguration;

namespace WBCCAD.Model.Models.Mapping
{
    public class gond_corte_angMap : EntityTypeConfiguration<gond_corte_ang>
    {
        public gond_corte_angMap()
        {
            // Primary Key
            this.HasKey(t => t.idGondCorteAng);

            // Properties
            this.Property(t => t.angulo)
                .HasMaxLength(50);

            // Table & Column Mappings
            this.ToTable("gond_corte_ang");
            this.Property(t => t.idcorte).HasColumnName("idcorte");
            this.Property(t => t.angulo).HasColumnName("angulo");
            this.Property(t => t.idGondCorteAng).HasColumnName("idGondCorteAng");
        }
    }
}
