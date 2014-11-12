using System.ComponentModel.DataAnnotations.Schema;
using System.Data.Entity.ModelConfiguration;

namespace WBCCAD.Model.Models.Mapping
{
    public class gond_rest_profMap : EntityTypeConfiguration<gond_rest_prof>
    {
        public gond_rest_profMap()
        {
            // Primary Key
            this.HasKey(t => t.idGondRestProf);

            // Properties
            // Table & Column Mappings
            this.ToTable("gond_rest_prof");
            this.Property(t => t.id_restricao).HasColumnName("id_restricao");
            this.Property(t => t.profundidade).HasColumnName("profundidade");
            this.Property(t => t.idGondRestProf).HasColumnName("idGondRestProf");
        }
    }
}
