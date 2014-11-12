using System.ComponentModel.DataAnnotations.Schema;
using System.Data.Entity.ModelConfiguration;

namespace WBCCAD.Model.Models.Mapping
{
    public class OrcAcoMap : EntityTypeConfiguration<OrcAco>
    {
        public OrcAcoMap()
        {
            // Primary Key
            this.HasKey(t => t.SEQUENCIAL);

            // Properties
            this.Property(t => t.DESCRICAO)
                .HasMaxLength(100);

            this.Property(t => t.numeroOrcamento)
                .IsFixedLength()
                .HasMaxLength(9);

            // Table & Column Mappings
            this.ToTable("OrcAcoes");
            this.Property(t => t.SEQUENCIAL).HasColumnName("SEQUENCIAL");
            this.Property(t => t.DESCRICAO).HasColumnName("DESCRICAO");
            this.Property(t => t.COMANDO1).HasColumnName("COMANDO1");
            this.Property(t => t.COMANDO2).HasColumnName("COMANDO2");
            this.Property(t => t.CANCELAR1).HasColumnName("CANCELAR1");
            this.Property(t => t.CANCELAR2).HasColumnName("CANCELAR2");
            this.Property(t => t.numeroOrcamento).HasColumnName("numeroOrcamento");
        }
    }
}
