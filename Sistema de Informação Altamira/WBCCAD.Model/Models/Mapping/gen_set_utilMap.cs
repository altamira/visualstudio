using System.ComponentModel.DataAnnotations.Schema;
using System.Data.Entity.ModelConfiguration;

namespace WBCCAD.Model.Models.Mapping
{
    public class gen_set_utilMap : EntityTypeConfiguration<gen_set_util>
    {
        public gen_set_utilMap()
        {
            // Primary Key
            this.HasKey(t => t.idGenSetUtil);

            // Properties
            this.Property(t => t.setor)
                .HasMaxLength(50);

            this.Property(t => t.utilizacao)
                .HasMaxLength(50);

            // Table & Column Mappings
            this.ToTable("gen_set_util");
            this.Property(t => t.setor).HasColumnName("setor");
            this.Property(t => t.utilizacao).HasColumnName("utilizacao");
            this.Property(t => t.idGenSetUtil).HasColumnName("idGenSetUtil");
        }
    }
}
