using System.ComponentModel.DataAnnotations.Schema;
using System.Data.Entity.ModelConfiguration;

namespace WBCCAD.Model.Models.Mapping
{
    public class PADVARPRJMap : EntityTypeConfiguration<PADVARPRJ>
    {
        public PADVARPRJMap()
        {
            // Primary Key
            this.HasKey(t => t.IDPADVARPRJ);

            // Properties
            this.Property(t => t.PADVARPRJ_VARIAVEL)
                .HasMaxLength(30);

            // Table & Column Mappings
            this.ToTable("PADVARPRJ");
            this.Property(t => t.PADVARPRJ_VARIAVEL).HasColumnName("PADVARPRJ_VARIAVEL");
            this.Property(t => t.PADVARPRJ_VALOR).HasColumnName("PADVARPRJ_VALOR");
            this.Property(t => t.IDPADVARPRJ).HasColumnName("IDPADVARPRJ");
        }
    }
}
