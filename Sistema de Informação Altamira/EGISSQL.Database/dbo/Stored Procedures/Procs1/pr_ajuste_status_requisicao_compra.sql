
-------------------------------------------------------------------------------
--pr_ajuste_status_requisicao_compra
-------------------------------------------------------------------------------
--GBS Global Business Solution Ltda                                        2004
-------------------------------------------------------------------------------
--Stored Procedure : Microsoft SQL Server 2000
--Autor(es)        : Carlos Cardoso Fernandes
--Banco de Dados   : Egissql
--Objetivo         : Ajuste do status da requisição de Compra, conforme geração
--                   pedido de compra
--
--Data             : 24/04/2006
--Alteração        : 
--
------------------------------------------------------------------------------
create procedure pr_ajuste_status_requisicao_compra
@cd_requisicao_compra int = 0

as

select
  cd_requisicao_compra
into
  #Requisicao
from
  Requisicao_Compra
where
  cd_requisicao_compra = case when @cd_requisicao_compra = 0 then cd_requisicao_compra else @cd_requisicao_compra end and
  cd_status_requisicao<>3 


declare @cd_requisicao        int
declare @qt_item_requisicao   int
declare @qt_item_pedido       int

while exists( select top 1 cd_requisicao_compra from #requisicao )
begin

  select
    top 1
    @cd_requisicao = cd_requisicao_compra
  from
    #requisicao

  --total de itens da requisicao

  select
    @qt_item_requisicao = count(*)
  from
    requisicao_compra_item 
  where
    cd_requisicao_compra = @cd_requisicao

  --total de itens da requisicao que viraram pedido de compra

  select
    @qt_item_pedido = count(*)
  from
    requisicao_compra_item 
  where
    cd_requisicao_compra = @cd_requisicao and
    isnull(cd_pedido_compra,0)>0          and
    isnull(cd_item_pedido_compra,0)>0           

 if @qt_item_pedido=@qt_item_requisicao
 begin
   update
     requisicao_compra
   set
     cd_status_requisicao = 3
   where
     cd_requisicao_compra = @cd_requisicao
 end

 delete from #Requisicao   
   where
     cd_requisicao_compra = @cd_requisicao

end
  

