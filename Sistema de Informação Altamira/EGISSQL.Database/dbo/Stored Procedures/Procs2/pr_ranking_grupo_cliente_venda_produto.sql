
-------------------------------------------------------------------------------
--sp_helptext pr_ranking_grupo_cliente_venda_produto
-------------------------------------------------------------------------------
--pr_ranking_grupo_cliente_venda_produto
-------------------------------------------------------------------------------
--GBS Global Business Solution Ltda                                        2009
-------------------------------------------------------------------------------
--Stored Procedure : Microsoft SQL Server 2000
--Autor(es)        : Carlos Cardoso Fernandes
--Banco de Dados   : Egissql
--Objetivo         : Consulta de Vendas por Ranking de Grupo de Cliente
--                   por produto/Faturamento
--Data             : 03.12.2009
--Alteração        : 
--
--
------------------------------------------------------------------------------
create procedure pr_ranking_grupo_cliente_venda_produto
@dt_inicial       datetime = '',
@dt_final         datetime = '',
@cd_cliente_grupo int      = 0

as


--select * from vw_faturamento

select
  vw.cd_cliente_grupo,
  max(vw.nm_cliente_grupo)       as Cliente_Grupo,
  vw.cd_produto,
  max(p.cd_mascara_produto)      as codigo,
  max(p.nm_fantasia_produto)     as fantasia,
  max(vw.nm_produto_item_nota)   as Produto,
  sum(vw.qt_item_nota_saida)               as Quantidade,
  sum(round(vw.vl_unitario_item_total,2)) as Total
from
   vw_faturamento vw
   left outer join produto p on p.cd_produto = vw.cd_produto
 
where
   vw.dt_nota_saida between @dt_inicial and @dt_final and
   vw.cd_cliente_grupo = case when @cd_cliente_grupo = 0 then vw.cd_cliente_grupo else @cd_cliente_grupo end

group by
  vw.cd_cliente_grupo,
  vw.cd_produto

