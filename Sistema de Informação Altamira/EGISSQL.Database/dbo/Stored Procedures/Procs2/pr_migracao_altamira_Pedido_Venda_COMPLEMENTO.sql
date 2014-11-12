
-------------------------------------------------------------------------------
--pr_migracao_altamira_Pedido_Venda
-------------------------------------------------------------------------------
--GBS Global Business Solution Ltda                                        2006
-------------------------------------------------------------------------------
--Stored Procedure : Microsoft SQL Server 2000
--Autor(es)        : Carlos Fernandes
--Banco de Dados   : Egissql
--Objetivo         : Migração da Tabela
--Data             : 08.09.2006
--Alteração        : 
------------------------------------------------------------------------------
create procedure pr_migracao_altamira_Pedido_Venda_COMPLEMENTO

as

select
  DISTINCT
  vepe_pedido                      as cd_pedido_venda,
  vepe_DataPedido                  as dt_pedido_venda,
  cast(vepe_Representante as int ) as cd_vendedor_pedido,
  isnull(c.cd_vendedor_interno,1)  as cd_vendedor_interno,
  'S'                              as ic_emitido_pedido_venda,
  cast(vepe_Observacao as varchar) as ds_pedido_venda,
  cast('' as varchar)              as ds_pedido_venda_fatura,
  cast('' as varchar)              as ds_cancelamento_pedido,
  4                                as cd_usuario_credito_pedido,
  vepe_DataPedido                  as dt_credito_pedido_venda,
  'N'                              as ic_smo_pedido_venda,
  vepe_ValorTabela                 as vl_total_pedido_venda,
  cast(0.00 as float )             as qt_liquido_pedido_venda,
  cast(0.00 as float )             as qt_bruto_pedido_venda,
  null                             as dt_conferido_pedido_venda,
  'S'                              as ic_pcp_pedido_venda,
  null                             as ic_lista_pcp_pedido_venda,
  'S'                              as ic_processo_pedido_venda,
  'N'                              as ic_lista_processo_pedido,
  null                             as ic_imed_pedido_venda,
  null                             as ic_lista_imed_pedido,
  null                             as nm_alteracao_pedido_venda,
  'N'                              as ic_consignacao_pedido,
  null                             as dt_cambio_pedido_venda,
  null                             as cd_cliente_entrega,
  'N'                              as ic_op_triang_pedido_venda,
  null                             as ic_nf_op_triang_pedido,
  null                             as nm_contato_op_triang,
  vepe_PedidoCliente               as cd_pdcompra_pedido_venda,
  null                             as cd_processo_exportacao,
  c.cd_cliente,
--  null                             as cd_tipo_frete,
  vepe_TipoTransporte              as cd_tipo_frete,
  null                             as cd_tipo_restricao_pedido,
  --select * from destinacao_produto
  2                                as cd_destinacao_produto,
  1                                as cd_tipo_pedido,
  vepe_Transportadora              as cd_transportadora,
  cast(vepe_Representante as int ) as cd_vendedor,
  1 as                             cd_tipo_endereco,
  1 as cd_moeda,
  (select top 1 cd_contato from cliente_contato cc
   where
     c.cd_cliente =  cc.cd_cliente ) as cd_contato,
