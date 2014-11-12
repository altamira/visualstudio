using System.ComponentModel.DataAnnotations.Schema;
using System.Data.Entity.ModelConfiguration;

namespace WBCCAD.Model.Models.Mapping
{
    public class arq_janela_portaMap : EntityTypeConfiguration<arq_janela_porta>
    {
        public arq_janela_portaMap()
        {
            // Primary Key
            this.HasKey(t => new { t.espelhar_1, t.espelhar_2 });

            // Properties
            this.Property(t => t.descricao)
                .HasMaxLength(50);

            this.Property(t => t.desenho)
                .HasMaxLength(100);

            this.Property(t => t.tipo)
                .HasMaxLength(50);

            // Table & Column Mappings
            this.ToTable("arq_janela_porta");
            this.Property(t => t.descricao).HasColumnName("descricao");
            this.Property(t => t.desenho).HasColumnName("desenho");
            this.Property(t => t.medida_comprimento).HasColumnName("medida_comprimento");
            this.Property(t => t.tipo).HasColumnName("tipo");
            this.Property(t => t.espelhar_1).HasColumnName("espelhar_1");
            this.Property(t => t.medida_altura).HasColumnName("medida_altura");
            this.Property(t => t.espelhar_2).HasColumnName("espelhar_2");
            this.Property(t => t.Altura_peitoril).HasColumnName("Altura_peitoril");
        }
    }
}
