using System.ComponentModel.DataAnnotations.Schema;
using System.Data.Entity.ModelConfiguration;

namespace WBCCAD.Model.Models.Mapping
{
    public class OrcMatExtraMap : EntityTypeConfiguration<OrcMatExtra>
    {
        public OrcMatExtraMap()
        {
            // Primary Key
            this.HasKey(t => t.idOrcMatExtra);

            // Properties
            this.Property(t => t.idOrcMatExtra)
                .HasDatabaseGeneratedOption(DatabaseGeneratedOption.None);

            this.Property(t => t.codigoProduto)
                .HasMaxLength(100);

            this.Property(t => t.corProduto)
                .HasMaxLength(50);

            this.Property(t => t.grupo)
                .HasMaxLength(2);

            this.Property(t => t.subgrupo)
                .HasMaxLength(2);

            this.Property(t => t.corte)
                .HasMaxLength(100);

            this.Property(t => t.id)
                .HasMaxLength(50);

            this.Property(t => t.departamento)
                .HasMaxLength(255);

            this.Property(t => t.setor)
                .HasMaxLength(255);

            this.Property(t => t.utilizacao)
                .HasMaxLength(255);

            this.Property(t => t.numeroOrcamento)
                .IsFixedLength()
                .HasMaxLength(9);

            this.Property(t => t.item)
                .HasMaxLength(20);

            // Table & Column Mappings
            this.ToTable("OrcMatExtra");
            this.Property(t => t.idOrcMatExtra).HasColumnName("idOrcMatExtra");
            this.Property(t => t.codigoProduto).HasColumnName("codigoProduto");
            this.Property(t => t.corProduto).HasColumnName("corProduto");
            this.Property(t => t.grupo).HasColumnName("grupo");
            this.Property(t => t.subgrupo).HasColumnName("subgrupo");
            this.Property(t => t.corte).HasColumnName("corte");
            this.Property(t => t.id).HasColumnName("id");
            this.Property(t => t.departamento).HasColumnName("departamento");
            this.Property(t => t.setor).HasColumnName("setor");
            this.Property(t => t.utilizacao).HasColumnName("utilizacao");
            this.Property(t => t.quantidade).HasColumnName("quantidade");
            this.Property(t => t.quantidadeUtilizada).HasColumnName("quantidadeUtilizada");
            this.Property(t => t.numeroOrcamento).HasColumnName("numeroOrcamento");
            this.Property(t => t.item).HasColumnName("item");
        }
    }
}
