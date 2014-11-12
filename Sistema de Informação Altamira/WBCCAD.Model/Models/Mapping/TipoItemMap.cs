using System.ComponentModel.DataAnnotations.Schema;
using System.Data.Entity.ModelConfiguration;

namespace WBCCAD.Model.Models.Mapping
{
    public class TipoItemMap : EntityTypeConfiguration<TipoItem>
    {
        public TipoItemMap()
        {
            // Primary Key
            this.HasKey(t => t.idTipoItem);

            // Properties
            this.Property(t => t.TipoItem1)
                .HasMaxLength(255);

            // Table & Column Mappings
            this.ToTable("TipoItem");
            this.Property(t => t.idTipoItem).HasColumnName("idTipoItem");
            this.Property(t => t.TipoItem1).HasColumnName("TipoItem");
            this.Property(t => t.Observacoes).HasColumnName("Observacoes");
        }
    }
}
