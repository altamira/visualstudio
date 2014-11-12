using System.ComponentModel.DataAnnotations.Schema;
using System.Data.Entity.ModelConfiguration;

namespace WBCCAD.Model.Models.Mapping
{
    public class INTEGRACAO_ORCPRDMap : EntityTypeConfiguration<INTEGRACAO_ORCPRD>
    {
        public INTEGRACAO_ORCPRDMap()
        {
            // Primary Key
            this.HasKey(t => t.idIntegracao_OrcPrd);

            // Properties
            this.Property(t => t.ORCNUM)
                .HasMaxLength(8);

            this.Property(t => t.PRDCOD)
                .HasMaxLength(80);

            this.Property(t => t.CORCOD)
                .HasMaxLength(20);

            this.Property(t => t.PRDDSC)
                .HasMaxLength(70);

            // Table & Column Mappings
            this.ToTable("INTEGRACAO_ORCPRD");
            this.Property(t => t.ORCNUM).HasColumnName("ORCNUM");
            this.Property(t => t.GRPCOD).HasColumnName("GRPCOD");
            this.Property(t => t.SUBGRPCOD).HasColumnName("SUBGRPCOD");
            this.Property(t => t.ORCITM).HasColumnName("ORCITM");
            this.Property(t => t.PRDCOD).HasColumnName("PRDCOD");
            this.Property(t => t.CORCOD).HasColumnName("CORCOD");
            this.Property(t => t.PRDDSC).HasColumnName("PRDDSC");
            this.Property(t => t.ORCQTD).HasColumnName("ORCQTD");
            this.Property(t => t.ORCTOT).HasColumnName("ORCTOT");
            this.Property(t => t.ORCPES).HasColumnName("ORCPES");
            this.Property(t => t.idIntegracao_OrcPrd).HasColumnName("idIntegracao_OrcPrd");
        }
    }
}
