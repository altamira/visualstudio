using System.ComponentModel.DataAnnotations.Schema;
using System.Data.Entity.ModelConfiguration;

namespace WBCCAD.Model.Models.Mapping
{
    public class PesAgtMap : EntityTypeConfiguration<PesAgt>
    {
        public PesAgtMap()
        {
            // Primary Key
            this.HasKey(t => t.idPesAgt);

            // Properties
            // Table & Column Mappings
            this.ToTable("PesAgt");
            this.Property(t => t.idPesAgt).HasColumnName("idPesAgt");
            this.Property(t => t.PesAgt_Codigo).HasColumnName("PesAgt_Codigo");
            this.Property(t => t.PesAgt_Desabilitado).HasColumnName("PesAgt_Desabilitado");
        }
    }
}
