using System.ComponentModel.DataAnnotations.Schema;
using System.Data.Entity.ModelConfiguration;

namespace WBCCAD.Model.Models.Mapping
{
    public class gond_rest_acessMap : EntityTypeConfiguration<gond_rest_acess>
    {
        public gond_rest_acessMap()
        {
            // Primary Key
            this.HasKey(t => t.idGondRestAcess);

            // Properties
            this.Property(t => t.nome_acess)
                .HasMaxLength(50);

            // Table & Column Mappings
            this.ToTable("gond_rest_acess");
            this.Property(t => t.id_restricao).HasColumnName("id_restricao");
            this.Property(t => t.nome_acess).HasColumnName("nome_acess");
            this.Property(t => t.idGondRestAcess).HasColumnName("idGondRestAcess");
        }
    }
}
