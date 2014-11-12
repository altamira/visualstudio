
-------------------------------------------------------------------------------
--pr_migracao_agua_funda_vendas_faturamento
-------------------------------------------------------------------------------
--GBS Global Business Solution Ltda                                        2008
-------------------------------------------------------------------------------
--Stored Procedure : Microsoft SQL Server 2000
--Autor(es)        : Autor
--Banco de Dados   : Egissql
--Objetivo         : Migração da Tabela de Vendas/Faturamento
--Data             : 08.09.2006
--Alteração        : 
------------------------------------------------------------------------------
create procedure pr_migracao_agua_funda_vendas_faturamento
@dt_pedido_venda as datetime ,
@nm_tabela       as varchar(50)

as

--delete from pedido_venda_item
--delete from pedido_venda

--select * from migracao.dbo.VD020708 where col002 = 3803
--select * from migracao.dbo.VD020708 where col002 = 6528

select
  *
into
  #item
from
  migracao.dbo.MOVVENDA

select
 distinct
 cast(col002 as int )      as col002,
-- cast(col003 as int )      as col003,
-- cast(col005 as int )      as col005,
  max(cast(col003 as int )) as col003,
  max(cast(col005 as int )) as col005,
 max(col011)                    as col011,
 sum( cast( col010 as float ) ) as Total_Pedido,
 count(*)                       as qtd_pedido

-- max(0)                         as cd_condicao_pagamento
into
  #pedido_agrupado
from
  #item
group by
 cast(col002 as int )
-- col003,
-- col005

--select * from #pedido_agrupado

--Atualiza a Condicao Pagamento

select
  col002,count(*)
from
  #pedido_agrupado
group by col002

--delete from pedido_venda_item
--delete from pedido_venda

--pedido de venda
--pedido_venda

