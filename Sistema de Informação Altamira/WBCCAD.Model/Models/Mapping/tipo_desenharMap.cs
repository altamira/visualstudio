using System.ComponentModel.DataAnnotations.Schema;
using System.Data.Entity.ModelConfiguration;

namespace WBCCAD.Model.Models.Mapping
{
    public class tipo_desenharMap : EntityTypeConfiguration<tipo_desenhar>
    {
        public tipo_desenharMap()
        {
            // Primary Key
            this.HasKey(t => t.idTipoDesenhar);

            // Properties
            this.Property(t => t.desenhar)
                .HasMaxLength(100);

            // Table & Column Mappings
            this.ToTable("tipo_desenhar");
            this.Property(t => t.idTipoDesenhar).HasColumnName("idTipoDesenhar");
            this.Property(t => t.desenhar).HasColumnName("desenhar");
            this.Property(t => t.nValor).HasColumnName("nValor");
        }
    }
}
