using System.ComponentModel.DataAnnotations.Schema;
using System.Data.Entity.ModelConfiguration;

namespace WBCCAD.Model.Models.Mapping
{
    public class tbl_tipo_cobrarMap : EntityTypeConfiguration<tbl_tipo_cobrar>
    {
        public tbl_tipo_cobrarMap()
        {
            // Primary Key
            this.HasKey(t => t.idTipoCobrar);

            // Properties
            this.Property(t => t.TipoCobrar)
                .HasMaxLength(255);

            // Table & Column Mappings
            this.ToTable("tbl_tipo_cobrar");
            this.Property(t => t.idTipoCobrar).HasColumnName("idTipoCobrar");
            this.Property(t => t.TipoCobrar).HasColumnName("TipoCobrar");
        }
    }
}
