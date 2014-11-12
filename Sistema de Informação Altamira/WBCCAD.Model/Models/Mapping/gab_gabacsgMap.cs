using System.ComponentModel.DataAnnotations.Schema;
using System.Data.Entity.ModelConfiguration;

namespace WBCCAD.Model.Models.Mapping
{
    public class gab_gabacsgMap : EntityTypeConfiguration<gab_gabacsg>
    {
        public gab_gabacsgMap()
        {
            // Primary Key
            this.HasKey(t => t.idGabGabacsg);

            // Properties
            this.Property(t => t.corte)
                .HasMaxLength(40);

            this.Property(t => t.acessorio)
                .HasMaxLength(40);

            this.Property(t => t.Insercao)
                .HasMaxLength(50);

            // Table & Column Mappings
            this.ToTable("gab_gabacsg");
            this.Property(t => t.corte).HasColumnName("corte");
            this.Property(t => t.acessorio).HasColumnName("acessorio");
            this.Property(t => t.qtde_minima).HasColumnName("qtde_minima");
            this.Property(t => t.qtde_maxima).HasColumnName("qtde_maxima");
            this.Property(t => t.opcional).HasColumnName("opcional");
            this.Property(t => t.dependencia).HasColumnName("dependencia");
            this.Property(t => t.qtde_default).HasColumnName("qtde_default");
            this.Property(t => t.altura_util).HasColumnName("altura_util");
            this.Property(t => t.potencia).HasColumnName("potencia");
            this.Property(t => t.visivel).HasColumnName("visivel");
            this.Property(t => t.prioridade).HasColumnName("prioridade");
            this.Property(t => t.esconder_orcamento).HasColumnName("esconder_orcamento");
            this.Property(t => t.Insercao).HasColumnName("Insercao");
            this.Property(t => t.altura_inicial).HasColumnName("altura_inicial");
            this.Property(t => t.distancia_entre_niveis).HasColumnName("distancia_entre_niveis");
            this.Property(t => t.multiplo_por_modulo).HasColumnName("multiplo_por_modulo");
            this.Property(t => t.comprimento_fixo).HasColumnName("comprimento_fixo");
            this.Property(t => t.afastamento_fundo).HasColumnName("afastamento_fundo");
            this.Property(t => t.travar_representante).HasColumnName("travar_representante");
            this.Property(t => t.altura_fixa).HasColumnName("altura_fixa");
            this.Property(t => t.idGabGabacsg).HasColumnName("idGabGabacsg");
        }
    }
}
