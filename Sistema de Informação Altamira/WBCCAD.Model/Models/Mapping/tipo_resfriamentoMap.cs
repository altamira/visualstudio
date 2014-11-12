using System.ComponentModel.DataAnnotations.Schema;
using System.Data.Entity.ModelConfiguration;

namespace WBCCAD.Model.Models.Mapping
{
    public class tipo_resfriamentoMap : EntityTypeConfiguration<tipo_resfriamento>
    {
        public tipo_resfriamentoMap()
        {
            // Primary Key
            this.HasKey(t => t.idTipoResfriamento);

            // Properties
            this.Property(t => t.TipoResfriamento)
                .HasMaxLength(100);

            // Table & Column Mappings
            this.ToTable("tipo_resfriamento");
            this.Property(t => t.idTipoResfriamento).HasColumnName("idTipoResfriamento");
            this.Property(t => t.TipoResfriamento).HasColumnName("TipoResfriamento");
        }
    }
}
