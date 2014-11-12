
-------------------------------------------------------------------------------
--pr_checagem_produto_sem_unidade_medida
-------------------------------------------------------------------------------
--GBS Global Business Solution Ltda                                        2005
-------------------------------------------------------------------------------
--Stored Procedure : Microsoft SQL Server       2000
--Autor(es)        : Carlos Cardoso Fernandes / Diego Borba
--Banco de Dados   : EgisSQL
--Objetivo         : 
--Data             : 10.08.2005
--Atualizado       : 10.08.2005
--------------------------------------------------------------------------------------------------
create procedure pr_checagem_produto_sem_unidade_medida
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
where
  isnull(p.cd_unidade_medida,0)=0

order by
  gp.nm_grupo_produto,
  p.cd_mascara_produto