-- null as cd_contato,
  4    as cd_usuario,
  getdate() as dt_usuario,
  null                              as dt_cancelamento_pedido,
  137                               as cd_condicao_pagamento,
  case when cast(vepe_NotaFiscal as int )>0 then
   2 
  else 
   1 
  end                               as cd_status_pedido,
  1 as cd_tipo_entrega_produto,
  vepe_Projeto                      as nm_referencia_consulta,
  null                              as vl_custo_financeiro,
  'N'                               as ic_custo_financeiro,
  null                              as vl_tx_mensal_cust_fin,
  2                                 as cd_tipo_pagamento_frete,
  null                              as nm_assina_pedido,
  null                              as ic_fax_pedido,
  null                              as ic_mail_pedido,
  vepe_ValorTabela + vepe_ValorIPI  as vl_total_pedido_ipi,
  vepe_ValorIPI                     as vl_total_ipi,
  cast(vepe_Observacao as varchar) as ds_observacao_pedido,
  null as cd_usuario_atendente,
  'S'                               as ic_fechado_pedido,
  1                                 as ic_vendedor_interno,
  null                              as cd_representante,
  null                              as ic_transf_matriz,
  null                              as ic_digitacao,
  null                              as ic_pedido_venda,
  null                              as hr_inicial_pedido,
  null                              as ic_outro_cliente,
  'S'                               as ic_fechamento_total,
  null                              as ic_operacao_triangular,
  null                              as ic_fatsmo_pedido,
  cast('' as varchar)               as ds_ativacao_pedido,
  null                              as dt_ativacao_pedido,
  cast('' as varchar)               as ds_obs_fat_pedido,
  'N' as ic_obs_corpo_nf,
  vepe_DataPedido                   as dt_fechamento_pedido,
  null                              as cd_cliente_faturar,
  1                                 as cd_tipo_local_entrega,
  null                              as ic_etiq_emb_pedido_venda,
  vepe_Orcamento                    as cd_consulta,
  null                              as dt_alteracao_pedido_venda,
  null                              as ic_dt_especifica_ped_vend,
  null                              as ic_dt_especifica_consulta,
  null                              as ic_fat_pedido_venda,
  null                              as ic_fat_total_pedido_venda,
  null                              as qt_volume_pedido_venda,
  null                              as qt_fatpbru_pedido_venda,
  null                              as ic_permite_agrupar_pedido,
  null                              as qt_fatpliq_pedido_venda,
  null                              as vl_indice_pedido_venda,
  null                              as vl_sedex_pedido_venda,
  null                              as pc_desconto_pedido_venda,
  vepe_Comissao                     as pc_comissao_pedido_venda,
  null                              as cd_plano_financeiro,
  cast('' as varchar)               as ds_multa_pedido_venda,
  null                              as vl_freq_multa_ped_venda,
  null                              as vl_base_multa_ped_venda,
  null                              as pc_limite_multa_ped_venda,
  null                              as pc_multa_pedido_venda,
  null                              as cd_fase_produto_contrato,
  null                              as nm_obs_restricao_pedido,
  null                              as cd_usu_restricao_pedido,
  null                              as dt_lib_restricao_pedido,
  null                              as nm_contato_op_triang_ped,
  'N' as ic_amostra_pedido_venda,
  null                              as ic_alteracao_pedido_venda,
  'N' as ic_calcula_sedex,
  null                              as vl_frete_pedido_venda,
  'N' as ic_calcula_peso,
  'N' as ic_subs_trib_pedido_venda,
  'N' as ic_credito_icms_pedido,
  null                              as cd_usu_lib_fat_min_pedido,
  null                              as dt_lib_fat_min_pedido,
  null                              as cd_identificacao_empresa,
  vepe_Comissao                     as pc_comissao_especifico,
  null                              as dt_ativacao_pedido_venda,
  null                              as cd_exportador,
  null                              as ic_atualizar_valor_cambio_fat,
  null                              as cd_tipo_documento,
  null                              as cd_loja,
  null                              as cd_usuario_alteracao,
'N' as ic_garantia_pedido_venda,
  null                              as cd_aplicacao_produto,
  'S' AS ic_comissao_pedido_venda,
  null                              as cd_motivo_liberacao,
  null                              as ic_entrega_futura,
  null                              as modalidade,
  null                              as modalidade1,
  null                              as cd_modalidade,
  null                              as cd_pedido_venda_origem,
  null                              as dt_entrada_pedido,
  null                              as dt_cond_pagto_pedido,
  null                              as cd_usuario_cond_pagto_ped,
  null                              as vl_credito_liberacao,
  null                              as vl_credito_liberado,
  null                              as cd_centro_custo,
  null                              as ic_bloqueio_licenca,
  null                              as cd_licenca_bloqueada,
  null                              as nm_bloqueio_licenca,
  null                              as dt_bloqueio_licenca,
  null                              as cd_usuario_bloqueio_licenca,
  null                              as vl_mp_aplicacada_pedido,
  null                              as vl_mo_aplicada_pedido,
  null                              as cd_usuario_impressao,
  null                              as cd_cliente_origem,
  null                              as cd_situacao_pedido,
  null                              as qt_total_item_pedido,
  'N'                               as ic_bonificacao_pedido_venda,
  null                              as pc_promocional_pedido,
  null                              as cd_tipo_reajuste

into
  #pedido_venda

from
  DB_ALTAMIRA.DBO.ve_pedidos  
  left outer join Cliente c on c.cd_cnpj_cliente = vepe_Cliente
