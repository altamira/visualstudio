using System.ComponentModel.DataAnnotations.Schema;
using System.Data.Entity.ModelConfiguration;

namespace WBCCAD.Model.Models.Mapping
{
    public class PescliMap : EntityTypeConfiguration<Pescli>
    {
        public PescliMap()
        {
            // Primary Key
            this.HasKey(t => new { t.pescli_codigo, t.idPescli });

            // Properties
            this.Property(t => t.pescli_codigo)
                .HasDatabaseGeneratedOption(DatabaseGeneratedOption.None);

            this.Property(t => t.pescli_et_especie)
                .HasMaxLength(4);

            this.Property(t => t.pescli_et_endereco)
                .HasMaxLength(40);

            this.Property(t => t.pescli_et_numero)
                .HasMaxLength(6);

            this.Property(t => t.pescli_et_complemento)
                .HasMaxLength(30);

            this.Property(t => t.pescli_et_bairro)
                .HasMaxLength(30);

            this.Property(t => t.pescli_et_municipio)
                .HasMaxLength(30);

            this.Property(t => t.pescli_et_uf)
                .HasMaxLength(2);

            this.Property(t => t.pescli_cb_especie)
                .HasMaxLength(4);

            this.Property(t => t.pescli_cb_endereco)
                .HasMaxLength(40);

            this.Property(t => t.pescli_cb_numero)
                .HasMaxLength(6);

            this.Property(t => t.pescli_cb_complemento)
                .HasMaxLength(30);

            this.Property(t => t.pescli_cb_bairro)
                .HasMaxLength(30);

            this.Property(t => t.pescli_cb_municipio)
                .HasMaxLength(30);

            this.Property(t => t.pescli_cb_uf)
                .HasMaxLength(2);

            this.Property(t => t.pescli_categoria)
                .HasMaxLength(20);

            this.Property(t => t.pescli_status)
                .HasMaxLength(30);

            this.Property(t => t.idPescli)
                .HasDatabaseGeneratedOption(DatabaseGeneratedOption.Identity);

            // Table & Column Mappings
            this.ToTable("Pescli");
            this.Property(t => t.pescli_codigo).HasColumnName("pescli_codigo");
            this.Property(t => t.pescli_et_especie).HasColumnName("pescli_et_especie");
            this.Property(t => t.pescli_et_endereco).HasColumnName("pescli_et_endereco");
            this.Property(t => t.pescli_et_numero).HasColumnName("pescli_et_numero");
            this.Property(t => t.pescli_et_complemento).HasColumnName("pescli_et_complemento");
            this.Property(t => t.pescli_et_bairro).HasColumnName("pescli_et_bairro");
            this.Property(t => t.pescli_et_municipio).HasColumnName("pescli_et_municipio");
            this.Property(t => t.pescli_et_uf).HasColumnName("pescli_et_uf");
            this.Property(t => t.pescli_et_cep).HasColumnName("pescli_et_cep");
            this.Property(t => t.pescli_cb_especie).HasColumnName("pescli_cb_especie");
            this.Property(t => t.pescli_cb_endereco).HasColumnName("pescli_cb_endereco");
            this.Property(t => t.pescli_cb_numero).HasColumnName("pescli_cb_numero");
            this.Property(t => t.pescli_cb_complemento).HasColumnName("pescli_cb_complemento");
            this.Property(t => t.pescli_cb_bairro).HasColumnName("pescli_cb_bairro");
            this.Property(t => t.pescli_cb_municipio).HasColumnName("pescli_cb_municipio");
            this.Property(t => t.pescli_cb_uf).HasColumnName("pescli_cb_uf");
            this.Property(t => t.pescli_cb_cep).HasColumnName("pescli_cb_cep");
            this.Property(t => t.pescli_comissao).HasColumnName("pescli_comissao");
            this.Property(t => t.pescli_categoria).HasColumnName("pescli_categoria");
            this.Property(t => t.pescli_status).HasColumnName("pescli_status");
            this.Property(t => t.idPescli).HasColumnName("idPescli");
        }
    }
}
