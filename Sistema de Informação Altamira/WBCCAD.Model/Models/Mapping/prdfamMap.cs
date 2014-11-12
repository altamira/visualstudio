using System.ComponentModel.DataAnnotations.Schema;
using System.Data.Entity.ModelConfiguration;

namespace WBCCAD.Model.Models.Mapping
{
    public class prdfamMap : EntityTypeConfiguration<prdfam>
    {
        public prdfamMap()
        {
            // Primary Key
            this.HasKey(t => t.idPrdfam);

            // Properties
            this.Property(t => t.Familia)
                .HasMaxLength(30);

            this.Property(t => t.Descricao)
                .HasMaxLength(50);

            this.Property(t => t.VARPRDESTLST)
                .HasMaxLength(250);

            // Table & Column Mappings
            this.ToTable("prdfam");
            this.Property(t => t.Familia).HasColumnName("Familia");
            this.Property(t => t.Descricao).HasColumnName("Descricao");
            this.Property(t => t.IMPORTAR).HasColumnName("IMPORTAR");
            this.Property(t => t.VARPRDESTLST).HasColumnName("VARPRDESTLST");
            this.Property(t => t.FORMULA).HasColumnName("FORMULA");
            this.Property(t => t.idPrdfam).HasColumnName("idPrdfam");
            this.Property(t => t.descritivoTecnico).HasColumnName("descritivoTecnico");
        }
    }
}
