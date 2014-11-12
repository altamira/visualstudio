using System.ComponentModel.DataAnnotations.Schema;
using System.Data.Entity.ModelConfiguration;

namespace WBCCAD.Model.Models.Mapping
{
    public class gond_rest_cjtoMap : EntityTypeConfiguration<gond_rest_cjto>
    {
        public gond_rest_cjtoMap()
        {
            // Primary Key
            this.HasKey(t => t.idGondRestCjto);

            // Properties
            this.Property(t => t.nome_cjto)
                .HasMaxLength(50);

            // Table & Column Mappings
            this.ToTable("gond_rest_cjto");
            this.Property(t => t.id_restricao).HasColumnName("id_restricao");
            this.Property(t => t.nome_cjto).HasColumnName("nome_cjto");
            this.Property(t => t.idGondRestCjto).HasColumnName("idGondRestCjto");
        }
    }
}
