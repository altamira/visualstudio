using System.ComponentModel.DataAnnotations.Schema;
using System.Data.Entity.ModelConfiguration;

namespace WBCCAD.Model.Models.Mapping
{
    public class conf_empresaMap : EntityTypeConfiguration<conf_empresa>
    {
        public conf_empresaMap()
        {
            // Primary Key
            this.HasKey(t => t.idConfEmpresa);

            // Properties
            this.Property(t => t.Empresa)
                .HasMaxLength(60);

            this.Property(t => t.CGC)
                .HasMaxLength(15);

            this.Property(t => t.IE)
                .HasMaxLength(15);

            this.Property(t => t.ENDERECO)
                .HasMaxLength(60);

            this.Property(t => t.BAIRRO)
                .HasMaxLength(50);

            this.Property(t => t.CIDADE)
                .HasMaxLength(50);

            this.Property(t => t.CEP)
                .HasMaxLength(9);

            this.Property(t => t.ESTADO)
                .HasMaxLength(2);

            this.Property(t => t.bloco_legenda)
                .HasMaxLength(50);

            this.Property(t => t.fone)
                .HasMaxLength(20);

            this.Property(t => t.fax)
                .HasMaxLength(20);

            this.Property(t => t.home)
                .HasMaxLength(30);

            this.Property(t => t.texto_resumo)
                .HasMaxLength(30);

            this.Property(t => t.TabsClientes)
                .HasMaxLength(255);

            this.Property(t => t.TabsPrecos)
                .HasMaxLength(255);

            this.Property(t => t.TipoClientes)
                .HasMaxLength(50);

            this.Property(t => t.TipoPrecos)
                .HasMaxLength(50);

            this.Property(t => t.tipoVendedor)
                .HasMaxLength(50);

            this.Property(t => t.TabsVendedor)
                .HasMaxLength(255);

            this.Property(t => t.imagem_cli)
                .HasMaxLength(70);

            this.Property(t => t.compl_esp)
                .HasMaxLength(50);

            this.Property(t => t.Validade)
                .HasMaxLength(5);

            this.Property(t => t.Prazo_entrega)
                .HasMaxLength(5);

            this.Property(t => t.Posto)
                .HasMaxLength(80);

            this.Property(t => t.IR)
                .HasMaxLength(5);

            this.Property(t => t.TipoFrete)
                .HasMaxLength(50);

            this.Property(t => t.Caminho_nOrca)
                .HasMaxLength(254);

            this.Property(t => t.Lista_de_Precos)
                .HasMaxLength(50);

            this.Property(t => t.LogoTipo)
                .HasMaxLength(100);

            this.Property(t => t.EMAIL2)
                .HasMaxLength(255);

            // Table & Column Mappings
            this.ToTable("conf_empresa");
            this.Property(t => t.Empresa).HasColumnName("Empresa");
            this.Property(t => t.CGC).HasColumnName("CGC");
            this.Property(t => t.IE).HasColumnName("IE");
            this.Property(t => t.ENDERECO).HasColumnName("ENDERECO");
            this.Property(t => t.BAIRRO).HasColumnName("BAIRRO");
            this.Property(t => t.CIDADE).HasColumnName("CIDADE");
            this.Property(t => t.CEP).HasColumnName("CEP");
            this.Property(t => t.ESTADO).HasColumnName("ESTADO");
            this.Property(t => t.CAMINHO_BASE).HasColumnName("CAMINHO_BASE");
            this.Property(t => t.CAMINHO_FIGURA).HasColumnName("CAMINHO_FIGURA");
            this.Property(t => t.texto_bloco).HasColumnName("texto_bloco");
            this.Property(t => t.altura_texto).HasColumnName("altura_texto");
            this.Property(t => t.bloco_legenda).HasColumnName("bloco_legenda");
            this.Property(t => t.af_horizontal).HasColumnName("af_horizontal");
            this.Property(t => t.af_vertical).HasColumnName("af_vertical");
            this.Property(t => t.caminho_alt_figura).HasColumnName("caminho_alt_figura");
            this.Property(t => t.fone).HasColumnName("fone");
            this.Property(t => t.fax).HasColumnName("fax");
            this.Property(t => t.home).HasColumnName("home");
            this.Property(t => t.texto_resumo).HasColumnName("texto_resumo");
            this.Property(t => t.viz_ver).HasColumnName("viz_ver");
            this.Property(t => t.precisao).HasColumnName("precisao");
            this.Property(t => t.End_completo).HasColumnName("End_completo");
            this.Property(t => t.DBFClientes).HasColumnName("DBFClientes");
            this.Property(t => t.TabsClientes).HasColumnName("TabsClientes");
            this.Property(t => t.DBFPrecos).HasColumnName("DBFPrecos");
            this.Property(t => t.TabsPrecos).HasColumnName("TabsPrecos");
            this.Property(t => t.TipoClientes).HasColumnName("TipoClientes");
            this.Property(t => t.TipoPrecos).HasColumnName("TipoPrecos");
            this.Property(t => t.trata_rel).HasColumnName("trata_rel");
            this.Property(t => t.numeracao_1).HasColumnName("numeracao_1");
            this.Property(t => t.numeracao_2).HasColumnName("numeracao_2");
            this.Property(t => t.tipoVendedor).HasColumnName("tipoVendedor");
            this.Property(t => t.DbfVendedor).HasColumnName("DbfVendedor");
            this.Property(t => t.TabsVendedor).HasColumnName("TabsVendedor");
            this.Property(t => t.arquivo_mat).HasColumnName("arquivo_mat");
            this.Property(t => t.set_acess).HasColumnName("set_acess");
            this.Property(t => t.ref_externa).HasColumnName("ref_externa");
            this.Property(t => t.fator_conv).HasColumnName("fator_conv");
            this.Property(t => t.imagem_cli).HasColumnName("imagem_cli");
            this.Property(t => t.ajust_imagem).HasColumnName("ajust_imagem");
            this.Property(t => t.fator_desc).HasColumnName("fator_desc");
            this.Property(t => t.compl_esp).HasColumnName("compl_esp");
            this.Property(t => t.Validade).HasColumnName("Validade");
            this.Property(t => t.Prazo_entrega).HasColumnName("Prazo_entrega");
            this.Property(t => t.Posto).HasColumnName("Posto");
            this.Property(t => t.OrdenCad).HasColumnName("OrdenCad");
            this.Property(t => t.ValFamilia).HasColumnName("ValFamilia");
            this.Property(t => t.IR).HasColumnName("IR");
            this.Property(t => t.OndeVerStatus).HasColumnName("OndeVerStatus");
            this.Property(t => t.ValidStatus).HasColumnName("ValidStatus");
            this.Property(t => t.BloqMaior).HasColumnName("BloqMaior");
            this.Property(t => t.PermValZero).HasColumnName("PermValZero");
            this.Property(t => t.TipoRevisao).HasColumnName("TipoRevisao");
            this.Property(t => t.TipoFrete).HasColumnName("TipoFrete");
            this.Property(t => t.Def_pessoa).HasColumnName("Def_pessoa");
            this.Property(t => t.Acessar_ev).HasColumnName("Acessar_ev");
            this.Property(t => t.Perm_impress).HasColumnName("Perm_impress");
            this.Property(t => t.Perm_Gravar).HasColumnName("Perm_Gravar");
            this.Property(t => t.Viz_Proj_Acess).HasColumnName("Viz_Proj_Acess");
            this.Property(t => t.foco_usua).HasColumnName("foco_usua");
            this.Property(t => t.Caminho_nOrca).HasColumnName("Caminho_nOrca");
            this.Property(t => t.Lista_de_Precos).HasColumnName("Lista_de_Precos");
            this.Property(t => t.LogoTipo).HasColumnName("LogoTipo");
            this.Property(t => t.EMAIL2).HasColumnName("EMAIL2");
            this.Property(t => t.idConfEmpresa).HasColumnName("idConfEmpresa");
        }
    }
}
