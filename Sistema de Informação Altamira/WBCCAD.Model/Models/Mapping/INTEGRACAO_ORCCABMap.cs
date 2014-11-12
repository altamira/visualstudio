using System.ComponentModel.DataAnnotations.Schema;
using System.Data.Entity.ModelConfiguration;

namespace WBCCAD.Model.Models.Mapping
{
    public class INTEGRACAO_ORCCABMap : EntityTypeConfiguration<INTEGRACAO_ORCCAB>
    {
        public INTEGRACAO_ORCCABMap()
        {
            // Primary Key
            this.HasKey(t => t.idIntegracao_OrcCab);

            // Properties
            this.Property(t => t.ORCNUM)
                .HasMaxLength(8);

            this.Property(t => t.REPCOD)
                .HasMaxLength(20);

            this.Property(t => t.CLINOM)
                .HasMaxLength(50);

            this.Property(t => t.CLICON)
                .HasMaxLength(50);

            this.Property(t => t.TIPMONCOD)
                .HasMaxLength(255);

            // Table & Column Mappings
            this.ToTable("INTEGRACAO_ORCCAB");
            this.Property(t => t.ORCNUM).HasColumnName("ORCNUM");
            this.Property(t => t.SITCOD).HasColumnName("SITCOD");
            this.Property(t => t.ORCALTDTH).HasColumnName("ORCALTDTH");
            this.Property(t => t.ORCVALVND).HasColumnName("ORCVALVND");
            this.Property(t => t.ORCVALLST).HasColumnName("ORCVALLST");
            this.Property(t => t.ORCVALINV).HasColumnName("ORCVALINV");
            this.Property(t => t.ORCVALLUC).HasColumnName("ORCVALLUC");
            this.Property(t => t.ORCVALEXP).HasColumnName("ORCVALEXP");
            this.Property(t => t.ORCVALCOM).HasColumnName("ORCVALCOM");
            this.Property(t => t.ORCPERCOM).HasColumnName("ORCPERCOM");
            this.Property(t => t.REPCOD).HasColumnName("REPCOD");
            this.Property(t => t.CLICOD).HasColumnName("CLICOD");
            this.Property(t => t.CLINOM).HasColumnName("CLINOM");
            this.Property(t => t.CLICONCOD).HasColumnName("CLICONCOD");
            this.Property(t => t.CLICON).HasColumnName("CLICON");
            this.Property(t => t.ORCVALTRP).HasColumnName("ORCVALTRP");
            this.Property(t => t.ORCVALEMB).HasColumnName("ORCVALEMB");
            this.Property(t => t.ORCVALMON).HasColumnName("ORCVALMON");
            this.Property(t => t.PGTCOD).HasColumnName("PGTCOD");
            this.Property(t => t.TIPMONCOD).HasColumnName("TIPMONCOD");
            this.Property(t => t.PRZENT).HasColumnName("PRZENT");
            this.Property(t => t.ORCBAS1).HasColumnName("ORCBAS1");
            this.Property(t => t.ORCBAS2).HasColumnName("ORCBAS2");
            this.Property(t => t.ORCBAS3).HasColumnName("ORCBAS3");
            this.Property(t => t.ORCPGT).HasColumnName("ORCPGT");
            this.Property(t => t.idIntegracao_OrcCab).HasColumnName("idIntegracao_OrcCab");
        }
    }
}
