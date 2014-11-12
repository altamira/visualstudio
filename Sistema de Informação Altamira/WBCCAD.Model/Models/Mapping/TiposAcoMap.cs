using System.ComponentModel.DataAnnotations.Schema;
using System.Data.Entity.ModelConfiguration;

namespace WBCCAD.Model.Models.Mapping
{
    public class TiposAcoMap : EntityTypeConfiguration<TiposAco>
    {
        public TiposAcoMap()
        {
            // Primary Key
            this.HasKey(t => t.idTipoAcao);

            // Properties
            this.Property(t => t.TipoAcao)
                .HasMaxLength(100);

            // Table & Column Mappings
            this.ToTable("TiposAcoes");
            this.Property(t => t.idTipoAcao).HasColumnName("idTipoAcao");
            this.Property(t => t.TipoAcao).HasColumnName("TipoAcao");
            this.Property(t => t.Ordem).HasColumnName("Ordem");
            this.Property(t => t.Observacoes).HasColumnName("Observacoes");
        }
    }
}