select
--  identity(int,1,1)       as cd_pedido_venda,
  col002                  as cd_pedido_venda,
  @dt_pedido_venda        as dt_pedido_venda,
  p.col005                as cd_vendedor_pedido,
  1                       as cd_vendedor_interno,
  'N'                     as ic_emitido_pedido_venda,
  cast('' as varchar)     as ds_pedido_venda,
  cast('' as varchar)     as ds_pedido_venda_fatura,
  cast('' as varchar)     as ds_cancelamento_pedido,
  null                    as cd_usuario_credito_pedido,
  @dt_pedido_venda        as dt_credito_pedido_venda,
  'N'                     as ic_smo_pedido_venda,
  Total_Pedido            as vl_total_pedido_venda,
  null                    as qt_liquido_pedido_venda,
  null                    as qt_bruto_pedido_venda,
  null                    as dt_conferido_pedido_venda,
  null                    as ic_pcp_pedido_venda,
  null                    as ic_lista_pcp_pedido_venda,
  null                    as ic_processo_pedido_venda,
  null                    as ic_lista_processo_pedido,
  null                    as ic_imed_pedido_venda,
  null                    as ic_lista_imed_pedido,
  null                    as nm_alteracao_pedido_venda,
  null                    as ic_consignacao_pedido,
  null                    as dt_cambio_pedido_venda,
  null                    as cd_cliente_entrega,
  null                    as ic_op_triang_pedido_venda,
  null                    as ic_nf_op_triang_pedido,
  null                    as nm_contato_op_triang,
  cast(col002 as varchar) as cd_pdcompra_pedido_venda,
  null                    as cd_processo_exportacao,
  p.Col003                as cd_cliente,
  null                    as cd_tipo_frete,
  null                    as cd_tipo_restricao_pedido,
  3                       as cd_destinacao_produto,
  1                       as cd_tipo_pedido,
  null                    as cd_transportadora,
  p.col005                as cd_vendedor,
  null                    as cd_tipo_endereco,
  1                       as cd_moeda,
  null                    as cd_contato,
  4                       as cd_usuario,
  getdate()               as dt_usuario,
  null                    as dt_cancelamento_pedido,
  1                       as cd_condicao_pagamento,
  1                       as cd_status_pedido,
  1                       as cd_tipo_entrega_produto,
  null                    as nm_referencia_consulta,
  null                    as vl_custo_financeiro,
  null                    as ic_custo_financeiro,
  null                    as vl_tx_mensal_cust_fin,
  1                       as cd_tipo_pagamento_frete,
  null                    as nm_assina_pedido,
  null                    as ic_fax_pedido,
  null                    as ic_mail_pedido, 
  Total_Pedido            as vl_total_pedido_ipi,
  0.00                    as vl_total_ipi,
  cast('' as varchar)     as ds_observacao_pedido,
  null                    as cd_usuario_atendente,
  'N'                     as ic_fechado_pedido,
  null                    as ic_vendedor_interno,
  null                    as cd_representante,
  null                    as ic_transf_matriz,
  null                    as ic_digitacao,
  null                    as ic_pedido_venda,
  null                    as hr_inicial_pedido,
  null                    as ic_outro_cliente,
  null                    as ic_fechamento_total,
  null                    as ic_operacao_triangular,
  null                    as ic_fatsmo_pedido,
  cast('' as varchar)     as ds_ativacao_pedido,
  null                    as dt_ativacao_pedido,
  cast('' as varchar)     as ds_obs_fat_pedido,
  null                    as ic_obs_corpo_nf,
  null                    as dt_fechamento_pedido,
  null                    as cd_cliente_faturar,
  1                       as cd_tipo_local_entrega,
  null                    as ic_etiq_emb_pedido_venda,
  null                    as cd_consulta,
  null                    as dt_alteracao_pedido_venda,
  null                    as ic_dt_especifica_ped_vend,
  null                    as ic_dt_especifica_consulta,
  null                    as ic_fat_pedido_venda,
  null                    as ic_fat_total_pedido_venda,
  null                    as qt_volume_pedido_venda,
  null                    as qt_fatpbru_pedido_venda,
  null                    as ic_permite_agrupar_pedido,
  null                    as qt_fatpliq_pedido_venda,
  null                    as vl_indice_pedido_venda,
  null                    as vl_sedex_pedido_venda,
  null                    as pc_desconto_pedido_venda,
  col011                  as pc_comissao_pedido_venda,
  null                    as cd_plano_financeiro,
  cast('' as varchar)     as ds_multa_pedido_venda,
  null                    as vl_freq_multa_ped_venda,
  null                    as vl_base_multa_ped_venda,
  null                    as pc_limite_multa_ped_venda,
  null                    as pc_multa_pedido_venda,
  null                    as cd_fase_produto_contrato,
  null                    as nm_obs_restricao_pedido,
  null                    as cd_usu_restricao_pedido,
  null                    as dt_lib_restricao_pedido,
  null                    as nm_contato_op_triang_ped,
  null                    as ic_amostra_pedido_venda,
  null                    as ic_alteracao_pedido_venda,
  null                    as ic_calcula_sedex,
  null                    as vl_frete_pedido_venda,
  null                    as ic_calcula_peso,
  null                    as ic_subs_trib_pedido_venda,
  null                    as ic_credito_icms_pedido,
  null                    as cd_usu_lib_fat_min_pedido,
  null                    as dt_lib_fat_min_pedido,
  null                    as cd_identificacao_empresa,
  col011                  as pc_comissao_especifico,
  null                    as dt_ativacao_pedido_venda,
  null                    as cd_exportador,
  null                    as ic_atualizar_valor_cambio_fat,
  null                    as cd_tipo_documento,
  null                    as cd_loja,
  null                    as cd_usuario_alteracao,
  null                    as ic_garantia_pedido_venda,
  null                    as cd_aplicacao_produto,
  null                    as ic_comissao_pedido_venda,
  null                    as cd_motivo_liberacao,
  null                    as ic_entrega_futura,
  null                    as modalidade,
  null                    as modalidade1,
  null                    as cd_modalidade,
  null                    as cd_pedido_venda_origem,
  @dt_pedido_venda        as dt_entrada_pedido,
  null                    as dt_cond_pagto_pedido,
  null                    as cd_usuario_cond_pagto_ped,
  null                    as vl_credito_liberacao,
  null                    as vl_credito_liberado,
  null                    as cd_centro_custo,
  null                    as ic_bloqueio_licenca,
  null                    as cd_licenca_bloqueada,
  null                    as nm_bloqueio_licenca,
  null                    as dt_bloqueio_licenca,
  null                    as cd_usuario_bloqueio_licenca,
  null                    as vl_mp_aplicacada_pedido,
  null                    as vl_mo_aplicada_pedido,
  null                    as cd_usuario_impressao,
  null                    as cd_cliente_origem,
  null                    as cd_situacao_pedido,
  null                    as qt_total_item_pedido,
  null                    as ic_bonificacao_pedido_venda

