using System.ComponentModel.DataAnnotations.Schema;
using System.Data.Entity.ModelConfiguration;

namespace WBCCAD.Model.Models.Mapping
{
    public class tipo_qtde_p_nivel_formulaMap : EntityTypeConfiguration<tipo_qtde_p_nivel_formula>
    {
        public tipo_qtde_p_nivel_formulaMap()
        {
            // Primary Key
            this.HasKey(t => t.idTipoQtdePNivelFormula);

            // Properties
            this.Property(t => t.qtde_p_nivel_formula)
                .HasMaxLength(100);

            // Table & Column Mappings
            this.ToTable("tipo_qtde_p_nivel_formula");
            this.Property(t => t.idTipoQtdePNivelFormula).HasColumnName("idTipoQtdePNivelFormula");
            this.Property(t => t.qtde_p_nivel_formula).HasColumnName("qtde_p_nivel_formula");
        }
    }
}
