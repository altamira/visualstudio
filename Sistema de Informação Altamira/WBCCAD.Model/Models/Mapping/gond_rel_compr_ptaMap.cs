using System.ComponentModel.DataAnnotations.Schema;
using System.Data.Entity.ModelConfiguration;

namespace WBCCAD.Model.Models.Mapping
{
    public class gond_rel_compr_ptaMap : EntityTypeConfiguration<gond_rel_compr_pta>
    {
        public gond_rel_compr_ptaMap()
        {
            // Primary Key
            this.HasKey(t => t.idGondRelComprPta);

            // Properties
            this.Property(t => t.base_gond)
                .HasMaxLength(30);

            // Table & Column Mappings
            this.ToTable("gond_rel_compr_pta");
            this.Property(t => t.prof_gond).HasColumnName("prof_gond");
            this.Property(t => t.compr_ponta).HasColumnName("compr_ponta");
            this.Property(t => t.base_gond).HasColumnName("base_gond");
            this.Property(t => t.idGondRelComprPta).HasColumnName("idGondRelComprPta");
        }
    }
}
