using System.ComponentModel.DataAnnotations.Schema;
using System.Data.Entity.ModelConfiguration;

namespace WBCCAD.Model.Models.Mapping
{
    public class gond_rel_compr_pta_prof_ptaMap : EntityTypeConfiguration<gond_rel_compr_pta_prof_pta>
    {
        public gond_rel_compr_pta_prof_ptaMap()
        {
            // Primary Key
            this.HasKey(t => t.idGondRelComprPtaProfPta);

            // Properties
            // Table & Column Mappings
            this.ToTable("gond_rel_compr_pta_prof_pta");
            this.Property(t => t.compr_pta).HasColumnName("compr_pta");
            this.Property(t => t.prof_pta).HasColumnName("prof_pta");
            this.Property(t => t.idGondRelComprPtaProfPta).HasColumnName("idGondRelComprPtaProfPta");
        }
    }
}
