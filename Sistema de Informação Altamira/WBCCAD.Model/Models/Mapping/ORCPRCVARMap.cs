using System.ComponentModel.DataAnnotations.Schema;
using System.Data.Entity.ModelConfiguration;

namespace WBCCAD.Model.Models.Mapping
{
    public class ORCPRCVARMap : EntityTypeConfiguration<ORCPRCVAR>
    {
        public ORCPRCVARMap()
        {
            // Primary Key
            this.HasKey(t => t.idOrcPrcVar);

            // Properties
            this.Property(t => t.numeroOrcamento)
                .IsRequired()
                .IsFixedLength()
                .HasMaxLength(9);

            this.Property(t => t.VARIAVEL)
                .HasMaxLength(50);

            this.Property(t => t.PRODUTO)
                .HasMaxLength(100);

            this.Property(t => t.COR)
                .HasMaxLength(20);

            // Table & Column Mappings
            this.ToTable("ORCPRCVAR");
            this.Property(t => t.idOrcPrcVar).HasColumnName("idOrcPrcVar");
            this.Property(t => t.numeroOrcamento).HasColumnName("numeroOrcamento");
            this.Property(t => t.VARIAVEL).HasColumnName("VARIAVEL");
            this.Property(t => t.PRODUTO).HasColumnName("PRODUTO");
            this.Property(t => t.COR).HasColumnName("COR");
            this.Property(t => t.PRECO).HasColumnName("PRECO");
            this.Property(t => t.LISTA).HasColumnName("LISTA");
            this.Property(t => t.ADICIONAL).HasColumnName("ADICIONAL");
            this.Property(t => t.COMPRIMENTO).HasColumnName("COMPRIMENTO");
            this.Property(t => t.ALTURA).HasColumnName("ALTURA");
            this.Property(t => t.PROFUNDIDADE).HasColumnName("PROFUNDIDADE");
        }
    }
}
