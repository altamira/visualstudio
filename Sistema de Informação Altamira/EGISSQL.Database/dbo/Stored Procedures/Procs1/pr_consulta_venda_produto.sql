
-------------------------------------------------------------------------------
--sp_helptext pr_consulta_venda_produto
-------------------------------------------------------------------------------
--pr_consulta_venda_produto
-------------------------------------------------------------------------------
--GBS Global Business Solution Ltda                                        2008
-------------------------------------------------------------------------------
--Stored Procedure : Microsoft SQL Server 2000
--Autor(es)        : Carlos Cardoso Fernandes
--Banco de Dados   : Egissql
--Objetivo         : Consulta de Vendas de Produto 
--Data             : 21.11.2008
--Alteração        : 05.01.2009 - Ajustes Diversos - Carlos Fernandes
-- 
-- 01.04.2009 - Ajuste do Valor a Prazao - Carlos Fernandes
-- 07.04.2009 - Preço Médio - Carlos Fernandes
-- 13.04.2009 - Novos Campos - Carlos Fernandes
------------------------------------------------------------------------------
create procedure pr_consulta_venda_produto
@cd_produto  int      = 0,
@dt_inicial  datetime = '',
@dt_final    datetime = ''

as

--select * from vw_venda_bi

select
  vw.cd_produto,
  max(vw.cd_mascara_produto)                                           as Codigo,
  max(vw.nm_fantasia_produto)                                          as Fantasia,
  max(vw.nm_produto)                                                   as Produto,
  max(vw.sg_unidade_medida)                                            as sg_unidade,
  sum( vw.qt_item_pedido_venda )                                       as Quantidade,
  sum( vw.qt_item_pedido_venda * vw.vl_unitario_item_pedido )          as Total,

  sum( Total_Prazo )                                                   as Total_Prazo,

  sum( Total_Vista )                                                   as Total_Vista,

--   sum( (vw.qt_item_pedido_venda * vw.vl_unitario_item_pedido) )
--   /
--   sum( vw.qt_item_pedido_venda )                                       as Preco_Medio,

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
  sum(Unidade)                                                         as qt_unidade,
  sum(Embalagem)                                                       as qt_embalagem,
  count( distinct vw.cd_pedido_venda )                                 as qt_positivacao,
  count( distinct vw.cd_cliente      )                                 as qt_cobertura,
  max(vw.qt_multiplo_embalagem)                                        as qt_multiplo_embalagem

into
  #Venda_Produto

from
  vw_venda_bi vw                               with (nolock)
  inner join produto  p                        with (nolock) on p.cd_produto              = vw.cd_produto

--     inner join nota_saida_item nsi            with (nolock) on nsi.cd_pedido_venda = vw.cd_pedido_venda and
--                                                                nsi.cd_item_pedido_venda = vw.cd_item_pedido_venda

where
  vw.cd_produto     = case when @cd_produto = 0 then vw.cd_produto else @cd_produto end and
  vw.dt_pedido_venda between @dt_inicial and @dt_final and
  vw.dt_cancelamento_item is null                      and
  --O pedido de Venda tem que estar com o crédito liberado
  vw.dt_credito_pedido_venda is not null               and
  vw.ic_bonificacao_pedido_venda = 'N'                                                      
--  and nsi.dt_restricao_item_nota is null
  
group by
  vw.cd_produto

order by
  vw.cd_produto


-------------------------------------------------------------------------------
--Mostra a Tabela Geral
-------------------------------------------------------------------------------

select
  *,
  Embalagem = qt_embalagem +
                             ( case when cast( (qt_Unidade/qt_multiplo_embalagem) as int )>0 then
                                 cast( (qt_Unidade/qt_multiplo_embalagem) as int ) 
                               else
                                 0
                               end ),
  Unidade   = qt_unidade   -
                             ( case when cast( (qt_Unidade/qt_multiplo_embalagem) as int )>0 then
                                 cast( (qt_Unidade/qt_multiplo_embalagem) as int ) 
                               else
                                 0
                               end ) * qt_multiplo_embalagem
          
from
  #Venda_Produto
order by
  cd_produto


-- (*
--       case when @ic_tipo_mapa = 'G' or @ic_tipo_mapa = 'E' 
--       then
--          cast( dbo.fn_strzero(qt_Embalagem +
-- 
--                              ( case when cast( (qt_Unidade/qt_multiplo_embalagem) as int )>0 then
--                                  cast( (qt_Unidade/qt_multiplo_embalagem) as int ) 
--                                else
--                                  0
--                                end )
-- 
--       ,6) as varchar) 
--       else
--          ''
--       end
-- 
--       +
-- 
--       case when @ic_tipo_mapa = 'G' then ' + ' else '  ' end
-- 
--       + 
-- 
--       case when @ic_tipo_mapa = 'G' or @ic_tipo_mapa = 'U' 
--       then
--          cast( dbo.fn_strzero(qt_Unidade
--          -
--                              ( case when cast( (qt_Unidade/qt_multiplo_embalagem) as int )>0 then
--                                  cast( (qt_Unidade/qt_multiplo_embalagem) as int ) 
--                                else
--                                  0
--                                end ) * qt_multiplo_embalagem
--                ,3) as varchar) 
--       else
--          ''
--       end                                                             as nm_embalagem_unidade
-- 
-- *)
  
--select * from condicao_pagamento
--select * from forma_condicao_pagamento

