using System.ComponentModel.DataAnnotations.Schema;
using System.Data.Entity.ModelConfiguration;

namespace WBCCAD.Model.Models.Mapping
{
    public class pesprjMap : EntityTypeConfiguration<pesprj>
    {
        public pesprjMap()
        {
            // Primary Key
            this.HasKey(t => new { t.pesprj_codigo, t.pesprj_desabilitado, t.idPesprj });

            // Properties
            this.Property(t => t.pesprj_codigo)
                .HasDatabaseGeneratedOption(DatabaseGeneratedOption.None);

            this.Property(t => t.idPesprj)
                .HasDatabaseGeneratedOption(DatabaseGeneratedOption.Identity);

            // Table & Column Mappings
            this.ToTable("pesprj");
            this.Property(t => t.pesprj_codigo).HasColumnName("pesprj_codigo");
            this.Property(t => t.pesprj_desabilitado).HasColumnName("pesprj_desabilitado");
            this.Property(t => t.idPesprj).HasColumnName("idPesprj");
        }
    }
}
