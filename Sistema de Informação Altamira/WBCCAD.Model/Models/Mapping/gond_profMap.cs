using System.ComponentModel.DataAnnotations.Schema;
using System.Data.Entity.ModelConfiguration;

namespace WBCCAD.Model.Models.Mapping
{
    public class gond_profMap : EntityTypeConfiguration<gond_prof>
    {
        public gond_profMap()
        {
            // Primary Key
            this.HasKey(t => t.idGondProf);

            // Properties
            // Table & Column Mappings
            this.ToTable("gond_prof");
            this.Property(t => t.Profundidade).HasColumnName("Profundidade");
            this.Property(t => t.profundidade_real).HasColumnName("profundidade_real");
            this.Property(t => t.profundidade_real_curva).HasColumnName("profundidade_real_curva");
            this.Property(t => t.vale_para_edicao).HasColumnName("vale_para_edicao");
            this.Property(t => t.idGondProf).HasColumnName("idGondProf");
        }
    }
}
