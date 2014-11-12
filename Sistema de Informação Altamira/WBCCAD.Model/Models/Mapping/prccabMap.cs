using System.ComponentModel.DataAnnotations.Schema;
using System.Data.Entity.ModelConfiguration;

namespace WBCCAD.Model.Models.Mapping
{
    public class prccabMap : EntityTypeConfiguration<prccab>
    {
        public prccabMap()
        {
            // Primary Key
            this.HasKey(t => t.idPrccab);

            // Properties
            this.Property(t => t.lista)
                .HasMaxLength(6);

            this.Property(t => t.observacao)
                .HasMaxLength(255);

            this.Property(t => t.lista_produto)
                .HasMaxLength(20);

            this.Property(t => t.lista_fator)
                .HasMaxLength(20);

            this.Property(t => t.cliente)
                .HasMaxLength(18);

            this.Property(t => t.moeda)
                .HasMaxLength(4);

            this.Property(t => t.PrcCabListaCor)
                .HasMaxLength(20);

            this.Property(t => t.INTEGRACAO)
                .HasMaxLength(255);

            this.Property(t => t.PRCVAL_CODIGO)
                .HasMaxLength(20);

            this.Property(t => t.lista_calculo)
                .HasMaxLength(20);

            // Table & Column Mappings
            this.ToTable("prccab");
            this.Property(t => t.lista).HasColumnName("lista");
            this.Property(t => t.observacao).HasColumnName("observacao");
            this.Property(t => t.lista_produto).HasColumnName("lista_produto");
            this.Property(t => t.lista_fator).HasColumnName("lista_fator");
            this.Property(t => t.criacao).HasColumnName("criacao");
            this.Property(t => t.utilizacao_ini).HasColumnName("utilizacao_ini");
            this.Property(t => t.utilizacao_fim).HasColumnName("utilizacao_fim");
            this.Property(t => t.cliente).HasColumnName("cliente");
            this.Property(t => t.importacao).HasColumnName("importacao");
            this.Property(t => t.moeda).HasColumnName("moeda");
            this.Property(t => t.PrcCabListaCor).HasColumnName("PrcCabListaCor");
            this.Property(t => t.INTEGRACAO).HasColumnName("INTEGRACAO");
            this.Property(t => t.PRCVAL_CODIGO).HasColumnName("PRCVAL_CODIGO");
            this.Property(t => t.idPrccab).HasColumnName("idPrccab");
            this.Property(t => t.lista_calculo).HasColumnName("lista_calculo");
        }
    }
}
