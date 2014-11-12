
-------------------------------------------------------------------------------
--sp_helptext pr_mapa_producao_aberto_analitico
-------------------------------------------------------------------------------
--pr_mapa_producao_aberto_analitico
-------------------------------------------------------------------------------
--GBS Global Business Solution Ltda                                        2008
-------------------------------------------------------------------------------
--Stored Procedure : Microsoft SQL Server 2000
--Autor(es)        : Carlos Cardoso Fernandes
--Banco de Dados   : Egissql
--Objetivo         : Mapa de Produção em Aberto / Analítico antes da Programação
--
--Data             : 28.10.2008
--Alteração        : 
--
--31.01.2009 - Carlos Fernandes 
------------------------------------------------------------------------------
create procedure pr_mapa_producao_aberto_analitico

@dt_inicial datetime = '',
@dt_final   datetime = '',
@cd_maquina int      = 0

as

declare @qt_fator int

set @qt_fator = 60

SELECT     
  identity(int,1,1)                                                    as cd_controle,
  case when pp.dt_entrega_processo<getdate() then 'Sim' else 'Não' end as ic_Atraso,
  pp.dt_entrega_processo,
  gm.nm_grupo_maquina,
  m.cd_maquina,
  m.nm_fantasia_maquina,
  m.nm_maquina,
  ppc.nm_maqcompl_processo,
  o.nm_fantasia_operacao, 
  ppc.nm_opecompl_Processo,
  pp.cd_identifica_processo, 
  pp.cd_pedido_venda, 
  pp.cd_item_pedido_venda, 
  --ppc.dt_ini_prod_operacao,
  cast(GetDate() as integer) - cast(pp.dt_entrega_processo as integer) as 'Atraso',
  ppc.cd_processo, 
  ppc.cd_item_processo,
  ppc.cd_seq_processo,
  pp.dt_processo,
  pp.qt_planejada_processo,
--  ppc.qt_hora_prog_operacao, 
--  ppc.nm_obs_operacao, 
  --ppc.cd_ordem_fab,
  isnull(prod.nm_produto,pvi.nm_produto_pedido) as Descricao,
  --ppc.ic_cnc_operacao,
  c.nm_fantasia_cliente,
  prod.cd_mascara_produto,
  prod.nm_fantasia_produto,
  isnull(prod.nm_produto,pvi.nm_produto_pedido) as nm_produto,
  um.sg_unidade_medida,
  pj.cd_interno_projeto,
  pjc.nm_projeto_composicao,
  pjm.nm_esp_projeto_material,
  fp.nm_fase_produto,
  sp.nm_status_processo,
  isnull(ppc.qt_hora_estimado_processo,0)/@qt_fator as qt_hora_estimado_processo,
  isnull(ppc.qt_hora_real_processo,0)    /@qt_fator as qt_hora_real_processo,
  isnull(ppc.qt_hora_setup_processo,0)   /@qt_fator as qt_hora_setup_processo,

  (isnull(ppc.qt_hora_estimado_processo,0)+
  isnull(ppc.qt_hora_setup_processo,0))/@qt_fator   as qt_hora_total_processo,

  ppc.dt_prog_mapa_processo,
  se.nm_servico_especial,
  isnull(ic_operacao_mapa_processo,'N')         as ic_operacao_mapa_processo,
  isnull(nm_obs_item_processo,'')               as nm_obs_item_processo,
  ppc.cd_ordem,
  cast('' as varchar(15))                       as nm_tempo_inicial,
  cast('' as varchar(15))                       as nm_tempo_final


--select * from processo_producao_composicao

into
  #Consulta_Mapa_Periodo

FROM 

  Processo_Producao pp                              with (nolock)
  inner join       Processo_Producao_Composicao ppc with (nolock) on pp.cd_processo           = ppc.cd_processo
  left outer join  Grupo_Maquina gm                 with (nolock) on gm.cd_grupo_maquina      = ppc.cd_grupo_maquina
  left outer join  Maquina m                        with (nolock) on m.cd_maquina             = ppc.cd_maquina 
  left outer join  Operacao o                       with (nolock) ON o.cd_operacao            = ppc.cd_operacao
  left outer join  Pedido_Venda pv                  with (nolock) ON pv.cd_pedido_venda       = pp.cd_pedido_venda 
  left outer join  Pedido_venda_item pvi            with (nolock) on pvi.cd_pedido_venda      = pp.cd_pedido_venda and
                                                                     pvi.cd_item_pedido_venda = pp.cd_item_pedido_venda

  left outer join  Cliente c                        with (nolock) on c.cd_cliente             = case when isnull(pv.cd_cliente,0)=0 then pp.cd_cliente else pv.cd_cliente end
  left outer join  Produto prod                     with (nolock) on prod.cd_produto          = pp.cd_produto
  left outer join  Unidade_Medida um                with (nolock) on um.cd_unidade_medida     = prod.cd_produto
  left outer join  Projeto         pj               with (nolock) on pj.cd_projeto            = pp.cd_projeto
  left outer join  Projeto_Composicao pjc           with (nolock) on pjc.cd_projeto           = pp.cd_projeto and
                                                                     pjc.cd_item_projeto      = pp.cd_item_projeto    
  left outer join  Projeto_Composicao_Material pjm  with (nolock) on pjm.cd_projeto           = pp.cd_projeto and
                                                                     pjm.cd_item_projeto      = pp.cd_item_projeto and
                                                                     pjm.cd_projeto_material  = pp.cd_projeto_material
   left outer join Fase_Produto fp                  with (nolock) on fp.cd_fase_produto       = pp.cd_fase_produto
   left outer join Status_Processo sp               with (nolock) on sp.cd_status_processo    = pp.cd_status_processo 
   left outer join Servico_Especial se              with (nolock) on se.cd_servico_especial   = ppc.cd_servico_especial

WHERE
  pp.dt_entrega_processo between @dt_inicial and @dt_final and  
  (pp.dt_fimprod_processo is null)        and
  IsNull(o.nm_fantasia_operacao,'') <> '' and
  isnull(pp.cd_status_processo,0) < 5     and
  ppc.cd_maquina = case when @cd_maquina = 0 then ppc.cd_maquina else @cd_maquina end 

--select * from status_processo
--select * from programacao
--select * from processo_producao
--select * from processo_producao_composicao
--select * from processo_producao_apontamento
--select * from servico_especial

--deleta as operações concluídas

-- select
--  *
-- from
--   #Consulta_Mapa_Periodo c
--   left outer join Processo_Producao_Apontamento a on a.cd_processo      = c.cd_processo and
--                                                      a.cd_item_processo = c.cd_item_processo
-- where
--   isnull(a.ic_operacao_concluida,'N')='S'
--   and a.cd_processo = 1503
-- 
-- delete #Consulta_Mapa_Periodo
-- where
--   isnull(ic_operacao_concluida,'N')='S'
-- 

delete from #Consulta_Mapa_periodo
from
  #Consulta_Mapa_periodo ppc
  inner join Processo_Producao_Apontamento a on
      a.cd_processo      = ppc.cd_processo      and
      a.cd_item_processo = ppc.cd_item_processo 
--      and isnull(a.ic_operacao_concluida,'N')  = 'S'
where
   isnull(a.ic_operacao_concluida,'N')  = 'S'




--Mostra a Tabela

select
  *
from
  #Consulta_Mapa_Periodo

order by
  dt_entrega_processo desc,
  cd_processo,cd_item_processo
  



