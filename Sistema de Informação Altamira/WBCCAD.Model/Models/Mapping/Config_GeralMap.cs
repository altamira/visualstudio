using System.ComponentModel.DataAnnotations.Schema;
using System.Data.Entity.ModelConfiguration;

namespace WBCCAD.Model.Models.Mapping
{
    public class Config_GeralMap : EntityTypeConfiguration<Config_Geral>
    {
        public Config_GeralMap()
        {
            // Primary Key
            this.HasKey(t => new { t.inc_pai, t.inc_teto, t.inc_piso, t.autocad, t.IdConfigGeral });

            // Properties
            this.Property(t => t.Dir_sistema)
                .HasMaxLength(100);

            this.Property(t => t.Dir_padrao_dados)
                .HasMaxLength(100);

            this.Property(t => t.Dir_resumo)
                .HasMaxLength(100);

            this.Property(t => t.Sufixo_gond)
                .HasMaxLength(2);

            this.Property(t => t.Sufixo_gond_estr)
                .HasMaxLength(2);

            this.Property(t => t.Corte_gond_pad)
                .HasMaxLength(45);

            this.Property(t => t.Fundo_gond_pad)
                .HasMaxLength(49);

            this.Property(t => t.Frente_gond_pad)
                .HasMaxLength(50);

            this.Property(t => t.Base_gond_pad)
                .HasMaxLength(50);

            this.Property(t => t.Pad_lista_Gond)
                .HasMaxLength(20);

            this.Property(t => t.Bloco_legenda)
                .HasMaxLength(100);

            this.Property(t => t.Pad_lista_exp)
                .HasMaxLength(20);

            this.Property(t => t.Pad_lista_Camara)
                .HasMaxLength(20);

            this.Property(t => t.Pad_lista_Maq)
                .HasMaxLength(20);

            this.Property(t => t.Perfil_Config)
                .HasMaxLength(50);

            this.Property(t => t.prefixo_orcamento)
                .HasMaxLength(4);

            this.Property(t => t.dir_cartas)
                .HasMaxLength(100);

            this.Property(t => t.dir_imagens)
                .HasMaxLength(100);

            this.Property(t => t.dir_dwg)
                .HasMaxLength(150);

            this.Property(t => t.Tipomed)
                .HasMaxLength(50);

            this.Property(t => t.comp_min_gab)
                .HasMaxLength(5);

            this.Property(t => t.comp_max_gab)
                .HasMaxLength(5);

            this.Property(t => t.dwg_padrao)
                .HasMaxLength(255);

            this.Property(t => t.sufixo_gond_pta)
                .HasMaxLength(2);

            this.Property(t => t.Corte_gond_pta_pad)
                .HasMaxLength(20);

            this.Property(t => t.fundo_gond_pta_pad)
                .HasMaxLength(50);

            this.Property(t => t.base_gond_pta_pad)
                .HasMaxLength(50);

            this.Property(t => t.cfgPassword)
                .HasMaxLength(50);

            this.Property(t => t.DIR_MOB_USUARIO)
                .HasMaxLength(100);

            this.Property(t => t.IdConfigGeral)
                .HasDatabaseGeneratedOption(DatabaseGeneratedOption.Identity);

            // Table & Column Mappings
            this.ToTable("Config_Geral");
            this.Property(t => t.Dir_sistema).HasColumnName("Dir_sistema");
            this.Property(t => t.Dir_padrao_dados).HasColumnName("Dir_padrao_dados");
            this.Property(t => t.Dir_resumo).HasColumnName("Dir_resumo");
            this.Property(t => t.Prof_estr_gond).HasColumnName("Prof_estr_gond");
            this.Property(t => t.Prof_estr_gond_ponta).HasColumnName("Prof_estr_gond_ponta");
            this.Property(t => t.Sufixo_gond).HasColumnName("Sufixo_gond");
            this.Property(t => t.Sufixo_gond_estr).HasColumnName("Sufixo_gond_estr");
            this.Property(t => t.Compr_ang_int).HasColumnName("Compr_ang_int");
            this.Property(t => t.Alt_txt_planta).HasColumnName("Alt_txt_planta");
            this.Property(t => t.Alt_txt_corte).HasColumnName("Alt_txt_corte");
            this.Property(t => t.Dist_hori_corte).HasColumnName("Dist_hori_corte");
            this.Property(t => t.Dist_vert_corte).HasColumnName("Dist_vert_corte");
            this.Property(t => t.Num_col_cortes).HasColumnName("Num_col_cortes");
            this.Property(t => t.Esc_des_formato).HasColumnName("Esc_des_formato");
            this.Property(t => t.Alt_text_formato).HasColumnName("Alt_text_formato");
            this.Property(t => t.Corte_gond_pad).HasColumnName("Corte_gond_pad");
            this.Property(t => t.Alt_gond_pad).HasColumnName("Alt_gond_pad");
            this.Property(t => t.Prof_gond_pad).HasColumnName("Prof_gond_pad");
            this.Property(t => t.Fundo_gond_pad).HasColumnName("Fundo_gond_pad");
            this.Property(t => t.Frente_gond_pad).HasColumnName("Frente_gond_pad");
            this.Property(t => t.Base_gond_pad).HasColumnName("Base_gond_pad");
            this.Property(t => t.Pad_lista_Gond).HasColumnName("Pad_lista_Gond");
            this.Property(t => t.Bloco_legenda).HasColumnName("Bloco_legenda");
            this.Property(t => t.Afast_vert).HasColumnName("Afast_vert");
            this.Property(t => t.Afast_Hori).HasColumnName("Afast_Hori");
            this.Property(t => t.Pad_lista_exp).HasColumnName("Pad_lista_exp");
            this.Property(t => t.Pad_lista_Camara).HasColumnName("Pad_lista_Camara");
            this.Property(t => t.Pad_lista_Maq).HasColumnName("Pad_lista_Maq");
            this.Property(t => t.Perfil_Config).HasColumnName("Perfil_Config");
            this.Property(t => t.comp_min_gond).HasColumnName("comp_min_gond");
            this.Property(t => t.comp_max_gond).HasColumnName("comp_max_gond");
            this.Property(t => t.prefixo_orcamento).HasColumnName("prefixo_orcamento");
            this.Property(t => t.dir_cartas).HasColumnName("dir_cartas");
            this.Property(t => t.dir_imagens).HasColumnName("dir_imagens");
            this.Property(t => t.inc_pai).HasColumnName("inc_pai");
            this.Property(t => t.inc_teto).HasColumnName("inc_teto");
            this.Property(t => t.inc_piso).HasColumnName("inc_piso");
            this.Property(t => t.dir_dwg).HasColumnName("dir_dwg");
            this.Property(t => t.Tipomed).HasColumnName("Tipomed");
            this.Property(t => t.autocad).HasColumnName("autocad");
            this.Property(t => t.comp_min_gab).HasColumnName("comp_min_gab");
            this.Property(t => t.comp_max_gab).HasColumnName("comp_max_gab");
            this.Property(t => t.dwg_padrao).HasColumnName("dwg_padrao");
            this.Property(t => t.t_salvar).HasColumnName("t_salvar");
            this.Property(t => t.hab_prop).HasColumnName("hab_prop");
            this.Property(t => t.hab_vis).HasColumnName("hab_vis");
            this.Property(t => t.sufixo_gond_pta).HasColumnName("sufixo_gond_pta");
            this.Property(t => t.Corte_gond_pta_pad).HasColumnName("Corte_gond_pta_pad");
            this.Property(t => t.fundo_gond_pta_pad).HasColumnName("fundo_gond_pta_pad");
            this.Property(t => t.base_gond_pta_pad).HasColumnName("base_gond_pta_pad");
            this.Property(t => t.cfgPassword).HasColumnName("cfgPassword");
            this.Property(t => t.DIR_MOB_USUARIO).HasColumnName("DIR_MOB_USUARIO");
            this.Property(t => t.IdConfigGeral).HasColumnName("IdConfigGeral");
        }
    }
}
