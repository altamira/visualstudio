using System.ComponentModel.DataAnnotations.Schema;
using System.Data.Entity.ModelConfiguration;

namespace WBCCAD.Model.Models.Mapping
{
    public class gond_grafia_diversosMap : EntityTypeConfiguration<gond_grafia_diversos>
    {
        public gond_grafia_diversosMap()
        {
            // Primary Key
            this.HasKey(t => t.indice);

            // Properties
            // Table & Column Mappings
            this.ToTable("gond_grafia_diversos");
            this.Property(t => t.indice).HasColumnName("indice");
            this.Property(t => t.profundidade).HasColumnName("profundidade");
            this.Property(t => t.distancia).HasColumnName("distancia");
            this.Property(t => t.TIPO_REGRA).HasColumnName("TIPO_REGRA");
        }
    }
}
