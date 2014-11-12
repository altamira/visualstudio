using System.ComponentModel.DataAnnotations.Schema;
using System.Data.Entity.ModelConfiguration;

namespace WBCCAD.Model.Models.Mapping
{
    public class tubula_gas_refrigeranteMap : EntityTypeConfiguration<tubula_gas_refrigerante>
    {
        public tubula_gas_refrigeranteMap()
        {
            // Primary Key
            this.HasKey(t => t.e_padrao);

            // Properties
            this.Property(t => t.descricao_gas)
                .HasMaxLength(50);

            // Table & Column Mappings
            this.ToTable("tubula_gas_refrigerante");
            this.Property(t => t.descricao_gas).HasColumnName("descricao_gas");
            this.Property(t => t.e_padrao).HasColumnName("e_padrao");
            this.Property(t => t.fator_correcao).HasColumnName("fator_correcao");
        }
    }
}
