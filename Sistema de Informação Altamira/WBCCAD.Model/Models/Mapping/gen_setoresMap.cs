using System.ComponentModel.DataAnnotations.Schema;
using System.Data.Entity.ModelConfiguration;

namespace WBCCAD.Model.Models.Mapping
{
    public class gen_setoresMap : EntityTypeConfiguration<gen_setores>
    {
        public gen_setoresMap()
        {
            // Primary Key
            this.HasKey(t => t.indice);

            // Properties
            this.Property(t => t.descricao)
                .HasMaxLength(50);

            this.Property(t => t.nome_eqpto)
                .HasMaxLength(20);

            // Table & Column Mappings
            this.ToTable("gen_setores");
            this.Property(t => t.indice).HasColumnName("indice");
            this.Property(t => t.descricao).HasColumnName("descricao");
            this.Property(t => t.nome_eqpto).HasColumnName("nome_eqpto");
        }
    }
}
