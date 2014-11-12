
-------------------------------------------------------------------------------
--sp_helptext pr_evolucao_venda_produto_diario
-------------------------------------------------------------------------------
--pr_evolucao_venda_produto_diario
-------------------------------------------------------------------------------
--GBS Global Business Solution Ltda                                        2008
-------------------------------------------------------------------------------
--Stored Procedure : Microsoft SQL Server 2000
--Autor(es)        : Carlos Cardoso Fernandes
--Banco de Dados   : EgisAdmin ou Egissql
--Objetivo         : 
--Data             : 01.01.2008
--Alteração        : 
--
--
------------------------------------------------------------------------------
create procedure pr_evolucao_venda_produto_diario
@cd_cliente  int      = 0,
@cd_vendedor int      = 0,
@cd_produto  int      = 0,
@dt_inicial  datetime = '',
@dt_final    datetime = ''

as

select 

  vw.dt_pedido_venda,
  vw.cd_produto,
  max(vw.nm_produto)                                          as Descricao,
  max(vw.cd_mascara_produto)                                  as Codigo,
  max(vw.nm_fantasia_produto)                                 as Fantasia,
  max(vw.sg_unidade_medida)                                   as Unidade,
  sum( vw.qt_item_pedido_venda )                              as Quantidade,
  sum( vw.qt_item_pedido_venda * vw.vl_unitario_item_pedido ) as Valor_Total,
  max(vw.nm_fantasia_cliente)                                 as Cliente,
  max(vw.nm_vendedor_externo)                                 as Vendedor,
  max(vw.cd_vendedor)                                         as cd_vendedor,
  max(vw.nm_cliente_regiao)                                   as Regiao,
  --Quantidade por Dia

  sum(case when day(vw.dt_pedido_venda ) = 01 then vw.qt_item_pedido_venda else 0.00 end ) as qtd_01,
  sum(case when day(vw.dt_pedido_venda ) = 02 then vw.qt_item_pedido_venda else 0.00 end ) as qtd_02,
  sum(case when day(vw.dt_pedido_venda ) = 03 then vw.qt_item_pedido_venda else 0.00 end ) as qtd_03,
  sum(case when day(vw.dt_pedido_venda ) = 04 then vw.qt_item_pedido_venda else 0.00 end ) as qtd_04,
  sum(case when day(vw.dt_pedido_venda ) = 05 then vw.qt_item_pedido_venda else 0.00 end ) as qtd_05,
  sum(case when day(vw.dt_pedido_venda ) = 06 then vw.qt_item_pedido_venda else 0.00 end ) as qtd_06,
  sum(case when day(vw.dt_pedido_venda ) = 07 then vw.qt_item_pedido_venda else 0.00 end ) as qtd_07,
  sum(case when day(vw.dt_pedido_venda ) = 08 then vw.qt_item_pedido_venda else 0.00 end ) as qtd_08,
  sum(case when day(vw.dt_pedido_venda ) = 09 then vw.qt_item_pedido_venda else 0.00 end ) as qtd_09,
  sum(case when day(vw.dt_pedido_venda ) = 10 then vw.qt_item_pedido_venda else 0.00 end ) as qtd_10,
  sum(case when day(vw.dt_pedido_venda ) = 11 then vw.qt_item_pedido_venda else 0.00 end ) as qtd_11,
  sum(case when day(vw.dt_pedido_venda ) = 12 then vw.qt_item_pedido_venda else 0.00 end ) as qtd_12,
  sum(case when day(vw.dt_pedido_venda ) = 13 then vw.qt_item_pedido_venda else 0.00 end ) as qtd_13,
  sum(case when day(vw.dt_pedido_venda ) = 14 then vw.qt_item_pedido_venda else 0.00 end ) as qtd_14,
  sum(case when day(vw.dt_pedido_venda ) = 15 then vw.qt_item_pedido_venda else 0.00 end ) as qtd_15,
  sum(case when day(vw.dt_pedido_venda ) = 16 then vw.qt_item_pedido_venda else 0.00 end ) as qtd_16,
  sum(case when day(vw.dt_pedido_venda ) = 17 then vw.qt_item_pedido_venda else 0.00 end ) as qtd_17,
  sum(case when day(vw.dt_pedido_venda ) = 18 then vw.qt_item_pedido_venda else 0.00 end ) as qtd_18,
  sum(case when day(vw.dt_pedido_venda ) = 19 then vw.qt_item_pedido_venda else 0.00 end ) as qtd_19,
  sum(case when day(vw.dt_pedido_venda ) = 20 then vw.qt_item_pedido_venda else 0.00 end ) as qtd_20,
  sum(case when day(vw.dt_pedido_venda ) = 21 then vw.qt_item_pedido_venda else 0.00 end ) as qtd_21,
  sum(case when day(vw.dt_pedido_venda ) = 22 then vw.qt_item_pedido_venda else 0.00 end ) as qtd_22,
  sum(case when day(vw.dt_pedido_venda ) = 23 then vw.qt_item_pedido_venda else 0.00 end ) as qtd_23,
  sum(case when day(vw.dt_pedido_venda ) = 24 then vw.qt_item_pedido_venda else 0.00 end ) as qtd_24,
  sum(case when day(vw.dt_pedido_venda ) = 25 then vw.qt_item_pedido_venda else 0.00 end ) as qtd_25,
  sum(case when day(vw.dt_pedido_venda ) = 26 then vw.qt_item_pedido_venda else 0.00 end ) as qtd_26,
  sum(case when day(vw.dt_pedido_venda ) = 27 then vw.qt_item_pedido_venda else 0.00 end ) as qtd_27,
  sum(case when day(vw.dt_pedido_venda ) = 28 then vw.qt_item_pedido_venda else 0.00 end ) as qtd_28,
  sum(case when day(vw.dt_pedido_venda ) = 29 then vw.qt_item_pedido_venda else 0.00 end ) as qtd_29,
  sum(case when day(vw.dt_pedido_venda ) = 30 then vw.qt_item_pedido_venda else 0.00 end ) as qtd_30,
  sum(case when day(vw.dt_pedido_venda ) = 31 then vw.qt_item_pedido_venda else 0.00 end ) as qtd_31,

  --Valor da Venda

  sum(case when day(vw.dt_pedido_venda ) = 01 then vw.vl_total_pedido_venda else 0.00 end ) as vl_01,
  sum(case when day(vw.dt_pedido_venda ) = 02 then vw.vl_total_pedido_venda else 0.00 end ) as vl_02,
  sum(case when day(vw.dt_pedido_venda ) = 03 then vw.vl_total_pedido_venda else 0.00 end ) as vl_03,
  sum(case when day(vw.dt_pedido_venda ) = 04 then vw.vl_total_pedido_venda else 0.00 end ) as vl_04,
  sum(case when day(vw.dt_pedido_venda ) = 05 then vw.vl_total_pedido_venda else 0.00 end ) as vl_05,
  sum(case when day(vw.dt_pedido_venda ) = 06 then vw.vl_total_pedido_venda else 0.00 end ) as vl_06,
  sum(case when day(vw.dt_pedido_venda ) = 07 then vw.vl_total_pedido_venda else 0.00 end ) as vl_07,
  sum(case when day(vw.dt_pedido_venda ) = 08 then vw.vl_total_pedido_venda else 0.00 end ) as vl_08,
  sum(case when day(vw.dt_pedido_venda ) = 09 then vw.vl_total_pedido_venda else 0.00 end ) as vl_09,
  sum(case when day(vw.dt_pedido_venda ) = 10 then vw.vl_total_pedido_venda else 0.00 end ) as vl_10,
  sum(case when day(vw.dt_pedido_venda ) = 11 then vw.vl_total_pedido_venda else 0.00 end ) as vl_11,
  sum(case when day(vw.dt_pedido_venda ) = 12 then vw.vl_total_pedido_venda else 0.00 end ) as vl_12,
  sum(case when day(vw.dt_pedido_venda ) = 13 then vw.vl_total_pedido_venda else 0.00 end ) as vl_13,
  sum(case when day(vw.dt_pedido_venda ) = 14 then vw.vl_total_pedido_venda else 0.00 end ) as vl_14,
  sum(case when day(vw.dt_pedido_venda ) = 15 then vw.vl_total_pedido_venda else 0.00 end ) as vl_15,
  sum(case when day(vw.dt_pedido_venda ) = 16 then vw.vl_total_pedido_venda else 0.00 end ) as vl_16,
  sum(case when day(vw.dt_pedido_venda ) = 17 then vw.vl_total_pedido_venda else 0.00 end ) as vl_17,
  sum(case when day(vw.dt_pedido_venda ) = 18 then vw.vl_total_pedido_venda else 0.00 end ) as vl_18,
  sum(case when day(vw.dt_pedido_venda ) = 19 then vw.vl_total_pedido_venda else 0.00 end ) as vl_19,
  sum(case when day(vw.dt_pedido_venda ) = 20 then vw.vl_total_pedido_venda else 0.00 end ) as vl_20,
  sum(case when day(vw.dt_pedido_venda ) = 21 then vw.vl_total_pedido_venda else 0.00 end ) as vl_21,
  sum(case when day(vw.dt_pedido_venda ) = 22 then vw.vl_total_pedido_venda else 0.00 end ) as vl_22,
  sum(case when day(vw.dt_pedido_venda ) = 23 then vw.vl_total_pedido_venda else 0.00 end ) as vl_23,
  sum(case when day(vw.dt_pedido_venda ) = 24 then vw.vl_total_pedido_venda else 0.00 end ) as vl_24,
  sum(case when day(vw.dt_pedido_venda ) = 25 then vw.vl_total_pedido_venda else 0.00 end ) as vl_25,
  sum(case when day(vw.dt_pedido_venda ) = 26 then vw.vl_total_pedido_venda else 0.00 end ) as vl_26,
  sum(case when day(vw.dt_pedido_venda ) = 27 then vw.vl_total_pedido_venda else 0.00 end ) as vl_27,
  sum(case when day(vw.dt_pedido_venda ) = 28 then vw.vl_total_pedido_venda else 0.00 end ) as vl_28,
  sum(case when day(vw.dt_pedido_venda ) = 29 then vw.vl_total_pedido_venda else 0.00 end ) as vl_29,
  sum(case when day(vw.dt_pedido_venda ) = 30 then vw.vl_total_pedido_venda else 0.00 end ) as vl_30,
  sum(case when day(vw.dt_pedido_venda ) = 31 then vw.vl_total_pedido_venda else 0.00 end ) as vl_31

from 
  vw_venda_bi vw with (nolock) 
where
  vw.dt_pedido_venda between @dt_inicial and @dt_final and
  vw.cd_cliente      = case when @cd_cliente  = 0 then vw.cd_cliente  else @cd_cliente  end and
  vw.cd_vendedor     = case when @cd_vendedor = 0 then vw.cd_vendedor else @cd_vendedor end and
  vw.cd_produto      = case when @cd_produto  = 0 then vw.cd_produto  else @cd_produto  end 
group by
  vw.dt_pedido_venda,
  vw.cd_produto


--select * from vw_venda_bi
  
