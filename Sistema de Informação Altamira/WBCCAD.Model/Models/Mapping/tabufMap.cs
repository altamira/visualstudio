using System.ComponentModel.DataAnnotations.Schema;
using System.Data.Entity.ModelConfiguration;

namespace WBCCAD.Model.Models.Mapping
{
    public class tabufMap : EntityTypeConfiguration<tabuf>
    {
        public tabufMap()
        {
            // Primary Key
            this.HasKey(t => t.idTabuf);

            // Properties
            this.Property(t => t.tabuf_codigo)
                .HasMaxLength(2);

            this.Property(t => t.tabuf_descricao)
                .HasMaxLength(40);

            this.Property(t => t.GrupoImpostos)
                .HasMaxLength(50);

            this.Property(t => t.tabuf_regiao)
                .HasMaxLength(2);

            this.Property(t => t.PAISCODIGO)
                .HasMaxLength(5);

            // Table & Column Mappings
            this.ToTable("tabuf");
            this.Property(t => t.tabuf_codigo).HasColumnName("tabuf_codigo");
            this.Property(t => t.tabuf_descricao).HasColumnName("tabuf_descricao");
            this.Property(t => t.GrupoImpostos).HasColumnName("GrupoImpostos");
            this.Property(t => t.tabuf_icms).HasColumnName("tabuf_icms");
            this.Property(t => t.tabuf_icms_local).HasColumnName("tabuf_icms_local");
            this.Property(t => t.Incluir_fator).HasColumnName("Incluir_fator");
            this.Property(t => t.Retirar_fator).HasColumnName("Retirar_fator");
            this.Property(t => t.tabuf_chave_cep).HasColumnName("tabuf_chave_cep");
            this.Property(t => t.tabuf_regiao).HasColumnName("tabuf_regiao");
            this.Property(t => t.PAISCODIGO).HasColumnName("PAISCODIGO");
            this.Property(t => t.idTabuf).HasColumnName("idTabuf");
        }
    }
}
