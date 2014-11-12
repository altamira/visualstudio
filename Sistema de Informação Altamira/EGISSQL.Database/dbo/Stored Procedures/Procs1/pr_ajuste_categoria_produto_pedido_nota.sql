
-------------------------------------------------------------------------------
--sp_helptext pr_ajuste_categoria_produto_pedido_nota
-------------------------------------------------------------------------------
--pr_ajuste_categoria_produto_pedido_nota
-------------------------------------------------------------------------------
--GBS Global Business Solution Ltda                                        2008
-------------------------------------------------------------------------------
--Stored Procedure : Microsoft SQL Server 2000
--Autor(es)        : Carlos Cardoso Fernandes
--Banco de Dados   : Egissql
--Objetivo         : Ajuste de Categoria de Produto dos Pedidos de Vendas/
--                   Notas de Saída
--Data             : 10.01.2008
--Alteração        : 
------------------------------------------------------------------------------
create procedure pr_ajuste_categoria_produto_pedido_nota
@dt_inicial datetime = '',
@dt_final   datetime = ''

as

update
  nota_saida_item
set
  cd_categoria_produto = p.cd_categoria_produto
from
  nota_saida_item nsi
  inner join nota_saida ns on ns.cd_nota_saida = nsi.cd_nota_saida
  inner join produto p    on p.cd_produto = nsi.cd_produto
where
  ns.dt_nota_saida between @dt_inicial and @dt_final

update
  pedido_venda_item
set
  cd_categoria_produto = p.cd_categoria_produto
from
  pedido_venda_item pvi
  inner join pedido_venda pv on pv.cd_pedido_venda = pvi.cd_pedido_venda
  inner join produto      p  on p.cd_produto       = pvi.cd_produto
where
  pv.dt_pedido_venda between @dt_inicial and @dt_final

update
  consulta_itens
set
  cd_categoria_produto = p.cd_categoria_produto
from
  consulta_itens ci  
  inner join consulta c on c.cd_consulta = ci.cd_consulta
  inner join produto  p on p.cd_produto  = ci.cd_produto
where
  c.dt_consulta between @dt_inicial and @dt_final




