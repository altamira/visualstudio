
-------------------------------------------------------------------------------
--pr_consulta_produto_categoria_exportacao
-------------------------------------------------------------------------------
--GBS Global Business Solution Ltda                                        2005
-------------------------------------------------------------------------------
--Stored Procedure : Microsoft SQL Server       2000
--Autor(es)        : Carlos Cardoso Fernandes
--Banco de Dados   : EgisSQL
--Objetivo         : Consulta de Produtos que possuem Categoria de Produto 
--                   e também a categoria de Exportação
--
--
--Data             : 25.06.2005
--Atualizado       : 25.06.2005
--------------------------------------------------------------------------------------------------
create procedure pr_consulta_produto_categoria_exportacao
@dt_inicial datetime,
@dt_final   datetime

as

select
  gp.nm_grupo_produto     as GrupoProduto,
  p.cd_mascara_produto    as MascaraProduto,
  p.nm_fantasia_produto   as Fantasia,
  p.nm_produto            as Produto,
  p.cd_categoria_produto  as CodCategoria,
 cp.cd_mascara_categoria  as MascaraCategoria,
 cp.nm_categoria_produto  as Categoria,
 pe.cd_categoria_produto  as CodCatExportacao,
 cpe.cd_mascara_categoria as MascaraCatExportacao,
 cpe.nm_categoria_produto as CatExportacao

from
  Produto p
  left outer join Grupo_Produto gp      on gp.cd_grupo_produto     = p.cd_grupo_produto
  left outer join Categoria_Produto cp  on cp.cd_categoria_produto = p.cd_categoria_produto
  left outer join Produto_Exportacao pe on pe.cd_produto           = p.cd_produto
  left outer join Categoria_produto cpe on cpe.cd_categoria_produto = pe.cd_categoria_produto

order by
  gp.cd_grupo_produto,
  cp.cd_mascara_categoria,  
   p.cd_mascara_produto  

--select * from categoria_produto
--  select * from produto_exportacao
