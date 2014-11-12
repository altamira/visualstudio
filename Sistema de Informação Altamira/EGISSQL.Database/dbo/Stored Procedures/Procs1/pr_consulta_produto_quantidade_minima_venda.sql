
-------------------------------------------------------------------------------
--pr_consulta_produto_quantidade_minima_venda
-------------------------------------------------------------------------------
--GBS Global Business Solution Ltda                                        2006
-------------------------------------------------------------------------------
--Stored Procedure : Microsoft SQL Server 2000
--Autor(es)        : Carlos Cardoso Fernandes
--Banco de Dados   : Egissql
--Objetivo         : Consulta de Produtos com a Quantidade Mínima de Venda
--
--Data             : 30.08.2006
--Alteração        : 
------------------------------------------------------------------------------
create procedure pr_consulta_produto_quantidade_minima_venda
@dt_inicial datetime,
@dt_final   datetime
as

select
  p.cd_mascara_produto      as Codigo,
  p.nm_fantasia_produto     as Fantasia,
  p.nm_produto              as Descricao,
  um.sg_unidade_medida      as Unidade,
  gp.nm_grupo_produto       as Grupo,
  p.qt_minimo_venda_produto as Quantidade
from
  Produto p
  left outer join unidade_medida um on um.cd_unidade_medida = p.cd_unidade_medida
  left outer join grupo_produto  gp on gp.cd_grupo_produto  = p.cd_grupo_produto
where
  isnull(p.qt_minimo_venda_produto,0)>0
order by
  p.nm_fantasia_produto

