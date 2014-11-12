using System.ComponentModel.DataAnnotations.Schema;
using System.Data.Entity.ModelConfiguration;

namespace WBCCAD.Model.Models.Mapping
{
    public class mob_cadastro_caracteristicasMap : EntityTypeConfiguration<mob_cadastro_caracteristicas>
    {
        public mob_cadastro_caracteristicasMap()
        {
            // Primary Key
            this.HasKey(t => t.idMobCadastroCaracteristicas);

            // Properties
            this.Property(t => t.tipo)
                .HasMaxLength(20);

            this.Property(t => t.caracteristica)
                .HasMaxLength(20);

            this.Property(t => t.descricao)
                .HasMaxLength(20);

            this.Property(t => t.sigla)
                .HasMaxLength(20);

            // Table & Column Mappings
            this.ToTable("mob_cadastro_caracteristicas");
            this.Property(t => t.tipo).HasColumnName("tipo");
            this.Property(t => t.caracteristica).HasColumnName("caracteristica");
            this.Property(t => t.descricao).HasColumnName("descricao");
            this.Property(t => t.sigla).HasColumnName("sigla");
            this.Property(t => t.e_padrao).HasColumnName("e_padrao");
            this.Property(t => t.idMobCadastroCaracteristicas).HasColumnName("idMobCadastroCaracteristicas");
        }
    }
}
