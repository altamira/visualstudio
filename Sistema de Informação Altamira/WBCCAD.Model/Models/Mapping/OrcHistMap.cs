using System.ComponentModel.DataAnnotations.Schema;
using System.Data.Entity.ModelConfiguration;

namespace WBCCAD.Model.Models.Mapping
{
    public class OrcHistMap : EntityTypeConfiguration<OrcHist>
    {
        public OrcHistMap()
        {
            // Primary Key
            this.HasKey(t => t.idOrcHist);

            // Properties
            this.Property(t => t.numeroOrcamento)
                .IsFixedLength()
                .HasMaxLength(9);

            this.Property(t => t.orchist_historico)
                .HasMaxLength(255);

            // Table & Column Mappings
            this.ToTable("OrcHist");
            this.Property(t => t.idOrcHist).HasColumnName("idOrcHist");
            this.Property(t => t.numeroOrcamento).HasColumnName("numeroOrcamento");
            this.Property(t => t.orchist_historico).HasColumnName("orchist_historico");
        }
    }
}
