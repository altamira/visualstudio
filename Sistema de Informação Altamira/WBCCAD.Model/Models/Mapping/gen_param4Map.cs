using System.ComponentModel.DataAnnotations.Schema;
using System.Data.Entity.ModelConfiguration;

namespace WBCCAD.Model.Models.Mapping
{
    public class gen_param4Map : EntityTypeConfiguration<gen_param4>
    {
        public gen_param4Map()
        {
            // Primary Key
            this.HasKey(t => t.indice);

            // Properties
            this.Property(t => t.valor)
                .HasMaxLength(30);

            // Table & Column Mappings
            this.ToTable("gen_param4");
            this.Property(t => t.indice).HasColumnName("indice");
            this.Property(t => t.valor).HasColumnName("valor");
        }
    }
}
