using System.ComponentModel.DataAnnotations.Schema;
using System.Data.Entity.ModelConfiguration;

namespace WBCCAD.Model.Models.Mapping
{
    public class tipo_Compr_conceitoMap : EntityTypeConfiguration<tipo_Compr_conceito>
    {
        public tipo_Compr_conceitoMap()
        {
            // Primary Key
            this.HasKey(t => t.idTipoComprConceito);

            // Properties
            this.Property(t => t.compr_conceito)
                .HasMaxLength(100);

            // Table & Column Mappings
            this.ToTable("tipo_Compr_conceito");
            this.Property(t => t.idTipoComprConceito).HasColumnName("idTipoComprConceito");
            this.Property(t => t.compr_conceito).HasColumnName("compr_conceito");
        }
    }
}
