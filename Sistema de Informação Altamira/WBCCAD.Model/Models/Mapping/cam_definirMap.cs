using System.ComponentModel.DataAnnotations.Schema;
using System.Data.Entity.ModelConfiguration;

namespace WBCCAD.Model.Models.Mapping
{
    public class cam_definirMap : EntityTypeConfiguration<cam_definir>
    {
        public cam_definirMap()
        {
            // Primary Key
            this.HasKey(t => t.cam_definir1);

            // Properties
            // Table & Column Mappings
            this.ToTable("cam_definir");
            this.Property(t => t.cam_definir1).HasColumnName("cam_definir");
            this.Property(t => t.comprimento_maximo_painel_teto).HasColumnName("comprimento_maximo_painel_teto");
        }
    }
}
