using System.ComponentModel.DataAnnotations.Schema;
using System.Data.Entity.ModelConfiguration;

namespace WBCCAD.Model.Models.Mapping
{
    public class OrcMatDetAdicionalMap : EntityTypeConfiguration<OrcMatDetAdicional>
    {
        public OrcMatDetAdicionalMap()
        {
            // Primary Key
            this.HasKey(t => t.idOrcMatDetAdicional);

            // Properties
            this.Property(t => t.chave)
                .HasMaxLength(255);

            this.Property(t => t.numeroOrcamento)
                .IsFixedLength()
                .HasMaxLength(9);

            // Table & Column Mappings
            this.ToTable("OrcMatDetAdicional");
            this.Property(t => t.idOrcMatDetAdicional).HasColumnName("idOrcMatDetAdicional");
            this.Property(t => t.idOrcMatDet).HasColumnName("idOrcMatDet");
            this.Property(t => t.chave).HasColumnName("chave");
            this.Property(t => t.@base).HasColumnName("base");
            this.Property(t => t.fator).HasColumnName("fator");
            this.Property(t => t.redutor).HasColumnName("redutor");
            this.Property(t => t.valor).HasColumnName("valor");
            this.Property(t => t.markup).HasColumnName("markup");
            this.Property(t => t.formula).HasColumnName("formula");
            this.Property(t => t.numeroOrcamento).HasColumnName("numeroOrcamento");
        }
    }
}
