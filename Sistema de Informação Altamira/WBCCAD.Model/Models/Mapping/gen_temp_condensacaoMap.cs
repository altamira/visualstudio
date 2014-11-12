using System.ComponentModel.DataAnnotations.Schema;
using System.Data.Entity.ModelConfiguration;

namespace WBCCAD.Model.Models.Mapping
{
    public class gen_temp_condensacaoMap : EntityTypeConfiguration<gen_temp_condensacao>
    {
        public gen_temp_condensacaoMap()
        {
            // Primary Key
            this.HasKey(t => t.indice);

            // Properties
            // Table & Column Mappings
            this.ToTable("gen_temp_condensacao");
            this.Property(t => t.indice).HasColumnName("indice");
            this.Property(t => t.condensacao).HasColumnName("condensacao");
        }
    }
}
