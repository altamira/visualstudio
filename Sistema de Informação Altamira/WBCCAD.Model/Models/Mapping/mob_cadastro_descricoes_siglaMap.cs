using System.ComponentModel.DataAnnotations.Schema;
using System.Data.Entity.ModelConfiguration;

namespace WBCCAD.Model.Models.Mapping
{
    public class mob_cadastro_descricoes_siglaMap : EntityTypeConfiguration<mob_cadastro_descricoes_sigla>
    {
        public mob_cadastro_descricoes_siglaMap()
        {
            // Primary Key
            this.HasKey(t => t.idMobCadastroDescricoesSigla);

            // Properties
            this.Property(t => t.descricao)
                .HasMaxLength(50);

            this.Property(t => t.sigla)
                .HasMaxLength(10);

            // Table & Column Mappings
            this.ToTable("mob_cadastro_descricoes_sigla");
            this.Property(t => t.descricao).HasColumnName("descricao");
            this.Property(t => t.sigla).HasColumnName("sigla");
            this.Property(t => t.par_p_compr).HasColumnName("par_p_compr");
            this.Property(t => t.par_p_prof).HasColumnName("par_p_prof");
            this.Property(t => t.par_p_alt).HasColumnName("par_p_alt");
            this.Property(t => t.idMobCadastroDescricoesSigla).HasColumnName("idMobCadastroDescricoesSigla");
        }
    }
}
