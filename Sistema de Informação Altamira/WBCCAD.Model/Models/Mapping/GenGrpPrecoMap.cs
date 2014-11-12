using System.ComponentModel.DataAnnotations.Schema;
using System.Data.Entity.ModelConfiguration;

namespace WBCCAD.Model.Models.Mapping
{
    public class GenGrpPrecoMap : EntityTypeConfiguration<GenGrpPreco>
    {
        public GenGrpPrecoMap()
        {
            // Primary Key
            this.HasKey(t => t.idGenGrpPreco);

            // Properties
            this.Property(t => t.GenGrpPrecoCodigo)
                .HasMaxLength(50);

            // Table & Column Mappings
            this.ToTable("GenGrpPreco");
            this.Property(t => t.GenGrpPrecoCodigo).HasColumnName("GenGrpPrecoCodigo");
            this.Property(t => t.GenGrpPrecoFator).HasColumnName("GenGrpPrecoFator");
            this.Property(t => t.GENGRPPRECOMULT).HasColumnName("GENGRPPRECOMULT");
            this.Property(t => t.GENGRPPRECOMULT2).HasColumnName("GENGRPPRECOMULT2");
            this.Property(t => t.GENGRPPRECOMULT3).HasColumnName("GENGRPPRECOMULT3");
            this.Property(t => t.idGenGrpPreco).HasColumnName("idGenGrpPreco");
        }
    }
}
