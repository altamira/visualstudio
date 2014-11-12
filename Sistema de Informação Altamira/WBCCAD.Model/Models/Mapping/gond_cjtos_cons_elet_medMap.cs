using System.ComponentModel.DataAnnotations.Schema;
using System.Data.Entity.ModelConfiguration;

namespace WBCCAD.Model.Models.Mapping
{
    public class gond_cjtos_cons_elet_medMap : EntityTypeConfiguration<gond_cjtos_cons_elet_med>
    {
        public gond_cjtos_cons_elet_medMap()
        {
            // Primary Key
            this.HasKey(t => t.idGondCjtosConsEletMed);

            // Properties
            this.Property(t => t.conjunto)
                .HasMaxLength(50);

            this.Property(t => t.tipo)
                .HasMaxLength(50);

            this.Property(t => t.equivalencia)
                .HasMaxLength(50);

            // Table & Column Mappings
            this.ToTable("gond_cjtos_cons_elet_med");
            this.Property(t => t.conjunto).HasColumnName("conjunto");
            this.Property(t => t.tipo).HasColumnName("tipo");
            this.Property(t => t.valor).HasColumnName("valor");
            this.Property(t => t.equivalencia).HasColumnName("equivalencia");
            this.Property(t => t.idGondCjtosConsEletMed).HasColumnName("idGondCjtosConsEletMed");
        }
    }
}
