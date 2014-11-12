using System.ComponentModel.DataAnnotations.Schema;
using System.Data.Entity.ModelConfiguration;

namespace WBCCAD.Model.Models.Mapping
{
    public class gen_dados_WBCCADMap : EntityTypeConfiguration<gen_dados_WBCCAD>
    {
        public gen_dados_WBCCADMap()
        {
            // Primary Key
            this.HasKey(t => new { t.Nao_mostrar_compr_especial_gond, t.Nao_incluir_fechamento_interno, t.Nao_incluir_plaquetas, t.Nao_cab_leg_tubula, t.utilizar_cabos_eletrica, t.nao_inc_rel_comprimentos_tubula, t.inverter_texto_diametros_legenda });

            // Properties
            this.Property(t => t.nomenclatura_maquinas_uc)
                .HasMaxLength(50);

            // Table & Column Mappings
            this.ToTable("gen_dados_WBCCAD");
            this.Property(t => t.Nao_mostrar_compr_especial_gond).HasColumnName("Nao_mostrar_compr_especial_gond");
            this.Property(t => t.Nao_incluir_fechamento_interno).HasColumnName("Nao_incluir_fechamento_interno");
            this.Property(t => t.Nao_incluir_plaquetas).HasColumnName("Nao_incluir_plaquetas");
            this.Property(t => t.Nao_cab_leg_tubula).HasColumnName("Nao_cab_leg_tubula");
            this.Property(t => t.altura_acima_forcador).HasColumnName("altura_acima_forcador");
            this.Property(t => t.utilizar_cabos_eletrica).HasColumnName("utilizar_cabos_eletrica");
            this.Property(t => t.nomenclatura_maquinas_uc).HasColumnName("nomenclatura_maquinas_uc");
            this.Property(t => t.acresc_kcal_uc).HasColumnName("acresc_kcal_uc");
            this.Property(t => t.Valor_padrao_subida_maquina).HasColumnName("Valor_padrao_subida_maquina");
            this.Property(t => t.nao_inc_rel_comprimentos_tubula).HasColumnName("nao_inc_rel_comprimentos_tubula");
            this.Property(t => t.Altura_canaleta_tubula).HasColumnName("Altura_canaleta_tubula");
            this.Property(t => t.altura_minima_incluir_subida).HasColumnName("altura_minima_incluir_subida");
            this.Property(t => t.inverter_texto_diametros_legenda).HasColumnName("inverter_texto_diametros_legenda");
        }
    }
}
