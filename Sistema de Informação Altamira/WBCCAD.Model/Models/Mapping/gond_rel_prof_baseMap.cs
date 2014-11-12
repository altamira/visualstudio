using System.ComponentModel.DataAnnotations.Schema;
using System.Data.Entity.ModelConfiguration;

namespace WBCCAD.Model.Models.Mapping
{
    public class gond_rel_prof_baseMap : EntityTypeConfiguration<gond_rel_prof_base>
    {
        public gond_rel_prof_baseMap()
        {
            // Primary Key
            this.HasKey(t => t.IdGondRelProfBase);

            // Properties
            this.Property(t => t.perfil)
                .HasMaxLength(50);

            this.Property(t => t.nome_conjunto)
                .HasMaxLength(40);

            // Table & Column Mappings
            this.ToTable("gond_rel_prof_base");
            this.Property(t => t.profundidade).HasColumnName("profundidade");
            this.Property(t => t.profundidade_base).HasColumnName("profundidade_base");
            this.Property(t => t.perfil).HasColumnName("perfil");
            this.Property(t => t.nome_conjunto).HasColumnName("nome_conjunto");
            this.Property(t => t.IdGondRelProfBase).HasColumnName("IdGondRelProfBase");
        }
    }
}
