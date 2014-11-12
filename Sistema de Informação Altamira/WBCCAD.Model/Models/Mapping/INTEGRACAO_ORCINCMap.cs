using System.ComponentModel.DataAnnotations.Schema;
using System.Data.Entity.ModelConfiguration;

namespace WBCCAD.Model.Models.Mapping
{
    public class INTEGRACAO_ORCINCMap : EntityTypeConfiguration<INTEGRACAO_ORCINC>
    {
        public INTEGRACAO_ORCINCMap()
        {
            // Primary Key
            this.HasKey(t => t.ORCNUM);

            // Properties
            this.Property(t => t.ORCNUM)
                .IsRequired()
                .HasMaxLength(8);

            this.Property(t => t.CLINOM)
                .HasMaxLength(50);

            this.Property(t => t.CLIEND)
                .HasMaxLength(50);

            this.Property(t => t.CLIFON)
                .HasMaxLength(20);

            this.Property(t => t.CLIFAX)
                .HasMaxLength(20);

            this.Property(t => t.CLIEMA)
                .HasMaxLength(70);

            this.Property(t => t.CLICON)
                .HasMaxLength(40);

            this.Property(t => t.USRCOD)
                .HasMaxLength(20);

            this.Property(t => t.ESTCOD)
                .HasMaxLength(2);

            this.Property(t => t.TIPVNDCOD)
                .HasMaxLength(50);

            this.Property(t => t.REPCOD)
                .HasMaxLength(20);

            this.Property(t => t.ACADSC)
                .HasMaxLength(50);

            this.Property(t => t.CLIMUN)
                .HasMaxLength(50);

            // Table & Column Mappings
            this.ToTable("INTEGRACAO_ORCINC");
            this.Property(t => t.ORCNUM).HasColumnName("ORCNUM");
            this.Property(t => t.ORCDAT).HasColumnName("ORCDAT");
            this.Property(t => t.CLINOM).HasColumnName("CLINOM");
            this.Property(t => t.CLIEND).HasColumnName("CLIEND");
            this.Property(t => t.CLIFON).HasColumnName("CLIFON");
            this.Property(t => t.CLIFAX).HasColumnName("CLIFAX");
            this.Property(t => t.CLIEMA).HasColumnName("CLIEMA");
            this.Property(t => t.CLICON).HasColumnName("CLICON");
            this.Property(t => t.USRCOD).HasColumnName("USRCOD");
            this.Property(t => t.ESTCOD).HasColumnName("ESTCOD");
            this.Property(t => t.TIPVNDCOD).HasColumnName("TIPVNDCOD");
            this.Property(t => t.REPCOD).HasColumnName("REPCOD");
            this.Property(t => t.ACADSC).HasColumnName("ACADSC");
            this.Property(t => t.CLIMUN).HasColumnName("CLIMUN");
        }
    }
}
