using System.ComponentModel.DataAnnotations.Schema;
using System.Data.Entity.ModelConfiguration;

namespace WBCCAD.Model.Models.Mapping
{
    public class tipo_variacaoMap : EntityTypeConfiguration<tipo_variacao>
    {
        public tipo_variacaoMap()
        {
            // Primary Key
            this.HasKey(t => t.idTipoVariacao);

            // Properties
            this.Property(t => t.Variacao)
                .HasMaxLength(100);

            this.Property(t => t.Tipo)
                .HasMaxLength(100);

            // Table & Column Mappings
            this.ToTable("tipo_variacao");
            this.Property(t => t.idTipoVariacao).HasColumnName("idTipoVariacao");
            this.Property(t => t.Variacao).HasColumnName("Variacao");
            this.Property(t => t.Tipo).HasColumnName("Tipo");
        }
    }
}
