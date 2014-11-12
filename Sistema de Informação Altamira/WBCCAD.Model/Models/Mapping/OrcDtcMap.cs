using System.ComponentModel.DataAnnotations.Schema;
using System.Data.Entity.ModelConfiguration;

namespace WBCCAD.Model.Models.Mapping
{
    public class OrcDtcMap : EntityTypeConfiguration<OrcDtc>
    {
        public OrcDtcMap()
        {
            // Primary Key
            this.HasKey(t => t.idOrcDtc);

            // Properties
            this.Property(t => t.numeroOrcamento)
                .IsRequired()
                .IsFixedLength()
                .HasMaxLength(9);

            this.Property(t => t.ORCDTCSUBGRUPO)
                .HasMaxLength(2);

            this.Property(t => t.ORCDTCCORTE)
                .HasMaxLength(50);

            this.Property(t => t.orcdtcitem)
                .HasMaxLength(20);

            // Table & Column Mappings
            this.ToTable("OrcDtc");
            this.Property(t => t.numeroOrcamento).HasColumnName("numeroOrcamento");
            this.Property(t => t.ORCDTCGRUPO).HasColumnName("ORCDTCGRUPO");
            this.Property(t => t.ORCDTCSUBGRUPO).HasColumnName("ORCDTCSUBGRUPO");
            this.Property(t => t.ORCDTCCORTE).HasColumnName("ORCDTCCORTE");
            this.Property(t => t.ORCDTCID).HasColumnName("ORCDTCID");
            this.Property(t => t.ORCDTCDTC).HasColumnName("ORCDTCDTC");
            this.Property(t => t.idOrcDtc).HasColumnName("idOrcDtc");
            this.Property(t => t.orcdtcids).HasColumnName("orcdtcids");
            this.Property(t => t.orcdtcitem).HasColumnName("orcdtcitem");
        }
    }
}
