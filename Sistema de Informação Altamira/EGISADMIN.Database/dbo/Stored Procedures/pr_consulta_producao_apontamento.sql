
-------------------------------------------------------------------------------
--sp_helptext pr_consulta_producao_apontamento
-------------------------------------------------------------------------------
--pr_consulta_producao_apontamento
-------------------------------------------------------------------------------
--GBS Global Business Solution Ltda                                        2007	
-------------------------------------------------------------------------------
--Stored Procedure : Microsoft SQL Server 2000
--Autor(es)        : Carlos Cardoso Fernandes
--Banco de Dados   : Egissql
--Objetivo         : Consulta de Produção lançanda no Cadastro de Apontamento
--Data             : 16.08.2007
--Alteração        : 
------------------------------------------------------------------------------
create procedure pr_consulta_producao_apontamento
@dt_inicial datetime = '',
@dt_final   datetime = ''
as

--select * from processo_producao
--select * from processo_producao_apontamento

--Tabela temporária com as quantidades de peças produzidas

select
  pp.cd_processo,
  max(ppa.dt_processo_apontamento)          as DataProducao,
  sum( isnull(qt_peca_boa_apontamento,0) )  as Producao,
  sum( isnull(qt_peca_aprov_apontamento,0)) as Aprovada,
  sum( isnull(qt_peca_ruim_produzida,0) )   as Refugo
into
  #AuxProducao
from
  processo_producao pp
  inner join Processo_Producao_Apontamento ppa on ppa.cd_processo = pp.cd_processo

where
  pp.dt_processo  between @dt_inicial and @dt_final 
  and isnull(ppa.ic_operacao_concluida,'N')='S'
group by
  pp.cd_processo

--select * from #AuxProducao
  
select
  pp.cd_processo,
  pp.dt_processo,
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
  Processo_Producao pp
  left outer join #AuxProducao a    on a.cd_processo        = pp.cd_processo
  left outer join Pedido_Venda pv   on pv.cd_pedido_venda   = pp.cd_pedido_venda
  left outer join cliente c         on c.cd_cliente         = case when isnull(pp.cd_cliente,0)<>0 then pp.cd_cliente else pv.cd_cliente end
  left outer join produto p         on p.cd_produto         = pp.cd_produto
  left outer join unidade_medida um on um.cd_unidade_medida = p.cd_unidade_medida
where
  a.DataProducao is not null         and
  pp.dt_processo between @dt_inicial and @dt_final and
  pp.dt_canc_processo is null

order by
  c.nm_fantasia_cliente,
  pp.dt_processo

