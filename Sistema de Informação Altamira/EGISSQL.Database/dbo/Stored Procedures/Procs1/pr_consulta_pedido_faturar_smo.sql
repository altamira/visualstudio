

/****** Object:  Stored Procedure dbo.pr_consulta_pedido_faturar_smo    Script Date: 13/12/2002 15:08:22 ******/

CREATE  PROCEDURE pr_consulta_pedido_faturar_smo
---------------------------------------------------
--GBS - Global Business Solution	       2002
--Stored Procedure: Microsoft SQL Server       2000
--Autor(es): Daniel Carrasco Neto
--Banco de Dados: EgisSql
--Objetivo: Realizar uma consulta de Faturamento de SMO
--Data: 15/03/2002
--Atualizado: 
---------------------------------------------------
@dt_inicial as DateTime,
@dt_final   as DateTime
AS

  SELECT     
    p.cd_pedido_venda, -- este
    p.dt_pedido_venda, -- este
    p.cd_vendedor_pedido,
    (Select nm_fantasia_vendedor From Vendedor Where cd_vendedor = p.cd_vendedor_pedido) as 'nm_vendedor_externo', -- este
    p.cd_vendedor_interno, -- este
    (Select nm_fantasia_vendedor From Vendedor Where cd_vendedor = p.cd_vendedor_interno) as 'nm_vendedor_interno', -- este
    IsNull(p.ic_fatsmo_pedido,'N') as 'ic_fatsmo_pedido', -- este
    p.vl_total_pedido_venda,  -- este
    c.nm_fantasia_cliente, -- este
    (Select top 1 nm_fantasia_contato 
     From Cliente_Contato
     Where cd_contato = p.cd_contato and cd_cliente = p.cd_cliente) as 'nm_fantasia_contato',
    p.cd_tipo_pedido, -- este
    ti.sg_tipo_pedido,
    i.cd_item_pedido_venda, -- este
    i.qt_item_pedido_venda, -- este
    i.dt_entrega_vendas_pedido, -- este
    i.dt_entrega_fabrica_pedido, -- este
    i.vl_unitario_item_pedido,
    (i.qt_item_pedido_venda * i.vl_unitario_item_pedido) as 'vl_total_item_pedido',
    i.pc_desconto_item_pedido,
    i.cd_produto,
    i.nm_produto_pedido as nm_produto,
    i.nm_fantasia_produto,
    s.cd_status_pedido,
    s.nm_status_pedido,
    s.sg_status_pedido
  FROM
    Pedido_Venda p left outer join
    Tipo_Pedido ti
      on ti.cd_tipo_pedido = p.cd_tipo_pedido LEFT OUTER JOIN 
    Cliente c
      ON p.cd_cliente = c.cd_cliente LEFT OUTER JOIN
    Pedido_Venda_Item i
      ON p.cd_pedido_venda = i.cd_pedido_venda LEFT OUTER JOIN
    Produto pd
      on i.cd_produto = pd.cd_produto LEFT OUTER JOIN
    Condicao_Pagamento cop
      on p.cd_condicao_pagamento = cop.cd_condicao_pagamento Left Outer Join
    Status_Pedido s
      on p.cd_status_pedido = s.cd_status_pedido
  WHERE     
    p.dt_pedido_venda BETWEEN @dt_inicial AND @dt_final and
    p.ic_fatsmo_pedido = 'S'
  ORDER BY
    p.dt_pedido_venda desc






