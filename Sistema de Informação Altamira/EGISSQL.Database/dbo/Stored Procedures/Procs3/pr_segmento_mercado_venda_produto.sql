
-------------------------------------------------------------------------------
--sp_helptext pr_segmento_mercado_venda_produto
-------------------------------------------------------------------------------
--pr_segmento_mercado_venda_produto
-------------------------------------------------------------------------------
--GBS Global Business Solution Ltda                                        2008
-------------------------------------------------------------------------------
--Stored Procedure : Microsoft SQL Server 2000
--Autor(es)        : Carlos Cardoso Fernandes
--Banco de Dados   : Egissql
--Objetivo         : Consulta de Vendas de Segmento de Mercado por Produto
--Data             : 21.11.2008
--Alteração        : 
--
-- 16.04.2009 - Ajuste da Marca/Categoria - Carlos Fernandes
------------------------------------------------------------------------------
create procedure pr_segmento_mercado_venda_produto
@cd_ramo_atividade int      = 0,
@cd_produto        int      = 0,
@dt_inicial        datetime = '',
@dt_final          datetime = ''

as

--select * from vw_venda_bi

select
  vw.cd_produto,
  vw.cd_ramo_atividade,
  vw.nm_ramo_atividade,
  max(vw.nm_produto)                                          as Descricao,
  max(vw.cd_mascara_produto)                                  as Codigo,
  max(vw.nm_fantasia_produto)                                 as Fantasia,
  max(vw.sg_unidade_medida)                                   as sg_unidade,
--  max(vw.nm_ramo_atividade)                                   as RamoAtividade,
  sum( vw.qt_item_pedido_venda )                              as Quantidade,
  sum( vw.qt_item_pedido_venda * vw.vl_unitario_item_pedido ) as Valor_Total,

  sum(
     (case when Unidade>0 then Unidade    else 1 end
     *
     case when Embalagem>0 then Embalagem else 1 end
     *
     vw.vl_unitario_item_pedido) )
     /
  sum(   
     (case when Unidade>0 then Unidade    else Embalagem end ))          as Preco_Medio,
     
  
     

  max(vw.cd_mascara_categoria)                                         as cd_mascara_categoria,
  max(vw.nm_categoria_produto)                                         as nm_categoria_produto,
  max(vw.nm_marca_produto)                                             as nm_marca_produto,
  sum(Unidade)                                                         as Unidade,
  sum(Embalagem)                                                       as Embalagem,
  count( distinct vw.cd_pedido_venda )                                 as qt_positivacao,
  count( distinct vw.cd_cliente      )                                 as qt_cobertura


  
from
  vw_venda_bi vw
where
  vw.dt_pedido_venda between @dt_inicial and @dt_final and
  vw.cd_produto        = case when @cd_produto = 0        then vw.cd_produto        else @cd_produto        end and
  vw.cd_ramo_atividade = case when @cd_ramo_atividade = 0 then vw.cd_ramo_atividade else @cd_ramo_atividade end 
group by
  vw.cd_produto,
  vw.cd_ramo_atividade,
  vw.nm_ramo_atividade
order by
  vw.nm_ramo_atividade

