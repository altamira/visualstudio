using System.ComponentModel.DataAnnotations.Schema;
using System.Data.Entity.ModelConfiguration;

namespace WpfApplication3.Models.Mapping
{
    public class SITUACAO_PEDIDOMap : EntityTypeConfiguration<SITUACAO_PEDIDO>
    {
        public SITUACAO_PEDIDOMap()
        {
            // Primary Key
            this.HasKey(t => new { t.PEDIDO_ID, t.SITUACAO_ID, t.DT_SITUACAO });

            // Properties
            this.Property(t => t.PEDIDO_ID)
                .HasDatabaseGeneratedOption(DatabaseGeneratedOption.None);

            this.Property(t => t.SITUACAO_ID)
                .HasDatabaseGeneratedOption(DatabaseGeneratedOption.None);

            // Table & Column Mappings
            this.ToTable("SITUACAO_PEDIDO");
            this.Property(t => t.PEDIDO_ID).HasColumnName("PEDIDO_ID");
            this.Property(t => t.SITUACAO_ID).HasColumnName("SITUACAO_ID");
            this.Property(t => t.DT_SITUACAO).HasColumnName("DT_SITUACAO");

            // Relationships
            this.HasRequired(t => t.PEDIDO)
                .WithMany(t => t.SITUACAO_PEDIDO)
                .HasForeignKey(d => d.PEDIDO_ID);
            this.HasRequired(t => t.SITUACAO)
                .WithMany(t => t.SITUACAO_PEDIDO)
                .HasForeignKey(d => d.SITUACAO_ID);

        }
    }
}
