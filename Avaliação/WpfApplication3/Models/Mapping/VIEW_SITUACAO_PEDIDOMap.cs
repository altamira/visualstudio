using System.ComponentModel.DataAnnotations.Schema;
using System.Data.Entity.ModelConfiguration;

namespace WpfApplication3.Models.Mapping
{
    public class VIEW_SITUACAO_PEDIDOMap : EntityTypeConfiguration<VIEW_SITUACAO_PEDIDO>
    {
        public VIEW_SITUACAO_PEDIDOMap()
        {
            // Primary Key
            this.HasKey(t => new { t.NUMERO, t.DT_EMISSAO, t.DT_ENTREGA, t.NOME, t.DESCRICAO });

            // Properties
            this.Property(t => t.NUMERO)
                .HasDatabaseGeneratedOption(DatabaseGeneratedOption.None);

            this.Property(t => t.NOME)
                .IsRequired()
                .HasMaxLength(50);

            this.Property(t => t.DESCRICAO)
                .IsRequired()
                .HasMaxLength(50);

            // Table & Column Mappings
            this.ToTable("VIEW_SITUACAO_PEDIDO");
            this.Property(t => t.NUMERO).HasColumnName("NUMERO");
            this.Property(t => t.DT_EMISSAO).HasColumnName("DT_EMISSAO");
            this.Property(t => t.DT_ENTREGA).HasColumnName("DT_ENTREGA");
            this.Property(t => t.NOME).HasColumnName("NOME");
            this.Property(t => t.DT_SITUACAO).HasColumnName("DT_SITUACAO");
            this.Property(t => t.DESCRICAO).HasColumnName("DESCRICAO");
        }
    }
}
