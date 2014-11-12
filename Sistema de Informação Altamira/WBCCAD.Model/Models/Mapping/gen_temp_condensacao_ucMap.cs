using System.ComponentModel.DataAnnotations.Schema;
using System.Data.Entity.ModelConfiguration;

namespace WBCCAD.Model.Models.Mapping
{
    public class gen_temp_condensacao_ucMap : EntityTypeConfiguration<gen_temp_condensacao_uc>
    {
        public gen_temp_condensacao_ucMap()
        {
            // Primary Key
            this.HasKey(t => t.indice);

            // Properties
            // Table & Column Mappings
            this.ToTable("gen_temp_condensacao_uc");
            this.Property(t => t.indice).HasColumnName("indice");
            this.Property(t => t.temperatura).HasColumnName("temperatura");
        }
    }
}
