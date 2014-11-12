
-------------------------------------------------------------------------------
--pr_checagem_produto_sem_aplicacao_markup
-------------------------------------------------------------------------------
--GBS Global Business Solution Ltda                                        2005
-------------------------------------------------------------------------------
--Stored Procedure : Microsoft SQL Server       2000
--Autor(es)        : Carlos Cardoso Fernandes 
--Banco de Dados   : EgisSQL
--Objetivo         : 
--Data             : 13.08.2005
--Atualizado       : 13.08.2005
--------------------------------------------------------------------------------------------------
create procedure pr_checagem_produto_sem_aplicacao_markup
@dt_inicial datetime,
@dt_final   datetime

as

--select * from produto

select
  gp.nm_grupo_produto    as GrupoProduto,
   p.cd_mascara_produto  as Codigo,
   p.nm_fantasia_produto as Fantasia,
   p.nm_produto          as Descricao
from
  Produto p
  left outer join Grupo_Produto gp on gp.cd_grupo_produto = p.cd_grupo_produto
  left outer join Produto_Custo pc on pc.cd_produto = p.cd_produto
where
  isnull(pc.cd_aplicacao_markup,0)=0

order by
  gp.nm_grupo_produto,
  p.cd_mascara_produto
