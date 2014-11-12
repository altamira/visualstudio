using System.ComponentModel.DataAnnotations.Schema;
using System.Data.Entity.ModelConfiguration;

namespace WBCCAD.Model.Models.Mapping
{
    public class varusr_rel_tipoMap : EntityTypeConfiguration<varusr_rel_tipo>
    {
        public varusr_rel_tipoMap()
        {
            // Primary Key
            this.HasKey(t => t.idVarusrRelTipo);

            // Properties
            this.Property(t => t.descricao)
                .HasMaxLength(255);

            // Table & Column Mappings
            this.ToTable("varusr_rel_tipo");
            this.Property(t => t.idVarusrRelTipo).HasColumnName("idVarusrRelTipo");
            this.Property(t => t.tipo).HasColumnName("tipo");
            this.Property(t => t.descricao).HasColumnName("descricao");
        }
    }
}
