using System.ComponentModel.DataAnnotations.Schema;
using System.Data.Entity.ModelConfiguration;

namespace WBCCAD.Model.Models.Mapping
{
    public class mob_grupos_restricoesMap : EntityTypeConfiguration<mob_grupos_restricoes>
    {
        public mob_grupos_restricoesMap()
        {
            // Primary Key
            this.HasKey(t => t.idMobGrupoRestricoes);

            // Properties
            this.Property(t => t.grupoSelecionado)
                .HasMaxLength(50);

            this.Property(t => t.gruporestringir)
                .HasMaxLength(50);

            // Table & Column Mappings
            this.ToTable("mob_grupos_restricoes");
            this.Property(t => t.grupoSelecionado).HasColumnName("grupoSelecionado");
            this.Property(t => t.gruporestringir).HasColumnName("gruporestringir");
            this.Property(t => t.Incluirgruporestringir).HasColumnName("Incluirgruporestringir");
            this.Property(t => t.existegruposelecionado).HasColumnName("existegruposelecionado");
            this.Property(t => t.idMobGrupoRestricoes).HasColumnName("idMobGrupoRestricoes");
        }
    }
}
