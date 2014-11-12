using System.ComponentModel.DataAnnotations.Schema;
using System.Data.Entity.ModelConfiguration;

namespace WBCCAD.Model.Models.Mapping
{
    public class gond_rest_comprMap : EntityTypeConfiguration<gond_rest_compr>
    {
        public gond_rest_comprMap()
        {
            // Primary Key
            this.HasKey(t => t.idGondRestCompr);

            // Properties
            // Table & Column Mappings
            this.ToTable("gond_rest_compr");
            this.Property(t => t.id_restricao).HasColumnName("id_restricao");
            this.Property(t => t.comprimento).HasColumnName("comprimento");
            this.Property(t => t.idGondRestCompr).HasColumnName("idGondRestCompr");
        }
    }
}
