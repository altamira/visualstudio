using System.ComponentModel.DataAnnotations.Schema;
using System.Data.Entity.ModelConfiguration;

namespace WBCCAD.Model.Models.Mapping
{
    public class tblDados_projetoMap : EntityTypeConfiguration<tblDados_projeto>
    {
        public tblDados_projetoMap()
        {
            // Primary Key
            this.HasKey(t => t.IdOpcao);

            // Properties
            this.Property(t => t.DescricaoChave)
                .HasMaxLength(50);

            this.Property(t => t.chaveValor)
                .HasMaxLength(255);

            this.Property(t => t.grupo)
                .HasMaxLength(50);

            this.Property(t => t.codigochave)
                .HasMaxLength(50);

            this.Property(t => t.Perfil)
                .HasMaxLength(50);

            // Table & Column Mappings
            this.ToTable("tblDados_projeto");
            this.Property(t => t.IdOpcao).HasColumnName("IdOpcao");
            this.Property(t => t.DescricaoChave).HasColumnName("DescricaoChave");
            this.Property(t => t.chaveValor).HasColumnName("chaveValor");
            this.Property(t => t.grupo).HasColumnName("grupo");
            this.Property(t => t.lista).HasColumnName("lista");
            this.Property(t => t.Alterar_no_projeto).HasColumnName("Alterar_no_projeto");
            this.Property(t => t.inativo).HasColumnName("inativo");
            this.Property(t => t.codigochave).HasColumnName("codigochave");
            this.Property(t => t.Somente_administrador).HasColumnName("Somente_administrador");
            this.Property(t => t.Perfil).HasColumnName("Perfil");
        }
    }
}
