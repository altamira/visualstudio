using System.ComponentModel.DataAnnotations.Schema;
using System.Data.Entity.ModelConfiguration;

namespace WBCCAD.Model.Models.Mapping
{
    public class OrcVarMap : EntityTypeConfiguration<OrcVar>
    {
        public OrcVarMap()
        {
            // Primary Key
            this.HasKey(t => t.idOrcVar);

            // Properties
            this.Property(t => t.numeroOrcamento)
                .IsRequired()
                .IsFixedLength()
                .HasMaxLength(9);

            this.Property(t => t.Variavel)
                .HasMaxLength(50);

            // Table & Column Mappings
            this.ToTable("OrcVar");
            this.Property(t => t.idOrcVar).HasColumnName("idOrcVar");
            this.Property(t => t.numeroOrcamento).HasColumnName("numeroOrcamento");
            this.Property(t => t.Valor).HasColumnName("Valor");
            this.Property(t => t.Variavel).HasColumnName("Variavel");
        }
    }
}
