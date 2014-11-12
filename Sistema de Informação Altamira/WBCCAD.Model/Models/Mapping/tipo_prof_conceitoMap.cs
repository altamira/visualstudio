using System.ComponentModel.DataAnnotations.Schema;
using System.Data.Entity.ModelConfiguration;

namespace WBCCAD.Model.Models.Mapping
{
    public class tipo_prof_conceitoMap : EntityTypeConfiguration<tipo_prof_conceito>
    {
        public tipo_prof_conceitoMap()
        {
            // Primary Key
            this.HasKey(t => t.idTipoProfConceito);

            // Properties
            this.Property(t => t.Prof_conceito)
                .HasMaxLength(100);

            // Table & Column Mappings
            this.ToTable("tipo_prof_conceito");
            this.Property(t => t.idTipoProfConceito).HasColumnName("idTipoProfConceito");
            this.Property(t => t.Prof_conceito).HasColumnName("Prof_conceito");
        }
    }
}
