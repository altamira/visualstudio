using System.ComponentModel.DataAnnotations.Schema;
using System.Data.Entity.ModelConfiguration;

namespace WBCCAD.Model.Models.Mapping
{
    public class mob_acesMap : EntityTypeConfiguration<mob_aces>
    {
        public mob_acesMap()
        {
            // Primary Key
            this.HasKey(t => t.idMobAces);

            // Properties
            this.Property(t => t.Descricao_principal)
                .HasMaxLength(50);

            this.Property(t => t.descricao_acess)
                .HasMaxLength(50);

            // Table & Column Mappings
            this.ToTable("mob_aces");
            this.Property(t => t.Descricao_principal).HasColumnName("Descricao_principal");
            this.Property(t => t.descricao_acess).HasColumnName("descricao_acess");
            this.Property(t => t.qtde_min).HasColumnName("qtde_min");
            this.Property(t => t.qtde_max).HasColumnName("qtde_max");
            this.Property(t => t.qtde_pad).HasColumnName("qtde_pad");
            this.Property(t => t.obrigatorio).HasColumnName("obrigatorio");
            this.Property(t => t.consumo_eletrico).HasColumnName("consumo_eletrico");
            this.Property(t => t.desl_x).HasColumnName("desl_x");
            this.Property(t => t.desl_y).HasColumnName("desl_y");
            this.Property(t => t.rotacao).HasColumnName("rotacao");
            this.Property(t => t.espelhar).HasColumnName("espelhar");
            this.Property(t => t.desl_z).HasColumnName("desl_z");
            this.Property(t => t.tratar_por_chave).HasColumnName("tratar_por_chave");
            this.Property(t => t.Cor_altera_codigo).HasColumnName("Cor_altera_codigo");
            this.Property(t => t.possui_tensao).HasColumnName("possui_tensao");
            this.Property(t => t.possui_frequencia).HasColumnName("possui_frequencia");
            this.Property(t => t.possui_parametro4).HasColumnName("possui_parametro4");
            this.Property(t => t.possui_parametro5).HasColumnName("possui_parametro5");
            this.Property(t => t.comprimento_entre_acessorios).HasColumnName("comprimento_entre_acessorios");
            this.Property(t => t.tipo_distribuicao).HasColumnName("tipo_distribuicao");
            this.Property(t => t.idMobAces).HasColumnName("idMobAces");
        }
    }
}
