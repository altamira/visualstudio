
-------------------------------------------------------------------------------
--pr_ajuste_status_pedido_compra
-------------------------------------------------------------------------------
--GBS Global Business Solution Ltda                                        2004
-------------------------------------------------------------------------------
--Stored Procedure : Microsoft SQL Server 2000
--Autor(es)        : Carlos Cardoso Fernandes
--Banco de Dados   : Egissql
--Objetivo         : Ajuste do status do pedido de Compra
--
--Data             : 24/04/2006
--Alteração        : 
--
------------------------------------------------------------------------------
create procedure pr_ajuste_status_pedido_compra
@cd_pedido_compra int = 0

as

--Atualiza os Saldos negativos

update
  pedido_compra_item
set
 qt_saldo_item_ped_compra=0
where
 qt_saldo_item_ped_compra<0 

--select * from status_pedido

select
  cd_pedido_compra
into
  #Pedido
from
  Pedido_Compra
where
  cd_pedido_compra = case when @cd_pedido_compra = 0 then cd_pedido_compra else @cd_pedido_compra end and
  cd_status_pedido=10 
  


declare @cd_pedido      int
declare @qt_item_pedido int
declare @qt_item_saldo  int

while exists ( select top 1 cd_pedido_compra from #pedido )
begin

  select 
    top 1
    @cd_pedido = cd_pedido_compra
  from
    #pedido

  --Total de itens do pedido

  select
    @qt_item_pedido = count(*)
  from
    pedido_compra_item
  where
    cd_pedido_compra = @cd_pedido

  --Verifica se existem item com saldo

  select
    @qt_item_saldo = count(*)
  from
    pedido_compra_item
  where
    cd_pedido_compra = @cd_pedido and
    isnull(qt_saldo_item_ped_compra,0)=0


  if @qt_item_pedido = @qt_item_saldo
  begin
    update
      pedido_compra
    set
      cd_status_pedido = 9
    where
      cd_pedido_compra = @cd_pedido
  end
  
  delete from #pedido where cd_pedido_compra = @cd_pedido

end

--select * from pedido_compra_item


