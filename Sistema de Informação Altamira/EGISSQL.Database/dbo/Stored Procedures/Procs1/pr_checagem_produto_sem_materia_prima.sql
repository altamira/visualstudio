
-------------------------------------------------------------------------------
--pr_checagem_produto_sem_materia_prima
-------------------------------------------------------------------------------
--GBS Global Business Solution Ltda                                        2005
-------------------------------------------------------------------------------
--Stored Procedure : Microsoft SQL Server       2000
--Autor(es)        : Carlos Cardoso Fernandes / Diego Borba
--Banco de Dados   : EgisSQL
--Objetivo         : 
--Data             : 10.08.2005
--Atualizado       : 31.08.2005
--------------------------------------------------------------------------------------------------
create procedure pr_checagem_produto_sem_materia_prima
@dt_inicial datetime,
@dt_final   datetime

as

--select * from produto
--select * from produto_custo

select
  gp.nm_grupo_produto    as GrupoProduto,
   p.cd_mascara_produto  as Codigo,
   p.nm_fantasia_produto as Fantasia,
   p.nm_produto          as Descricao
from
  Produto p
  left outer join Grupo_Produto gp on gp.cd_grupo_produto = p.cd_grupo_produto
  left outer join Produto_Custo pc on pc.cd_produto       = p.cd_produto
  left outer join Materia_Prima mp on mp.cd_mat_prima     = pc.cd_mat_prima
  left outer join Bitola b         on b.cd_bitola         = pc.cd_bitola
where
  isnull(pc.cd_mat_prima,0)=0 or
  isnull(pc.cd_bitola,0) = 0
order by
  gp.nm_grupo_produto,
  p.cd_mascara_produto
