
CREATE PROCEDURE pr_consulta_item_pedido_etiqueta
@ic_parametro    as int,
@cd_pedido_venda as int,
@dt_inicial as datetime,
@dt_final   as datetime

AS


-------------------------------------------------------------------------------
if @ic_parametro = 1 -- Realiza a Consulta dos Dados do Pedido de Venda
-------------------------------------------------------------------------------
  begin
    SELECT     
      IsNull(pv.ic_etiq_emb_pedido_venda,'N') as 'ic_etiq_emb_pedido_venda',
      pv.cd_pedido_venda,
      pv.dt_pedido_venda,
      pv.cd_vendedor_pedido,
      (Select nm_vendedor From Vendedor Where cd_vendedor = pv.cd_vendedor_pedido) as 'Vendedor',
      cli.nm_fantasia_cliente as 'Cliente', 
      pv.cd_contato, 
      (Select nm_contato From Contato Where cd_contato = pv.cd_contato and cd_cliente = pv.cd_cliente) as 'Contato'
    from Pedido_Venda pv
      left outer join Cliente cli ON cli.cd_cliente=pv.cd_cliente 
    WHERE     
      (pv.cd_pedido_venda = @cd_pedido_venda) or
      ((@cd_pedido_venda = 0) and 
       IsNull(pv.ic_etiq_emb_pedido_venda,'N') = 'N' and
       (pv.dt_pedido_venda between @dt_inicial and @dt_final))
  end

--------------------------------------------------------------------------------------------
if @ic_parametro = 2 -- Realiza a Consulta dos Itens do Pedido
--------------------------------------------------------------------------------------------  
  Begin
    Select
      pvi.cd_pedido_venda,
      pvi.cd_item_pedido_venda, 
      pvi.dt_item_pedido_venda, 
      pvi.qt_item_pedido_venda, 
      pvi.qt_saldo_pedido_venda, 
      pvi.dt_entrega_vendas_pedido,
      pvi.vl_unitario_item_pedido, 
      cast(IsNull(pvi.ic_etiqueta_emb_pedido,'N') as char(1)) as 'ic_etiqueta_emb_pedido',
      p.cd_produto,
      p.nm_fantasia_produto,
      p.nm_produto
    FROM
      Pedido_Venda_Item pvi 
      left outer join Pedido_Venda pv on pv.cd_pedido_venda = pvi.cd_pedido_venda
      left outer join Produto p on p.cd_produto = pvi.cd_produto 
    WHERE     
      pvi.cd_pedido_venda = @cd_pedido_venda
    ORDER BY
      pvi.cd_item_pedido_venda
  end

