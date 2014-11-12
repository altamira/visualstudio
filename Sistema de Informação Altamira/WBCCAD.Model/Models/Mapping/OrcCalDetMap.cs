using System.ComponentModel.DataAnnotations.Schema;
using System.Data.Entity.ModelConfiguration;

namespace WBCCAD.Model.Models.Mapping
{
    public class OrcCalDetMap : EntityTypeConfiguration<OrcCalDet>
    {
        public OrcCalDetMap()
        {
            // Primary Key
            this.HasKey(t => t.idOrcCalDet);

            // Properties
            this.Property(t => t.TipoCalculo)
                .HasMaxLength(255);

            this.Property(t => t.Valor)
                .HasMaxLength(100);

            this.Property(t => t.numeroOrcamento)
                .IsFixedLength()
                .HasMaxLength(9);

            // Table & Column Mappings
            this.ToTable("OrcCalDet");
            this.Property(t => t.idOrcCalDet).HasColumnName("idOrcCalDet");
            this.Property(t => t.TipoCalculo).HasColumnName("TipoCalculo");
            this.Property(t => t.idGrupo).HasColumnName("idGrupo");
            this.Property(t => t.Valor).HasColumnName("Valor");
            this.Property(t => t.TotalLista).HasColumnName("TotalLista");
            this.Property(t => t.TotalVenda).HasColumnName("TotalVenda");
            this.Property(t => t.numeroOrcamento).HasColumnName("numeroOrcamento");
        }
    }
}
