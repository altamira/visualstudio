using System.ComponentModel.DataAnnotations.Schema;
using System.Data.Entity.ModelConfiguration;

namespace WBCCAD.Model.Models.Mapping
{
    public class INTEGRACAO_ORCINDMap : EntityTypeConfiguration<INTEGRACAO_ORCIND>
    {
        public INTEGRACAO_ORCINDMap()
        {
            // Primary Key
            this.HasKey(t => t.idIntegracao_OrcInd);

            // Properties
            this.Property(t => t.ORCNUM)
                .HasMaxLength(8);

            this.Property(t => t.TIPINDCOD)
                .HasMaxLength(20);

            // Table & Column Mappings
            this.ToTable("INTEGRACAO_ORCIND");
            this.Property(t => t.ORCNUM).HasColumnName("ORCNUM");
            this.Property(t => t.TIPINDCOD).HasColumnName("TIPINDCOD");
            this.Property(t => t.ORCVAL).HasColumnName("ORCVAL");
            this.Property(t => t.idIntegracao_OrcInd).HasColumnName("idIntegracao_OrcInd");
        }
    }
}
