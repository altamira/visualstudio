using System.ComponentModel.DataAnnotations.Schema;
using System.Data.Entity.ModelConfiguration;

namespace WBCCAD.Model.Models.Mapping
{
    public class OrcmotMap : EntityTypeConfiguration<Orcmot>
    {
        public OrcmotMap()
        {
            // Primary Key
            this.HasKey(t => t.idOrcMot);

            // Properties
            this.Property(t => t.mot_descricao)
                .HasMaxLength(40);

            // Table & Column Mappings
            this.ToTable("Orcmot");
            this.Property(t => t.mot_descricao).HasColumnName("mot_descricao");
            this.Property(t => t.st_codigo).HasColumnName("st_codigo");
            this.Property(t => t.idOrcMot).HasColumnName("idOrcMot");
        }
    }
}
