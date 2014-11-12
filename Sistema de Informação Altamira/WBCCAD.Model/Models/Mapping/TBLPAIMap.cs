using System.ComponentModel.DataAnnotations.Schema;
using System.Data.Entity.ModelConfiguration;

namespace WBCCAD.Model.Models.Mapping
{
    public class TBLPAIMap : EntityTypeConfiguration<TBLPAI>
    {
        public TBLPAIMap()
        {
            // Primary Key
            this.HasKey(t => t.idTBLPAIS);

            // Properties
            this.Property(t => t.PAISCODIGO)
                .HasMaxLength(5);

            this.Property(t => t.PAISDESCRICAO)
                .HasMaxLength(50);

            // Table & Column Mappings
            this.ToTable("TBLPAIS");
            this.Property(t => t.PAISCODIGO).HasColumnName("PAISCODIGO");
            this.Property(t => t.PAISDESCRICAO).HasColumnName("PAISDESCRICAO");
            this.Property(t => t.idTBLPAIS).HasColumnName("idTBLPAIS");
        }
    }
}