into
  #pedido_venda
from
  #pedido_agrupado p
-- where
--   qtd_pedido = 1

insert into
  pedido_venda
select
  *
from 
  #pedido_venda  
where
  cd_pedido_venda not in ( select cd_pedido_venda from pedido_venda )  

--select * from pedido_venda

--select * from 
--item do pedido de venda
--select * from #item

select
  pv.cd_pedido_venda        as cd_pedido_venda,
  identity(int,1,1)         as cd_item_pedido_venda,
  @dt_pedido_venda          as dt_item_pedido_venda,
  case when cast(col008 as float )>0 then
    cast(col008 as float )   
  else
    cast(col009 as float )   
  end
  as qt_item_pedido_venda,
  case when   cast(col008 as float )>0 then   
  cast(col008 as float )   
  else
  cast(col009 as float )   
  end as qt_saldo_pedido_venda,

  @dt_pedido_venda          as dt_entrega_vendas_pedido,
  @dt_pedido_venda          as dt_entrega_fabrica_pedido,
  cast('' as varchar)       as ds_produto_pedido_venda,

  case when isnull(col008,0)>0 then
    col010 / cast(col008 as float )
  else
    case when cast(col009 as float ) > 0   then
       col010 / cast(col009 as float )
    else
      col010
    end
  end as vl_unitario_item_pedido,

 case when isnull(col008,0)>0 then
    col010 / cast(col008 as float )
  else
    case when cast(col009 as float ) > 0   then
       col010 / cast(col009 as float )
    else
      col010
    end
  end as vl_lista_item_pedido,

  0.00                            as pc_desconto_item_pedido,
  null                            as dt_cancelamento_item,
  null                            as dt_estoque_item_pedido,
  null                            as cd_pdcompra_item_pedido,
  null                            as dt_reprog_item_pedido,
  col022                          as qt_liquido_item_pedido,
  col022                          as qt_bruto_item_pedido,
  null                            as ic_fatura_item_pedido,
  null                            as ic_reserva_item_pedido,
  null                            as ic_tipo_montagem_item,
  null                            as ic_montagem_g_item_pedido,
  null                            as ic_subs_tributaria_item,
  null                            as cd_posicao_item_pedido,
  null                            as cd_os_tipo_pedido_venda,
  null                            as ic_desconto_item_pedido,
  null                            as dt_desconto_item_pedido,
  null                            as vl_indice_item_pedido,
  prod.cd_grupo_produto,
  prod.cd_produto,
  cp.cd_grupo_categoria,
  prod.cd_categoria_produto,
  null                            as cd_pedido_rep_pedido,
  null                            as cd_item_pedidorep_pedido,
  null                            as cd_ocorrencia,
  null                            as cd_consulta,
  4 as cd_usuario,
  getdate() as dt_usuario,
  null                            as nm_mot_canc_item_pedido,
  null                            as nm_obs_restricao_pedido,
  null                            as cd_item_consulta,
  null                            as ic_etiqueta_emb_pedido,
  null                            as pc_ipi_item,
  null                            as pc_icms_item,
  null                            as pc_reducao_base_item,
  null                            as dt_necessidade_cliente,
  null                            as qt_dia_entrega_cliente,
  null                            as dt_entrega_cliente,
  null                            as ic_smo_item_pedido_venda,
  null                            as cd_om,
  null                            as ic_controle_pcp_pedido,
  null                            as nm_mat_canc_item_pedido,
  null                            as cd_servico,
  null                            as ic_produto_especial,
  null                            as cd_produto_concorrente,
  null                            as ic_orcamento_pedido_venda,
  cast('' as varchar)             as ds_produto_pedido,
  prod.nm_produto                 as nm_produto_pedido,
  null                            as cd_serie_produto,
  null                            as pc_ipi,
  null                            as pc_icms,
  null                            as qt_dia_entrega_pedido,
  null                            as ic_sel_fechamento,
  null                            as dt_ativacao_item,
  null                            as nm_mot_ativ_item_pedido,
  prod.nm_fantasia_produto,
  null                            as ic_etiqueta_emb_ped_venda,
  null                            as dt_fechamento_pedido,
  cast('' as varchar)             as ds_progfat_pedido_venda,
  'P'                             as ic_pedido_venda_item,
  null                            as ic_ordsep_pedido_venda,
  null                            as ic_progfat_item_pedido,
  null                            as qt_progfat_item_pedido,
  null                            as cd_referencia_produto,
  null                            as ic_libpcp_item_pedido,
  cast('' as varchar)             as ds_observacao_fabrica,
  null                            as nm_observacao_fabrica1,
  null                            as nm_observacao_fabrica2,
  prod.cd_unidade_medida,
  null                            as pc_reducao_icms,
  null                            as pc_desconto_sobre_desc,
  null                            as nm_desconto_item_pedido,
  null                            as cd_item_contrato,
  null                            as cd_contrato_fornecimento,
  null                            as nm_kardex_item_ped_venda,
  null                            as ic_gprgcnc_pedido_venda,
  null                            as cd_pedido_importacao,
  null                            as cd_item_pedido_importacao,
  null                            as dt_progfat_item_pedido,
  null                            as qt_cancelado_item_pedido,
  null                            as qt_ativado_pedido_venda,
  null                            as cd_mes,
  null                            as cd_ano,
  null                            as ic_mp66_item_pedido,
  null                            as ic_montagem_item_pedido,
  null                            as ic_reserva_estrutura_item,
  null                            as ic_estrutura_item_pedido,
  null                            as vl_frete_item_pedido,
  null                            as cd_usuario_lib_desconto,
  null                            as dt_moeda_cotacao,
  null                            as vl_moeda_cotacao,
  null                            as cd_moeda_cotacao,
  null                            as dt_zera_saldo_pedido_item,
  null                            as cd_lote_produto,
  null                            as cd_num_serie_item_pedido,
  null                            as cd_lote_item_pedido,
  null                            as ic_controle_mapa_pedido,
  null                            as cd_tipo_embalagem,
  null                            as dt_validade_item_pedido,
  null                            as cd_movimento_caixa,
  null                            as vl_custo_financ_item,
  null                            as qt_garantia_item_pedido,
  null                            as cd_tipo_montagem,
  null                            as cd_montagem,
  null                            as cd_usuario_ordsep,
  null                            as ic_kit_grupo_produto,
  null                            as cd_sub_produto_especial,
  null                            as cd_plano_financeiro,
  null                            as dt_fluxo_caixa,
  null                            as ic_fluxo_caixa,
  cast('' as varchar )            as ds_servico_item_pedido,
  null                            as dt_reservado_montagem,
  null                            as cd_usuario_montagem,
  null                            as ic_imediato_produto,
  null                            as cd_mascara_classificacao,
  null                            as cd_desenho_item_pedido,
  null                            as cd_rev_des_item_pedido,
  null                            as cd_centro_custo,
  null                            as qt_area_produto,
  null                            as cd_produto_estampo,
  null                            as vl_digitado_item_desconto,
  null                            as cd_lote_Item_anterior,
  null                            as cd_programacao_entrega,
  null                            as ic_estoque_fatura,
  null                            as ic_estoque_venda,
  null                            as ic_manut_mapa_producao,
  null                            as pc_comissao_item_pedido,
  null                            as cd_produto_servico,
  null                            as ic_baixa_composicao_item,
  null                            as vl_unitario_ipi_produto

