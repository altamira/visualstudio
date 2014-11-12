
create procedure pr_rel_diario_proposta

@dt_inicial  datetime,
@dt_final    datetime,
@cd_vendedor int

as

  select
    c.nm_fantasia_cliente                   as 'Cliente',
   co.dt_consulta                           as 'Data', 
    cp.sg_categoria_produto                 as 'Produto',
    isnull(ico.qt_item_consulta * 
           ico.vl_unitario_item_consulta,0) as 'Total',
    pg.nm_condicao_pagamento                as 'CondicaoPagamento',

    case 
      when
        ico.dt_entrega_consulta = ico.dt_item_consulta
      then 'Imediato'
      else convert( varchar(10),ico.dt_entrega_consulta,103 ) end as 'Entrega',

    Interno = ( select nm_fantasia_vendedor from Vendedor where cd_vendedor = co.cd_vendedor_interno ),
    Externo = ( select nm_fantasia_vendedor from Vendedor where cd_vendedor = co.cd_vendedor )

  from
    Consulta          co,
    Consulta_Itens   ico,
    Cliente            c,
    Condicao_Pagamento pg,
    Categoria_Produto  cp
  
  where

    co.dt_consulta between @dt_inicial   and @dt_final and
    co.cd_consulta     = ico.cd_consulta and
  ( ico.dt_perda_consulta_itens is null or ico.dt_perda_consulta_itens > @dt_final ) and
    co.cd_cliente            = c.cd_cliente             and
    co.cd_condicao_pagamento = pg.cd_condicao_pagamento and
   ico.cd_categoria_produto  = cp.cd_categoria_produto

order by
   4 desc

