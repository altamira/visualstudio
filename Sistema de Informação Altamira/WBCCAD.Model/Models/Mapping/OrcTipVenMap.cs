using System.ComponentModel.DataAnnotations.Schema;
using System.Data.Entity.ModelConfiguration;

namespace WBCCAD.Model.Models.Mapping
{
    public class OrcTipVenMap : EntityTypeConfiguration<OrcTipVen>
    {
        public OrcTipVenMap()
        {
            // Primary Key
            this.HasKey(t => t.idOrcTipVen);

            // Properties
            this.Property(t => t.TIPOVENDA)
                .HasMaxLength(50);

            this.Property(t => t.numeroOrcamento)
                .HasMaxLength(50);

            // Table & Column Mappings
            this.ToTable("OrcTipVen");
            this.Property(t => t.PRDGRP_GRUPO).HasColumnName("PRDGRP_GRUPO");
            this.Property(t => t.TIPOVENDA).HasColumnName("TIPOVENDA");
            this.Property(t => t.numeroOrcamento).HasColumnName("numeroOrcamento");
            this.Property(t => t.idOrcTipVen).HasColumnName("idOrcTipVen");
        }
    }
}
