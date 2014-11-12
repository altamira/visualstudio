using System.ComponentModel.DataAnnotations.Schema;
using System.Data.Entity.ModelConfiguration;

namespace WBCCAD.Model.Models.Mapping
{
    public class OrcstMap : EntityTypeConfiguration<Orcst>
    {
        public OrcstMap()
        {
            // Primary Key
            this.HasKey(t => t.idOrcst);

            // Properties
            this.Property(t => t.st_descricao)
                .HasMaxLength(30);

            // Table & Column Mappings
            this.ToTable("Orcst");
            this.Property(t => t.st_codigo).HasColumnName("st_codigo");
            this.Property(t => t.st_descricao).HasColumnName("st_descricao");
            this.Property(t => t.st_flag_ativo).HasColumnName("st_flag_ativo");
            this.Property(t => t.idOrcst).HasColumnName("idOrcst");
        }
    }
}
