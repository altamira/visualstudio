
-------------------------------------------------------------------------------
--pr_produto_garantia
-------------------------------------------------------------------------------
--GBS Global Business Solution Ltda                                        2005
-------------------------------------------------------------------------------
--Stored Procedure : Microsoft SQL Server       2000
--Autor(es)        : Carlos Cardoso Fernandes
--Banco de Dados   : EgisSQL
--Objetivo         : Consulta dos produtos em garantia
--                   
--Data             : 01.07.2005
--Atualizado       : 
--------------------------------------------------------------------------------------------------
create procedure pr_produto_garantia
@dt_inicial datetime,
@dt_final  datetime
as

select 
 gp.nm_grupo_produto        as Grupo,
  p.cd_mascara_produto      as CodigoProduto,
  p.nm_fantasia_produto     as fantasiaproduto,
  p.nm_produto              as Produto,
  p.qt_dia_garantia_produto as Dia
from
  Produto p 
  left outer join Grupo_Produto gp on gp.cd_grupo_produto = p.cd_grupo_produto
where
  isnull(ic_garantia_produto,'N')='S'
order by
  gp.cd_grupo_produto,
  p.nm_fantasia_produto  


