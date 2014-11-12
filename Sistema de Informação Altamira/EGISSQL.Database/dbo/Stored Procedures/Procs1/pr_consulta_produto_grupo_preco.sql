
--------------------------------------------------------------------------------
CREATE PROCEDURE pr_consulta_produto_grupo_preco
--------------------------------------------------------------------------------
--pr_consulta_produto_grupo_preco
--------------------------------------------------------------------------------
--GBS - Global Business Solution  Ltda                                      2004 
--------------------------------------------------------------------------------
--Stored Procedure      : Microsoft SQL Server 2000 
--Autor(es)             : Daniel C. Neto 
--Banco de Dados        : EGISSQL 
--Objetivo              : Consulta de Produtos por Grupo de Preço
--Data                  : 23.06.2005
--Artualização          : 23.06.2005
--                      : 
--------------------------------------------------------------------------------- 

@dt_inicial          datetime,
@dt_final            datetime

as 

select 
  gpp.cd_grupo_preco_produto as Codigo,
  gpp.cd_mascara_grupo_preco as MascaraCodigoPreco, 
  gpp.nm_grupo_preco_produto as GrupoPreco,
  p.cd_mascara_produto       as CodigoProduto,
  p.nm_fantasia_produto      as Fantasia,
  p.nm_produto               as Produto,
  gp.cd_grupo_produto        as CodigoGrupo,
  gp.nm_grupo_produto        as GrupoProduto
from
  Produto p
  left outer join Produto_Custo       pc  on pc.cd_produto              = p.cd_produto
  left outer join Grupo_Preco_Produto gpp on gpp.cd_grupo_preco_produto = pc.cd_grupo_preco_produto
  left outer join Grupo_Produto       gp  on gp.cd_grupo_produto        = p.cd_grupo_produto

order by
  gpp.cd_mascara_grupo_preco,
  p.cd_mascara_produto




