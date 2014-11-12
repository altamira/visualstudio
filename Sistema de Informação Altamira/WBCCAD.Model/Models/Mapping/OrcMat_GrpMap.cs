using System.ComponentModel.DataAnnotations.Schema;
using System.Data.Entity.ModelConfiguration;

namespace WBCCAD.Model.Models.Mapping
{
    public class OrcMat_GrpMap : EntityTypeConfiguration<OrcMat_Grp>
    {
        public OrcMat_GrpMap()
        {
            // Primary Key
            this.HasKey(t => t.idOrcMatGrp);

            // Properties
            this.Property(t => t.orcmat_grp_codigo)
                .HasMaxLength(100);

            this.Property(t => t.orcmat_grp_cor)
                .HasMaxLength(20);

            this.Property(t => t.orcmat_grp_subgrupo)
                .IsFixedLength()
                .HasMaxLength(2);

            this.Property(t => t.numeroOrcamento)
                .IsFixedLength()
                .HasMaxLength(9);

            // Table & Column Mappings
            this.ToTable("OrcMat_Grp");
            this.Property(t => t.idOrcMatGrp).HasColumnName("idOrcMatGrp");
            this.Property(t => t.orcmat_grp_codigo).HasColumnName("orcmat_grp_codigo");
            this.Property(t => t.orcmat_grp_cor).HasColumnName("orcmat_grp_cor");
            this.Property(t => t.orcmat_grp_grupo).HasColumnName("orcmat_grp_grupo");
            this.Property(t => t.orcmat_grp_qtde).HasColumnName("orcmat_grp_qtde");
            this.Property(t => t.orcmat_grp_subgrupo).HasColumnName("orcmat_grp_subgrupo");
            this.Property(t => t.numeroOrcamento).HasColumnName("numeroOrcamento");
        }
    }
}
