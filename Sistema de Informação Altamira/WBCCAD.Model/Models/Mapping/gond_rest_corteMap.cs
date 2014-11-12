using System.ComponentModel.DataAnnotations.Schema;
using System.Data.Entity.ModelConfiguration;

namespace WBCCAD.Model.Models.Mapping
{
    public class gond_rest_corteMap : EntityTypeConfiguration<gond_rest_corte>
    {
        public gond_rest_corteMap()
        {
            // Primary Key
            this.HasKey(t => t.idGondRestCorte);

            // Properties
            // Table & Column Mappings
            this.ToTable("gond_rest_corte");
            this.Property(t => t.id_restricao).HasColumnName("id_restricao");
            this.Property(t => t.id_corte).HasColumnName("id_corte");
            this.Property(t => t.idGondRestCorte).HasColumnName("idGondRestCorte");
        }
    }
}
