
-------------------------------------------------------------------------------
--sp_helptext pr_consulta_processo_motivo_refugo
-------------------------------------------------------------------------------
--pr_consulta_processo_motivo_refugo
-------------------------------------------------------------------------------
--GBS Global Business Solution Ltda                                        2008
-------------------------------------------------------------------------------
--Stored Procedure : Microsoft SQL Server 2000
--Autor(es)        : Douglas de Paula Lopes
--Banco de Dados   : Egissql
--Objetivo         : Consulta das Ordens de Produção com Refugo
--Data             : 29.09.2008
--Alteração        : 27.10.2008 - Ajustes Diversos - Carlos Fernandes
--
-- 14.03.2009 - Ajustes Diversos - Carlos Fernandes
------------------------------------------------------------------------------
create procedure pr_consulta_processo_motivo_refugo
@dt_inicial      datetime = '',
@dt_final        datetime = '',
@analitico       integer  = 1,
@cd_causa_refugo integer = 0

as

select
  pp.cd_processo,
  pp.dt_processo,
  ppa.cd_item_processo,
  cr.cd_causa_refugo,
  cr.nm_causa_refugo,
--  ppa.cd_item_processo,
  c.nm_fantasia_cliente,
  p.cd_mascara_produto,
  p.nm_fantasia_produto,
  isnull(pvi.nm_produto_pedido,p.nm_produto) as nm_produto,
  pp.cd_pedido_venda,
  pp.cd_item_pedido_venda,
  ppa.dt_processo_apontamento,
  um.sg_unidade_medida,
  op.nm_operacao,
  o.nm_operador,
  m.nm_maquina,
  isnull(ppa.qt_peca_boa_apontamento,0)    as qt_peca_boa_apontamento, 
  isnull(ppa.qt_peca_ruim_produzida,0)     as qt_peca_ruim_produzida,
  isnull(ppa.qt_peca_aprov_apontamento,0)  as qt_peca_aprov_apontamento,
  case when isnull(ppa.qt_peca_boa_apontamento,0)>0 then
    ppa.qt_peca_ruim_produzida * 100 / ppa.qt_peca_boa_apontamento 
  else
    0.00
  end as PERC,
  ppa.nm_obs_apontamento,
  0.00                                     as PERC2 
into
  #Refugo
from 
  processo_producao                             pp  with(nolock)
  inner      join processo_producao_apontamento ppa with(nolock) on ppa.cd_processo      = pp.cd_processo and
                                                                    isnull(ppa.qt_peca_ruim_produzida,0) > 0
  inner      join causa_refugo                  cr  with(nolock) on cr.cd_causa_refugo   = ppa.cd_causa_refugo
  left outer join pedido_venda                  pv  with(nolock) on pv.cd_pedido_venda   = pp.cd_pedido_venda
  left outer join cliente                       c   with(nolock) on c.cd_cliente         = 
                                                                    case when isnull(pv.cd_cliente,0)=0 
                                                                    then
                                                                      pp.cd_cliente else pv.cd_cliente end
  left outer join pedido_venda_item            pvi  with(nolock) on pvi.cd_pedido_venda      = pv.cd_pedido_venda and
                                                                    pvi.cd_item_pedido_venda = pp.cd_item_pedido_venda
  left outer join produto                       p   with(nolock) on p.cd_produto         = pp.cd_produto
  left outer join maquina                       m   with(nolock) on m.cd_maquina         = ppa.cd_maquina
  left outer join operador                      o   with(nolock) on o.cd_operador        = ppa.cd_operador
  left outer join operacao                      op  with(nolock) on op.cd_operacao       = ppa.cd_operacao
  left outer join unidade_medida                um  with(nolock) on um.cd_unidade_medida = p.cd_unidade_medida
where
  ppa.dt_processo_apontamento between @dt_Inicial and @dt_Final    


if @analitico = 1 
  begin
    select
            cd_causa_refugo,
            nm_causa_refugo,
      0  as cd_causa_refugo, 
      '' as nm_causa_refugo,
      0  as cd_item_processo,
      '' as nm_fantasia_cliente,
      ''  as cd_mascara_produto,
      '' as nm_fantasia_produto,
      '' as nm_produto,
      0  as cd_pedido_venda,
      0  as cd_item_pedido_venda,
      cast(30000 as datetime)        as dt_processo_apontamento,
      '' as sg_unidade_medida,
      '' as nm_operacao,
      '' as nm_operador,
      '' as nm_maquina, 
      sum(qt_peca_boa_apontamento)   as qt_peca_boa_apontamento,
      sum(qt_peca_ruim_produzida)    as qt_peca_ruim_produzida,
      sum(qt_peca_aprov_apontamento) as qt_peca_aprov_apontamento,
     (sum(qt_peca_ruim_produzida) * 100 / sum(qt_peca_boa_apontamento)) as PERC,
      '' as nm_obs_apontamento
    from 
      #Refugo
    group by
      cd_causa_refugo,
      nm_causa_refugo
    order by
      cd_causa_refugo    
  end
else
  begin

  declare @TotalBoas int 
  
  set @TotalBoas = (select sum(qt_peca_boa_apontamento) from #Refugo where cd_causa_refugo = @cd_causa_refugo)
  
  print @TotalBoas
    select 
      *,
      case when isnull(@TotalBoas,0)>0 then
        qt_peca_ruim_produzida * 100 / @TotalBoas 
      else
        0.00
      end as PERC2 
    from 
      #Refugo 
    where 
      cd_causa_refugo = case when @cd_causa_refugo = 0 then cd_causa_refugo else @cd_causa_refugo end
    order by 
      cd_causa_refugo
  end
 
drop table #refugo    

