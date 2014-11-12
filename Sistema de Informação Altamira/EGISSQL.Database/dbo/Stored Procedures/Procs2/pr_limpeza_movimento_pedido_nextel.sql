
-------------------------------------------------------------------------------
--sp_helptext pr_limpeza_movimento_pedido_nextel
-------------------------------------------------------------------------------
--pr_limpeza_movimento_pedido_nextel
-------------------------------------------------------------------------------
--GBS Global Business Solution Ltda                                        2009
-------------------------------------------------------------------------------
--Stored Procedure : Microsoft SQL Server 2000
--Autor(es)        : Carlos Cardoso Fernandes
--Banco de Dados   : Egissql
--
--Objetivo         : Limpeza da Entrada de Pedido de Venda por período
--
--Data             : 02.04.2009
--Alteração        : 
--
--
------------------------------------------------------------------------------
create procedure pr_limpeza_movimento_pedido_nextel
@dt_inicial datetime = '',
@dt_final   datetime = ''

as

select
  cd_pedido_venda
into
  #Pedido
from
  Pedido_Venda with (nolock) 
where
  dt_pedido_venda between @dt_inicial and @dt_final

select * from #Pedido

--deleta is itens do Pedido de Venda

delete from pedido_venda_item 
where
  cd_pedido_venda in ( select cd_pedido_venda from #Pedido )

delete from pedido_venda 
where
  cd_pedido_venda in ( select cd_pedido_venda from #Pedido )



