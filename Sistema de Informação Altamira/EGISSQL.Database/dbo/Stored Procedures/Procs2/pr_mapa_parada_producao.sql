
-------------------------------------------------------------------------------
--sp_helptext pr_mapa_parada_producao
-------------------------------------------------------------------------------
--pr_mapa_parada_producao
-------------------------------------------------------------------------------
--GBS Global Business Solution Ltda                                        2008
-------------------------------------------------------------------------------
--Stored Procedure : Microsoft SQL Server 2000
--Autor(es)        : Carlos Cardoso Fernandes
--Banco de Dados   : Egissql
--Objetivo         : Mapa de Parada de Produção
--
--Data             : 28.10.2008
--Alteração        : 
--
-- 01.02.2009 - Novos Filtros - Carlos Fernandes
-- 14.03.2009 - Ajuste da Consulta somente por processo - Carlos Fernandes
-- 28.06.2010 - Tempo de Parada de Máquina - Carlos Fernandes
-- 16.07.2010 - Hora de Início/Fim de Parada - Carlos Fernandes
------------------------------------------------------------------------------
create procedure pr_mapa_parada_producao

@dt_inicial             datetime = '',
@dt_final               datetime = '',
@cd_maquina             int      = 0,
@cd_operador            int      = 0,
@cd_processo            int      = 0,
@cd_tipo_maquina_parada int      = 0

as

SELECT     
  identity(int,1,1)                                                    as cd_controle,
  tpm.nm_tipo_maquina_parada,
  ppp.dt_processo_parada,
  isnull(ppp.qt_processo_parada,0)                                     as qt_processo_parada,                         
  ppp.hr_inicial_parada,
  ppp.hr_final_parada,
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
  cast(GetDate() as integer) - cast(pp.dt_entrega_processo as integer) as 'Atraso',
  ppc.cd_processo, 
  ppc.cd_item_processo,
  ppc.cd_seq_processo,
  pp.dt_processo,
  pp.qt_planejada_processo,
  isnull(prod.nm_produto,pvi.nm_produto_pedido) as Descricao,
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
  isnull(ppc.qt_hora_estimado_processo,0)       as qt_hora_estimado_processo,
  isnull(ppc.qt_hora_real_processo,0)           as qt_hora_real_processo,
  isnull(ppc.qt_hora_setup_processo,0)          as qt_hora_setup_processo,

  isnull(ppc.qt_hora_estimado_processo,0)+
  isnull(ppc.qt_hora_setup_processo,0)          as qt_hora_total_processo,

  ppc.dt_prog_mapa_processo,
  se.nm_servico_especial,
  isnull(ic_operacao_mapa_processo,'N')         as ic_operacao_mapa_processo,
  isnull(nm_obs_item_processo,'')               as nm_obs_item_processo,
  ppc.cd_ordem,

  ope.nm_operador
 

--select * from processo_producao_composicao
--select * from processo_producao_parada

into
  #Consulta_Mapa_Parada

FROM 

  Processo_Producao pp                         with (nolock)

  inner join Processo_Producao_Composicao ppc  with (nolock) on ppc.cd_processo            = pp.cd_processo

  inner join Processo_Producao_Parada ppp      with (nolock)  on ppp.cd_processo           = ppc.cd_processo and
                                                                 ppp.cd_item_processo      = ppc.cd_item_processo

  left outer join  Grupo_Maquina gm                  with (nolock) on gm.cd_grupo_maquina      = ppc.cd_grupo_maquina

  left outer join  Maquina m                         with (nolock) on m.cd_maquina             = case when isnull(ppp.cd_maquina,0)=0
                                                                                                 then ppc.cd_maquina
                                                                                                 else ppp.cd_maquina end 
  left outer join  Operacao o                        with (nolock) ON o.cd_operacao            = 
                                                                      case when isnull(ppc.cd_operacao,0)>0 then
                                                                       ppc.cd_operacao
                                                                      else
                                                                       ppc.cd_operacao
                                                                      end

  left outer join  Pedido_Venda pv                   with (nolock) ON pv.cd_pedido_venda       = pp.cd_pedido_venda 

  left outer join  Pedido_venda_item pvi             with (nolock) on pvi.cd_pedido_venda      = pp.cd_pedido_venda and
                                                                      pvi.cd_item_pedido_venda = pp.cd_item_pedido_venda

  left outer join  Cliente c                         with (nolock) on c.cd_cliente             = case when isnull(pv.cd_cliente,0)=0 then pp.cd_cliente else pv.cd_cliente end
  left outer join  Produto prod                      with (nolock) on prod.cd_produto          = pp.cd_produto
  left outer join  Unidade_Medida um                 with (nolock) on um.cd_unidade_medida     = prod.cd_produto

  left outer join  Projeto         pj                with (nolock) on pj.cd_projeto            = pp.cd_projeto
  left outer join  Projeto_Composicao pjc            with (nolock) on pjc.cd_projeto           = pp.cd_projeto and
                                                                      pjc.cd_item_projeto      = pp.cd_item_projeto    

  left outer join  Projeto_Composicao_Material pjm   with (nolock) on pjm.cd_projeto           = pp.cd_projeto and
                                                                      pjm.cd_item_projeto      = pp.cd_item_projeto and
                                                                      pjm.cd_projeto_material  = pp.cd_projeto_material

  left outer join Fase_Produto fp                   with (nolock)  on fp.cd_fase_produto       = pp.cd_fase_produto

  left outer join Status_Processo sp                with (nolock)  on sp.cd_status_processo    = pp.cd_status_processo 

  left outer join Servico_Especial se               with (nolock)  on se.cd_servico_especial   = ppc.cd_servico_especial

  left outer join Operador         ope              with (nolock)  on ope.cd_operador          = ppp.cd_operador


  inner join Tipo_Maquina_Parada tpm                with (nolock) on tpm.cd_tipo_maquina_parada = ppp.cd_tipo_maquina_parada

--select * from processo_producao_parada

WHERE
  ppp.cd_tipo_maquina_parada = case when @cd_tipo_maquina_parada = 0 then ppp.cd_tipo_maquina_parada else @cd_tipo_maquina_parada end and
  pp.cd_processo  = case when @cd_processo = 0 then pp.cd_processo  else @cd_processo end and
  ppp.cd_maquina  = case when @cd_maquina  = 0 then ppp.cd_maquina  else @cd_maquina  end and
  ppp.cd_operador = case when @cd_operador = 0 then ppp.cd_operador else @cd_operador end and    

  ppp.dt_processo_parada between case when @cd_processo = 0 then @dt_inicial else ppp.dt_processo_parada end 
                                      and 
                                      case when @cd_processo = 0 then @dt_final else ppp.dt_processo_parada   end

  and  

  IsNull(o.nm_fantasia_operacao,'') <> '' and
  pp.dt_canc_processo is null             and
  isnull(pp.cd_status_processo,0) <= 5

--select * from processo_producao_apontamento
--select * from status_processo
--select * from programacao
--select * from processo_producao
--select * from processo_producao_composicao
--select * from servico_especial

select
  *
from
  #Consulta_Mapa_Parada
order by
  dt_processo_parada desc,
  cd_processo,cd_item_processo
  

