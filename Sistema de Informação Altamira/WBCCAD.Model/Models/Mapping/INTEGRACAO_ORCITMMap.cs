using System.ComponentModel.DataAnnotations.Schema;
using System.Data.Entity.ModelConfiguration;

namespace WBCCAD.Model.Models.Mapping
{
    public class INTEGRACAO_ORCITMMap : EntityTypeConfiguration<INTEGRACAO_ORCITM>
    {
        public INTEGRACAO_ORCITMMap()
        {
            // Primary Key
            this.HasKey(t => t.idIntegracao_OrcItm);

            // Properties
            this.Property(t => t.ORCNUM)
                .HasMaxLength(8);

            this.Property(t => t.ORCPRDCOD)
                .IsFixedLength()
                .HasMaxLength(60);

            this.Property(t => t.ORCTXT)
                .HasMaxLength(5000);

            // Table & Column Mappings
            this.ToTable("INTEGRACAO_ORCITM");
            this.Property(t => t.ORCNUM).HasColumnName("ORCNUM");
            this.Property(t => t.GRPCOD).HasColumnName("GRPCOD");
            this.Property(t => t.SUBGRPCOD).HasColumnName("SUBGRPCOD");
            this.Property(t => t.ORCITM).HasColumnName("ORCITM");
            this.Property(t => t.ORCPRDCOD).HasColumnName("ORCPRDCOD");
            this.Property(t => t.ORCPRDQTD).HasColumnName("ORCPRDQTD");
            this.Property(t => t.ORCTXT).HasColumnName("ORCTXT");
            this.Property(t => t.ORCVAL).HasColumnName("ORCVAL");
            this.Property(t => t.ORCIPI).HasColumnName("ORCIPI");
            this.Property(t => t.ORCICM).HasColumnName("ORCICM");
            this.Property(t => t.idIntegracao_OrcItm).HasColumnName("idIntegracao_OrcItm");
        }
    }
}
