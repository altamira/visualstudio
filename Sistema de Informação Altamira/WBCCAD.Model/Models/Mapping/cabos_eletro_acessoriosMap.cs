using System.ComponentModel.DataAnnotations.Schema;
using System.Data.Entity.ModelConfiguration;

namespace WBCCAD.Model.Models.Mapping
{
    public class cabos_eletro_acessoriosMap : EntityTypeConfiguration<cabos_eletro_acessorios>
    {
        public cabos_eletro_acessoriosMap()
        {
            // Primary Key
            this.HasKey(t => new { t.dep_dia1, t.dep_dia2, t.qtde_por_compr, t.valido_somente_uc });

            // Properties
            this.Property(t => t.chave)
                .HasMaxLength(50);

            this.Property(t => t.desenho)
                .HasMaxLength(50);

            // Table & Column Mappings
            this.ToTable("cabos_eletro_acessorios");
            this.Property(t => t.dep_dia1).HasColumnName("dep_dia1");
            this.Property(t => t.dep_dia2).HasColumnName("dep_dia2");
            this.Property(t => t.qtde_por_compr).HasColumnName("qtde_por_compr");
            this.Property(t => t.multiplo).HasColumnName("multiplo");
            this.Property(t => t.qtde_p_linha).HasColumnName("qtde_p_linha");
            this.Property(t => t.chave).HasColumnName("chave");
            this.Property(t => t.compr_min_p_incluir).HasColumnName("compr_min_p_incluir");
            this.Property(t => t.valido_somente_uc).HasColumnName("valido_somente_uc");
            this.Property(t => t.desenho).HasColumnName("desenho");
        }
    }
}
