
-------------------------------------------------------------------------------
--sp_helptext pr_mapa_carteira_cliente_aberto
-------------------------------------------------------------------------------
--pr_mapa_carteira_cliente_aberto
-------------------------------------------------------------------------------
--GBS Global Business Solution Ltda                                        2009
-------------------------------------------------------------------------------
--Stored Procedure : Microsoft SQL Server 2000
--Autor(es)        : Carlos Cardoso Fernandes
--Banco de Dados   : Egissql
--Objetivo         : Mapa de Carteira em Aberto por Cliente
--
--Data             : 04.02.2009
--Alteração        : 
--
-- 27.01.2010 - Novos Campos - Carlos Fernandes
------------------------------------------------------------------------------
create procedure pr_mapa_carteira_cliente_aberto
@dt_inicial datetime = '',
@dt_final   datetime = ''

as

select
  max(pv.dt_pedido_venda)                                   as 'Emissao',
  pv.cd_pedido_venda,
  max(isnull(pv.ic_entrega_futura,'N'))                     as 'ic_entrega_futura',
  max(c.nm_fantasia_cliente)                                as 'Cliente',
  max(pvi.dt_entrega_vendas_pedido)                         as 'Entrega',
  max(pvi.dt_entrega_fabrica_pedido)                        as 'Fabrica',
  max(pvi.dt_reprog_item_pedido)                            as 'Reprogramacao',

  case when sum(pvi.qt_item_pedido_venda)<>sum(pvi.qt_saldo_pedido_venda)
  then
   'Parcial'
  else
   'Total'
  end                                                        as 'Tipo',

  sum( (pvi.qt_item_pedido_venda  * vl_unitario_item_pedido)
       +
       (pvi.qt_item_pedido_venda  * vl_unitario_item_pedido) * ( isnull(pvi.pc_ipi,0)/100)  
     )                                                       as 'Total',


  sum((pvi.qt_item_pedido_venda  * vl_unitario_item_pedido)) as 'Total_Liquido',

  sum( (pvi.qt_saldo_pedido_venda * vl_unitario_item_pedido)
       +
       (pvi.qt_saldo_pedido_venda * vl_unitario_item_pedido)* ( isnull(pvi.pc_ipi,0)/100)  
     )                                                       as 'Saldo',

  max(cp.nm_condicao_pagamento)                              as 'Condicao_Pagamento',
  max(v.nm_fantasia_vendedor)                                as 'Vendedor',
  sum( (pvi.qt_item_pedido_venda  * vl_unitario_item_pedido) 
       * ( isnull(pvi.pc_ipi,0)/100)  )                      as 'Valor_IPI',
  
  --Valor Pago no Contas a Receber
  --select * from documento_receber_pagamento
  isnull(( select
      sum( isnull(dp.vl_pagamento_documento,0) )
    from
      documento_receber_pagamento dp
      inner join documento_receber d on d.cd_documento_receber = dp.cd_documento_receber 
    where
      d.cd_pedido_venda = pv.cd_pedido_venda ),0)             as 'Valor_Pago'

  --select * from pedido_venda_item

into
  #MapaCarteiraPedido

from
  pedido_venda pv                       with (nolock) 
  inner join pedido_venda_item pvi      with (nolock) on pvi.cd_pedido_venda      = pv.cd_pedido_venda
  left outer join cliente            c  with (nolock) on c.cd_cliente             = pv.cd_cliente
  left outer join condicao_pagamento cp with (nolock) on cp.cd_condicao_pagamento = pv.cd_condicao_pagamento
  left outer join vendedor           v  with (nolock) on v.cd_vendedor            = pv.cd_vendedor
  
where
  isnull(pvi.qt_saldo_pedido_venda,0)>0  
  and 
  pvi.dt_cancelamento_item is null
group by
  pv.cd_pedido_venda
order by
  4 
  --max(pvi.dt_entrega_vendas_pedido)

--select * from pedido_venda_item
--select * from pedido_venda

select
  *,
  SaldoReceber = Total - Valor_Pago
from
  #MapaCarteiraPedido
order by
  Entrega
  

