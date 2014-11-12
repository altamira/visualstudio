using System.ComponentModel.DataAnnotations.Schema;
using System.Data.Entity.ModelConfiguration;

namespace WBCCAD.Model.Models.Mapping
{
    public class gond_rest_angMap : EntityTypeConfiguration<gond_rest_ang>
    {
        public gond_rest_angMap()
        {
            // Primary Key
            this.HasKey(t => t.idGondRestAng);

            // Properties
            this.Property(t => t.angulo)
                .HasMaxLength(30);

            // Table & Column Mappings
            this.ToTable("gond_rest_ang");
            this.Property(t => t.id_restricao).HasColumnName("id_restricao");
            this.Property(t => t.angulo).HasColumnName("angulo");
            this.Property(t => t.idGondRestAng).HasColumnName("idGondRestAng");
        }
    }
}
