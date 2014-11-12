using System.ComponentModel.DataAnnotations.Schema;
using System.Data.Entity.ModelConfiguration;

namespace WBCCAD.Model.Models.Mapping
{
    public class FatoresCalculoMap : EntityTypeConfiguration<FatoresCalculo>
    {
        public FatoresCalculoMap()
        {
            // Primary Key
            this.HasKey(t => new { t.Variavel, t.Visivel, t.PertenceListaPreco });

            // Properties
            this.Property(t => t.Fator)
                .HasMaxLength(255);

            // Table & Column Mappings
            this.ToTable("FatoresCalculo");
            this.Property(t => t.idFator).HasColumnName("idFator");
            this.Property(t => t.idListaFatorCalculo).HasColumnName("idListaFatorCalculo");
            this.Property(t => t.Fator).HasColumnName("Fator");
            this.Property(t => t.ReferentePreco).HasColumnName("ReferentePreco");
            this.Property(t => t.Variavel).HasColumnName("Variavel");
            this.Property(t => t.Visivel).HasColumnName("Visivel");
            this.Property(t => t.PertenceListaPreco).HasColumnName("PertenceListaPreco");
            this.Property(t => t.Valor).HasColumnName("Valor");
        }
    }
}
