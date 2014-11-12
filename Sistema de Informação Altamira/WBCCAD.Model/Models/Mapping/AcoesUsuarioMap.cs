using System.ComponentModel.DataAnnotations.Schema;
using System.Data.Entity.ModelConfiguration;

namespace WBCCAD.Model.Models.Mapping
{
    public class AcoesUsuarioMap : EntityTypeConfiguration<AcoesUsuario>
    {
        public AcoesUsuarioMap()
        {
            // Primary Key
            this.HasKey(t => new { t.idAcaoUsuario, t.idAcao, t.idUsuario, t.Permitir });

            // Properties
            this.Property(t => t.idAcaoUsuario)
                .HasDatabaseGeneratedOption(DatabaseGeneratedOption.Identity);

            this.Property(t => t.idAcao)
                .HasDatabaseGeneratedOption(DatabaseGeneratedOption.None);

            this.Property(t => t.idUsuario)
                .HasDatabaseGeneratedOption(DatabaseGeneratedOption.None);

            // Table & Column Mappings
            this.ToTable("AcoesUsuarios");
            this.Property(t => t.idAcaoUsuario).HasColumnName("idAcaoUsuario");
            this.Property(t => t.idAcao).HasColumnName("idAcao");
            this.Property(t => t.idUsuario).HasColumnName("idUsuario");
            this.Property(t => t.Permitir).HasColumnName("Permitir");
        }
    }
}
