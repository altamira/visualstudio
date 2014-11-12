using System.ComponentModel.DataAnnotations.Schema;
using System.Data.Entity.ModelConfiguration;

namespace WBCCAD.Model.Models.Mapping
{
    public class GruposUsuarioMap : EntityTypeConfiguration<GruposUsuario>
    {
        public GruposUsuarioMap()
        {
            // Primary Key
            this.HasKey(t => new { t.idGrupoUsuario, t.idUsuario, t.idGrupo });

            // Properties
            this.Property(t => t.idGrupoUsuario)
                .HasDatabaseGeneratedOption(DatabaseGeneratedOption.Identity);

            this.Property(t => t.idUsuario)
                .HasDatabaseGeneratedOption(DatabaseGeneratedOption.None);

            this.Property(t => t.idGrupo)
                .HasDatabaseGeneratedOption(DatabaseGeneratedOption.None);

            // Table & Column Mappings
            this.ToTable("GruposUsuarios");
            this.Property(t => t.idGrupoUsuario).HasColumnName("idGrupoUsuario");
            this.Property(t => t.idUsuario).HasColumnName("idUsuario");
            this.Property(t => t.idGrupo).HasColumnName("idGrupo");
        }
    }
}
