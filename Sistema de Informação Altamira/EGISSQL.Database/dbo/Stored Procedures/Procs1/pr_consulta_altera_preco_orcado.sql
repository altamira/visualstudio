
CREATE PROCEDURE pr_consulta_altera_preco_orcado

@cd_pedido_venda               int,
@cd_item_pedido_venda          int,
@dt_inicial                    datetime,    --Data Inicial
@dt_final                      datetime     --Data Final


AS

-----------------------------------------------------------
if @cd_pedido_venda = 0 -- Escolhe todos os Pedidos por período
-----------------------------------------------------------
begin
  select     
    Pedido_Venda.cd_pedido_venda as Pedido, 
    Pedido_Venda_Item.vl_unitario_item_pedido as VlUnitario , 
    Pedido_Venda_Item.dt_item_pedido_venda as Emissao, 
    Cliente.nm_fantasia_cliente as Cliente, 
    Pedido_Venda_Item.cd_item_pedido_venda as Item, 
    Pedido_Venda_Item.qt_item_pedido_venda as Qtd, 
    Pedido_Venda_Item.vl_lista_item_pedido as VlOriginal, 
    Pedido_Venda_Item.nm_fantasia_produto as Produto, 
    Pedido_Venda_Item.pc_desconto_item_pedido as Desconto, 
    IsNull(Produto.nm_produto, Pedido_Venda_Item.nm_produto_pedido) as Descricao,
    vi.nm_vendedor as Vendedor_Interno,
    ve.nm_vendedor as Vendedor_Externo,
    Pedido_Venda.pc_comissao_especifico

  from Pedido_Venda 
    inner join Cliente on 
      Pedido_Venda.cd_cliente = Cliente.cd_cliente 
    inner join Pedido_Venda_Item on 
      Pedido_Venda.cd_pedido_venda = Pedido_Venda_Item.cd_pedido_venda 
    left outer join Produto on 
      Pedido_Venda_Item.cd_produto = Produto.cd_produto
    left outer join Vendedor vi on
      vi.cd_vendedor = Pedido_Venda.cd_vendedor_interno
    left outer join Vendedor ve on
      ve.cd_vendedor = Pedido_Venda.cd_vendedor

  where
    Pedido_Venda.dt_pedido_venda between @dt_inicial and @dt_final 
--Carlos 27.06.2005
--    Pedido_Venda.dt_cancelamento_pedido is null and
--    Pedido_Venda.cd_status_pedido not in (7,14)

  order by Pedido_Venda_Item.dt_item_pedido_venda desc,
         Pedido_Venda.cd_pedido_venda desc , Pedido_Venda_Item.cd_item_pedido_venda
end

-----------------------------------
else if @cd_pedido_venda <> 0 -- Escolhe todos os Pedidos por período
------------------------------------
begin
  select     
    Pedido_Venda.cd_pedido_venda as Pedido, 
    Pedido_Venda_Item.vl_unitario_item_pedido as VlUnitario , 
    Pedido_Venda_Item.dt_item_pedido_venda as Emissao, 
    Cliente.nm_fantasia_cliente as Cliente, 
    Pedido_Venda_Item.cd_item_pedido_venda as Item, 
    Pedido_Venda_Item.qt_item_pedido_venda as Qtd, 
    Pedido_Venda_Item.vl_lista_item_pedido as VlOriginal, 
    Pedido_Venda_Item.nm_fantasia_produto as Produto, 
    Pedido_Venda_Item.pc_desconto_item_pedido as Desconto, 
    IsNull(Produto.nm_produto, Pedido_Venda_Item.nm_produto_pedido) as Descricao,
    vi.nm_vendedor as Vendedor_Interno,
    ve.nm_vendedor as Vendedor_Externo,
    Pedido_Venda.pc_comissao_especifico

  from Pedido_Venda 
    inner join Cliente on 
      Pedido_Venda.cd_cliente = Cliente.cd_cliente 
    inner join Pedido_Venda_Item on 
      Pedido_Venda.cd_pedido_venda = Pedido_Venda_Item.cd_pedido_venda 
    left join Produto on 
      Pedido_Venda_Item.cd_produto = Produto.cd_produto
    left outer join Vendedor vi on
      vi.cd_vendedor = Pedido_Venda.cd_vendedor_interno
    left outer join Vendedor ve on
      ve.cd_vendedor = Pedido_Venda.cd_vendedor

  where
    (Pedido_Venda.cd_pedido_venda = @cd_pedido_venda) and
    (Pedido_Venda_Item.cd_item_pedido_venda = @cd_item_pedido_venda or @cd_item_pedido_venda=0)    
--Carlos 27.06.2005
--    Pedido_Venda.dt_cancelamento_pedido is null and
--    Pedido_Venda.cd_status_pedido not in (7,14) 

  order by Pedido_Venda_Item.dt_item_pedido_venda desc, Pedido_Venda.cd_pedido_venda desc , Pedido_Venda_Item.cd_item_pedido_venda
end

