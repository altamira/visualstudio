using System.ComponentModel.DataAnnotations.Schema;
using System.Data.Entity.ModelConfiguration;

namespace WBCCAD.Model.Models.Mapping
{
    public class ItemRelMap : EntityTypeConfiguration<ItemRel>
    {
        public ItemRelMap()
        {
            // Primary Key
            this.HasKey(t => t.idItemRel);

            // Properties
            this.Property(t => t.Item)
                .HasMaxLength(20);

            this.Property(t => t.numeroOrcamento)
                .HasMaxLength(9);

            // Table & Column Mappings
            this.ToTable("ItemRel");
            this.Property(t => t.idItemRel).HasColumnName("idItemRel");
            this.Property(t => t.ItemRel1).HasColumnName("ItemRel");
            this.Property(t => t.Item).HasColumnName("Item");
            this.Property(t => t.numeroOrcamento).HasColumnName("numeroOrcamento");
        }
    }
}
