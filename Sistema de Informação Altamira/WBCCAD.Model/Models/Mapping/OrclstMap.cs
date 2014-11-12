using System.ComponentModel.DataAnnotations.Schema;
using System.Data.Entity.ModelConfiguration;

namespace WBCCAD.Model.Models.Mapping
{
    public class OrclstMap : EntityTypeConfiguration<Orclst>
    {
        public OrclstMap()
        {
            // Primary Key
            this.HasKey(t => t.orclst_numero);

            // Properties
            this.Property(t => t.orclst_numero)
                .IsRequired()
                .HasMaxLength(40);

            this.Property(t => t.orclst_loja)
                .HasMaxLength(50);

            this.Property(t => t.orclst_municipio)
                .HasMaxLength(23);

            this.Property(t => t.orclst_uf)
                .HasMaxLength(2);

            this.Property(t => t.orclst_planta)
                .HasMaxLength(1);

            this.Property(t => t.orclst_corte)
                .HasMaxLength(1);

            this.Property(t => t.orclst_orcamento)
                .HasMaxLength(1);

            this.Property(t => t.orclst_nr_orc_vnd)
                .HasMaxLength(10);

            this.Property(t => t.orclst_lista)
                .HasMaxLength(20);

            this.Property(t => t.orclst_revisao)
                .HasMaxLength(1);

            this.Property(t => t.orclst_nova_reforma)
                .HasMaxLength(1);

            this.Property(t => t.orclst_versao_dat)
                .HasMaxLength(10);

            this.Property(t => t.orclst_cli_nome)
                .HasMaxLength(50);

            this.Property(t => t.orclst_cli_cgc_cpf)
                .HasMaxLength(18);

            this.Property(t => t.orclst_cli_end_especie)
                .HasMaxLength(4);

            this.Property(t => t.orclst_cli_end_endereco)
                .HasMaxLength(50);

            this.Property(t => t.orclst_cli_end_numero)
                .HasMaxLength(6);

            this.Property(t => t.orclst_cli_end_bairro)
                .HasMaxLength(30);

            this.Property(t => t.orclst_cli_end_cep)
                .HasMaxLength(9);

            this.Property(t => t.orclst_cli_end_complemento)
                .HasMaxLength(30);

            this.Property(t => t.orclst_cli_bmp)
                .HasMaxLength(255);

            this.Property(t => t.orclst_revisao_orc)
                .HasMaxLength(1);

            this.Property(t => t.orclst_motivo)
                .HasMaxLength(40);

            this.Property(t => t.orclst_caminho_dwg)
                .HasMaxLength(255);

            this.Property(t => t.orclst_pedido)
                .HasMaxLength(15);

            this.Property(t => t.orclst_pedido_usuario)
                .HasMaxLength(255);

            this.Property(t => t.orclst_opcao_comissao)
                .HasMaxLength(50);

            this.Property(t => t.OrcLst_EmUsoPor)
                .HasMaxLength(50);

            this.Property(t => t.OrcLst_Computador)
                .HasMaxLength(50);

            this.Property(t => t.BANDEIRA)
                .HasMaxLength(50);

            this.Property(t => t.ORCLST_REFERENCIA)
                .HasMaxLength(40);

            this.Property(t => t.ORCLST_GERENTE)
                .HasMaxLength(50);

            this.Property(t => t.ORCLST_VENDEDOR)
                .HasMaxLength(50);

            this.Property(t => t.ORCLST_PROJETISTA)
                .HasMaxLength(50);

            this.Property(t => t.ORCLST_ORCAMENTISTA)
                .HasMaxLength(50);

            this.Property(t => t.idOrcLst)
                .HasDatabaseGeneratedOption(DatabaseGeneratedOption.Identity);

            this.Property(t => t.ORCLST_AGENTE)
                .HasMaxLength(60);

            // Table & Column Mappings
            this.ToTable("Orclst");
            this.Property(t => t.orclst_numero).HasColumnName("orclst_numero");
            this.Property(t => t.orclst_status).HasColumnName("orclst_status");
            this.Property(t => t.orclst_cadastro).HasColumnName("orclst_cadastro");
            this.Property(t => t.orclst_emissao).HasColumnName("orclst_emissao");
            this.Property(t => t.orclst_contato).HasColumnName("orclst_contato");
            this.Property(t => t.orclst_loja).HasColumnName("orclst_loja");
            this.Property(t => t.orclst_municipio).HasColumnName("orclst_municipio");
            this.Property(t => t.orclst_uf).HasColumnName("orclst_uf");
            this.Property(t => t.orclst_area).HasColumnName("orclst_area");
            this.Property(t => t.orclst_planta).HasColumnName("orclst_planta");
            this.Property(t => t.orclst_corte).HasColumnName("orclst_corte");
            this.Property(t => t.orclst_orcamento).HasColumnName("orclst_orcamento");
            this.Property(t => t.orclst_nr_orc_vnd).HasColumnName("orclst_nr_orc_vnd");
            this.Property(t => t.orclst_lista).HasColumnName("orclst_lista");
            this.Property(t => t.orclst_revisao).HasColumnName("orclst_revisao");
            this.Property(t => t.orclst_total).HasColumnName("orclst_total");
            this.Property(t => t.orclst_nova_reforma).HasColumnName("orclst_nova_reforma");
            this.Property(t => t.orclst_versao_dat).HasColumnName("orclst_versao_dat");
            this.Property(t => t.orclst_cli_codigo).HasColumnName("orclst_cli_codigo");
            this.Property(t => t.orclst_cli_nome).HasColumnName("orclst_cli_nome");
            this.Property(t => t.orclst_cli_cgc_cpf).HasColumnName("orclst_cli_cgc_cpf");
            this.Property(t => t.orclst_cli_end_especie).HasColumnName("orclst_cli_end_especie");
            this.Property(t => t.orclst_cli_end_endereco).HasColumnName("orclst_cli_end_endereco");
            this.Property(t => t.orclst_cli_end_numero).HasColumnName("orclst_cli_end_numero");
            this.Property(t => t.orclst_cli_end_bairro).HasColumnName("orclst_cli_end_bairro");
            this.Property(t => t.orclst_cli_end_cep).HasColumnName("orclst_cli_end_cep");
            this.Property(t => t.orclst_cli_end_complemento).HasColumnName("orclst_cli_end_complemento");
            this.Property(t => t.orclst_cli_bmp).HasColumnName("orclst_cli_bmp");
            this.Property(t => t.orclst_data_status).HasColumnName("orclst_data_status");
            this.Property(t => t.orclst_revisao_orc).HasColumnName("orclst_revisao_orc");
            this.Property(t => t.orclst_temperatura).HasColumnName("orclst_temperatura");
            this.Property(t => t.orclst_motivo).HasColumnName("orclst_motivo");
            this.Property(t => t.orclst_caminho_dwg).HasColumnName("orclst_caminho_dwg");
            this.Property(t => t.orclst_pedido).HasColumnName("orclst_pedido");
            this.Property(t => t.orclst_pedido_data).HasColumnName("orclst_pedido_data");
            this.Property(t => t.orclst_pedido_usuario).HasColumnName("orclst_pedido_usuario");
            this.Property(t => t.orclst_dataImportacao).HasColumnName("orclst_dataImportacao");
            this.Property(t => t.orclst_email).HasColumnName("orclst_email");
            this.Property(t => t.orclst_data_email).HasColumnName("orclst_data_email");
            this.Property(t => t.orclst_opcao_comissao).HasColumnName("orclst_opcao_comissao");
            this.Property(t => t.OrcLst_EmUsoPor).HasColumnName("OrcLst_EmUsoPor");
            this.Property(t => t.OrcLst_Computador).HasColumnName("OrcLst_Computador");
            this.Property(t => t.BANDEIRA).HasColumnName("BANDEIRA");
            this.Property(t => t.ORCLSTDATAULTATUALIZACAO).HasColumnName("ORCLSTDATAULTATUALIZACAO");
            this.Property(t => t.ORCLSTDATAFATURAMENTO).HasColumnName("ORCLSTDATAFATURAMENTO");
            this.Property(t => t.COMISSAO_FATOR).HasColumnName("COMISSAO_FATOR");
            this.Property(t => t.ORCLST_REFERENCIA).HasColumnName("ORCLST_REFERENCIA");
            this.Property(t => t.ORCLST_TOTAL1).HasColumnName("ORCLST_TOTAL1");
            this.Property(t => t.ORCLST_TOTAL2).HasColumnName("ORCLST_TOTAL2");
            this.Property(t => t.ORCLSTDATAENTREGA).HasColumnName("ORCLSTDATAENTREGA");
            this.Property(t => t.ORCLST_IMPORTACAO_LISTA).HasColumnName("ORCLST_IMPORTACAO_LISTA");
            this.Property(t => t.ORCLST_GERENTE).HasColumnName("ORCLST_GERENTE");
            this.Property(t => t.ORCLST_VENDEDOR).HasColumnName("ORCLST_VENDEDOR");
            this.Property(t => t.ORCLST_PROJETISTA).HasColumnName("ORCLST_PROJETISTA");
            this.Property(t => t.ORCLST_ORCAMENTISTA).HasColumnName("ORCLST_ORCAMENTISTA");
            this.Property(t => t.idOrcLst).HasColumnName("idOrcLst");
            this.Property(t => t.ORCLST_AGENTE).HasColumnName("ORCLST_AGENTE");
            this.Property(t => t.ORCLST_TOTAL_LISTA).HasColumnName("ORCLST_TOTAL_LISTA");
        }
    }
}
