using System.ComponentModel.DataAnnotations.Schema;
using System.Data.Entity.ModelConfiguration;

namespace WBCCAD.Model.Models.Mapping
{
    public class TABTIPVENMap : EntityTypeConfiguration<TABTIPVEN>
    {
        public TABTIPVENMap()
        {
            // Primary Key
            this.HasKey(t => t.idTipoVenda);

            // Properties
            this.Property(t => t.TipoVenda)
                .HasMaxLength(50);

            this.Property(t => t.DescricaoProposta)
                .HasMaxLength(50);

            // Table & Column Mappings
            this.ToTable("TABTIPVEN");
            this.Property(t => t.TipoVenda).HasColumnName("TipoVenda");
            this.Property(t => t.DescricaoProposta).HasColumnName("DescricaoProposta");
            this.Property(t => t.idTipoVenda).HasColumnName("idTipoVenda");
        }
    }
}
