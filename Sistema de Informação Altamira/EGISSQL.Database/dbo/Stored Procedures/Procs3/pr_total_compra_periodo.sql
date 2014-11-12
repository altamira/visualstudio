
--sp_helptext pr_total_compra_periodo

-------------------------------------------------------------------------------
--pr_total_compra_periodo
-------------------------------------------------------------------------------
--GBS Global Business Solution Ltda                                        2004
-------------------------------------------------------------------------------
--Stored Procedure : Microsoft SQL Server 2000
--Autor(es)        : Carlos Cardoso Fernandes
--Banco de Dados   : Egissql
--Objetivo         : Consulta do Total de Compras
--Data             : 02.12.2006
--Alteração        : 
------------------------------------------------------------------------------
create procedure pr_total_compra_periodo
@dt_inicial datetime = '',
@dt_final   datetime = ''

as

--select * from pedido_compra

select
  sum( isnull(vl_total_pedido_compra,0) ) as TotalCompra
from
  Pedido_Compra
where
  dt_pedido_compra between @dt_inicial and @dt_final




