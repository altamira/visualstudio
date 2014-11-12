using System.ComponentModel.DataAnnotations.Schema;
using System.Data.Entity.ModelConfiguration;

namespace WBCCAD.Model.Models.Mapping
{
    public class OrcVarUsrMap : EntityTypeConfiguration<OrcVarUsr>
    {
        public OrcVarUsrMap()
        {
            // Primary Key
            this.HasKey(t => t.idOrcVarUsr);

            // Properties
            this.Property(t => t.numeroOrcamento)
                .IsRequired()
                .IsFixedLength()
                .HasMaxLength(9);

            this.Property(t => t.varusrcodigo)
                .HasMaxLength(50);

            this.Property(t => t.varusrvalor)
                .HasMaxLength(255);

            // Table & Column Mappings
            this.ToTable("OrcVarUsr");
            this.Property(t => t.idOrcVarUsr).HasColumnName("idOrcVarUsr");
            this.Property(t => t.numeroOrcamento).HasColumnName("numeroOrcamento");
            this.Property(t => t.varusrcodigo).HasColumnName("varusrcodigo");
            this.Property(t => t.varusrvalor).HasColumnName("varusrvalor");
            this.Property(t => t.RECALCULAR).HasColumnName("RECALCULAR");
        }
    }
}
