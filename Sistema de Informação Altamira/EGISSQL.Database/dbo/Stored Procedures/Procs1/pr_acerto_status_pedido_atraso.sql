
-------------------------------------------------------------------------------
--pr_acerto_status_pedido_atraso
-------------------------------------------------------------------------------
--GBS Global Business Solution Ltda                                        2004
-------------------------------------------------------------------------------
--Stored Procedure : Microsoft SQL Server 2000
--Autor(es)        : Carlos Cardoso Fernandes
--Banco de Dados   : Egissql
--Objetivo         : Acerto do Status do Pedido de Compra
--Data             : 29.08.2006
--Alteração        : 
------------------------------------------------------------------------------
create procedure pr_acerto_status_pedido_atraso
as

--select * from status_pedido

update
  status_pedido
set
  ic_atraso_status_pedido = 'S'
where
  ic_atraso_status_pedido is null


