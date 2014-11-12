using System.ComponentModel.DataAnnotations.Schema;
using System.Data.Entity.ModelConfiguration;

namespace WpfApplication3.Models.Mapping
{
    public class PEDIDOMap : EntityTypeConfiguration<PEDIDO>
    {
        public PEDIDOMap()
        {
            // Primary Key
            this.HasKey(t => t.NUMERO);

            // Properties
            this.Property(t => t.NUMERO)
                .HasDatabaseGeneratedOption(DatabaseGeneratedOption.None);

            // Table & Column Mappings
            this.ToTable("PEDIDO");
            this.Property(t => t.NUMERO).HasColumnName("NUMERO");
            this.Property(t => t.CLIENTE_ID).HasColumnName("CLIENTE_ID");
            this.Property(t => t.DT_EMISSAO).HasColumnName("DT_EMISSAO");
            this.Property(t => t.DT_ENTREGA).HasColumnName("DT_ENTREGA");

            // Relationships
            this.HasRequired(t => t.CLIENTE)
                .WithMany(t => t.PEDIDOes)
                .HasForeignKey(d => d.CLIENTE_ID);

        }
    }
}
