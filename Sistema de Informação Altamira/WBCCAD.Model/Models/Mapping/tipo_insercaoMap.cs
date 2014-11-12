using System.ComponentModel.DataAnnotations.Schema;
using System.Data.Entity.ModelConfiguration;

namespace WBCCAD.Model.Models.Mapping
{
    public class tipo_insercaoMap : EntityTypeConfiguration<tipo_insercao>
    {
        public tipo_insercaoMap()
        {
            // Primary Key
            this.HasKey(t => t.idTipoInsercao);

            // Properties
            this.Property(t => t.inmgab_codigo)
                .HasMaxLength(255);

            // Table & Column Mappings
            this.ToTable("tipo_insercao");
            this.Property(t => t.idTipoInsercao).HasColumnName("idTipoInsercao");
            this.Property(t => t.inmgab_codigo).HasColumnName("inmgab_codigo");
        }
    }
}
