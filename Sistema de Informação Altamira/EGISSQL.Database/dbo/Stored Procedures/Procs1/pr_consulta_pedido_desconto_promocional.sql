
-------------------------------------------------------------------------------
--sp_helptext pr_consulta_pedido_desconto_promocional
-------------------------------------------------------------------------------
--pr_consulta_pedido_desconto_promocional
-------------------------------------------------------------------------------
--GBS Global Business Solution Ltda                                        2008
-------------------------------------------------------------------------------
--Stored Procedure : Microsoft SQL Server 2000
--Autor(es)        : Douglas de Paula Lopes
--Banco de Dados   : Egissql
--Objetivo         : Consulta de desconto promocional por pedido.
--Data             : 08.09.2008
--Alteração        : 
------------------------------------------------------------------------------
create procedure pr_consulta_pedido_desconto_promocional
@cd_pedido_venda int,  
@dt_inicial      datetime,  
@dt_final        datetime  
as
    select 
      pv.pc_promocional_pedido,
      pv.cd_pedido_venda,
      pv.dt_pedido_venda,
      c.nm_fantasia_cliente,
      cp.nm_condicao_pagamento,
      pvi.cd_item_pedido_venda,
      pvi.qt_item_pedido_venda,
     (pvi.vl_unitario_item_pedido - (pvi.vl_unitario_item_pedido - 
      pvi.vl_unitario_item_pedido * (pv.pc_promocional_pedido / 100)))  as vl_desc_item,
      pvi.vl_unitario_item_pedido -(pvi.vl_unitario_item_pedido - (pvi.vl_unitario_item_pedido - 
      pvi.vl_unitario_item_pedido * (pv.pc_promocional_pedido / 100)))  as vl_uni_desc,  
      pvi.qt_item_pedido_venda * isnull(pvi.vl_unitario_item_pedido,0)  as vl_total_item,
     (pvi.qt_item_pedido_venda * isnull(pvi.vl_unitario_item_pedido,0))
      * (isnull(pv.pc_promocional_pedido,0) / 100)                      as ValorDesconto,
     ( pvi.qt_item_pedido_venda * isnull(pvi.vl_unitario_item_pedido,0) )
      -
     (pvi.qt_item_pedido_venda * isnull(pvi.vl_unitario_item_pedido,0)) * 
                             (isnull(pv.pc_promocional_pedido,0) / 100) as VlItemDesc, 
      p.nm_fantasia_produto,
      p.nm_produto,
      um.sg_unidade_medida,
      pvi.vl_unitario_item_pedido,
      pv.vl_total_pedido_venda
    from
      pedido_venda                       pv  with (nolock)
      inner join pedido_venda_item       pvi with (nolock) on pvi.cd_pedido_venda      = pv.cd_pedido_venda
      left outer join condicao_pagamento cp  with (nolock) on cp.cd_condicao_pagamento = pv.cd_condicao_pagamento
      left outer join produto            p   with (nolock) on p.cd_produto             = pvi.cd_produto 
      left outer join cliente            c   with (nolock) on c.cd_cliente             = pv.cd_cliente
      left outer join unidade_medida     um  with (nolock) on um.cd_unidade_medida     = pvi.cd_unidade_medida
    where 
      pv.cd_pedido_venda = case when @cd_pedido_venda = 0 then pv.cd_pedido_venda else @cd_pedido_venda end  and
      pv.dt_pedido_venda between @dt_inicial       and 
                                 @dt_final         and
      isnull(pv.pc_promocional_pedido,0) > 0       and
      isnull(pvi.ic_desc_prom_item_pedido,'N')='S' and
      pv.dt_cancelamento_pedido is null
    order by
      pv.cd_pedido_venda,
      pvi.cd_item_pedido_venda

