using System.ComponentModel.DataAnnotations.Schema;
using System.Data.Entity.ModelConfiguration;

namespace WBCCAD.Model.Models.Mapping
{
    public class mez_tipo_vigaMap : EntityTypeConfiguration<mez_tipo_viga>
    {
        public mez_tipo_vigaMap()
        {
            // Primary Key
            this.HasKey(t => t.especial);

            // Properties
            this.Property(t => t.nome)
                .HasMaxLength(255);

            this.Property(t => t.tipo)
                .HasMaxLength(255);

            this.Property(t => t.estilo)
                .HasMaxLength(255);

            this.Property(t => t.gp_acab)
                .HasMaxLength(255);

            this.Property(t => t.sigla_ref_viga)
                .HasMaxLength(50);

            this.Property(t => t.desenho)
                .HasMaxLength(50);

            // Table & Column Mappings
            this.ToTable("mez_tipo_viga");
            this.Property(t => t.nome).HasColumnName("nome");
            this.Property(t => t.comprimento).HasColumnName("comprimento");
            this.Property(t => t.largura).HasColumnName("largura");
            this.Property(t => t.altura).HasColumnName("altura");
            this.Property(t => t.qtde_max).HasColumnName("qtde_max");
            this.Property(t => t.qtde_min).HasColumnName("qtde_min");
            this.Property(t => t.tipo).HasColumnName("tipo");
            this.Property(t => t.estilo).HasColumnName("estilo");
            this.Property(t => t.gp_acab).HasColumnName("gp_acab");
            this.Property(t => t.especial).HasColumnName("especial");
            this.Property(t => t.sigla_ref_viga).HasColumnName("sigla_ref_viga");
            this.Property(t => t.desenho).HasColumnName("desenho");
            this.Property(t => t.wx).HasColumnName("wx");
            this.Property(t => t.ix).HasColumnName("ix");
        }
    }
}
