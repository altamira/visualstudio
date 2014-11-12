using System.ComponentModel.DataAnnotations.Schema;
using System.Data.Entity.ModelConfiguration;

namespace WBCCAD.Model.Models.Mapping
{
    public class CartasRTFMap : EntityTypeConfiguration<CartasRTF>
    {
        public CartasRTFMap()
        {
            // Primary Key
            this.HasKey(t => t.Carta);

            // Properties
            this.Property(t => t.idCartaRTF)
                .HasDatabaseGeneratedOption(DatabaseGeneratedOption.Identity);

            this.Property(t => t.Carta)
                .IsRequired()
                .HasMaxLength(255);

            this.Property(t => t.numeroOrcamento)
                .IsFixedLength()
                .HasMaxLength(9);

            // Table & Column Mappings
            this.ToTable("CartasRTF");
            this.Property(t => t.idCartaRTF).HasColumnName("idCartaRTF");
            this.Property(t => t.Carta).HasColumnName("Carta");
            this.Property(t => t.RTF).HasColumnName("RTF");
            this.Property(t => t.RTFImagem).HasColumnName("RTFImagem");
            this.Property(t => t.numeroOrcamento).HasColumnName("numeroOrcamento");
        }
    }
}
