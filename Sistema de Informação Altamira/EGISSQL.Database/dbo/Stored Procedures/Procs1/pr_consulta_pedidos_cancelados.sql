

/****** Object:  Stored Procedure dbo.pr_consulta_pedidos_cancelados    Script Date: 13/12/2002 15:08:22 ******/



CREATE     PROCEDURE pr_consulta_pedidos_cancelados
---------------------------------------------------
--GBS - Global Business Sollution              2002
--Stored Procedure: Microsoft SQL Server       2000
--Autor(es): Daniel Carrasco Neto
--Banco de Dados: EGISQL
--Objetivo: Consulta de Pedidos Cancelados Total ou por Item
--Data: 18/03/2002
--Atualizado: 12/05/2002 - Igor
---------------------------------------------------
@ic_parametro as int,
@cd_pedido as Int,
@dt_inicial as datetime,
@dt_final as datetime

AS

--------------------------------------------------------------------------------------------
  if @ic_parametro = 1 -- Realiza a Consulta do Pedido
--------------------------------------------------------------------------------------------  
  Begin
    select distinct
      t.sg_tipo_pedido,
      p.cd_pedido_venda,
      p.dt_pedido_venda,
      c.nm_fantasia_cliente,
--      (Select top 1 MAX(dt_entrega_vendas_pedido) From Pedido_Venda_Item Where cd_pedido_venda = p.cd_pedido_venda) as 'dt_entrega_vendas_pedido',
--      (Select top 1 MAX(dt_entrega_fabrica_pedido) From Pedido_Venda_Item Where cd_pedido_venda = p.cd_pedido_venda) as 'dt_entrega_fabrica_pedido',
      cast(isnull(p.vl_total_pedido_venda,0) as decimal(25,2)) as 'vl_total_pedido_venda', 
      p.dt_cancelamento_pedido,
      p.ds_cancelamento_pedido,
      p.cd_vendedor_pedido,
      (Select nm_fantasia_vendedor From Vendedor Where cd_vendedor = p.cd_vendedor_pedido) as 'nm_vendedor_externo',
      p.cd_vendedor_interno,
      (Select nm_fantasia_vendedor From Vendedor Where cd_vendedor = p.cd_vendedor_interno) as 'nm_vendedor_interno',
      Case 
        When p.dt_cancelamento_pedido is not null then 'S' Else 'N' end as 'BaixaTotal',
      cp.nm_condicao_pagamento as 'CondicaoPagto',
      tp.nm_transportadora as 'Transportadora',
      st.nm_status_pedido as 'Status'
    from
      Pedido_Venda p 
      left outer join Tipo_Pedido t
        on p.cd_tipo_pedido = t.cd_tipo_pedido 
      left outer join Cliente c
        on p.cd_cliente = c.cd_cliente
      left outer join Condicao_Pagamento cp
        on cp.cd_condicao_pagamento = p.cd_condicao_pagamento
      left outer join Transportadora tp 
        on tp.cd_transportadora = p.cd_transportadora
      left outer join Status_Pedido st 
        on st.cd_status_pedido = p.cd_status_pedido
    where
      p.dt_pedido_venda between @dt_inicial and @dt_final and
      p.cd_status_pedido = 7
    order by
      p.dt_pedido_venda desc, p.cd_pedido_venda desc
end
else 
--------------------------------------------------------------------------------------------
  if @ic_parametro = 2 -- Realiza a Consulta de Itens do Pedido
--------------------------------------------------------------------------------------------  
  Begin
    select
      t.sg_tipo_pedido,
      p.cd_pedido_venda,
      p.dt_pedido_venda,
      c.nm_fantasia_cliente,
      c.nm_razao_social_cliente,
      i.qt_item_pedido_venda,
      i.qt_saldo_pedido_venda,
      i.cd_item_pedido_venda,
      i.nm_fantasia_produto,
      i.nm_produto_pedido,
      i.dt_cancelamento_item,
      i.nm_mot_canc_item_pedido,
      i.vl_unitario_item_pedido,
      cast(isnull(i.qt_item_pedido_venda,0) * isnull(i.vl_unitario_item_pedido,0) as decimal(25,2)) as 'vl_total_item_Pedido'
    from
      Pedido_Venda_Item i left outer join
      Pedido_Venda p
        on p.cd_pedido_venda = i.cd_pedido_venda left outer join
      Tipo_Pedido t
        on p.cd_tipo_pedido = t.cd_tipo_pedido left outer join
      Cliente c
        on p.cd_cliente = c.cd_cliente
    where
      i.cd_pedido_venda = @cd_pedido and
      p.cd_status_pedido = 7
    order by
      i.dt_cancelamento_item desc, p.cd_pedido_venda desc, i.cd_item_pedido_venda
end
Else
  if @ic_parametro = 3 -- Realiza a Consulta para Relatório
--------------------------------------------------------------------------------------------  
  Begin
    Select
      t.sg_tipo_pedido,
      t.nm_tipo_pedido,
      p.cd_pedido_venda,
      p.dt_pedido_venda,
      c.nm_fantasia_cliente,
      (Select nm_fantasia_Contato
       From Cliente_Contato
       Where cd_cliente = p.cd_cliente and cd_contato = p.cd_contato) as 'nm_fantasia_contato',
      p.ds_cancelamento_pedido,
      p.dt_cancelamento_pedido,
      i.cd_item_pedido_venda,
      i.qt_item_pedido_venda,
      i.vl_unitario_item_pedido,
      (i.qt_item_pedido_venda * i.vl_unitario_item_pedido) as 'vl_total_item_pedido',
      i.dt_entrega_vendas_pedido,
      i.dt_entrega_fabrica_pedido,
      pd.cd_produto,
      i.nm_produto_pedido as 'nm_produto',
      i.nm_fantasia_produto
    from
      Pedido_Venda p left outer join
      Pedido_Venda_Item i
        on p.cd_pedido_venda = i.cd_pedido_venda Left Outer Join
      Produto pd
        on i.cd_produto = pd.cd_produto Left Outer Join
      Tipo_Pedido t
        on p.cd_tipo_pedido = t.cd_tipo_pedido left outer join
      Cliente c
        on p.cd_cliente = c.cd_cliente
    where
      p.dt_pedido_venda between @dt_inicial and @dt_final and
      p.cd_status_pedido = 7

    order by
      p.dt_cancelamento_pedido desc, p.cd_pedido_venda desc, i.cd_item_pedido_venda
end







