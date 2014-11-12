Create procedure pr_atualiza_saldo_pedido_compra
-------------------------------------------------------------------------------
--GBS-Global Business Solution Ltda            2004
-------------------------------------------------------------------------------
--Stored Procedure: Microsoft SQL Server       2000
--Autor(es)       : Diego
--Banco de Dados  : EgisSql
--Objetivo        : Realiza os ajustes de saldo do pedido de compra
--Data            : 18.05.2004
-- 20/06/2004 - Colocado pra funcionar - Daniel C. Neto.
--------------------------------------------------------------------------------
@cd_pedido_compra int
as

declare @cd_item_pedido_compra int
declare @qt_item_nota_entrada float

select 
  cd_item_pedido_compra,
  sum(qt_item_nota_entrada) as qt_item_nota_entrada
into
  #Nota_Entrada_Item
from
  Nota_Entrada_item 
where
  cd_pedido_compra = @cd_pedido_compra
group by
  cd_item_pedido_compra

while exists ( select 'x' from #Nota_Entrada_Item)
begin

  set @cd_item_pedido_compra = 
    ( select top 1 cd_item_pedido_compra from #Nota_Entrada_Item)

  set @qt_item_nota_entrada = 
    ( select top 1 qt_item_nota_entrada from #Nota_Entrada_Item)

  update Pedido_Compra_item
  set qt_saldo_item_ped_compra = qt_item_pedido_compra - @qt_item_nota_entrada
  where 
    cd_pedido_compra = @cd_pedido_compra and
    cd_item_pedido_compra = @cd_item_pedido_compra 

  delete from #Nota_Entrada_Item where cd_item_pedido_compra = @cd_item_pedido_compra

end

