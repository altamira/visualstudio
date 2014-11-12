
-------------------------------------------------------------------------------
--pr_consulta_grupo_produto_sem_fechamento_mensal
-------------------------------------------------------------------------------
--GBS Global Business Solution Ltda                                        2005
-------------------------------------------------------------------------------
--Stored Procedure : Microsoft SQL Server       2000
--Autor(es)        : Carlos Cardoso Fernandes
--Banco de Dados   : EgisSQL
--Objetivo         : 
--Data             : 20/01/2005
--Atualizado       : 28/01/2005
--------------------------------------------------------------------------------------------------
create procedure pr_consulta_grupo_produto_sem_fechamento_mensal
@dt_inicial datetime,
@dt_final   datetime
as

--select * from grupo_produto_custo
--select * from produto_custo

select
  gp.cd_grupo_produto           as CodGrupo,
  gp.nm_grupo_produto           as Grupo,
  gpc.ic_fechamento_mensal      as FecGrupo,
  p.cd_mascara_produto          as Mascara,
  p.nm_fantasia_produto         as Fantasia,
  p.nm_produto                  as Produto,
  pc.ic_fechamento_mensal_prod  as FecProd
from
  Produto p
  left outer join Grupo_Produto gp        on gp.cd_grupo_produto  = p.cd_grupo_produto
  left outer join Grupo_Produto_Custo gpc on gpc.cd_grupo_produto = p.cd_grupo_produto
  left outer join Produto_Custo pc        on pc.cd_produto        = p.cd_produto 
where
  ( isnull(gpc.ic_fechamento_mensal,'N') = 'N' or isnull(pc.ic_fechamento_mensal_prod,'N')='N' )
order by
  gp.cd_grupo_produto,
  p.nm_fantasia_produto

