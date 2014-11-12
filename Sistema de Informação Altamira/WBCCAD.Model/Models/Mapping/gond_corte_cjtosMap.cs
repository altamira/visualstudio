using System.ComponentModel.DataAnnotations.Schema;
using System.Data.Entity.ModelConfiguration;

namespace WBCCAD.Model.Models.Mapping
{
    public class gond_corte_cjtosMap : EntityTypeConfiguration<gond_corte_cjtos>
    {
        public gond_corte_cjtosMap()
        {
            // Primary Key
            this.HasKey(t => t.idGondCorteCjtos);

            // Properties
            this.Property(t => t.nome_conjunto)
                .HasMaxLength(100);

            this.Property(t => t.pos_ins)
                .HasMaxLength(50);

            this.Property(t => t.Var_alt)
                .HasMaxLength(20);

            this.Property(t => t.Var_Compr)
                .HasMaxLength(20);

            this.Property(t => t.Var_Prof)
                .HasMaxLength(20);

            this.Property(t => t.qpn_desc)
                .HasMaxLength(20);

            this.Property(t => t.tipo_corte)
                .HasMaxLength(50);

            // Table & Column Mappings
            this.ToTable("gond_corte_cjtos");
            this.Property(t => t.nome_conjunto).HasColumnName("nome_conjunto");
            this.Property(t => t.qtde_niveis).HasColumnName("qtde_niveis");
            this.Property(t => t.tipo_ins).HasColumnName("tipo_ins");
            this.Property(t => t.pos_ins).HasColumnName("pos_ins");
            this.Property(t => t.pos_ins_valor).HasColumnName("pos_ins_valor");
            this.Property(t => t.dist_niveis).HasColumnName("dist_niveis");
            this.Property(t => t.qtde_niveis_min).HasColumnName("qtde_niveis_min");
            this.Property(t => t.qtde_niveis_max).HasColumnName("qtde_niveis_max");
            this.Property(t => t.idcorte).HasColumnName("idcorte");
            this.Property(t => t.Var_alt).HasColumnName("Var_alt");
            this.Property(t => t.Var_Compr).HasColumnName("Var_Compr");
            this.Property(t => t.Var_Prof).HasColumnName("Var_Prof");
            this.Property(t => t.qpn_desc).HasColumnName("qpn_desc");
            this.Property(t => t.qpn_valor).HasColumnName("qpn_valor");
            this.Property(t => t.tipo_corte).HasColumnName("tipo_corte");
            this.Property(t => t.idGondCorteCjtos).HasColumnName("idGondCorteCjtos");
        }
    }
}
