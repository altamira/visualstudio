using System.ComponentModel.DataAnnotations.Schema;
using System.Data.Entity.ModelConfiguration;

namespace WBCCAD.Model.Models.Mapping
{
    public class gond_cjtos_profMap : EntityTypeConfiguration<gond_cjtos_prof>
    {
        public gond_cjtos_profMap()
        {
            // Primary Key
            this.HasKey(t => t.idGondCjtosProf);

            // Properties
            this.Property(t => t.descricao_cjto)
                .HasMaxLength(50);

            this.Property(t => t.profundidade)
                .HasMaxLength(10);

            // Table & Column Mappings
            this.ToTable("gond_cjtos_prof");
            this.Property(t => t.descricao_cjto).HasColumnName("descricao_cjto");
            this.Property(t => t.profundidade).HasColumnName("profundidade");
            this.Property(t => t.idGondCjtosProf).HasColumnName("idGondCjtosProf");
        }
    }
}
