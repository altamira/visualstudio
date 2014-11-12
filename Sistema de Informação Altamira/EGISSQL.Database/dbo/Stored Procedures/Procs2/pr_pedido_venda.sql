

/****** Object:  Stored Procedure dbo.pr_pedido_venda    Script Date: 13/12/2002 15:08:38 ******/


CREATE procedure pr_pedido_venda
@cd_pedido_venda int
as

  Select
    ped.cd_pedido_venda,
    ped.dt_pedido_venda,
    (Select nm_fantasia_vendedor From Vendedor
     Where cd_vendedor = ped.cd_vendedor_pedido) as 'nm_vendedor_externo',
    (Select nm_fantasia_vendedor From Vendedor
     Where cd_vendedor = ped.cd_vendedor_interno) as 'nm_vendedor_interno',
    ped.cd_vendedor_pedido,
    ped.cd_vendedor_interno,
    pvi.cd_item_pedido_venda,
    pvi.dt_item_pedido_venda,
    pvi.qt_item_pedido_venda,
    pvi.qt_saldo_pedido_venda,
    pvi.vl_unitario_item_pedido,
    
    cli.cd_cliente,
    cli.nm_fantasia_cliente,
    pdh.dt_pedido_venda_historico,
    dep.cd_departamento,
    dep.sg_departamento,
    ved.cd_vendedor,
    ved.nm_vendedor,
    ved.sg_vendedor,
    pdh.nm_pedido_venda_histor_1,
    pdh.nm_pedido_venda_histor_2,
    pdh.nm_pedido_venda_histor_3,
    pdh.nm_pedido_venda_histor_4,
    usu.cd_usuario,
    usu.nm_usuario
  From
    Pedido_Venda ped Left Outer Join Pedido_Venda_Item pvi on
      ped.cd_pedido_venda = pvi.cd_pedido_venda
    Left Outer Join Pedido_Venda_Historico pdh on
      ped.cd_pedido_venda = pdh.cd_pedido_venda 
    Left Outer Join Cliente Cli on
      ped.cd_cliente = cli.cd_cliente
    Left Outer Join Departamento dep on
      pdh.cd_departamento = dep.cd_departamento
    Left Outer Join Vendedor ved on
      ped.cd_vendedor = ved.cd_vendedor
    Left Outer Join Usuario usu on
      pdh.cd_usuario = usu.cd_usuario
  Where
    ped.cd_pedido_venda = @cd_pedido_venda





