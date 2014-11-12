using System.ComponentModel.DataAnnotations.Schema;
using System.Data.Entity.ModelConfiguration;

namespace WBCCAD.Model.Models.Mapping
{
    public class fabricanteMap : EntityTypeConfiguration<fabricante>
    {
        public fabricanteMap()
        {
            // Primary Key
            this.HasKey(t => t.idFabricantes);

            // Properties
            this.Property(t => t.nome)
                .HasMaxLength(50);

            this.Property(t => t.Tipo)
                .HasMaxLength(50);

            // Table & Column Mappings
            this.ToTable("fabricantes");
            this.Property(t => t.nome).HasColumnName("nome");
            this.Property(t => t.Tipo).HasColumnName("Tipo");
            this.Property(t => t.idFabricantes).HasColumnName("idFabricantes");
        }
    }
}
