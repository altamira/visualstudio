using System.ComponentModel.DataAnnotations.Schema;
using System.Data.Entity.ModelConfiguration;

namespace WBCCAD.Model.Models.Mapping
{
    public class ORCVARPRJMap : EntityTypeConfiguration<ORCVARPRJ>
    {
        public ORCVARPRJMap()
        {
            // Primary Key
            this.HasKey(t => new { t.ORCVARPRJ_VARIAVEL, t.numeroOrcamento });

            // Properties
            this.Property(t => t.idORCVARPRJ)
                .HasDatabaseGeneratedOption(DatabaseGeneratedOption.Identity);

            this.Property(t => t.ORCVARPRJ_VARIAVEL)
                .IsRequired()
                .HasMaxLength(30);

            this.Property(t => t.numeroOrcamento)
                .IsRequired()
                .HasMaxLength(9);

            // Table & Column Mappings
            this.ToTable("ORCVARPRJ");
            this.Property(t => t.idORCVARPRJ).HasColumnName("idORCVARPRJ");
            this.Property(t => t.ORCVARPRJ_VARIAVEL).HasColumnName("ORCVARPRJ_VARIAVEL");
            this.Property(t => t.ORCVARPRJ_VALOR).HasColumnName("ORCVARPRJ_VALOR");
            this.Property(t => t.numeroOrcamento).HasColumnName("numeroOrcamento");
        }
    }
}
