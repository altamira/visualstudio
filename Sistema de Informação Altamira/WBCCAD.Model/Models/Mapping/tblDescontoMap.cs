using System.ComponentModel.DataAnnotations.Schema;
using System.Data.Entity.ModelConfiguration;

namespace WBCCAD.Model.Models.Mapping
{
    public class tblDescontoMap : EntityTypeConfiguration<tblDesconto>
    {
        public tblDescontoMap()
        {
            // Primary Key
            this.HasKey(t => t.idTblDesconto);

            // Properties
            // Table & Column Mappings
            this.ToTable("tblDesconto");
            this.Property(t => t.idTblDesconto).HasColumnName("idTblDesconto");
            this.Property(t => t.DescontoFaixa).HasColumnName("DescontoFaixa");
            this.Property(t => t.DescontoComissao).HasColumnName("DescontoComissao");
        }
    }
}
