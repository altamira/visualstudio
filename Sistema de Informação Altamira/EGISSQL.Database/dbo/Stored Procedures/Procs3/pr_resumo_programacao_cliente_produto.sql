
-------------------------------------------------------------------------------
--sp_helptext pr_resumo_programacao_cliente_produto
-------------------------------------------------------------------------------
--pr_resumo_programacao_cliente_produto
-------------------------------------------------------------------------------
--GBS Global Business Solution Ltda                                        2009
-------------------------------------------------------------------------------
--Stored Procedure : Microsoft SQL Server 2000
--Autor(es)        : Carlos Cardoso Fernandes
--                   Robert Gaffo
--Banco de Dados   : Egissql
--Objetivo         : Consulta de Programação Cliente/Produto por Período
--Data             : 28.02.2009
--Alteração        : 
--
--
------------------------------------------------------------------------------
create procedure pr_resumo_programacao_cliente_produto
@dt_inicial datetime = '',
@dt_final   datetime = ''

as

--select * from programacao_entrega
--select * from programacao_entrega_composicao

select
  pe.cd_cliente,
  pe.cd_produto,
  max(c.nm_fantasia_cliente)     as nm_fantasia_cliente,
  max(p.cd_mascara_produto)      as cd_mascara_produto,
  max(p.nm_fantasia_produto)     as nm_fantasia_produto,
  max(p.nm_produto)              as nm_produto,
  sum(pe.qt_programacao_entrega) as qt_programacao_entrega,
  count(cd_programacao_entrega)  as qt_programacao
from
  programacao_entrega     pe with (nolock)
  left outer join cliente c                on c.cd_cliente = pe.cd_cliente
  left outer join produto p                on p.cd_produto = pe.cd_produto
where
  pe.dt_programacao_entrega between @dt_inicial and @dt_final
group by
  pe.cd_cliente,
  pe.cd_produto

