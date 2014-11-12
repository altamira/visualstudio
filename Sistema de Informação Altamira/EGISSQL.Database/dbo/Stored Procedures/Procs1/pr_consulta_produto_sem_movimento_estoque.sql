
-------------------------------------------------------------------------------
--sp_helptext pr_consulta_produto_sem_movimento_estoque
-------------------------------------------------------------------------------
--pr_consulta_produto_sem_movimento_estoque
-------------------------------------------------------------------------------
--GBS Global Business Solution Ltda                                        2008
-------------------------------------------------------------------------------
--Stored Procedure : Microsoft SQL Server 2000
--Autor(es)        : Carlos Cardoso Fernandes
--Banco de Dados   : Egissql
--Objetivo         : Consulta de Produtos sem Movimentação de Estoque
--Data             : 22.07.2008
--Alteração        : 
--
--
------------------------------------------------------------------------------
create procedure pr_consulta_produto_sem_movimento_estoque
as

select
  gp.nm_grupo_produto,
  p.cd_produto,
  p.cd_mascara_produto,
  p.nm_fantasia_produto,
  p.nm_produto,
  um.sg_unidade_medida,
  fp.nm_fase_produto,
  count(me.cd_movimento_estoque) as Qtd_Lancamento,
  min(dt_movimento_estoque)      as dt_primeiro_lancamento,
  max(dt_movimento_estoque)      as dt_ultimo_lancamento

  --select * from movimento_estoque
  

from
  produto p  with (nolock) 
  left outer join fase_produto fp on fp.cd_fase_produto     = p.cd_fase_produto_baixa
  left outer join unidade_medida um on um.cd_unidade_medida = p.cd_unidade_medida
  left outer join grupo_produto  gp on gp.cd_grupo_produto  = p.cd_grupo_produto
  left outer join movimento_estoque me on me.cd_produto     = p.cd_produto

group by
  gp.nm_grupo_produto,
  p.cd_produto,
  p.cd_mascara_produto,
  p.nm_fantasia_produto,
  p.nm_produto,
  um.sg_unidade_medida,
  fp.nm_fase_produto
  
order by
  p.nm_fantasia_produto


