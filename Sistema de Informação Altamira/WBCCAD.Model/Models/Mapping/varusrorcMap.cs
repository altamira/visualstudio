using System.ComponentModel.DataAnnotations.Schema;
using System.Data.Entity.ModelConfiguration;

namespace WBCCAD.Model.Models.Mapping
{
    public class varusrorcMap : EntityTypeConfiguration<varusrorc>
    {
        public varusrorcMap()
        {
            // Primary Key
            this.HasKey(t => new { t.varusrcodigo, t.numeroOrcamento });

            // Properties
            this.Property(t => t.varusrcodigo)
                .IsRequired()
                .HasMaxLength(100);

            this.Property(t => t.numeroOrcamento)
                .IsRequired()
                .HasMaxLength(9);

            this.Property(t => t.varusrvalor)
                .HasMaxLength(1024);

            // Table & Column Mappings
            this.ToTable("varusrorc");
            this.Property(t => t.varusrcodigo).HasColumnName("varusrcodigo");
            this.Property(t => t.RECALCULAR).HasColumnName("RECALCULAR");
            this.Property(t => t.numeroOrcamento).HasColumnName("numeroOrcamento");
            this.Property(t => t.varusrvalor).HasColumnName("varusrvalor");
        }
    }
}
