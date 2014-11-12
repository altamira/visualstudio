using System.ComponentModel.DataAnnotations.Schema;
using System.Data.Entity.ModelConfiguration;

namespace WBCCAD.Model.Models.Mapping
{
    public class OrcMatMap : EntityTypeConfiguration<OrcMat>
    {
        public OrcMatMap()
        {
            // Primary Key
            this.HasKey(t => new { t.numeroOrcamento, t.orcmat_counter });

            // Properties
            this.Property(t => t.numeroOrcamento)
                .IsRequired()
                .HasMaxLength(50);

            this.Property(t => t.NATUREZA)
                .HasMaxLength(20);

            this.Property(t => t.orcmat_codigo)
                .HasMaxLength(100);

            this.Property(t => t.orcmat_codigo_pai)
                .HasMaxLength(100);

            this.Property(t => t.orcmat_cor)
                .HasMaxLength(20);

            this.Property(t => t.orcmat_descricao)
                .HasMaxLength(255);

            this.Property(t => t.ORCMAT_FORNECEDOR)
                .HasMaxLength(20);

            this.Property(t => t.ORCMAT_IDMDESCRICAO)
                .HasMaxLength(70);

            this.Property(t => t.ORCMAT_IDMUNIDADE)
                .HasMaxLength(5);

            this.Property(t => t.ORCMAT_PRDUNIDADE)
                .HasMaxLength(5);

            this.Property(t => t.orcmatbase)
                .HasMaxLength(50);

            this.Property(t => t.OrcMatCorPesquisa)
                .HasMaxLength(20);

            this.Property(t => t.orcmatlista)
                .HasMaxLength(20);

            this.Property(t => t.ORCMATSITUACAO)
                .HasMaxLength(20);

            this.Property(t => t.OrcMatSubGrupo)
                .HasMaxLength(2);

            this.Property(t => t.orcmat_counter)
                .HasDatabaseGeneratedOption(DatabaseGeneratedOption.Identity);

            // Table & Column Mappings
            this.ToTable("OrcMat");
            this.Property(t => t.numeroOrcamento).HasColumnName("numeroOrcamento");
            this.Property(t => t.COMISSAO_FATOR).HasColumnName("COMISSAO_FATOR");
            this.Property(t => t.ENCARGOS_VALOR).HasColumnName("ENCARGOS_VALOR");
            this.Property(t => t.FreteValor).HasColumnName("FreteValor");
            this.Property(t => t.IcmsBase).HasColumnName("IcmsBase");
            this.Property(t => t.IcmsFator).HasColumnName("IcmsFator");
            this.Property(t => t.IcmsRedutor).HasColumnName("IcmsRedutor");
            this.Property(t => t.IcmsValor).HasColumnName("IcmsValor");
            this.Property(t => t.IpiBase).HasColumnName("IpiBase");
            this.Property(t => t.IpiFator).HasColumnName("IpiFator");
            this.Property(t => t.IpiValor).HasColumnName("IpiValor");
            this.Property(t => t.MontagemValor).HasColumnName("MontagemValor");
            this.Property(t => t.NATUREZA).HasColumnName("NATUREZA");
            this.Property(t => t.orcmat_codigo).HasColumnName("orcmat_codigo");
            this.Property(t => t.orcmat_codigo_pai).HasColumnName("orcmat_codigo_pai");
            this.Property(t => t.orcmat_cor).HasColumnName("orcmat_cor");
            this.Property(t => t.orcmat_descricao).HasColumnName("orcmat_descricao");
            this.Property(t => t.ORCMAT_FORNECEDOR).HasColumnName("ORCMAT_FORNECEDOR");
            this.Property(t => t.ORCMAT_IDMDESCRICAO).HasColumnName("ORCMAT_IDMDESCRICAO");
            this.Property(t => t.ORCMAT_IDMUNIDADE).HasColumnName("ORCMAT_IDMUNIDADE");
            this.Property(t => t.orcmat_peso).HasColumnName("orcmat_peso");
            this.Property(t => t.ORCMAT_PRC_ALTURA).HasColumnName("ORCMAT_PRC_ALTURA");
            this.Property(t => t.ORCMAT_PRC_COMPRIMENTO).HasColumnName("ORCMAT_PRC_COMPRIMENTO");
            this.Property(t => t.ORCMAT_PRC_FORMULA).HasColumnName("ORCMAT_PRC_FORMULA");
            this.Property(t => t.ORCMAT_SEMCENTAVOS).HasColumnName("ORCMAT_SEMCENTAVOS");
            this.Property(t => t.ORCMAT_PRC_LARGURA).HasColumnName("ORCMAT_PRC_LARGURA");
            this.Property(t => t.ORCMAT_PRDUNIDADE).HasColumnName("ORCMAT_PRDUNIDADE");
            this.Property(t => t.orcmat_preco).HasColumnName("orcmat_preco");
            this.Property(t => t.orcmat_preco_lista).HasColumnName("orcmat_preco_lista");
            this.Property(t => t.orcmat_preco_lista_sem).HasColumnName("orcmat_preco_lista_sem");
            this.Property(t => t.ORCMAT_PRECO_TAB).HasColumnName("ORCMAT_PRECO_TAB");
            this.Property(t => t.orcmat_qtde).HasColumnName("orcmat_qtde");
            this.Property(t => t.ORCMATALTURA).HasColumnName("ORCMATALTURA");
            this.Property(t => t.orcmatbase).HasColumnName("orcmatbase");
            this.Property(t => t.ORCMATCOMPRIMENTO).HasColumnName("ORCMATCOMPRIMENTO");
            this.Property(t => t.OrcMatCorPesquisa).HasColumnName("OrcMatCorPesquisa");
            this.Property(t => t.ORCMATDESCONTO).HasColumnName("ORCMATDESCONTO");
            this.Property(t => t.OrcMatGrupo).HasColumnName("OrcMatGrupo");
            this.Property(t => t.ORCMATLARGURA).HasColumnName("ORCMATLARGURA");
            this.Property(t => t.orcmatlista).HasColumnName("orcmatlista");
            this.Property(t => t.ORCMATSITUACAO).HasColumnName("ORCMATSITUACAO");
            this.Property(t => t.OrcMatSubGrupo).HasColumnName("OrcMatSubGrupo");
            this.Property(t => t.PISCOFINSFATOR).HasColumnName("PISCOFINSFATOR");
            this.Property(t => t.PISCOFINSVALOR).HasColumnName("PISCOFINSVALOR");
            this.Property(t => t.PRDORCCHK).HasColumnName("PRDORCCHK");
            this.Property(t => t.preco_fixo).HasColumnName("preco_fixo");
            this.Property(t => t.PISFATOR).HasColumnName("PISFATOR");
            this.Property(t => t.COFINSFATOR).HasColumnName("COFINSFATOR");
            this.Property(t => t.ROYALTIES_CALCULO).HasColumnName("ROYALTIES_CALCULO");
            this.Property(t => t.CUSTO_CALCULO).HasColumnName("CUSTO_CALCULO");
            this.Property(t => t.REPASSE_CALCULO).HasColumnName("REPASSE_CALCULO");
            this.Property(t => t.FRETE_CALCULO).HasColumnName("FRETE_CALCULO");
            this.Property(t => t.INDICE_COMPRA).HasColumnName("INDICE_COMPRA");
            this.Property(t => t.INDICE_FATURAMENTO).HasColumnName("INDICE_FATURAMENTO");
            this.Property(t => t.IPI_NAO_INCLUSO).HasColumnName("IPI_NAO_INCLUSO");
            this.Property(t => t.orcmat_counter).HasColumnName("orcmat_counter");
        }
    }
}
