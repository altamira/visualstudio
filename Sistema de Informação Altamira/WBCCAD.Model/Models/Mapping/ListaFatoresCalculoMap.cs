using System.ComponentModel.DataAnnotations.Schema;
using System.Data.Entity.ModelConfiguration;

namespace WBCCAD.Model.Models.Mapping
{
    public class ListaFatoresCalculoMap : EntityTypeConfiguration<ListaFatoresCalculo>
    {
        public ListaFatoresCalculoMap()
        {
            // Primary Key
            this.HasKey(t => t.idListaFatorCalculo);

            // Properties
            this.Property(t => t.ListaFatorCalculo)
                .HasMaxLength(20);

            // Table & Column Mappings
            this.ToTable("ListaFatoresCalculo");
            this.Property(t => t.idListaFatorCalculo).HasColumnName("idListaFatorCalculo");
            this.Property(t => t.ListaFatorCalculo).HasColumnName("ListaFatorCalculo");
            this.Property(t => t.Ativa).HasColumnName("Ativa");
            this.Property(t => t.Padrao).HasColumnName("Padrao");
        }
    }
}
