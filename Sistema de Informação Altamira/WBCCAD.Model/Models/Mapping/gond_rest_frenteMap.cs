using System.ComponentModel.DataAnnotations.Schema;
using System.Data.Entity.ModelConfiguration;

namespace WBCCAD.Model.Models.Mapping
{
    public class gond_rest_frenteMap : EntityTypeConfiguration<gond_rest_frente>
    {
        public gond_rest_frenteMap()
        {
            // Primary Key
            this.HasKey(t => t.idGondRestFrente);

            // Properties
            this.Property(t => t.frente)
                .HasMaxLength(50);

            // Table & Column Mappings
            this.ToTable("gond_rest_frente");
            this.Property(t => t.id_restricao).HasColumnName("id_restricao");
            this.Property(t => t.frente).HasColumnName("frente");
            this.Property(t => t.idGondRestFrente).HasColumnName("idGondRestFrente");
        }
    }
}
