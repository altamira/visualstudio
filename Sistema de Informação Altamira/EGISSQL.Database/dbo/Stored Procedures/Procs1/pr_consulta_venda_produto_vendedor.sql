
-------------------------------------------------------------------------------
--sp_helptext pr_consulta_venda_produto_vendedor
-------------------------------------------------------------------------------
--pr_documentacao_padrao
-------------------------------------------------------------------------------
--GBS Global Business Solution Ltda                                        2008
-------------------------------------------------------------------------------
--Stored Procedure : Microsoft SQL Server 2000
--Autor(es)        : Carlos Cardoso Fernandes
--Banco de Dados   : Egissql
--Objetivo         : Consulta de Vendas de Produto por Vendedor
--Data             : 21.11.2008
--Alteração        : 05.01.2009 - Ajustes Diversos - Carlos Fernandes
-- 
--13.04.2009 - Complemento dos dados - Carlos Fernandes
--16.04.2009 - Ajustes - Carlos Fernandes
--25.04.2009 - Grupo Região - Carlos Fernandes
------------------------------------------------------------------------------
create procedure pr_consulta_venda_produto_vendedor
@cd_vendedor int      = 0,
@dt_inicial  datetime = '',
@dt_final    datetime = ''

as

--select * from vw_venda_bi

select
  identity(int,1,1)                                                    as cd_controle,
  vw.cd_vendedor                                                       as cd_vendedor,
  max(v.nm_fantasia_vendedor)                                          as nm_fantasia_vendedor,
  max(v.sg_vendedor)                                                   as sg_vendedor,
  vw.cd_produto,
  max(vw.cd_mascara_produto)                                           as Codigo,
  max(vw.nm_fantasia_produto)                                          as Fantasia,
  max(vw.nm_produto)                                                   as Produto,
  max(vw.sg_unidade_medida)                                            as sg_unidade,
  sum( vw.qt_item_pedido_venda )                                       as Quantidade,
  sum( vw.qt_item_pedido_venda * vw.vl_unitario_item_pedido )          as Total,

  sum( Total_Prazo )                                                   as Total_Prazo,

  sum( Total_Vista )                                                   as Total_Vista,

  sum( (vw.qt_item_pedido_venda * vw.vl_unitario_item_pedido) )
  /
  sum( vw.qt_item_pedido_venda )                                       as Preco_Medio,
  max(vw.cd_mascara_categoria)                                         as cd_mascara_categoria,
  max(vw.nm_categoria_produto)                                         as nm_categoria_produto,
  max(vw.nm_marca_produto)                                             as nm_marca_produto,

  max(cd_cliente_regiao)                                               as cd_cliente_regiao,
  max(nm_cliente_regiao)                                               as Regiao,
  sum(Unidade)                                                         as qt_unidade,
  sum(Embalagem)                                                       as qt_embalagem,
  count( distinct vw.cd_pedido_venda )                                 as qt_positivacao,
  count( distinct vw.cd_cliente      )                                 as qt_cobertura,
  max(vw.qt_multiplo_embalagem)                                        as qt_multiplo_embalagem


into
  #Venda_Produto_Vendedor

from
  vw_venda_bi vw                               with (nolock)
  inner join vendedor v                        with (nolock) on v.cd_vendedor             = vw.cd_vendedor
  inner join produto  p                        with (nolock) on p.cd_produto              = vw.cd_produto
  left outer join condicao_pagamento cp        with (nolock) on cp.cd_condicao_pagamento  = vw.cd_condicao_pagamento
  left outer join forma_condicao_pagamento fcp with (nolock) on fcp.cd_forma_condicao     = cp.cd_forma_condicao

--   inner join nota_saida_item nsi               with (nolock) on nsi.cd_pedido_venda       = vw.cd_pedido_venda and
--                                                                 nsi.cd_item_pedido_venda  = vw.cd_item_pedido_venda

where
  vw.cd_vendedor     = case when @cd_vendedor = 0 then vw.cd_vendedor else @cd_vendedor end and
  vw.dt_pedido_venda between @dt_inicial and @dt_final                                      and
  vw.ic_bonificacao_pedido_venda = 'N'                                                      and
  vw.dt_cancelamento_item is null

group by
  vw.cd_vendedor,
  vw.cd_produto

order by
  vw.cd_vendedor


--Mostra a Tabela 

-------------------------------------------------------------------------------
--Mostra a Tabela Geral
-------------------------------------------------------------------------------

select
  v.*,
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
                               end ) * qt_multiplo_embalagem,

  isnull(gr.nm_grupo_regiao,'') as nm_grupo_regiao
          
from
  #Venda_Produto_Vendedor v
  left outer join Cliente_Regiao cr on cr.cd_cliente_regiao = v.cd_cliente_regiao
  left outer join Grupo_Regiao gr   on gr.cd_grupo_regiao   = cr.cd_grupo_regiao
order by
  cd_vendedor,
  cd_produto



  
--select * from condicao_pagamento
--select * from forma_condicao_pagamento

