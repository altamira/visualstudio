using System.ComponentModel.DataAnnotations.Schema;
using System.Data.Entity.ModelConfiguration;

namespace WBCCAD.Model.Models.Mapping
{
    public class gond_listaMap : EntityTypeConfiguration<gond_lista>
    {
        public gond_listaMap()
        {
            // Primary Key
            this.HasKey(t => t.idGondLista);

            // Properties
            this.Property(t => t.lista)
                .HasMaxLength(50);

            this.Property(t => t.tipo_cad)
                .HasMaxLength(10);

            this.Property(t => t.sufixo)
                .HasMaxLength(2);

            this.Property(t => t.base_padrao)
                .HasMaxLength(50);

            this.Property(t => t.Utilizar_somente_para_este_perfil)
                .HasMaxLength(50);

            // Table & Column Mappings
            this.ToTable("gond_lista");
            this.Property(t => t.lista).HasColumnName("lista");
            this.Property(t => t.ESCONDER).HasColumnName("ESCONDER");
            this.Property(t => t.esconder_perfil).HasColumnName("esconder_perfil");
            this.Property(t => t.travar_representante).HasColumnName("travar_representante");
            this.Property(t => t.tipo_cad).HasColumnName("tipo_cad");
            this.Property(t => t.sufixo).HasColumnName("sufixo");
            this.Property(t => t.pedir_dados_armazenagem).HasColumnName("pedir_dados_armazenagem");
            this.Property(t => t.base_padrao).HasColumnName("base_padrao");
            this.Property(t => t.Utilizar_somente_para_este_perfil).HasColumnName("Utilizar_somente_para_este_perfil");
            this.Property(t => t.Utilizar_travessas).HasColumnName("Utilizar_travessas");
            this.Property(t => t.idGondLista).HasColumnName("idGondLista");
        }
    }
}
