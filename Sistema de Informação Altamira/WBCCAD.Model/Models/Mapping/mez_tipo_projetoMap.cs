using System.ComponentModel.DataAnnotations.Schema;
using System.Data.Entity.ModelConfiguration;

namespace WBCCAD.Model.Models.Mapping
{
    public class mez_tipo_projetoMap : EntityTypeConfiguration<mez_tipo_projeto>
    {
        public mez_tipo_projetoMap()
        {
            // Primary Key
            this.HasKey(t => t.selecionado);

            // Properties
            this.Property(t => t.tipo)
                .HasMaxLength(255);

            // Table & Column Mappings
            this.ToTable("mez_tipo_projeto");
            this.Property(t => t.tipo).HasColumnName("tipo");
            this.Property(t => t.selecionado).HasColumnName("selecionado");
        }
    }
}
