using System.ComponentModel.DataAnnotations.Schema;
using System.Data.Entity.ModelConfiguration;

namespace WBCCAD.Model.Models.Mapping
{
    public class gond_acess_rel_profMap : EntityTypeConfiguration<gond_acess_rel_prof>
    {
        public gond_acess_rel_profMap()
        {
            // Primary Key
            this.HasKey(t => t.idGondAcessRelProf);

            // Properties
            this.Property(t => t.descricao)
                .HasMaxLength(50);

            this.Property(t => t.ang)
                .HasMaxLength(50);

            this.Property(t => t.tipo_frente)
                .HasMaxLength(30);

            this.Property(t => t.conceito)
                .HasMaxLength(50);

            this.Property(t => t.ch_busca)
                .HasMaxLength(20);

            this.Property(t => t.desenho_2d)
                .HasMaxLength(18);

            this.Property(t => t.prefixo_2d)
                .HasMaxLength(12);

            this.Property(t => t.var_larg_2d)
                .HasMaxLength(20);

            this.Property(t => t.var_alt_2d)
                .HasMaxLength(20);

            this.Property(t => t.desenho_3d)
                .HasMaxLength(5);

            this.Property(t => t.prefixo_3d)
                .HasMaxLength(12);

            this.Property(t => t.Var_alt_3d)
                .HasMaxLength(20);

            this.Property(t => t.Var_larg_3d)
                .HasMaxLength(20);

            this.Property(t => t.Var_compr_3d)
                .HasMaxLength(20);

            // Table & Column Mappings
            this.ToTable("gond_acess_rel_prof");
            this.Property(t => t.descricao).HasColumnName("descricao");
            this.Property(t => t.ang).HasColumnName("ang");
            this.Property(t => t.tipo_frente).HasColumnName("tipo_frente");
            this.Property(t => t.id_corte_frontal).HasColumnName("id_corte_frontal");
            this.Property(t => t.conceito).HasColumnName("conceito");
            this.Property(t => t.ch_busca).HasColumnName("ch_busca");
            this.Property(t => t.valor).HasColumnName("valor");
            this.Property(t => t.desenho_2d).HasColumnName("desenho_2d");
            this.Property(t => t.prefixo_2d).HasColumnName("prefixo_2d");
            this.Property(t => t.med_alt_2d).HasColumnName("med_alt_2d");
            this.Property(t => t.med_larg_2d).HasColumnName("med_larg_2d");
            this.Property(t => t.var_larg_2d).HasColumnName("var_larg_2d");
            this.Property(t => t.var_alt_2d).HasColumnName("var_alt_2d");
            this.Property(t => t.afs_fundo_2d).HasColumnName("afs_fundo_2d");
            this.Property(t => t.afs_inicio_2d).HasColumnName("afs_inicio_2d");
            this.Property(t => t.desenho_3d).HasColumnName("desenho_3d");
            this.Property(t => t.prefixo_3d).HasColumnName("prefixo_3d");
            this.Property(t => t.med_alt_3d).HasColumnName("med_alt_3d");
            this.Property(t => t.med_larg_3d).HasColumnName("med_larg_3d");
            this.Property(t => t.med_compr_3d).HasColumnName("med_compr_3d");
            this.Property(t => t.afs_fundo_3d).HasColumnName("afs_fundo_3d");
            this.Property(t => t.afs_inicio_3d).HasColumnName("afs_inicio_3d");
            this.Property(t => t.ativo).HasColumnName("ativo");
            this.Property(t => t.Var_alt_3d).HasColumnName("Var_alt_3d");
            this.Property(t => t.Var_larg_3d).HasColumnName("Var_larg_3d");
            this.Property(t => t.Var_compr_3d).HasColumnName("Var_compr_3d");
            this.Property(t => t.idGondAcessRelProf).HasColumnName("idGondAcessRelProf");
        }
    }
}
