using System.ComponentModel.DataAnnotations.Schema;
using System.Data.Entity.ModelConfiguration;

namespace WBCCAD.Model.Models.Mapping
{
    public class UsuarioMap : EntityTypeConfiguration<Usuario>
    {
        public UsuarioMap()
        {
            // Primary Key
            this.HasKey(t => new { t.idUsuario, t.Usuario1, t.Login, t.Senha, t.Ativo });

            // Properties
            this.Property(t => t.idUsuario)
                .HasDatabaseGeneratedOption(DatabaseGeneratedOption.Identity);

            this.Property(t => t.Usuario1)
                .IsRequired()
                .HasMaxLength(100);

            this.Property(t => t.Login)
                .IsRequired()
                .HasMaxLength(20);

            this.Property(t => t.Senha)
                .IsRequired()
                .HasMaxLength(50);

            this.Property(t => t.Prefixo)
                .HasMaxLength(4);

            this.Property(t => t.descontoMax)
                .HasMaxLength(10);

            // Table & Column Mappings
            this.ToTable("Usuarios");
            this.Property(t => t.idUsuario).HasColumnName("idUsuario");
            this.Property(t => t.Usuario1).HasColumnName("Usuario");
            this.Property(t => t.Login).HasColumnName("Login");
            this.Property(t => t.Senha).HasColumnName("Senha");
            this.Property(t => t.Prefixo).HasColumnName("Prefixo");
            this.Property(t => t.Observacoes).HasColumnName("Observacoes");
            this.Property(t => t.Ativo).HasColumnName("Ativo");
            this.Property(t => t.descontoMax).HasColumnName("descontoMax");
        }
    }
}
