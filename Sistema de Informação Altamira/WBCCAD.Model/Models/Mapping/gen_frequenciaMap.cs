using System.ComponentModel.DataAnnotations.Schema;
using System.Data.Entity.ModelConfiguration;

namespace WBCCAD.Model.Models.Mapping
{
    public class gen_frequenciaMap : EntityTypeConfiguration<gen_frequencia>
    {
        public gen_frequenciaMap()
        {
            // Primary Key
            this.HasKey(t => t.indice);

            // Properties
            this.Property(t => t.valor)
                .HasMaxLength(30);

            // Table & Column Mappings
            this.ToTable("gen_frequencia");
            this.Property(t => t.indice).HasColumnName("indice");
            this.Property(t => t.valor).HasColumnName("valor");
        }
    }
}
