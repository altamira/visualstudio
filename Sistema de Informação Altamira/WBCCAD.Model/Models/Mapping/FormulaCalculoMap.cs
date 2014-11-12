using System.ComponentModel.DataAnnotations.Schema;
using System.Data.Entity.ModelConfiguration;

namespace WBCCAD.Model.Models.Mapping
{
    public class FormulaCalculoMap : EntityTypeConfiguration<FormulaCalculo>
    {
        public FormulaCalculoMap()
        {
            // Primary Key
            this.HasKey(t => t.idFormula);

            // Properties
            this.Property(t => t.DescricaoFormula)
                .HasMaxLength(255);

            // Table & Column Mappings
            this.ToTable("FormulaCalculo");
            this.Property(t => t.idFormula).HasColumnName("idFormula");
            this.Property(t => t.idListaFatorCalculo).HasColumnName("idListaFatorCalculo");
            this.Property(t => t.DescricaoFormula).HasColumnName("DescricaoFormula");
            this.Property(t => t.Formula).HasColumnName("Formula");
            this.Property(t => t.FormulaDetalhe).HasColumnName("FormulaDetalhe");
            this.Property(t => t.ReferentePreco).HasColumnName("ReferentePreco");
        }
    }
}
