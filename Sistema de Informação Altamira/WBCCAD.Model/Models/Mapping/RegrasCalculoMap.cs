using System.ComponentModel.DataAnnotations.Schema;
using System.Data.Entity.ModelConfiguration;

namespace WBCCAD.Model.Models.Mapping
{
    public class RegrasCalculoMap : EntityTypeConfiguration<RegrasCalculo>
    {
        public RegrasCalculoMap()
        {
            // Primary Key
            this.HasKey(t => t.idRegraCalculo);

            // Properties
            // Table & Column Mappings
            this.ToTable("RegrasCalculo");
            this.Property(t => t.idRegraCalculo).HasColumnName("idRegraCalculo");
            this.Property(t => t.idListaFatorCalculo).HasColumnName("idListaFatorCalculo");
            this.Property(t => t.idTipoVenda).HasColumnName("idTipoVenda");
            this.Property(t => t.idGrupoImposto).HasColumnName("idGrupoImposto");
            this.Property(t => t.idGrupo).HasColumnName("idGrupo");
            this.Property(t => t.idSubgrupo).HasColumnName("idSubgrupo");
            this.Property(t => t.idFormula).HasColumnName("idFormula");
            this.Property(t => t.descritivoRegra).HasColumnName("descritivoRegra");
        }
    }
}
