using System.ComponentModel.DataAnnotations.Schema;
using System.Data.Entity.ModelConfiguration;

namespace WBCCAD.Model.Models.Mapping
{
    public class PescabMap : EntityTypeConfiguration<Pescab>
    {
        public PescabMap()
        {
            // Primary Key
            this.HasKey(t => new { t.pescab_codigo, t.idPescab });

            // Properties
            this.Property(t => t.pescab_codigo)
                .HasDatabaseGeneratedOption(DatabaseGeneratedOption.None);

            this.Property(t => t.pescab_nome)
                .HasMaxLength(40);

            this.Property(t => t.pescab_lc_especie)
                .HasMaxLength(4);

            this.Property(t => t.pescab_lc_endereco)
                .HasMaxLength(40);

            this.Property(t => t.pescab_lc_numero)
                .HasMaxLength(6);

            this.Property(t => t.pescab_lc_complemento)
                .HasMaxLength(30);

            this.Property(t => t.pescab_lc_bairro)
                .HasMaxLength(30);

            this.Property(t => t.pescab_lc_municipio)
                .HasMaxLength(30);

            this.Property(t => t.pescab_uf)
                .HasMaxLength(2);

            this.Property(t => t.pescab_ie)
                .HasMaxLength(18);

            this.Property(t => t.pescab_rg)
                .HasMaxLength(18);

            this.Property(t => t.pescab_im)
                .HasMaxLength(30);

            this.Property(t => t.pescab_suframa)
                .HasMaxLength(18);

            this.Property(t => t.pescab_ramo)
                .HasMaxLength(30);

            this.Property(t => t.PAISCODIGO)
                .HasMaxLength(5);

            this.Property(t => t.PESCAB_CONTATO)
                .HasMaxLength(40);

            this.Property(t => t.PESCAB_FONE)
                .HasMaxLength(20);

            this.Property(t => t.PESCAB_FAX)
                .HasMaxLength(20);

            this.Property(t => t.PESCAB_EMAIL)
                .HasMaxLength(50);

            this.Property(t => t.pescab_cob_especie)
                .HasMaxLength(4);

            this.Property(t => t.pescab_cob_endereco)
                .HasMaxLength(40);

            this.Property(t => t.pescab_cob_numero)
                .HasMaxLength(6);

            this.Property(t => t.pescab_cob_complemento)
                .HasMaxLength(30);

            this.Property(t => t.pescab_cob_bairro)
                .HasMaxLength(30);

            this.Property(t => t.pescab_cob_municipio)
                .HasMaxLength(30);

            this.Property(t => t.pescab_cob_uf)
                .HasMaxLength(2);

            this.Property(t => t.pescab_integracao)
                .HasMaxLength(20);

            this.Property(t => t.PESCAB_CODINOME)
                .HasMaxLength(50);

            this.Property(t => t.idPescab)
                .HasDatabaseGeneratedOption(DatabaseGeneratedOption.Identity);

            // Table & Column Mappings
            this.ToTable("Pescab");
            this.Property(t => t.pescab_codigo).HasColumnName("pescab_codigo");
            this.Property(t => t.pescab_nome).HasColumnName("pescab_nome");
            this.Property(t => t.pescab_lc_especie).HasColumnName("pescab_lc_especie");
            this.Property(t => t.pescab_lc_endereco).HasColumnName("pescab_lc_endereco");
            this.Property(t => t.pescab_lc_numero).HasColumnName("pescab_lc_numero");
            this.Property(t => t.pescab_lc_complemento).HasColumnName("pescab_lc_complemento");
            this.Property(t => t.pescab_lc_bairro).HasColumnName("pescab_lc_bairro");
            this.Property(t => t.pescab_lc_municipio).HasColumnName("pescab_lc_municipio");
            this.Property(t => t.pescab_uf).HasColumnName("pescab_uf");
            this.Property(t => t.pescab_cep).HasColumnName("pescab_cep");
            this.Property(t => t.pescab_ie).HasColumnName("pescab_ie");
            this.Property(t => t.pescab_rg).HasColumnName("pescab_rg");
            this.Property(t => t.pescab_im).HasColumnName("pescab_im");
            this.Property(t => t.pescab_suframa).HasColumnName("pescab_suframa");
            this.Property(t => t.pescab_ramo).HasColumnName("pescab_ramo");
            this.Property(t => t.pescab_visita).HasColumnName("pescab_visita");
            this.Property(t => t.PAISCODIGO).HasColumnName("PAISCODIGO");
            this.Property(t => t.PESCAB_CONTATO).HasColumnName("PESCAB_CONTATO");
            this.Property(t => t.PESCAB_FONE).HasColumnName("PESCAB_FONE");
            this.Property(t => t.PESCAB_FAX).HasColumnName("PESCAB_FAX");
            this.Property(t => t.PESCAB_EMAIL).HasColumnName("PESCAB_EMAIL");
            this.Property(t => t.pescab_cob_cep).HasColumnName("pescab_cob_cep");
            this.Property(t => t.pescab_cob_especie).HasColumnName("pescab_cob_especie");
            this.Property(t => t.pescab_cob_endereco).HasColumnName("pescab_cob_endereco");
            this.Property(t => t.pescab_cob_numero).HasColumnName("pescab_cob_numero");
            this.Property(t => t.pescab_cob_complemento).HasColumnName("pescab_cob_complemento");
            this.Property(t => t.pescab_cob_bairro).HasColumnName("pescab_cob_bairro");
            this.Property(t => t.pescab_cob_municipio).HasColumnName("pescab_cob_municipio");
            this.Property(t => t.pescab_cob_uf).HasColumnName("pescab_cob_uf");
            this.Property(t => t.pescab_integracao).HasColumnName("pescab_integracao");
            this.Property(t => t.PESCAB_CODINOME).HasColumnName("PESCAB_CODINOME");
            this.Property(t => t.concorrente).HasColumnName("concorrente");
            this.Property(t => t.idPescab).HasColumnName("idPescab");
        }
    }
}