where
  vepe_pedido>0 and
  c.cd_cnpj_cliente is not null
--  and vepe_datapedido > '09/01/2009' 
  and
  vepe_pedido   not in ( select cd_pedido_venda from pedido_venda )

--select * from #pedido_venda order by cd_pedido_venda

select
  cd_pedido_venda,
  count(*)         as Qtd
into
  #PedidoCliente
from
  #pedido_venda
group by cd_pedido_venda
order by 2 desc

select * from #PedidoCliente where QTD>1

delete from 
  #Pedido_Venda
where
  cd_pedido_venda in ( select cd_pedido_venda from #PedidoCliente 
                       where QTD>1 )

select * from #pedido_venda order by cd_pedido_venda

insert into pedido_venda
select
  x.*
from
  #pedido_venda x
where
  x.cd_pedido_venda not in ( select p.cd_pedido_venda from pedido_venda p where
                           p.cd_cliente = x.cd_cliente)


select * from #pedido_venda

drop table #pedido_venda


--Itens do Pedido de Venda
--select * from dbaltamira.dbo.ve_pedidos
--select * from dbaltamira.dbo.ve_textospedidos

select
  vetx_pedido      as cd_pedido_venda,
  vetx_item        as cd_item_pedido_venda,
  vetx_dtpedido    as dt_item_pedido_venda,
  vetx_quantidade  as qt_item_pedido_venda,
  vetx_quantidade  as qt_saldo_pedido_venda,
  vepe_DataEntrega as dt_entrega_vendas_pedido,
  vepe_DataEntrega as dt_entrega_fabrica_pedido,
  vetx_Texto       as ds_produto_pedido_venda,
  vetx_Valor       as vl_unitario_item_pedido,
  vetx_Valor       as vl_lista_item_pedido,
  null             as pc_desconto_item_pedido,
  null             as dt_cancelamento_item,
  null             as dt_estoque_item_pedido,
  vepe_PedidoCliente as cd_pdcompra_item_pedido,
  null             as dt_reprog_item_pedido,
  null             as qt_liquido_item_pedido,
  null             as qt_bruto_item_pedido,
  null             as ic_fatura_item_pedido,
  null             as ic_reserva_item_pedido,
  null             as ic_tipo_montagem_item,
  null             as ic_montagem_g_item_pedido,
  null             as ic_subs_tributaria_item,
  null             as cd_posicao_item_pedido,
  null             as cd_os_tipo_pedido_venda,
  null             as ic_desconto_item_pedido,
  null             as dt_desconto_item_pedido,
  null             as vl_indice_item_pedido,
  1                as cd_grupo_produto,
  null             as cd_produto,
  1                as cd_grupo_categoria,
  1             as cd_categoria_produto,
  null             as cd_pedido_rep_pedido,
  null             as cd_item_pedidorep_pedido,
  null             as cd_ocorrencia,
  vepe_Orcamento   as cd_consulta,
  4                as cd_usuario,
  getdate() as dt_usuario,
  null             as nm_mot_canc_item_pedido,
  null             as nm_obs_restricao_pedido,
  null             as cd_item_consulta,
  null             as ic_etiqueta_emb_pedido,
  vetx_IPI         as pc_ipi_item,
  --vepe_AliqICMS    AS pc_icms_item,
  null             as pc_icms_item,  
  null             as pc_reducao_base_item,
  null             as dt_necessidade_cliente,
  null             as qt_dia_entrega_cliente,
  null             as dt_entrega_cliente,
  null             as ic_smo_item_pedido_venda,
  null             as cd_om,
  'S'              as ic_controle_pcp_pedido,
  null             as nm_mat_canc_item_pedido,
  null             as cd_servico,
  'S'              as ic_produto_especial,
  null             as cd_produto_concorrente,
  null             as ic_orcamento_pedido_venda,
  cast('' as varchar) as ds_produto_pedido,
  cast(vetx_Texto as varchar(50)) as nm_produto_pedido,
  null             as cd_serie_produto,
  vetx_IPI         as pc_ipi,
  null             as pc_icms,
  null             as qt_dia_entrega_pedido,
  'S'              as ic_sel_fechamento,
  null             as dt_ativacao_item,
  null             as nm_mot_ativ_item_pedido,
  'ESPECIAL'          as nm_fantasia_produto,
  null                as ic_etiqueta_emb_ped_venda,
  vepe_DataPedido     as dt_fechamento_pedido,
  cast('' as varchar) as ds_progfat_pedido_venda,
  'P'              as ic_pedido_venda_item,
  null             as ic_ordsep_pedido_venda,
  null             as ic_progfat_item_pedido,
  null             as qt_progfat_item_pedido,
  null             as cd_referencia_produto,
  null             as ic_libpcp_item_pedido,
  cast('' as varchar) as ds_observacao_fabrica,
  null             as nm_observacao_fabrica1,
  null             as nm_observacao_fabrica2,
  12               as  cd_unidade_medida,
  null             as pc_reducao_icms,
  null             as pc_desconto_sobre_desc,
  null             as nm_desconto_item_pedido,
  null             as cd_item_contrato,
  null             as cd_contrato_fornecimento,
  null             as nm_kardex_item_ped_venda,
  null             as ic_gprgcnc_pedido_venda,
  null             as cd_pedido_importacao,
  null             as cd_item_pedido_importacao,
  null             as dt_progfat_item_pedido,
  null             as qt_cancelado_item_pedido,
  null             as qt_ativado_pedido_venda,
  null             as cd_mes,
  null             as cd_ano,
  null             as ic_mp66_item_pedido,
  null             as ic_montagem_item_pedido,
  null             as ic_reserva_estrutura_item,
  null             as ic_estrutura_item_pedido,
  null             as vl_frete_item_pedido,
  null             as cd_usuario_lib_desconto,
  null             as dt_moeda_cotacao,
  null             as vl_moeda_cotacao,
  null             as cd_moeda_cotacao,
  null             as dt_zera_saldo_pedido_item,
  null             as cd_lote_produto,
  null             as cd_num_serie_item_pedido,
  null             as cd_lote_item_pedido,
  null             as ic_controle_mapa_pedido,
  null             as cd_tipo_embalagem,
  null             as dt_validade_item_pedido,
  null             as cd_movimento_caixa,
  null             as vl_custo_financ_item,
  null             as qt_garantia_item_pedido,
  null             as cd_tipo_montagem,
  null             as cd_montagem,
  null             as cd_usuario_ordsep,
  null             as ic_kit_grupo_produto,
  null             as cd_sub_produto_especial,
  null             as cd_plano_financeiro,
  null             as dt_fluxo_caixa,
  null             as ic_fluxo_caixa,
  CAST('' as varchar) as ds_servico_item_pedido,
  null             as dt_reservado_montagem,
  null             as cd_usuario_montagem,
  null             as ic_imediato_produto,
  null             as cd_mascara_classificacao,
  null             as cd_desenho_item_pedido,
  null             as cd_rev_des_item_pedido,
  null             as cd_centro_custo,
  null             as qt_area_produto,
  null             as cd_produto_estampo,
  null             as vl_digitado_item_desconto,
  null             as cd_lote_Item_anterior,
  null             as cd_programacao_entrega,
  null             as ic_estoque_fatura,
  null             as ic_estoque_venda,
  null             as ic_manut_mapa_producao,
  null             as pc_comissao_item_pedido,
  null             as cd_produto_servico,
  null             as ic_baixa_composicao_item,
  null             as vl_unitario_ipi_produto,
  null             as ic_desc_prom_item_pedido,
  null             as cd_tabela_preco,
  null             as cd_motivo_reprogramacao,
  null             as qt_estoque,
  null             as dt_estoque,
  null             as dt_atendimento,
  null             as qt_atendimento,
  null             as nm_forma,
  null             as cd_documento,
  null             as cd_item_documento,
  null             as nm_obs_atendimento,
  null             as qt_atendimento_1,
  null             as qt_atendimento_2,
  null             as qt_atendimento_3

--SELECT * from pedido_venda_item

into #pedido_venda_item
from
  DB_ALTAMIRA.DBO.VE_TEXTOSPEDIDOS 
  inner join DB_ALTAMIRA.DBO.VE_PEDIDOS ON VEPE_PEDIDO = VETX_PEDIDO
where
  vepe_pedido > 0 and
  vetx_pedido not in ( select cd_pedido_venda from pedido_venda_item
                       where
                         cd_item_pedido_venda = vetx_item )


insert into 
  pedido_venda_item
select
  *
from
  #pedido_venda_item

select * from #pedido_venda_item

drop table #pedido_venda_item


