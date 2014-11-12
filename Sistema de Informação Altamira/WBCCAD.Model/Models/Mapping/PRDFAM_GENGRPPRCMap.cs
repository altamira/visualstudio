using System.ComponentModel.DataAnnotations.Schema;
using System.Data.Entity.ModelConfiguration;

namespace WBCCAD.Model.Models.Mapping
{
    public class PRDFAM_GENGRPPRCMap : EntityTypeConfiguration<PRDFAM_GENGRPPRC>
    {
        public PRDFAM_GENGRPPRCMap()
        {
            // Primary Key
            this.HasKey(t => t.idPrdfamGengrpprc);

            // Properties
            this.Property(t => t.FAMILIA)
                .HasMaxLength(30);

            this.Property(t => t.GenGrpPrecoCodigo)
                .HasMaxLength(50);

            // Table & Column Mappings
            this.ToTable("PRDFAM_GENGRPPRC");
            this.Property(t => t.FAMILIA).HasColumnName("FAMILIA");
            this.Property(t => t.GenGrpPrecoCodigo).HasColumnName("GenGrpPrecoCodigo");
            this.Property(t => t.FATOR).HasColumnName("FATOR");
            this.Property(t => t.idPrdfamGengrpprc).HasColumnName("idPrdfamGengrpprc");
        }
    }
}
