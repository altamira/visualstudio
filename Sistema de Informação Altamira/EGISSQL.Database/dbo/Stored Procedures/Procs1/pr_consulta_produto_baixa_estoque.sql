
-------------------------------------------------------------------------------
--pr_consulta_produto_baixa_estoque
-------------------------------------------------------------------------------
--GBS Global Business Solution Ltda                                        2005
-------------------------------------------------------------------------------
--Stored Procedure : Microsoft SQL Server       2000
--Autor(es)        : Carlos Cardoso Fernandes
--Banco de Dados   : EgisSQL
--Objetivo         : Retorno do Reajuste Definitivo, caso tenha sido processado indevidamente 
--                   pelo usuário
--Data             : 21/02/2005
--Atualizado       : 23.06.2005 - Acerto do código do Reajuste de preço
--------------------------------------------------------------------------------------------------
create procedure pr_consulta_produto_baixa_estoque
@dt_inicial datetime,
@dt_final   datetime
as

select
  p.cd_mascara_produto as MascaraProduto,
  p.nm_fantasia_produto   as FantasiaProduto,
  p.nm_produto            as DescricaoProduto,
  um.sg_unidade_medida    as Unidade,
  pb.cd_mascara_produto   as MascaraEstoque,
  pb.nm_fantasia_produto  as FantasiaEstoque,
  pb.nm_produto           as DescricaoEstoque
from
  Produto p
  left outer join Produto pb        on pb.cd_produto = p.cd_produto_baixa_estoque
  left outer join Unidade_Medida um on um.cd_unidade_medida = p.cd_unidade_medida
where
  isnull(p.cd_produto_baixa_estoque,0)>0

