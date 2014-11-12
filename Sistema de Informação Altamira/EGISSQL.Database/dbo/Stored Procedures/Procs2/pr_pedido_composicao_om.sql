
create procedure pr_pedido_composicao_om
@cd_pedido_venda      int,
@cd_item_pedido_venda int

as

  Select
    a.cd_pedido_venda           as 'Pedido',
    a.dt_pedido_venda           as 'Emissao',
    a.cd_vendedor               as 'CodVendedor',
    b.cd_item_pedido_venda      as 'Item',
    b.qt_item_pedido_venda      as 'Qtde',
    b.qt_saldo_pedido_venda     as 'Saldo',
    b.dt_entrega_vendas_pedido  as 'Comercial',
    b.dt_entrega_fabrica_pedido as 'Fabrica',
    b.dt_reprog_item_pedido     as 'Reprogramacao',
    b.ic_controle_pcp_pedido    as 'Pcp',
    b.nm_produto_pedido as 'Descricao',
    MascaraProduto =
    Case when a.cd_tipo_pedido = 1 then
      (Select max(cd_mascara_produto) from produto where cd_produto = b.CD_PRODUTO)
         when a.cd_tipo_pedido = 2 then  
      (cast(b.cd_grupo_produto as char(2)) + '9999999')
    else Null end,
    a.cd_cliente                as 'CodCliente',
    a.qt_liquido_pedido_venda   as 'LiquidoPedido',
    a.qt_bruto_pedido_venda     as 'BrutoPedido',
    c.nm_fantasia_cliente       as 'Cliente',
    d.nm_fantasia_vendedor      as 'Setor',
    h.nm_fantasia_vendedor      as 'VendedorInterno',
    b.qt_liquido_item_pedido    as 'LiquidoItem',
    b.qt_bruto_item_pedido      as 'BrutoItem',
    -- Campos para serem alimentados posteriormente
    Null                        as 'DataMatPrima',
    e.cd_produto                as 'CodProdutoComponente',
    e.cd_id_item_pedido_venda   as 'ID',
    f.cd_mascara_produto        as 'MascaraComponente',
    f.nm_fantasia_produto       as 'ProdutoComponente',
    e.qt_item_produto_comp      as 'QtdeComponente',
    e.cd_fase_produto           as 'CodFaseComponente',
    g.nm_fase_produto           as 'FaseComponente',
    e.ic_estoque_produto        as 'EstoqueComponente',
    e.ic_reserva_estoque_prod   as 'ReservadoComponente',
    e.qt_peso_liquido_produto   as 'LiquidoComponente',
    e.qt_peso_bruto_produto     as 'BrutoComponente',
    e.nm_obs_ordem_montagem     as 'ObsOrdemMontagem',
    e.ic_calculo_peso_produto   as 'CalculoPesoComponente',
    e.pc_composicao_produto     as '%Composicao',
    e.ic_montagemg_produto      as 'MontagemGComponente',
    e.ic_tipo_montagem_produto  as 'TipoMontagemComponente',
    f.vl_produto                as 'ValorUnitarioComponente'

  From
    Pedido_Venda a

  Left Outer Join Pedido_Venda_Item b on
  a.cd_pedido_venda = b.cd_pedido_venda

  Left Outer Join Cliente c on
  a.cd_cliente = c.cd_cliente

  Left Outer Join Vendedor d on
  a.cd_vendedor = d.cd_vendedor

  Left Outer Join Pedido_Venda_Composicao e on
  a.cd_pedido_venda = e.cd_pedido_venda and
  b.cd_item_pedido_venda = e.cd_item_pedido_venda 

  Left Outer Join Produto f on
  e.cd_produto = f.cd_produto

  Left Outer Join Grupo_Produto_Custo gpc on
  f.cd_grupo_produto = gpc.cd_grupo_produto

  Left Outer Join Fase_produto g on
  e.cd_fase_produto = g.cd_fase_produto

  Left Outer Join Vendedor h on
  a.cd_vendedor_interno = h.cd_vendedor

  Where --a.cd_tipo_pedido = 2                  and -- Somente pedidos especiais 
        a.cd_pedido_venda = @cd_pedido_venda  and
        b.cd_item_pedido_venda = @cd_item_pedido_venda and
        isnull(gpc.ic_om_custo_grupo_produto,'S')='S'

  Order by a.cd_pedido_venda,
           b.cd_item_pedido_venda,
           e.cd_ordem_item_composicao

