using System.ComponentModel.DataAnnotations.Schema;
using System.Data.Entity.ModelConfiguration;

namespace WBCCAD.Model.Models.Mapping
{
    public class tab_cadastrosMap : EntityTypeConfiguration<tab_cadastros>
    {
        public tab_cadastrosMap()
        {
            // Primary Key
            this.HasKey(t => t.indice);

            // Properties
            this.Property(t => t.descr_usu)
                .HasMaxLength(50);

            this.Property(t => t.tabela)
                .HasMaxLength(50);

            this.Property(t => t.tipo_cad)
                .HasMaxLength(50);

            this.Property(t => t.tipo_usar)
                .HasMaxLength(50);

            this.Property(t => t.tab_seg)
                .HasMaxLength(50);

            this.Property(t => t.tab_tab1_tabseg)
                .HasMaxLength(50);

            this.Property(t => t.tabela_chave)
                .HasMaxLength(50);

            this.Property(t => t.tab_seg_chave)
                .HasMaxLength(50);

            this.Property(t => t.Campo_ref_tab)
                .HasMaxLength(50);

            this.Property(t => t.Campo_ref_seg)
                .HasMaxLength(50);

            this.Property(t => t.formulario)
                .HasMaxLength(50);

            // Table & Column Mappings
            this.ToTable("tab_cadastros");
            this.Property(t => t.indice).HasColumnName("indice");
            this.Property(t => t.descr_usu).HasColumnName("descr_usu");
            this.Property(t => t.tabela).HasColumnName("tabela");
            this.Property(t => t.uso_interno).HasColumnName("uso_interno");
            this.Property(t => t.tipo_cad).HasColumnName("tipo_cad");
            this.Property(t => t.tipo_usar).HasColumnName("tipo_usar");
            this.Property(t => t.tab_seg).HasColumnName("tab_seg");
            this.Property(t => t.tab_tab1_tabseg).HasColumnName("tab_tab1_tabseg");
            this.Property(t => t.tabela_chave).HasColumnName("tabela_chave");
            this.Property(t => t.tab_seg_chave).HasColumnName("tab_seg_chave");
            this.Property(t => t.Campo_ref_tab).HasColumnName("Campo_ref_tab");
            this.Property(t => t.Campo_ref_seg).HasColumnName("Campo_ref_seg");
            this.Property(t => t.formulario).HasColumnName("formulario");
        }
    }
}
