using System.ComponentModel.DataAnnotations.Schema;
using System.Data.Entity.ModelConfiguration;

namespace WBCCAD.Model.Models.Mapping
{
    public class OrcPrcMap : EntityTypeConfiguration<OrcPrc>
    {
        public OrcPrcMap()
        {
            // Primary Key
            this.HasKey(t => t.idOrcPrc);

            // Properties
            this.Property(t => t.numeroOrcamento)
                .IsRequired()
                .IsFixedLength()
                .HasMaxLength(9);

            this.Property(t => t.@base)
                .HasMaxLength(50);

            this.Property(t => t.lista_precos)
                .HasMaxLength(100);

            // Table & Column Mappings
            this.ToTable("OrcPrc");
            this.Property(t => t.numeroOrcamento).HasColumnName("numeroOrcamento");
            this.Property(t => t.@base).HasColumnName("base");
            this.Property(t => t.lista_precos).HasColumnName("lista_precos");
            this.Property(t => t.idOrcPrc).HasColumnName("idOrcPrc");
        }
    }
}
