using System.ComponentModel.DataAnnotations.Schema;
using System.Data.Entity.ModelConfiguration;

namespace WBCCAD.Model.Models.Mapping
{
    public class gond_prof_rel_prof_supMap : EntityTypeConfiguration<gond_prof_rel_prof_sup>
    {
        public gond_prof_rel_prof_supMap()
        {
            // Primary Key
            this.HasKey(t => t.IdGondProfRelProfSup);

            // Properties
            this.Property(t => t.perfil)
                .HasMaxLength(20);

            // Table & Column Mappings
            this.ToTable("gond_prof_rel_prof_sup");
            this.Property(t => t.profundidade).HasColumnName("profundidade");
            this.Property(t => t.profundidade_superior).HasColumnName("profundidade_superior");
            this.Property(t => t.profundidade_superior_real).HasColumnName("profundidade_superior_real");
            this.Property(t => t.perfil).HasColumnName("perfil");
            this.Property(t => t.IdGondProfRelProfSup).HasColumnName("IdGondProfRelProfSup");
        }
    }
}
