using System.ComponentModel.DataAnnotations.Schema;
using System.Data.Entity.ModelConfiguration;

namespace WBCCAD.Model.Models.Mapping
{
    public class ORCCABMap : EntityTypeConfiguration<ORCCAB>
    {
        public ORCCABMap()
        {
            // Primary Key
            this.HasKey(t => t.numeroOrcamento);

            // Properties
            this.Property(t => t.numeroOrcamento)
                .IsRequired()
                .IsFixedLength()
                .HasMaxLength(9);

            this.Property(t => t.BANDEIRA)
                .HasMaxLength(50);

            this.Property(t => t.GrupoImpostos)
                .HasMaxLength(50);

            this.Property(t => t.orccab_caminho_dwg)
                .HasMaxLength(255);

            this.Property(t => t.orccab_chave)
                .HasMaxLength(40);

            this.Property(t => t.orccab_cliente_bmp)
                .HasMaxLength(255);

            this.Property(t => t.orccab_cliente_CGC_cpf)
                .HasMaxLength(18);

            this.Property(t => t.orccab_cliente_end_bairro)
                .HasMaxLength(30);

            this.Property(t => t.orccab_cliente_end_cep)
                .HasMaxLength(9);

            this.Property(t => t.orccab_cliente_end_complemento)
                .HasMaxLength(30);

            this.Property(t => t.orccab_cliente_end_endereco)
                .HasMaxLength(50);

            this.Property(t => t.orccab_cliente_end_especie)
                .HasMaxLength(4);

            this.Property(t => t.orccab_cliente_end_numero)
                .HasMaxLength(6);

            this.Property(t => t.orccab_cliente_Nome)
                .HasMaxLength(50);

            this.Property(t => t.ORCCAB_CONTATO_EMAIL)
                .HasMaxLength(70);

            this.Property(t => t.orccab_fax)
                .HasMaxLength(20);

            this.Property(t => t.orccab_fone)
                .HasMaxLength(20);

            this.Property(t => t.orccab_gerente)
                .HasMaxLength(50);

            this.Property(t => t.orccab_ie_rg)
                .HasMaxLength(18);

            this.Property(t => t.orccab_Lista)
                .HasMaxLength(20);

            this.Property(t => t.orccab_loja)
                .HasMaxLength(50);

            this.Property(t => t.orccab_motivo)
                .HasMaxLength(40);

            this.Property(t => t.orccab_municipio)
                .HasMaxLength(23);

            this.Property(t => t.orccab_nova_reforma)
                .HasMaxLength(1);

            this.Property(t => t.orccab_nr_orc_vnd)
                .HasMaxLength(10);

            this.Property(t => t.orccab_opcao_comissao)
                .HasMaxLength(50);

            this.Property(t => t.orccab_opcao_resumo)
                .HasMaxLength(50);

            this.Property(t => t.orccab_orcamentista)
                .HasMaxLength(50);

            this.Property(t => t.orccab_pedido)
                .HasMaxLength(15);

            this.Property(t => t.orccab_Pedido_Usuario)
                .HasMaxLength(255);

            this.Property(t => t.orccab_projetista)
                .HasMaxLength(50);

            this.Property(t => t.orccab_ramo)
                .HasMaxLength(30);

            this.Property(t => t.ORCCAB_REFERENCIA)
                .HasMaxLength(8);

            this.Property(t => t.orccab_revisao)
                .HasMaxLength(1);

            this.Property(t => t.orccab_revisao_orc)
                .HasMaxLength(1);

            this.Property(t => t.orccab_suframa)
                .HasMaxLength(18);

            this.Property(t => t.orccab_UF)
                .HasMaxLength(2);

            this.Property(t => t.orccab_vendedor)
                .HasMaxLength(50);

            this.Property(t => t.orccab_versao_dat)
                .HasMaxLength(10);

            this.Property(t => t.PAISCODIGO)
                .HasMaxLength(5);

            this.Property(t => t.PgtCabCodigo)
                .HasMaxLength(1024);

            this.Property(t => t.TipoVenda)
                .HasMaxLength(50);

            this.Property(t => t.condicaoPagamentoDescricao)
                .HasMaxLength(255);

            this.Property(t => t.orccab_pedido_cliente)
                .HasMaxLength(50);

            this.Property(t => t.orccab_cliente_et_especie)
                .HasMaxLength(4);

            this.Property(t => t.orccab_cliente_et_endereco)
                .HasMaxLength(40);

            this.Property(t => t.orccab_cliente_et_numero)
                .HasMaxLength(6);

            this.Property(t => t.orccab_cliente_et_complemento)
                .HasMaxLength(30);

            this.Property(t => t.orccab_cliente_et_bairro)
                .HasMaxLength(30);

            this.Property(t => t.orccab_cliente_et_municipio)
                .HasMaxLength(30);

            this.Property(t => t.orccab_cliente_et_uf)
                .HasMaxLength(2);

            this.Property(t => t.orccab_cliente_et_cep)
                .HasMaxLength(9);

            this.Property(t => t.orccab_cliente_et_pais)
                .HasMaxLength(5);

            this.Property(t => t.orccab_cliente_cb_especie)
                .HasMaxLength(4);

            this.Property(t => t.orccab_cliente_cb_endereco)
                .HasMaxLength(40);

            this.Property(t => t.orccab_cliente_cb_numero)
                .HasMaxLength(6);

            this.Property(t => t.orccab_cliente_cb_complemento)
                .HasMaxLength(30);

            this.Property(t => t.orccab_cliente_cb_bairro)
                .HasMaxLength(30);

            this.Property(t => t.orccab_cliente_cb_municipio)
                .HasMaxLength(30);

            this.Property(t => t.orccab_cliente_cb_uf)
                .HasMaxLength(2);

            this.Property(t => t.orccab_cliente_cb_cep)
                .HasMaxLength(9);

            this.Property(t => t.orccab_cliente_cb_pais)
                .HasMaxLength(5);

            this.Property(t => t.ObservacoesEntrega)
                .HasMaxLength(255);

            this.Property(t => t.concorrentes)
                .HasMaxLength(1000);

            this.Property(t => t.orccab_cliente_codinome)
                .HasMaxLength(40);

            this.Property(t => t.ORCCAB_AGENTE)
                .HasMaxLength(60);

            // Table & Column Mappings
            this.ToTable("ORCCAB");
            this.Property(t => t.numeroOrcamento).HasColumnName("numeroOrcamento");
            this.Property(t => t.BANDEIRA).HasColumnName("BANDEIRA");
            this.Property(t => t.COMISSAO_FATOR).HasColumnName("COMISSAO_FATOR");
            this.Property(t => t.GrupoImpostos).HasColumnName("GrupoImpostos");
            this.Property(t => t.orccab_Area).HasColumnName("orccab_Area");
            this.Property(t => t.orccab_bloqueado).HasColumnName("orccab_bloqueado");
            this.Property(t => t.orccab_bloquear_icad).HasColumnName("orccab_bloquear_icad");
            this.Property(t => t.orccab_Cadastro).HasColumnName("orccab_Cadastro");
            this.Property(t => t.orccab_caminho_dwg).HasColumnName("orccab_caminho_dwg");
            this.Property(t => t.orccab_chave).HasColumnName("orccab_chave");
            this.Property(t => t.orccab_cliente_bmp).HasColumnName("orccab_cliente_bmp");
            this.Property(t => t.orccab_cliente_CGC_cpf).HasColumnName("orccab_cliente_CGC_cpf");
            this.Property(t => t.orccab_cliente_Codigo).HasColumnName("orccab_cliente_Codigo");
            this.Property(t => t.orccab_cliente_end_bairro).HasColumnName("orccab_cliente_end_bairro");
            this.Property(t => t.orccab_cliente_end_cep).HasColumnName("orccab_cliente_end_cep");
            this.Property(t => t.orccab_cliente_end_complemento).HasColumnName("orccab_cliente_end_complemento");
            this.Property(t => t.orccab_cliente_end_endereco).HasColumnName("orccab_cliente_end_endereco");
            this.Property(t => t.orccab_cliente_end_especie).HasColumnName("orccab_cliente_end_especie");
            this.Property(t => t.orccab_cliente_end_numero).HasColumnName("orccab_cliente_end_numero");
            this.Property(t => t.orccab_cliente_Nome).HasColumnName("orccab_cliente_Nome");
            this.Property(t => t.orccab_contato).HasColumnName("orccab_contato");
            this.Property(t => t.ORCCAB_CONTATO_EMAIL).HasColumnName("ORCCAB_CONTATO_EMAIL");
            this.Property(t => t.OrcCab_data_email).HasColumnName("OrcCab_data_email");
            this.Property(t => t.orccab_Data_preco_Cor).HasColumnName("orccab_Data_preco_Cor");
            this.Property(t => t.orccab_Data_Status).HasColumnName("orccab_Data_Status");
            this.Property(t => t.orccab_desconto_valor).HasColumnName("orccab_desconto_valor");
            this.Property(t => t.OrcCab_Diferenca).HasColumnName("OrcCab_Diferenca");
            this.Property(t => t.orccab_diferenca_valor).HasColumnName("orccab_diferenca_valor");
            this.Property(t => t.OrcCab_email).HasColumnName("OrcCab_email");
            this.Property(t => t.orccab_emissao).HasColumnName("orccab_emissao");
            this.Property(t => t.orccab_encargos_perc).HasColumnName("orccab_encargos_perc");
            this.Property(t => t.orccab_encargos_valor).HasColumnName("orccab_encargos_valor");
            this.Property(t => t.orccab_fax).HasColumnName("orccab_fax");
            this.Property(t => t.orccab_fone).HasColumnName("orccab_fone");
            this.Property(t => t.orccab_frete_valor).HasColumnName("orccab_frete_valor");
            this.Property(t => t.OrcCab_FRETE1).HasColumnName("OrcCab_FRETE1");
            this.Property(t => t.orccab_gerente).HasColumnName("orccab_gerente");
            this.Property(t => t.orccab_ie_rg).HasColumnName("orccab_ie_rg");
            this.Property(t => t.orccab_ipi_valor).HasColumnName("orccab_ipi_valor");
            this.Property(t => t.orccab_Lista).HasColumnName("orccab_Lista");
            this.Property(t => t.orccab_loja).HasColumnName("orccab_loja");
            this.Property(t => t.OrcCab_Montagem).HasColumnName("OrcCab_Montagem");
            this.Property(t => t.orccab_motivo).HasColumnName("orccab_motivo");
            this.Property(t => t.orccab_municipio).HasColumnName("orccab_municipio");
            this.Property(t => t.orccab_nova_reforma).HasColumnName("orccab_nova_reforma");
            this.Property(t => t.orccab_nr_orc_vnd).HasColumnName("orccab_nr_orc_vnd");
            this.Property(t => t.orccab_opcao_comissao).HasColumnName("orccab_opcao_comissao");
            this.Property(t => t.orccab_opcao_resumo).HasColumnName("orccab_opcao_resumo");
            this.Property(t => t.orccab_orcamentista).HasColumnName("orccab_orcamentista");
            this.Property(t => t.orccab_pedido).HasColumnName("orccab_pedido");
            this.Property(t => t.orccab_Pedido_Data).HasColumnName("orccab_Pedido_Data");
            this.Property(t => t.orccab_Pedido_Usuario).HasColumnName("orccab_Pedido_Usuario");
            this.Property(t => t.OrcCab_Preco_lista_Sem).HasColumnName("OrcCab_Preco_lista_Sem");
            this.Property(t => t.orccab_projetista).HasColumnName("orccab_projetista");
            this.Property(t => t.orccab_ramo).HasColumnName("orccab_ramo");
            this.Property(t => t.ORCCAB_REFERENCIA).HasColumnName("ORCCAB_REFERENCIA");
            this.Property(t => t.orccab_revisao).HasColumnName("orccab_revisao");
            this.Property(t => t.orccab_revisao_orc).HasColumnName("orccab_revisao_orc");
            this.Property(t => t.orccab_Status).HasColumnName("orccab_Status");
            this.Property(t => t.orccab_suframa).HasColumnName("orccab_suframa");
            this.Property(t => t.orccab_Temperatura).HasColumnName("orccab_Temperatura");
            this.Property(t => t.orccab_total).HasColumnName("orccab_total");
            this.Property(t => t.orccab_total_geral).HasColumnName("orccab_total_geral");
            this.Property(t => t.ORCCAB_TOTAL1).HasColumnName("ORCCAB_TOTAL1");
            this.Property(t => t.ORCCAB_TOTAL2).HasColumnName("ORCCAB_TOTAL2");
            this.Property(t => t.orccab_UF).HasColumnName("orccab_UF");
            this.Property(t => t.orccab_vendedor).HasColumnName("orccab_vendedor");
            this.Property(t => t.orccab_versao_dat).HasColumnName("orccab_versao_dat");
            this.Property(t => t.ORCCAB_VINCULAR).HasColumnName("ORCCAB_VINCULAR");
            this.Property(t => t.ORCCABDATAENTREGA).HasColumnName("ORCCABDATAENTREGA");
            this.Property(t => t.ORCCABDATAFATURAMENTO).HasColumnName("ORCCABDATAFATURAMENTO");
            this.Property(t => t.ORCCABDATAULTATUALIZACAO).HasColumnName("ORCCABDATAULTATUALIZACAO");
            this.Property(t => t.OrccabFlagImpostos).HasColumnName("OrccabFlagImpostos");
            this.Property(t => t.OrcCabPrecoLista).HasColumnName("OrcCabPrecoLista");
            this.Property(t => t.OrccabTextoProposta).HasColumnName("OrccabTextoProposta");
            this.Property(t => t.ORCCABVALORFINAL1).HasColumnName("ORCCABVALORFINAL1");
            this.Property(t => t.ORCCABVALORFINAL2).HasColumnName("ORCCABVALORFINAL2");
            this.Property(t => t.ORCCABVALORFINAL3).HasColumnName("ORCCABVALORFINAL3");
            this.Property(t => t.ORCCABVALORFINAL4).HasColumnName("ORCCABVALORFINAL4");
            this.Property(t => t.ORCCABVALORFINAL5).HasColumnName("ORCCABVALORFINAL5");
            this.Property(t => t.ORCCABVALORFINAL6).HasColumnName("ORCCABVALORFINAL6");
            this.Property(t => t.ORCCABTROCARFINAL1).HasColumnName("ORCCABTROCARFINAL1");
            this.Property(t => t.ORCCABTROCARFINAL2).HasColumnName("ORCCABTROCARFINAL2");
            this.Property(t => t.ORCCABTROCARFINAL3).HasColumnName("ORCCABTROCARFINAL3");
            this.Property(t => t.ORCCABTROCARFINAL4).HasColumnName("ORCCABTROCARFINAL4");
            this.Property(t => t.ORCCABTROCARFINAL5).HasColumnName("ORCCABTROCARFINAL5");
            this.Property(t => t.ORCCABTROCARFINAL6).HasColumnName("ORCCABTROCARFINAL6");
            this.Property(t => t.ORCCABVALORBASE1).HasColumnName("ORCCABVALORBASE1");
            this.Property(t => t.ORCCABVALORBASE2).HasColumnName("ORCCABVALORBASE2");
            this.Property(t => t.ORCCABVALORBASE3).HasColumnName("ORCCABVALORBASE3");
            this.Property(t => t.ORCCABVALORBASE4).HasColumnName("ORCCABVALORBASE4");
            this.Property(t => t.ORCCABVALORBASE5).HasColumnName("ORCCABVALORBASE5");
            this.Property(t => t.ORCCABVALORBASE6).HasColumnName("ORCCABVALORBASE6");
            this.Property(t => t.PAISCODIGO).HasColumnName("PAISCODIGO");
            this.Property(t => t.PgtCabCodigo).HasColumnName("PgtCabCodigo");
            this.Property(t => t.QtdeAlteradas).HasColumnName("QtdeAlteradas");
            this.Property(t => t.TipoVenda).HasColumnName("TipoVenda");
            this.Property(t => t.condicaoPagamento).HasColumnName("condicaoPagamento");
            this.Property(t => t.condicaoPagamentoDescricao).HasColumnName("condicaoPagamentoDescricao");
            this.Property(t => t.orccab_pedido_cliente).HasColumnName("orccab_pedido_cliente");
            this.Property(t => t.orccab_cliente_et_especie).HasColumnName("orccab_cliente_et_especie");
            this.Property(t => t.orccab_cliente_et_endereco).HasColumnName("orccab_cliente_et_endereco");
            this.Property(t => t.orccab_cliente_et_numero).HasColumnName("orccab_cliente_et_numero");
            this.Property(t => t.orccab_cliente_et_complemento).HasColumnName("orccab_cliente_et_complemento");
            this.Property(t => t.orccab_cliente_et_bairro).HasColumnName("orccab_cliente_et_bairro");
            this.Property(t => t.orccab_cliente_et_municipio).HasColumnName("orccab_cliente_et_municipio");
            this.Property(t => t.orccab_cliente_et_uf).HasColumnName("orccab_cliente_et_uf");
            this.Property(t => t.orccab_cliente_et_cep).HasColumnName("orccab_cliente_et_cep");
            this.Property(t => t.orccab_cliente_et_pais).HasColumnName("orccab_cliente_et_pais");
            this.Property(t => t.orccab_cliente_cb_especie).HasColumnName("orccab_cliente_cb_especie");
            this.Property(t => t.orccab_cliente_cb_endereco).HasColumnName("orccab_cliente_cb_endereco");
            this.Property(t => t.orccab_cliente_cb_numero).HasColumnName("orccab_cliente_cb_numero");
            this.Property(t => t.orccab_cliente_cb_complemento).HasColumnName("orccab_cliente_cb_complemento");
            this.Property(t => t.orccab_cliente_cb_bairro).HasColumnName("orccab_cliente_cb_bairro");
            this.Property(t => t.orccab_cliente_cb_municipio).HasColumnName("orccab_cliente_cb_municipio");
            this.Property(t => t.orccab_cliente_cb_uf).HasColumnName("orccab_cliente_cb_uf");
            this.Property(t => t.orccab_cliente_cb_cep).HasColumnName("orccab_cliente_cb_cep");
            this.Property(t => t.orccab_cliente_cb_pais).HasColumnName("orccab_cliente_cb_pais");
            this.Property(t => t.ObservacoesEntrega).HasColumnName("ObservacoesEntrega");
            this.Property(t => t.orccab_cliente_et_utilizar).HasColumnName("orccab_cliente_et_utilizar");
            this.Property(t => t.orccab_cliente_cb_utilizar).HasColumnName("orccab_cliente_cb_utilizar");
            this.Property(t => t.condicaoPagamentoFator).HasColumnName("condicaoPagamentoFator");
            this.Property(t => t.concorrentes).HasColumnName("concorrentes");
            this.Property(t => t.orccab_cliente_codinome).HasColumnName("orccab_cliente_codinome");
            this.Property(t => t.ORCCAB_AGENTE).HasColumnName("ORCCAB_AGENTE");
        }
    }
}
