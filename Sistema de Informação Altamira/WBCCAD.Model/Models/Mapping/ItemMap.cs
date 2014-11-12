using System.ComponentModel.DataAnnotations.Schema;
using System.Data.Entity.ModelConfiguration;

namespace WBCCAD.Model.Models.Mapping
{
    public class ItemMap : EntityTypeConfiguration<Item>
    {
        public ItemMap()
        {
            // Primary Key
            this.HasKey(t => t.idItem);

            // Properties
            this.Property(t => t.Item1)
                .HasMaxLength(255);

            this.Property(t => t.Campo)
                .HasMaxLength(255);

            this.Property(t => t.Valor)
                .HasMaxLength(255);

            // Table & Column Mappings
            this.ToTable("Item");
            this.Property(t => t.idItem).HasColumnName("idItem");
            this.Property(t => t.idRelatorio).HasColumnName("idRelatorio");
            this.Property(t => t.idSecao).HasColumnName("idSecao");
            this.Property(t => t.idTipoItem).HasColumnName("idTipoItem");
            this.Property(t => t.Item1).HasColumnName("Item");
            this.Property(t => t.Campo).HasColumnName("Campo");
            this.Property(t => t.Ordem).HasColumnName("Ordem");
            this.Property(t => t.Valor).HasColumnName("Valor");
        }
    }
}
