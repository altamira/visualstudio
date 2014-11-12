
-------------------------------------------------------------------------------
--pr_produto_sem_conta_contabil
-------------------------------------------------------------------------------
--GBS Global Business Solution Ltda                                        2005
-------------------------------------------------------------------------------
--Stored Procedure : Microsoft SQL Server       2000
--Autor(es)        : Carlos Cardoso Fernandes
--Banco de Dados   : EgisSQL
--Objetivo         : Consulta de Produtos sem Conta Contábil
--Data             : 23/08/2005
--Atualizado       : 23/08/2005
--------------------------------------------------------------------------------------------------
create procedure pr_produto_sem_conta_contabil
@dt_inicial datetime,
@dt_final   datetime
as

--select * from produto
--select * from produto_contabilizacao order by cd_produto

select
 gp.nm_grupo_produto    as Grupo,
  p.cd_produto          as CodigoInterno,
  p.cd_mascara_produto  as Codigo,
  p.nm_fantasia_produto as Fantasia,
  p.nm_produto          as Descricao,
  um.sg_unidade_medida  as Unidade
from
  Produto p
  left outer join Grupo_Produto  gp on gp.cd_grupo_produto  = p.cd_grupo_produto
  left outer join Unidade_Medida um on um.cd_unidade_medida = p.cd_unidade_medida
where
  p.cd_produto not in ( select cd_produto from Produto_Contabilizacao )

