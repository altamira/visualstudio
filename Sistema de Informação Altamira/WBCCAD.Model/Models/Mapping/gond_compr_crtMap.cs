using System.ComponentModel.DataAnnotations.Schema;
using System.Data.Entity.ModelConfiguration;

namespace WBCCAD.Model.Models.Mapping
{
    public class gond_compr_crtMap : EntityTypeConfiguration<gond_compr_crt>
    {
        public gond_compr_crtMap()
        {
            // Primary Key
            this.HasKey(t => t.idGondComprCrt);

            // Properties
            // Table & Column Mappings
            this.ToTable("gond_compr_crt");
            this.Property(t => t.comprimento).HasColumnName("comprimento");
            this.Property(t => t.idcorte).HasColumnName("idcorte");
            this.Property(t => t.idGondComprCrt).HasColumnName("idGondComprCrt");
        }
    }
}
