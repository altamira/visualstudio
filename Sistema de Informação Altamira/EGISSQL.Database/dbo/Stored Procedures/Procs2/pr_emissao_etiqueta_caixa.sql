
CREATE procedure pr_emissao_etiqueta_caixa
  
@ic_parametro         int, -- 1 = Pedido, 2 = Data de Processo, 3 = Data de Programação
@cd_pedido_venda_1    int,  
@cd_pedido_venda_2    int,
@cd_item_pedido_venda int,
@dt_inicial           datetime,  
@dt_final             datetime
  
as  

-------------------------------------------------------------------------------------
if @ic_parametro = 1  
-------------------------------------------------------------------------------------
  select  
    a.cd_pedido_venda           as 'Pedido',  
    a.dt_pedido_venda           as 'Emissao',  
    b.qt_bruto_item_pedido      as 'BrutoItem',   
    b.qt_liquido_item_pedido    as 'LiquidoItem',  
    TipoPedido =   
    case when a.cd_tipo_pedido = 1 then 'PV'   
         when a.cd_tipo_pedido = 2 then 'PVE'   
    else Null end,  
    Descricao = b.nm_produto_pedido,
    Entrega = isnull(b.dt_reprog_item_pedido,b.dt_entrega_fabrica_pedido),
    b.cd_item_pedido_venda      as 'Item',  
    b.qt_item_pedido_venda      as 'Qtde', 
    b.qt_saldo_pedido_venda     as 'Saldo', 
    c.nm_fantasia_cliente       as 'Cliente',  
    b.ic_etiqueta_emb_pedido,
    p.cd_mascara_produto,
    Polimold =  
    case when substring(p.cd_mascara_produto,7,1) < '4' then 'POLIMOLD EM ACO 0' else  
                                                             'POLIMOLD EM ACO' end 
  -- 
  from Pedido_Venda a  
  --
  Inner Join Pedido_Venda_Item b on  
  a.cd_pedido_venda = b.cd_pedido_venda  
  Inner Join Cliente c on  
  a.cd_cliente = c.cd_cliente  
  Left Outer Join Produto p on
  b.cd_produto = p.cd_produto
  --
  Where  
  (((a.cd_pedido_venda between @cd_pedido_venda_1 and @cd_pedido_venda_2) and
    (b.ic_controle_pcp_pedido = 'S' and b.ic_controle_mapa_pedido = 'S')) OR
    (@cd_pedido_venda_1 = @cd_pedido_venda_2 and a.cd_pedido_venda = @cd_pedido_venda_1)) and
    (@cd_item_pedido_venda = 0 or b.cd_item_pedido_venda = @cd_item_pedido_venda) and
    (b.dt_entrega_vendas_pedido <> a.dt_pedido_venda) and -- Imediato
     b.dt_cancelamento_item is null 

  order by b.cd_pedido_venda, 
           b.cd_item_pedido_venda
  
else  
-------------------------------------------------------------------------------------
if @ic_parametro = 2
-------------------------------------------------------------------------------------
  select  
    a.cd_pedido_venda           as 'Pedido',
    a.dt_pedido_venda           as 'Emissao',
    b.qt_bruto_item_pedido      as 'BrutoItem',
    b.qt_liquido_item_pedido    as 'LiquidoItem',
    TipoPedido =
    case when a.cd_tipo_pedido = 1 then 'PV'
         when a.cd_tipo_pedido = 2 then 'PVE'
    else Null end,
    Descricao = b.nm_produto_pedido,
    Entrega = isnull(b.dt_reprog_item_pedido,b.dt_entrega_fabrica_pedido),
    b.cd_item_pedido_venda      as 'Item',
    b.qt_item_pedido_venda      as 'Qtde',
    b.qt_saldo_pedido_venda     as 'Saldo',
    c.nm_fantasia_cliente       as 'Cliente',
    b.ic_etiqueta_emb_pedido,
    p.cd_mascara_produto,
    Polimold =
    case when substring(p.cd_mascara_produto,7,1) < '4' then 'POLIMOLD EM ACO 0' else
                                                             'POLIMOLD EM ACO' end
  --
  from Processo_Producao pp
  --
  Inner Join Pedido_Venda_Item b on  
  pp.cd_pedido_venda = b.cd_pedido_venda and
  pp.cd_item_pedido_venda = b.cd_item_pedido_venda
  Inner Join Pedido_Venda a on
  b.cd_pedido_venda = a.cd_pedido_venda
  Inner Join Cliente c on  
  a.cd_cliente = c.cd_cliente  
  Left Outer Join Produto p on
  b.cd_produto = p.cd_produto
  --
  Where  
   ( (pp.dt_processo between @dt_inicial and @dt_final) or
     (pp.dt_liberacao_processo between @dt_inicial and @dt_final) ) and 
      b.ic_controle_pcp_pedido = 'S' and
      b.ic_controle_mapa_pedido = 'S' and
     (ic_lista_processo_pedido = 'S' or ic_processo_pedido_venda = 'S') and 
      b.qt_saldo_pedido_venda > 0 and
     (b.dt_entrega_vendas_pedido <> a.dt_pedido_venda) and -- Imediato
      b.dt_cancelamento_item is null
  
  order by b.cd_pedido_venda, b.cd_item_pedido_venda

else  
-------------------------------------------------------------------------------------
if @ic_parametro = 3
-------------------------------------------------------------------------------------
  select  
    a.cd_pedido_venda           as 'Pedido',  
    a.dt_pedido_venda           as 'Emissao',  
    b.qt_bruto_item_pedido      as 'BrutoItem',   
    b.qt_liquido_item_pedido    as 'LiquidoItem',  
    TipoPedido =   
    case when a.cd_tipo_pedido = 1 then 'PV'   
         when a.cd_tipo_pedido = 2 then 'PVE'   
    else Null end,  
    Descricao = b.nm_produto_pedido,
    Entrega = isnull(b.dt_reprog_item_pedido,b.dt_entrega_fabrica_pedido),
    b.cd_item_pedido_venda      as 'Item',  
    b.qt_item_pedido_venda      as 'Qtde', 
    b.qt_saldo_pedido_venda     as 'Saldo', 
    c.nm_fantasia_cliente       as 'Cliente',  
    b.ic_etiqueta_emb_pedido,
    p.cd_mascara_produto,
    ic_lista_pcp_pedido_venda,
    ic_pcp_pedido_venda,
    ic_lista_processo_pedido,
    ic_processo_pedido_venda,
    Polimold =  
    case when substring(p.cd_mascara_produto,7,1) < '4' then 'POLIMOLD EM ACO 0' else  
                                                             'POLIMOLD EM ACO' end 
  -- 
  from Pedido_Venda a
  --
  Inner Join Pedido_Venda_Item b on  
  a.cd_pedido_venda = b.cd_pedido_venda  
  Inner Join Cliente c on  
  a.cd_cliente = c.cd_cliente  
  Left Outer Join Produto p on
  b.cd_produto = p.cd_produto
  --
  Where  
     (b.dt_item_pedido_venda between @dt_inicial and @dt_final) and
      b.qt_saldo_pedido_venda > 0 and
      b.ic_controle_pcp_pedido = 'S' and
      b.ic_controle_mapa_pedido = 'S' and
      ic_lista_pcp_pedido_venda = 'S' and
     (b.dt_entrega_vendas_pedido <> a.dt_pedido_venda) and -- Imediato
      b.dt_cancelamento_item is null

  order by b.cd_pedido_venda, b.cd_item_pedido_venda

