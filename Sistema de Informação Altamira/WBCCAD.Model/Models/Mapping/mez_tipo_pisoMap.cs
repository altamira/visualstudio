using System.ComponentModel.DataAnnotations.Schema;
using System.Data.Entity.ModelConfiguration;

namespace WBCCAD.Model.Models.Mapping
{
    public class mez_tipo_pisoMap : EntityTypeConfiguration<mez_tipo_piso>
    {
        public mez_tipo_pisoMap()
        {
            // Primary Key
            this.HasKey(t => t.metal);

            // Properties
            this.Property(t => t.Nome)
                .HasMaxLength(255);

            this.Property(t => t.Tipo)
                .HasMaxLength(255);

            this.Property(t => t.gp_acab)
                .HasMaxLength(255);

            this.Property(t => t.larg)
                .HasMaxLength(255);

            this.Property(t => t.comp)
                .HasMaxLength(255);

            this.Property(t => t.cor_piso)
                .HasMaxLength(50);

            this.Property(t => t.montar_chave)
                .HasMaxLength(50);

            this.Property(t => t.dim_soma_ao_arremat)
                .HasMaxLength(50);

            // Table & Column Mappings
            this.ToTable("mez_tipo_piso");
            this.Property(t => t.Nome).HasColumnName("Nome");
            this.Property(t => t.Tipo).HasColumnName("Tipo");
            this.Property(t => t.gp_acab).HasColumnName("gp_acab");
            this.Property(t => t.larg).HasColumnName("larg");
            this.Property(t => t.comp).HasColumnName("comp");
            this.Property(t => t.cor_piso).HasColumnName("cor_piso");
            this.Property(t => t.montar_chave).HasColumnName("montar_chave");
            this.Property(t => t.dim_soma_ao_arremat).HasColumnName("dim_soma_ao_arremat");
            this.Property(t => t.metal).HasColumnName("metal");
        }
    }
}
