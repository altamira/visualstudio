
create procedure pr_reserva_diaria_pedido
@cd_categoria_produto integer,
@dt_inicial           datetime,
@dt_final             datetime

as

  select

    cp.sg_categoria_produto                               as 'Categoria',
     p.cd_mascara_produto                                 as 'Codigo',
     p.nm_fantasia_produto                                as 'Fantasia',
     p.nm_produto                                         as 'Descricao',
    pv.dt_pedido_venda                                    as 'Emissao',
    pv.cd_pedido_venda                                    as 'Pedido',
   ipv.cd_item_pedido_venda                               as 'Item',
   ipv.qt_item_pedido_venda                               as 'Qtd',

   isnull(( select distinct qt_movimento_estoque
            from Movimento_Estoque
            where
              pv.cd_pedido_venda       = cast( cd_documento_movimento as int ) and
              ipv.cd_item_pedido_venda = cd_item_documento and 
              ipv.cd_produto           = cd_produto        and
              cd_tipo_movimento_estoque= 2                and
              ipv.qt_item_pedido_venda = qt_movimento_estoque),0)
                                                                as 'Reserva',

   ipv.qt_item_pedido_venda * ipv.vl_unitario_item_pedido as 'Valor',
    c.nm_fantasia_cliente                                 as 'Cliente'
   
--sp_help movimento_estoque    
--select * from tipo_movimento_estoque
  from
    Pedido_Venda      pv,
    Pedido_Venda_Item ipv,
    Categoria_Produto cp,
    Produto           p,
    Cliente           c
  where
    pv.dt_pedido_venda between @dt_inicial and @dt_final and
    pv.cd_pedido_venda       = ipv.cd_pedido_venda       and
    ipv.cd_produto           = p.cd_produto              and
    ipv.cd_categoria_produto = cp.cd_categoria_produto   and
    ((ipv.cd_categoria_produto = @cd_categoria_produto) or (@cd_categoria_produto = 0))   and
    pv.cd_cliente            = c.cd_cliente
   
order by 

    cp.cd_mascara_categoria, 
     p.cd_mascara_produto,
    pv.cd_pedido_venda,
   ipv.cd_item_pedido_venda

