
-------------------------------------------------------------------------------
--sp_helptext pr_comparativo_processo_apontamento
-------------------------------------------------------------------------------
--pr_documentacao_padrao
-------------------------------------------------------------------------------
--GBS Global Business Solution Ltda                                        2007	
-------------------------------------------------------------------------------
--Stored Procedure : Microsoft SQL Server 2000
--Autor(es)        : Carlos Cardoso Fernandes
--Banco de Dados   : Egissql
--Objetivo         : Consulta do comparativo de Processo x Padrão x Orçamento x
--                   Programação x Apontamento
--Data             : 02.11.2007
--Alteração        : 
--
------------------------------------------------------------------------------

create procedure pr_comparativo_processo_apontamento
@cd_processo int      = 0,
@dt_inicial  datetime = '',
@dt_final    datetime = ''

as

  --select * from processo_producao_composicao
  --select * from processo_padrao_composicao
  --select * from operacao
  --select * from programacao_composicao
  --select * from processo_producao_apontamento

  --Montagem da Tabela com a Somatoria dos Apontamentos

  select
    ppa.cd_processo,
    ppa.cd_item_processo,
    ppa.cd_operacao,
    sum( isnull(ppa.qt_processo_apontamento,0) )  as qt_processo_apontamento,
    sum( isnull(ppa.qt_setup_apontamento,0))      as qt_setup_apontamento,
    sum( isnull(ppa.qt_peca_boa_apontamento,0))   as qt_peca_boa_apontamento,
    sum( isnull(ppa.qt_peca_ruim_produzida,0))    as qt_peca_ruim_apontamento,
    sum( isnull(ppa.qt_peca_aprov_apontamento,0)) as qt_peca_aprov_apontamento
  into
    #Apontamento
  from
    processo_producao_apontamento ppa with (nolock)
    inner join operacao o             with (nolock) on o.cd_operacao = ppa.cd_operacao
  where
    ppa.cd_processo = case when @cd_processo = 0 then ppa.cd_processo else @cd_processo end
    and isnull(o.ic_analise_apontamento,'N')='S'
  group by
    ppa.cd_processo,
    ppa.cd_item_processo,
    ppa.cd_operacao
 
  select 
    p.cd_processo,
    p.qt_planejada_processo,
    p.cd_processo_padrao,
    pp.cd_item_processo,
    pp.ic_operacao_mapa_processo,
    pp.cd_operacao,
    o.nm_operacao,
    pp.qt_hora_estimado_processo,
    pp.qt_hora_setup_processo,
    isnull(pp.qt_hora_estimado_processo,0) +
    isnull(pp.qt_hora_setup_processo,0)                      as qt_hora_total_processo,
    pc.qt_hora_setup,
    pc.qt_hora_operacao,
    isnull(pc.qt_hora_setup,0)+isnull(pc.qt_hora_operacao,0) as qt_hora_total_padrao,
    isnull(pg.qt_hora_real_producao,0)                       as qt_hora_real_producao,
    pg.dt_ini_prod_operacao,
    pg.dt_fim_prod_operacao,
    a.qt_processo_apontamento,
    a.qt_setup_apontamento,
    a.qt_peca_boa_apontamento,
    a.qt_peca_ruim_apontamento,
    a.qt_peca_aprov_apontamento,
    prod.cd_mascara_produto,
    prod.nm_fantasia_produto,
    prod.nm_produto
  

  from 
    processo_producao p                           with (nolock)
    inner join processo_producao_composicao pp    with (nolock) on pp.cd_processo        = p.cd_processo
    inner join operacao o                         with (nolock) on o.cd_operacao         = pp.cd_operacao
    left outer join processo_padrao_composicao pc with (nolock) on pc.cd_processo_padrao = p.cd_processo_padrao and
                                                                   pc.cd_operacao        = pp.cd_operacao
    left outer join programacao_composicao   pg   with (nolock) on pg.cd_processo        = pp.cd_processo      and
                                                                   pg.cd_item_processo   = pp.cd_item_processo and
                                                                   pg.cd_operacao        = pp.cd_operacao     
    left outer join #Apontamento             a    with (nolock) on a.cd_processo         = p.cd_processo       and
                                                                   a.cd_item_processo    = pp.cd_item_processo and
                                                                   a.cd_operacao         = pp.cd_operacao

    left outer join Produto_Producao ppo          with (nolock) on ppo.cd_processo_padrao= p.cd_processo_padrao
    left outer join Produto          prod         with (nolock) on prod.cd_produto       = ppo.cd_produto
  where 
    p.cd_processo = case when @cd_processo = 0 then p.cd_processo else @cd_processo end
  order by
    p.cd_processo,
    pp.cd_item_processo 

