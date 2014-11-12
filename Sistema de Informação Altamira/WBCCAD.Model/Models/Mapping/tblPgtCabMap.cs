using System.ComponentModel.DataAnnotations.Schema;
using System.Data.Entity.ModelConfiguration;

namespace WBCCAD.Model.Models.Mapping
{
    public class tblPgtCabMap : EntityTypeConfiguration<tblPgtCab>
    {
        public tblPgtCabMap()
        {
            // Primary Key
            this.HasKey(t => t.id);

            // Properties
            this.Property(t => t.descricao)
                .HasMaxLength(100);

            this.Property(t => t.codigo)
                .HasMaxLength(50);

            this.Property(t => t.PGTCAB_CANAL_VENDA)
                .HasMaxLength(20);

            this.Property(t => t.PGTCAB_INTEGRACAO)
                .HasMaxLength(20);

            // Table & Column Mappings
            this.ToTable("tblPgtCab");
            this.Property(t => t.descricao).HasColumnName("descricao");
            this.Property(t => t.Fator).HasColumnName("Fator");
            this.Property(t => t.codigo).HasColumnName("codigo");
            this.Property(t => t.PGTCAB_CANAL_VENDA).HasColumnName("PGTCAB_CANAL_VENDA");
            this.Property(t => t.PGTCAB_VALOR_MINIMO).HasColumnName("PGTCAB_VALOR_MINIMO");
            this.Property(t => t.PGTCAB_VALOR_MAXIMO).HasColumnName("PGTCAB_VALOR_MAXIMO");
            this.Property(t => t.PGTCAB_INTEGRACAO).HasColumnName("PGTCAB_INTEGRACAO");
            this.Property(t => t.PGTCAB_PARCELAS).HasColumnName("PGTCAB_PARCELAS");
            this.Property(t => t.PGTCAB_TX_FINANCEIRA).HasColumnName("PGTCAB_TX_FINANCEIRA");
            this.Property(t => t.PGTCAB_FLAG_ESPECIAL).HasColumnName("PGTCAB_FLAG_ESPECIAL");
            this.Property(t => t.PGTCAB_PRIMEIRA).HasColumnName("PGTCAB_PRIMEIRA");
            this.Property(t => t.id).HasColumnName("id");
            this.Property(t => t.condicaoPagamento).HasColumnName("condicaoPagamento");
        }
    }
}
