using System.ComponentModel.DataAnnotations.Schema;
using System.Data.Entity.ModelConfiguration;

namespace WBCCAD.Model.Models.Mapping
{
    public class arm_piso_tipo_cantoneiraMap : EntityTypeConfiguration<arm_piso_tipo_cantoneira>
    {
        public arm_piso_tipo_cantoneiraMap()
        {
            // Primary Key
            this.HasKey(t => t.e_padrao);

            // Properties
            this.Property(t => t.descricao)
                .HasMaxLength(30);

            // Table & Column Mappings
            this.ToTable("arm_piso_tipo_cantoneira");
            this.Property(t => t.descricao).HasColumnName("descricao");
            this.Property(t => t.e_padrao).HasColumnName("e_padrao");
        }
    }
}
