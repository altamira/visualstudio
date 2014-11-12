using System.ComponentModel.DataAnnotations.Schema;
using System.Data.Entity.ModelConfiguration;

namespace WBCCAD.Model.Models.Mapping
{
    public class tbl_consumo_tipoMap : EntityTypeConfiguration<tbl_consumo_tipo>
    {
        public tbl_consumo_tipoMap()
        {
            // Primary Key
            this.HasKey(t => t.idConsumoTipo);

            // Properties
            this.Property(t => t.ConsumoTipo)
                .HasMaxLength(255);

            // Table & Column Mappings
            this.ToTable("tbl_consumo_tipo");
            this.Property(t => t.idConsumoTipo).HasColumnName("idConsumoTipo");
            this.Property(t => t.ConsumoTipo).HasColumnName("ConsumoTipo");
            this.Property(t => t.NValor).HasColumnName("NValor");
        }
    }
}
