
CREATE PROCEDURE pr_pedido_categoria_aberto
@dt_base datetime,
@cd_categoria int
--@cd_cat_final char(10)
AS

--------------------------------------------------------
if @cd_categoria = 0  -- Todas as categorias
--------------------------------------------------------

begin

  select 
    cs.cd_categoria_produto,
    p.ic_smo_pedido_venda, --Status
    p.cd_tipo_pedido,
    t.nm_tipo_pedido,
    cli.nm_fantasia_cliente, --Cliente
    p.cd_vendedor_pedido,
    (Select nm_vendedor From Vendedor Where cd_vendedor = p.cd_vendedor_pedido) as 'nm_vendedor_externo',
    p.dt_pedido_venda, --Data Emissão
    p.cd_pedido_venda,
    i.qt_item_pedido_venda, --Qtdade
    i.cd_item_pedido_venda,
    p.qt_liquido_pedido_venda,
    p.qt_bruto_pedido_venda,
    i.ds_produto_pedido_venda, --Desc
    p.vl_total_pedido_venda, --Valor
    i.qt_saldo_pedido_venda, --Saldo
    sp.nm_status_pedido,
    sp.sg_status_pedido --Status Pedido

----------------------------------------------
--- Campos constando no Mapa em Aberto do GIP.
--  c.cd_categoria_produto, 
--  c.nm_categoria_produto,  
--  i.vl_unitario_item_pedido,
--  i.vl_lista_item_pedido,
--  i.cd_item_pedido_venda,
--  c.sg_categoria_produto,
----------------------------------------------

  from 
    Pedido_Venda p
  left outer join
    Tipo_Pedido t
  on
    t.cd_tipo_pedido = p.cd_tipo_pedido
  left outer join
    Cliente_Substituicao_Tributari cs
  on
    p.cd_cliente = cs.cd_cliente
  left outer join
    Cliente cli
  on
    p.cd_cliente = cli.cd_cliente
  left outer join
    Pedido_Venda_Item i
  on
    p.cd_pedido_venda = i.cd_pedido_venda
  left outer join
    Status_Pedido sp
  on
    p.cd_status_pedido =  sp.cd_status_pedido

  where
--  cs.cd_cliente = p.cd_cliente and
    p.cd_status_pedido = 1 and
    p.dt_pedido_venda > @dt_base

end else 
begin

  select 
    cs.cd_categoria_produto,
    p.ic_smo_pedido_venda,
    p.cd_tipo_pedido,
    t.nm_tipo_pedido,
    cli.nm_fantasia_cliente,
    p.cd_vendedor_pedido,
    (Select nm_vendedor From Vendedor Where cd_vendedor = p.cd_vendedor_pedido) as 'nm_vendedor_externo',
    p.dt_pedido_venda,
    p.cd_pedido_venda,
    i.qt_item_pedido_venda,
    i.cd_item_pedido_venda,
    p.qt_liquido_pedido_venda,
    p.qt_bruto_pedido_venda,
    i.ds_produto_pedido_venda, 
    p.vl_total_pedido_venda,
    i.qt_saldo_pedido_venda,
    sp.nm_status_pedido,
    sp.sg_status_pedido

----------------------------------------------
--- Campos constando no Mapa em Aberto do GIP.
--  c.cd_categoria_produto, 
--  c.nm_categoria_produto,  
--  i.vl_unitario_item_pedido,
--  i.vl_lista_item_pedido,
--  i.cd_item_pedido_venda,
--  c.sg_categoria_produto,
----------------------------------------------

  from 
      Cliente_Substituicao_Tributari cs
    left outer join
      Pedido_Venda p
    on
      p.cd_cliente = cs.cd_cliente
    left outer join
      Tipo_Pedido t
    on
      p.cd_tipo_pedido = t.cd_tipo_pedido
    left outer join
      Cliente cli
    on
      p.cd_cliente = cli.cd_cliente
    left outer join
      Pedido_Venda_Item i
    on
      p.cd_pedido_venda = i.cd_pedido_venda
    left outer join
      Status_Pedido sp
    on
      p.cd_status_pedido =  sp.cd_status_pedido
    where
--      cs.cd_cliente = p.cd_cliente and
      cs.cd_categoria_produto = @cd_categoria and
      p.cd_status_pedido = 1 and
      p.dt_pedido_venda > @dt_base

end

  
