
-------------------------------------------------------------------------------
--sp_helptext pr_consulta_producao_atendidas_periodo
-------------------------------------------------------------------------------
--pr_consulta_producao_atendidas_periodo
-------------------------------------------------------------------------------
--GBS Global Business Solution Ltda                                        2007	
-------------------------------------------------------------------------------
--Stored Procedure : Microsoft SQL Server 2000
--Autor(es)        : Carlos Cardoso Fernandes
--Banco de Dados   : Egissql
--Objetivo         : Consulta de Ordem de Produção atendidas por data de entrega
--                   com Data de Produção - Apontadas
--
--Data             : 16.08.2007
--Alteração        : 03.12.2007 - Pegar a última operação - Carlos Fernandes
-- 07.12.2007 - Flag na Operação para busca na consulta do Apontamento - Carlos Fernandes
-- 18.12.2007 - Ordem por data de entrega - Carlos Fernandes
-- 04.06.2008 - Ajuste da Consulta para Mostrar a Data de Entrega - Carlos Fernandes
-- 14.03.2009 - Complemento e Ajustes Diversos - Carlos Fernandes
-----------------------------------------------------------------------------------------
create procedure pr_consulta_producao_atendidas_periodo
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
  and isnull(ppa.ic_operacao_concluida,'N')='S' 
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
  and isnull(ppa.ic_operacao_concluida,'N')='S' 
group by
  pp.cd_processo
order by
  pp.cd_processo

--select * from   #UltimaOperacao


--Tabela temporária com as quantidades de peças produzidas

select
  pp.cd_processo,
  max(pp.dt_entrega_processo)               as DataEntrega,
  max(ppa.dt_processo_apontamento)          as DataProducao,
  sum( isnull(qt_peca_boa_apontamento,0) )  as Producao,
  sum( isnull(qt_peca_aprov_apontamento,0)) as Aprovada,
  sum( isnull(qt_peca_ruim_produzida,0) )   as Refugo
into
  #AuxProducao
from
  processo_producao pp                         with (nolock) 
  inner join #UltimaOperacao               up  with (nolock) on up.cd_processo       = pp.cd_processo 
  inner join Processo_Producao_Apontamento ppa with (nolock) on ppa.cd_processo      = up.cd_processo       and
                                                                ppa.cd_item_processo = up.cd_item_processo
where
  pp.dt_entrega_processo  between @dt_inicial and @dt_final 
  and isnull(ppa.ic_operacao_concluida,'N')='S'
group by
  pp.cd_processo

--select * from #AuxProducao
  
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
  a.DataProducao
from
  Processo_Producao pp              with (nolock) 
  left outer join #AuxProducao a    with (nolock) on a.cd_processo        = pp.cd_processo
  left outer join Pedido_Venda pv   with (nolock) on pv.cd_pedido_venda   = pp.cd_pedido_venda
  left outer join cliente c         with (nolock) on c.cd_cliente         = case when isnull(pp.cd_cliente,0)<>0 then pp.cd_cliente else pv.cd_cliente end
  left outer join produto p         with (nolock) on p.cd_produto         = pp.cd_produto
  left outer join unidade_medida um with (nolock) on um.cd_unidade_medida = p.cd_unidade_medida
where
  a.DataProducao      is not null         and
  pp.dt_entrega_processo between @dt_inicial and @dt_final and
  pp.dt_canc_processo is null

order by
  pp.dt_entrega_processo,
  c.nm_fantasia_cliente