into
  #pedido_venda_item
from
  #item 
--  left outer join pedido_venda pv      on pv.cd_pdcompra_pedido_venda      = cast(col002 as varchar(40))
  left outer join pedido_venda pv      on pv.cd_pedido_venda      = cast(col002 as int )
  left outer join produto prod         on prod.cd_mascara_produto = cast(col001 as varchar(20))
  left outer join categoria_produto cp on cp.cd_categoria_produto = prod.cd_categoria_produto

insert into
  pedido_venda_item
select
  *
from
  #pedido_venda_item

--Calculando o Total do Pedido de Venda

--Todos
update 
  pedido_venda 
set 
  vl_total_pedido_venda = ( 
    Select 
      isnull( Sum( isnull(qt_item_pedido_venda,0) * isnull(vl_unitario_item_pedido,0) ),0) 
    from
      Pedido_Venda Pv
      inner join Pedido_Venda_Item pvi on pvi.cd_pedido_venda = pv.cd_pedido_venda
    where
      pv.cd_pedido_venda = pvA.cd_pedido_venda
   )
From
  Pedido_venda PVA

update
  pedido_venda
set
  vl_total_pedido_ipi = vl_total_pedido_venda

 
--select * from pedido_venda_item

drop table #pedido_venda
drop table #pedido_venda_item

--item do pedido de venda

--nota de saída

--nota de saída item


