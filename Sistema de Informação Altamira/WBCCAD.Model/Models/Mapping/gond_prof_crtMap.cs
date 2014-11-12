using System.ComponentModel.DataAnnotations.Schema;
using System.Data.Entity.ModelConfiguration;

namespace WBCCAD.Model.Models.Mapping
{
    public class gond_prof_crtMap : EntityTypeConfiguration<gond_prof_crt>
    {
        public gond_prof_crtMap()
        {
            // Primary Key
            this.HasKey(t => t.idGondProfCrt);

            // Properties
            // Table & Column Mappings
            this.ToTable("gond_prof_crt");
            this.Property(t => t.profundidade).HasColumnName("profundidade");
            this.Property(t => t.idcorte).HasColumnName("idcorte");
            this.Property(t => t.idGondProfCrt).HasColumnName("idGondProfCrt");
        }
    }
}
