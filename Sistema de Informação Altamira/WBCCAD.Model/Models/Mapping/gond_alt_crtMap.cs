using System.ComponentModel.DataAnnotations.Schema;
using System.Data.Entity.ModelConfiguration;

namespace WBCCAD.Model.Models.Mapping
{
    public class gond_alt_crtMap : EntityTypeConfiguration<gond_alt_crt>
    {
        public gond_alt_crtMap()
        {
            // Primary Key
            this.HasKey(t => t.idGondAltCrt);

            // Properties
            // Table & Column Mappings
            this.ToTable("gond_alt_crt");
            this.Property(t => t.Altura).HasColumnName("Altura");
            this.Property(t => t.idcorte).HasColumnName("idcorte");
            this.Property(t => t.idGondAltCrt).HasColumnName("idGondAltCrt");
        }
    }
}
