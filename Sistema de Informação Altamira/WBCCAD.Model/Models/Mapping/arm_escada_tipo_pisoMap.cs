using System.ComponentModel.DataAnnotations.Schema;
using System.Data.Entity.ModelConfiguration;

namespace WBCCAD.Model.Models.Mapping
{
    public class arm_escada_tipo_pisoMap : EntityTypeConfiguration<arm_escada_tipo_piso>
    {
        public arm_escada_tipo_pisoMap()
        {
            // Primary Key
            this.HasKey(t => t.padrao);

            // Properties
            this.Property(t => t.descricao)
                .HasMaxLength(100);

            // Table & Column Mappings
            this.ToTable("arm_escada_tipo_piso");
            this.Property(t => t.descricao).HasColumnName("descricao");
            this.Property(t => t.padrao).HasColumnName("padrao");
            this.Property(t => t.largura_degrau_fixa_em).HasColumnName("largura_degrau_fixa_em");
        }
    }
}
