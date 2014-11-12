
create procedure pr_rel_diario_vendas

@dt_inicial  datetime,
@dt_final    datetime

as

  --Diário Analítico

  select
    c.nm_fantasia_cliente             as 'Cliente',
    pv.dt_pedido_venda                as 'Data',
    cp.sg_categoria_produto           as 'Produto',
    isnull(ipv.qt_item_pedido_venda * 
           vl_unitario_item_pedido,0) as 'Total',
    pg.nm_condicao_pagamento          as 'CondicaoPagamento',

    case 
      when
        ipv.dt_entrega_vendas_pedido = ipv.dt_item_pedido_venda
      then 'Imediato'
      else convert( varchar(10),ipv.dt_entrega_vendas_pedido,103 ) end as 'Entrega',

    Interno = ( select nm_fantasia_vendedor from Vendedor where cd_vendedor = pv.cd_vendedor_interno ),
    Externo = ( select nm_fantasia_vendedor from Vendedor where cd_vendedor = pv.cd_vendedor )

  from
    Pedido_Venda       pv,
    Pedido_Venda_Item ipv,
    Cliente            c,
    Condicao_Pagamento pg,
    Categoria_Produto  cp
  
  where
    pv.dt_pedido_venda between @dt_inicial   and @dt_final and
    pv.cd_pedido_venda = ipv.cd_pedido_venda and
  ( ipv.dt_cancelamento_item is null or ipv.dt_cancelamento_item > @dt_final ) and
    pv.cd_cliente            = c.cd_cliente             and
    pv.cd_condicao_pagamento = pg.cd_condicao_pagamento and
   ipv.cd_categoria_produto  = cp.cd_categoria_produto

order by
   4 desc
