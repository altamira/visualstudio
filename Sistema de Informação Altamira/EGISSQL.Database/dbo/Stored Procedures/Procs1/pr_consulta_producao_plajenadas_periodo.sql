
-------------------------------------------------------------------------------
--sp_helptext pr_consulta_producao_plajenadas_periodo
-------------------------------------------------------------------------------
--pr_consulta_producao_plajenadas_periodo
-------------------------------------------------------------------------------
--GBS Global Business Solution Ltda                                        2007	
-------------------------------------------------------------------------------
--Stored Procedure : Microsoft SQL Server 2000
--Autor(es)        : Carlos Cardoso Fernandes
--Banco de Dados   : Egissql
--Objetivo         : Consulta de Ordens de Produção Planejadas por Data de Entrega
--Data             : 16.08.2007
--Alteração        : 03.12.2007 - Pegar a última operação - Carlos Fernandes
-- 07.12.2007 - Flag na Operação para busca na consulta do Apontamento - Carlos Fernandes
-- 18.12.2007 - Ordem por data de entrega - Carlos Fernandes
-- 04.06.2008 - Ajuste da Consulta para Mostrar a Data de Entrega - Carlos Fernandes
-- 14.03.2009 - Complemento de campos e ajustes diversos - Carlos Fernandes
-- 25.05.2009 - Ajuste da Quantidade de Refugos - Carlos Fernandes
-- 05.12.2009 - Buscar o Campos de Custo de Produção - Carlos Fernandes
-----------------------------------------------------------------------------------------
create procedure pr_consulta_producao_plajenadas_periodo
@dt_inicial datetime = '',
@dt_final   datetime = ''
as

--select * from processo_producao
--select * from processo_producao_apontamento

--Tabela temporária com a última operação

select
  pp.cd_processo,
  max(ppa.cd_item_processo) as cd_item_processo,
  sum( isnull(ppa.qt_peca_aprov_apontamento,0)) as Aprovada
  
into
  #UltimaOperacao

from
  processo_producao pp                         with (nolock) 
  inner join Processo_Producao_Apontamento ppa with (nolock) on ppa.cd_processo = pp.cd_processo
  left outer join Operacao                 o   with (nolock) on o.cd_operacao   = ppa.cd_operacao  

where
  pp.dt_entrega_processo  between @dt_inicial and @dt_final 
--  and isnull(ppa.ic_operacao_concluida,'N')='S' 
  and isnull(o.ic_analise_apontamento,'N' )='S'           --Somente a Operação configurada no Cadastro
group by
  pp.cd_processo
order by
  pp.cd_processo,
  ppa.cd_item_processo desc

select
  pp.cd_processo,
  sum( isnull(ppa.qt_peca_ruim_produzida,0)) as Refugo
  
into
  #Refugo
from
  processo_producao pp                         with (nolock) 
  inner join Processo_Producao_Apontamento ppa with (nolock) on ppa.cd_processo = pp.cd_processo
  left outer join Operacao                 o   with (nolock) on o.cd_operacao   = ppa.cd_operacao  
where
  pp.dt_entrega_processo  between @dt_inicial and @dt_final 
--  and isnull(ppa.ic_operacao_concluida,'N')='S' 
group by
  pp.cd_processo
order by
  pp.cd_processo

--select * from   #UltimaOperacao


--Tabela temporária com as quantidades de peças produzidas

select
  pp.cd_processo,
  max(pp.dt_entrega_processo)                   as DataEntrega,
  max(ppa.dt_processo_apontamento)              as DataProducao,
  --sum( isnull(ppa.qt_peca_boa_apontamento,0) )  as Producao,
  max(isnull(up.Aprovada,0)) +
  max( isnull(ppx.Refugo,0) )                   as Producao,

  max(isnull(up.Aprovada,0))                    as Aprovada,
  max(isnull(ppx.Refugo,0) )                   as Refugo

into
  #AuxProducao

from
  processo_producao pp                         with (nolock) 
  inner join #UltimaOperacao               up  with (nolock) on up.cd_processo       = pp.cd_processo 
  inner join Processo_Producao_Apontamento ppa with (nolock) on ppa.cd_processo      = up.cd_processo       and
                                                                ppa.cd_item_processo = up.cd_item_processo

  inner join #Refugo ppx                       with (nolock) on ppx.cd_processo      = pp.cd_processo       


--select * from processo_producao_apontamento where cd_processo = 1689

--select * from status_processo

where
  --ppa.dt_processo_apontamento  between @dt_inicial and @dt_final 
  --and
-- isnull(ppa.ic_operacao_concluida,'N')='S'
-- and
 cd_status_processo = 5    --Processo Encerrados


--select * from processo_producao

group by
  pp.cd_processo

--select * from #AuxProducao where cd_processo = 1689
  
select
  pp.cd_processo,
  pp.dt_processo,
  pp.dt_entrega_processo,
  isnull(c.nm_fantasia_cliente,'')    as Cliente,
  isnull(p.cd_mascara_produto,'')     as Codigo,
  isnull(p.nm_fantasia_produto,'')    as Produto,
  isnull(p.nm_produto,'')             as Descricao,
  isnull(um.sg_unidade_medida,'')     as Unidade,
  isnull(pp.qt_planejada_processo,0)  as Planejada,
  isnull(a.Producao,0)                as Producao,
  isnull(a.Aprovada,0)                as Aprovada,
  isnull(a.Refugo,0)                  as Refugo,
  a.DataProducao,
  sp.nm_status_processo,
  pp.cd_identifica_processo           as cd_identificacao_processo,
  Atendimento = ( Case when a.DataProducao <= pp.dt_entrega_processo then 'S' else 'N' end ),

  --Total de Horas da Ordem de Produção

  isnull(( select sum( (isnull(qt_hora_estimado_processo,0) + isnull(qt_hora_setup_processo,0))/60 )
    from
      processo_producao_composicao ppc
    where
      pp.cd_processo = ppc.cd_processo ),0)                                                       as TotalEstimado,

  --Total de Horas do Apontamento da Ordem de Produção

  isnull( (select sum( isnull(qt_processo_apontamento,0) )
    from
      processo_producao_apontamento ppa
    where 
      pp.cd_processo = ppa.cd_processo ),0)                                                       as TotalRealizado

  
--select * from processo_producao

from
  Processo_Producao pp               with (nolock) 
  left outer join #AuxProducao a     with (nolock) on a.cd_processo         = pp.cd_processo
  left outer join Pedido_Venda pv    with (nolock) on pv.cd_pedido_venda    = pp.cd_pedido_venda
  left outer join cliente c          with (nolock) on c.cd_cliente          = case when isnull(pp.cd_cliente,0)<>0 then pp.cd_cliente else pv.cd_cliente end
  left outer join produto p          with (nolock) on p.cd_produto          = pp.cd_produto
  left outer join unidade_medida um  with (nolock) on um.cd_unidade_medida  = p.cd_unidade_medida
  left outer join status_processo sp with (nolock) on sp.cd_status_processo = pp.cd_status_processo
  
where
  --a.DataProducao      is not null         and
  pp.dt_entrega_processo between @dt_inicial and @dt_final and
  --a.DataProducao between @dt_inicial and @dt_final and
  pp.dt_canc_processo is null

order by
  a.DataProducao,
  c.nm_fantasia_cliente

