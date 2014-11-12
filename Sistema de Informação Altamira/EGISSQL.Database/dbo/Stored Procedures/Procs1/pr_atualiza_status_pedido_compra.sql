
CREATE PROCEDURE pr_atualiza_status_pedido_compra
@cd_nota_entrada int, --No. da Nota de Entrada
@cd_serie_nota_fiscal int, --Série da Nota de Entrada
@cd_fornecedor int --Código do Fornecedor
AS


  Select 
    distinct 
    cd_pedido_compra
  into
    #Pedido_Compra
  from
    Nota_Entrada_Item
  where
    cd_nota_entrada = @cd_nota_entrada

  Select 
    pc.cd_pedido_compra,
    IsNull((Select count('x') from pedido_compra_item 
   	    where cd_pedido_compra = pc.cd_pedido_compra),0) 
    as qt_item_pedido,
    IsNull((Select count('x') from pedido_compra_item 
            where cd_pedido_compra = pc.cd_pedido_compra and 
		  ((qt_saldo_item_ped_compra <> qt_item_pedido_compra) or 
                  qt_item_pedido_compra = 0)),0) 
    as qt_item_entregue
  into
    #Pedido_Compra_Posicao
  from
    #Pedido_Compra pc

  --Define o pedido como em aberto
  print 'Pedido de Compra - Abertos'
  update 
    Pedido_Compra
  set 
    cd_status_pedido = 8
  from
    pedido_compra, #Pedido_Compra_Posicao
  where
    pedido_compra.cd_pedido_compra = #Pedido_Compra_Posicao.cd_pedido_compra and
    #Pedido_Compra_Posicao.qt_item_entregue = 0

  print 'Pedido de Compra - Parcialmente recebido'  
  --Define o pedido como parcialmente entregue
  update pedido_compra
  set cd_status_pedido = 10
  from
    pedido_compra, #Pedido_Compra_Posicao
  where
    pedido_compra.cd_pedido_compra = #Pedido_Compra_Posicao.cd_pedido_compra and
    #Pedido_Compra_Posicao.qt_item_entregue > 0 and
    #Pedido_Compra_Posicao.qt_item_entregue <> #Pedido_Compra_Posicao.qt_item_pedido


  --Define o pedido como totalmente entregue
  print 'Pedido de Compra - Totalmente recebido'  
  update pedido_compra
  set cd_status_pedido = 9
  from
    pedido_compra, #Pedido_Compra_Posicao
  where
    pedido_compra.cd_pedido_compra = #Pedido_Compra_Posicao.cd_pedido_compra and
    #Pedido_Compra_Posicao.qt_item_entregue > 0 and
    #Pedido_Compra_Posicao.qt_item_entregue = #Pedido_Compra_Posicao.qt_item_pedido

