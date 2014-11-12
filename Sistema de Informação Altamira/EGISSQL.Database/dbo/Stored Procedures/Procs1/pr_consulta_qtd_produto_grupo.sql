
-------------------------------------------------------------------------------
--pr_consulta_qtd_produto_grupo
-------------------------------------------------------------------------------
--GBS Global Business Solution Ltda                                        2004
-------------------------------------------------------------------------------
--Stored Procedure : Microsoft SQL Server 2000
--Autor(es)        : Carlos Cardoso Fernandes
--Banco de Dados   : Egissql
--Objetivo         : 
--Data             : 15.03.2006
--Alteração        : 
------------------------------------------------------------------------------
create procedure pr_consulta_qtd_produto_grupo
@dt_inicial datetime,
@dt_final datetime
as

  select
    gp.nm_grupo_produto   as 'Grupo',
    count( p.cd_produto ) as 'QtdProduto'
  from
    grupo_produto gp
    left outer join Produto p on p.cd_grupo_produto = gp.cd_grupo_produto
  where
    gp.nm_grupo_produto is not null
  group by 
     gp.nm_grupo_produto
  order by
    gp.nm_grupo_produto 
  

