
-------------------------------------------------------------------------------
--pr_migracao_industecnica_nota_saida
-------------------------------------------------------------------------------
--GBS Global Business Solution Ltda                                        2004
-------------------------------------------------------------------------------
--Stored Procedure : Microsoft SQL Server 2000
--Autor(es)        : Carlos Fernandes
--                   Wilder Mendes
--Banco de Dados   : Egissql
--Objetivo         : Migração da Tabela de Ramo 
--Data             : 25.07.2006
--Alteração        : 
------------------------------------------------------------------------------
create procedure pr_migracao_industecnica_nota_saida
as

--Deleta todos os registro da tabela pedido_compra

delete nota_saida

--select * from nota_saida

select
  NOTA                                    as cd_nota_saida,
  cast(0 as int )                         as cd_num_formulario_nota,
  DTEMI                                   as dt_nota_saida
--   cast(0 as int )                         as cd_requisicao_faturamento,
--   cast(0 as int )                         as cd_operacao_fiscal,
-- nm_fantasia_nota_saida
--   cast(0 as int )                         as cd_transportadora,
--   cast(0 as int )                         as cd_destinacao_produto,
--   cast(0 as int )                         as cd_obs_padrao_nf,
--   cast(0 as int )                         as cd_tipo_pagamento_frete,
-- ds_obs_compl_nota_saida
-- qt_peso_liq_nota_saida
-- qt_peso_bruto_nota_saida
-- qt_volume_nota_saida
--   cast(0 as int )                         as cd_especie_embalagem,
-- nm_especie_nota_saida
-- nm_marca_nota_saida
-- cd_placa_nota_saida
-- nm_numero_emb_nota_saida
-- ic_emitida_nota_saida
-- nm_mot_cancel_nota_saida
-- dt_cancel_nota_saida
-- dt_saida_nota_saida
-- 99 as cd_usuario,
-- getdate() dt_usuario,
-- vl_bc_icms
-- vl_icms
-- vl_bc_subst_icms
-- vl_produto
-- vl_frete
-- vl_seguro
-- vl_desp_acess
-- vl_total
-- vl_icms_subst
-- vl_ipi
--   cast(0 as int )                         as cd_vendedor
--   cast(0 as int )                         as cd_fornecedor
--   cast(0 as int )                         as cd_cliente
--   cast(0 as int )                         as cd_itinerario
-- nm_obs_entrega_nota_saida
-- nm_entregador_nota_saida
--   cast(0 as int )                         as cd_observacao_entrega
--   cast(0 as int )                         as cd_entregador
-- ic_entrega_nota_saida
-- sg_estado_placa
-- cd_pedido_cliente
-- cd_status_nota
-- cd_tipo_calculo
--   cast(0 as int )                         as cd_num_formulario
-- cd_cnpj_nota_saida
-- cd_inscest_nota_saida
-- cd_inscmunicipal_nota
-- cd_cep_entrega
-- nm_endereco_entrega
-- cd_numero_endereco_ent
-- nm_complemento_end_ent
-- nm_bairro_entrega
-- cd_ddd_nota_saida
-- cd_telefone_nota_saida
-- cd_fax_nota_saida
-- nm_pais_nota_saida
-- sg_estado_entrega
-- nm_cidade_entrega
-- hr_saida_nota_saida
-- nm_endereco_cobranca
-- nm_bairro_cobranca
-- cd_cep_cobranca
-- nm_cidade_cobranca
-- sg_estado_cobranca
-- cd_numero_endereco_cob
-- nm_complemento_end_cob
-- qt_item_nota_saida
-- ic_outras_operacoes
-- cd_pedido_venda
-- ic_status_nota_saida
-- ds_descricao_servico
-- vl_iss
-- vl_servico
-- ic_minuta_nota_saida
-- dt_entrega_nota_saida
-- sg_estado_nota_saida
-- nm_cidade_nota_saida
-- nm_bairro_nota_saida
-- nm_endereco_nota_saida
-- cd_numero_end_nota_saida
-- cd_cep_nota_saida
-- nm_razao_social_nota
-- nm_razao_social_c
-- cd_mascara_operacao
-- nm_operacao_fiscal
--   cast(0 as int )                         as cd_tipo_destinatario
--   cast(0 as int )                         as cd_contrato_servico
--   cast(0 as int )                         as cd_condicao_pagamento
-- vl_irrf_nota_saida
-- pc_irrf_serv_empresa
-- nm_fantasia_destinatario
-- nm_compl_endereco_nota
-- ic_sedex_nota_saida
-- ic_coleta_nota_saida
-- dt_coleta_nota_saida
-- nm_coleta_nota_saida
--   cast(0 as int )                         as cd_tipo_local_entrega
-- ic_dev_nota_saida
--   cast(0 as int )                         as cd_nota_dev_nota_saida
-- dt_nota_dev_nota_saida
-- nm_razao_social_cliente
-- nm_razao_socila_cliente_c
--   cast(0 as int )                         as cd_tipo_operacao_fiscal
-- vl_bc_ipi
-- cd_mascara_operacao3
-- cd_mascara_operacao2
--   cast(0 as int )                         as cd_operacao_fiscal3
--   cast(0 as int )                         as cd_operacao_fiscal2
-- nm_operacao_fiscal2
-- nm_operacao_fiscal3
--   cast(0 as int )                         as cd_tipo_operacao_fiscal2
--   cast(0 as int )                         as cd_tipo_operacao_fiscal3
--   cast(0 as int )                         as cd_tipo_operacao3
--   cast(0 as int )                         as cd_tipo_operacao2
-- ic_zona_franca
-- cd_nota_fiscal_origem
-- ic_forma_nota_saida
--   cast(0 as int )                         as cd_serie_nota
-- cd_vendedor_externo
-- nm_local_entrega_nota
-- cd_cnpj_entrega_nota
-- cd_inscest_entrega_nota
-- vl_base_icms_reduzida
-- vl_bc_icms_reduzida
-- cd_dde_nota_saida
-- dt_dde_nota_saida
-- nm_fat_com_nota_saida
-- vl_icms_isento
-- vl_icms_outros
-- vl_icms_obs
-- vl_ipi_isento
-- vl_ipi_outros
-- vl_ipi_obs
-- ic_mp66_item_nota_saida
-- ic_fiscal_nota_saida
-- 1 as cd_pais,
-- 1 as cd_moeda,
-- dt_cambio_nota_saida
-- vl_cambio_nota_saida
-- qt_desconto_nota_saida
-- vl_desconto_nota_saida
-- qt_peso_real_nota_saida
-- ds_obs_usuario_nota_saida
-- ic_obs_usuario_nota_saida
-- cd_requisicao_fat_ant
-- qt_ord_entrega_nota_saida
-- ic_credito_icms_nota
-- ic_locacao_cilindro_nota
-- ic_smo_nota_saida
--   cast(0 as int )                         as cd_di
-- cd_guia_trafego_nota_said
-- dt_lancamento_entrega
-- vl_iss_retido
-- vl_cofins
-- vl_pis
-- vl_csll
-- nm_mot_ativacao_nota_saida
-- vl_desp_aduaneira
-- ic_di_carregada
-- vl_ii
-- pc_ii
-- ic_cupom_fiscal
-- cd_cupom_fiscal
--   cast(0 as int )                         as cd_loja
-- vl_simbolico
-- cd_identificacao_nota_saida
-- cd_coleta_nota_saida
-- qt_ord_entregador_saida
-- vl_inss_nota_saida
-- pc_inss_servico
--   cast(0 as int )                         as cd_serie_nota_fiscal
-- vl_icms_desconto
-- ic_etiqueta_nota_saida
-- ic_imposto_nota_saida

into
  #notasaida
from
  KIN.dbo.ivenf


insert into
  nota_saida
select
  * 
from
  #notasaida


drop table #notasaida
select * from nota_saida

