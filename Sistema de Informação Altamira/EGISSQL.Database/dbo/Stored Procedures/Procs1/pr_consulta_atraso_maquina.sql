
CREATE PROCEDURE pr_consulta_atraso_maquina

------------------------------------------------------------------------------------------------------
--pr_consulta_atraso_maquina
------------------------------------------------------------------------------------------------------
--GBS - Global Business Solution	       2002
--Stored Procedure: Microsoft SQL Server       2000
--Autor(es)     : Daniel Carrasco Neto
--Banco de Dados: EgisSQL
--Objetivo      : Consultar Operações em Atraso por Máquina.
--Data          : 03/05/2004
-- 14/06/2004 - Incluído Data de Programaçãoe Nome do Cliente
-- 02.09.2007 - Incluído dados do Produto - Carlos Fernandes     
-- 21.11.2007 - mostrar somente as operações que possuem processo - Carlos Fernandes      
-- 15.03.2010 - Não Mostrar Op's Canceladas e Encerradas - Carlos Fernandes
------------------------------------------------------------------------------------------------------

@cd_maquina       int

AS

SELECT     
  case when p.dt_programacao<getdate() then 'Sim' else 'Não' end as ic_Atraso,
  p.dt_programacao,
  m.cd_maquina,
  m.nm_fantasia_maquina,
  m.nm_maquina,
  o.nm_fantasia_operacao, 
  pp.cd_identifica_processo, 
  pp.cd_pedido_venda, 
  pp.cd_item_pedido_venda, 
  ppc.dt_ini_prod_operacao,
  cast(GetDate() as integer) - cast(ppc.dt_ini_prod_operacao as integer) as 'Atraso',
  ppc.cd_processo, 
  ppc.qt_hora_prog_operacao, 
  ppc.nm_obs_operacao, 
  ppc.cd_ordem_fab,
  pvi.nm_produto_pedido as Descricao,
  ppc.ic_cnc_operacao,
  c.nm_fantasia_cliente,
  prod.cd_mascara_produto,
  prod.nm_fantasia_produto,
  isnull(prod.nm_produto,pvi.nm_produto_pedido) as nm_produto,
  um.sg_unidade_medida,
  pj.cd_interno_projeto,
  pjc.nm_projeto_composicao,
  pjm.nm_esp_projeto_material,
  fp.nm_fase_produto,
  sp.nm_status_processo

FROM 
  Programacao p                               with (nolock)
  inner join       Programacao_Composicao ppc with (nolock) on p.cd_programacao = ppc.cd_programacao 
  inner join       Processo_Producao pp       with (nolock) ON ppc.cd_processo = pp.cd_processo

  left outer join  Maquina m                  with (nolock) on p.cd_maquina = m.cd_maquina 
  left outer join  Operacao o                 with (nolock) ON o.cd_operacao = ppc.cd_operacao
  left outer join  Pedido_Venda pv            with (nolock) ON pp.cd_pedido_venda = pv.cd_pedido_venda 
  left outer join  Pedido_venda_item pvi      with (nolock) on pvi.cd_pedido_venda = pp.cd_pedido_venda and
                                                               pvi.cd_item_pedido_venda = pp.cd_item_pedido_venda
  left outer join  Cliente c                  with (nolock) on c.cd_cliente = pv.cd_cliente
  left outer join  Produto prod               with (nolock) on prod.cd_produto = pp.cd_produto
  left outer join  Unidade_Medida um          with (nolock) on um.cd_unidade_medida = prod.cd_produto
  left outer join Projeto         pj              with (nolock) on pj.cd_projeto            = pp.cd_projeto
  left outer join Projeto_Composicao pjc          with (nolock) on pjc.cd_projeto           = pp.cd_projeto and
                                                                   pjc.cd_item_projeto      = pp.cd_item_projeto    
  left outer join Projeto_Composicao_Material pjm with (nolock) on pjm.cd_projeto           = pp.cd_projeto and
                                                                   pjm.cd_item_projeto      = pp.cd_item_projeto and
                                                                   pjm.cd_projeto_material  = pp.cd_projeto_material
   left outer join Fase_Produto fp          with (nolock)       on fp.cd_fase_produto       = pp.cd_fase_produto
   left outer join Status_Processo sp       with (nolock)       on sp.cd_status_processo    = pp.cd_status_processo 

WHERE
  IsNull(m.cd_maquina,0) = ( case when @cd_maquina = 0 then
                              IsNull(m.cd_maquina,0) else
                              @cd_maquina end ) and
  (ppc.dt_fim_prod_operacao is null) and
  pp.dt_canc_processo is null        and
  pp.cd_status_processo <> 5         and --Encerradas
  IsNull(o.nm_fantasia_operacao,'') <> ''


