using System.ComponentModel.DataAnnotations.Schema;
using System.Data.Entity.ModelConfiguration;

namespace WBCCAD.Model.Models.Mapping
{
    public class gond_restMap : EntityTypeConfiguration<gond_rest>
    {
        public gond_restMap()
        {
            // Primary Key
            this.HasKey(t => t.id_restricao);

            // Properties
            this.Property(t => t.oque)
                .HasMaxLength(50);

            this.Property(t => t.tipo_rest)
                .HasMaxLength(50);

            this.Property(t => t.obj_rest)
                .HasMaxLength(50);

            this.Property(t => t.quem_cjto)
                .HasMaxLength(50);

            this.Property(t => t.quem_aces)
                .HasMaxLength(50);

            // Table & Column Mappings
            this.ToTable("gond_rest");
            this.Property(t => t.id_restricao).HasColumnName("id_restricao");
            this.Property(t => t.quem_corte).HasColumnName("quem_corte");
            this.Property(t => t.oque).HasColumnName("oque");
            this.Property(t => t.tipo_rest).HasColumnName("tipo_rest");
            this.Property(t => t.obj_rest).HasColumnName("obj_rest");
            this.Property(t => t.quem_cjto).HasColumnName("quem_cjto");
            this.Property(t => t.quem_aces).HasColumnName("quem_aces");
            this.Property(t => t.todos_quem).HasColumnName("todos_quem");
            this.Property(t => t.todos_com_quem).HasColumnName("todos_com_quem");
            this.Property(t => t.e_ou).HasColumnName("e_ou");
        }
    }
}
