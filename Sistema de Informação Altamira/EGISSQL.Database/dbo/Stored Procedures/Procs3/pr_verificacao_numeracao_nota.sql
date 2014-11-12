
-------------------------------------------------------------------------------
--pr_verificacao_numeracao_nota
-------------------------------------------------------------------------------
--GBS Global Business Solution Ltda                                        2005
-------------------------------------------------------------------------------
--Stored Procedure : Microsoft SQL Server       2000
--Autor(es)        : Carlos Cardoso Fernandes
--Banco de Dados   : EgisSQL
--Objetivo         : Verificação de Numeração de Notas de Saída Emitida
--Data             : 07.12.2005
--Atualizado       : 07.12.2005
--------------------------------------------------------------------------------------------------
create procedure pr_verificacao_numeracao_nota
@dt_inicial datetime,
@dt_final   datetime

as

--select vl_total_pedido_venda,* from pedido_venda

select
  sum( vl_total_pedido_venda) as Total
from
  Pedido_Venda
where
  dt_pedido_venda between @dt_inicial and @dt_final


