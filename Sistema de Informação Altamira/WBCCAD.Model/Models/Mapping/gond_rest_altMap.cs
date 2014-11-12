using System.ComponentModel.DataAnnotations.Schema;
using System.Data.Entity.ModelConfiguration;

namespace WBCCAD.Model.Models.Mapping
{
    public class gond_rest_altMap : EntityTypeConfiguration<gond_rest_alt>
    {
        public gond_rest_altMap()
        {
            // Primary Key
            this.HasKey(t => t.idGondRestAlt);

            // Properties
            // Table & Column Mappings
            this.ToTable("gond_rest_alt");
            this.Property(t => t.id_restricao).HasColumnName("id_restricao");
            this.Property(t => t.altura).HasColumnName("altura");
            this.Property(t => t.idGondRestAlt).HasColumnName("idGondRestAlt");
        }
    }
}
