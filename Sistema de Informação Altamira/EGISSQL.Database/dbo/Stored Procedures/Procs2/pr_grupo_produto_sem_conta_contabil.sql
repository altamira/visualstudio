
-------------------------------------------------------------------------------
--pr_grupo_produto_sem_conta_contabil
-------------------------------------------------------------------------------
--GBS Global Business Solution Ltda                                        2005
-------------------------------------------------------------------------------
--Stored Procedure : Microsoft SQL Server       2000
--Autor(es)        : Carlos Cardoso Fernandes
--Banco de Dados   : EgisSQL
--Objetivo         : Consulta de Grupo de Produtos sem Conta Contábil
--Data             : 23/08/2005
--Atualizado       : 23/08/2005
--------------------------------------------------------------------------------------------------
create procedure pr_grupo_produto_sem_conta_contabil
@dt_inicial datetime,
@dt_final   datetime
as

--select * from grupo_produto
--select * from produto_contabilizacao order by cd_produto

select
 gp.cd_grupo_produto          as Codigo,
 gp.nm_grupo_produto          as Grupo,
 gp.nm_fantasia_grupo_produto as Fantasia
from
  Grupo_Produto gp
where
  gp.cd_grupo_produto not in ( select cd_grupo_produto from Grupo_Produto_Contabilizacao )

