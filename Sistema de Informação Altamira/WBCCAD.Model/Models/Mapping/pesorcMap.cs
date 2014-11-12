using System.ComponentModel.DataAnnotations.Schema;
using System.Data.Entity.ModelConfiguration;

namespace WBCCAD.Model.Models.Mapping
{
    public class pesorcMap : EntityTypeConfiguration<pesorc>
    {
        public pesorcMap()
        {
            // Primary Key
            this.HasKey(t => new { t.pesorc_codigo, t.pesorc_desabilitado, t.idPesorc });

            // Properties
            this.Property(t => t.pesorc_codigo)
                .HasDatabaseGeneratedOption(DatabaseGeneratedOption.None);

            this.Property(t => t.idPesorc)
                .HasDatabaseGeneratedOption(DatabaseGeneratedOption.Identity);

            // Table & Column Mappings
            this.ToTable("pesorc");
            this.Property(t => t.pesorc_codigo).HasColumnName("pesorc_codigo");
            this.Property(t => t.pesorc_desabilitado).HasColumnName("pesorc_desabilitado");
            this.Property(t => t.idPesorc).HasColumnName("idPesorc");
        }
    }
}
