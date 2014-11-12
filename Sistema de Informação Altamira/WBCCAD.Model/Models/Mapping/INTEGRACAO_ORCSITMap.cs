using System.ComponentModel.DataAnnotations.Schema;
using System.Data.Entity.ModelConfiguration;

namespace WBCCAD.Model.Models.Mapping
{
    public class INTEGRACAO_ORCSITMap : EntityTypeConfiguration<INTEGRACAO_ORCSIT>
    {
        public INTEGRACAO_ORCSITMap()
        {
            // Primary Key
            this.HasKey(t => t.idIntegracao_OrcSit);

            // Properties
            this.Property(t => t.ORCNUM)
                .HasMaxLength(8);

            // Table & Column Mappings
            this.ToTable("INTEGRACAO_ORCSIT");
            this.Property(t => t.ORCNUM).HasColumnName("ORCNUM");
            this.Property(t => t.SITCOD).HasColumnName("SITCOD");
            this.Property(t => t.ORCALTDTH).HasColumnName("ORCALTDTH");
            this.Property(t => t.idIntegracao_OrcSit).HasColumnName("idIntegracao_OrcSit");
        }
    }
}
