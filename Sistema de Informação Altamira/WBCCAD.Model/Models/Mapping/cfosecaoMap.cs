using System.ComponentModel.DataAnnotations.Schema;
using System.Data.Entity.ModelConfiguration;

namespace WBCCAD.Model.Models.Mapping
{
    public class cfosecaoMap : EntityTypeConfiguration<cfosecao>
    {
        public cfosecaoMap()
        {
            // Primary Key
            this.HasKey(t => t.imprimir);

            // Properties
            this.Property(t => t.perfil)
                .HasMaxLength(50);

            this.Property(t => t.secao)
                .HasMaxLength(50);

            this.Property(t => t.texto_indice)
                .HasMaxLength(100);

            // Table & Column Mappings
            this.ToTable("cfosecao");
            this.Property(t => t.perfil).HasColumnName("perfil");
            this.Property(t => t.secao).HasColumnName("secao");
            this.Property(t => t.imprimir).HasColumnName("imprimir");
            this.Property(t => t.ordem_impressao).HasColumnName("ordem_impressao");
            this.Property(t => t.texto_indice).HasColumnName("texto_indice");
        }
    }
}
