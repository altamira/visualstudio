
-------------------------------------------------------------------------------
--sp_helptext pr_troca_fornecedor_pedido_compra
-------------------------------------------------------------------------------
--pr_troca_fornecedor_pedido_compra
-------------------------------------------------------------------------------
--GBS Global Business Solution Ltda                                        2009
-------------------------------------------------------------------------------
--Stored Procedure : Microsoft SQL Server 2000
--Autor(es)        : Carlos Cardoso Fernandes
--Banco de Dados   : Egissql
--Objetivo         : Trocar o Fornecedor do Pedido de Compra
--Data             : 18.09.2009
--Alteração        : 19.11.2009 - Ajustes Diversos - Carlos Fernandes
--
--
------------------------------------------------------------------------------
create procedure pr_troca_fornecedor_pedido_compra
@cd_pedido_compra int = 0,
@cd_fornecedor    int = 0
as

--select * from pedido_compra

if @cd_pedido_compra>0 and @cd_fornecedor>0
begin

update 
  pedido_compra
set
  cd_fornecedor    = @cd_fornecedor
where
  cd_pedido_compra = @cd_pedido_compra

end



