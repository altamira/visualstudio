
CREATE PROCEDURE pr_demonstrativo_custo_mao_obra_resumo
@dt_inicial 			datetime,
@dt_final 			datetime
AS

  select
    pp.cd_processo,
    o.nm_operador,
    pp.dt_processo,
    p.nm_fantasia_produto,
    p.nm_produto,
    pp.qt_planejada_processo,
    o.vl_hora_operador,
    o.vl_encargo_operador,

    sum(datediff(n,convert(DateTime, ppa.hr_inicial_apontamento), convert(DateTime, ppa.hr_final_apontamento)))/60.00 as qt_horas_apontadas,

    sum(datediff(n,convert(DateTime, ppa.hr_inicial_apontamento), convert(DateTime, ppa.hr_final_apontamento)))/60.00 * o.vl_hora_operador as vl_horas,

    sum(datediff(n,convert(DateTime, ppa.hr_inicial_apontamento), convert(DateTime, ppa.hr_final_apontamento)))/60.00 * o.vl_encargo_operador as vl_encargo
  into
    #Processo
  from
    Processo_Producao 			pp  left outer join
    Produto 	    			p   on pp.cd_produto = p.cd_produto left outer join
    Processo_Producao_Apontamento 	ppa on pp.cd_processo = ppa.cd_processo left outer join
    Operador				o   on ppa.cd_operador = o.cd_operador
  where
    pp.dt_fimprod_processo between @dt_inicial and @dt_final and
    pp.cd_status_processo = 5 --Encerrada
  group by
    pp.cd_processo,
    o.nm_operador,
    pp.dt_processo,
    p.nm_fantasia_produto,
    p.nm_produto,
    pp.qt_planejada_processo,
    o.vl_hora_operador,
    o.vl_encargo_operador
  order by
    pp.cd_processo

  select
    cd_processo,
    nm_operador,
    dt_processo,
    nm_fantasia_produto,
    nm_produto,
    qt_planejada_processo,
    sum(qt_horas_apontadas) as qt_horas_apontadas,
    sum(vl_horas) as vl_horas,
    sum(vl_encargo) as vl_encargos
  into
    #Total
  from
    #Processo
  group by
    cd_processo,
    nm_operador,
    dt_processo,
    nm_fantasia_produto,
    nm_produto,
    qt_planejada_processo
  order by
    cd_processo,
    nm_operador


  select
    distinct
    t.cd_processo,
    isnull(nm_operador,'') as nm_operador,
    convert(char,pp.dt_fimprod_processo,103) as dt_fim,
    t.nm_fantasia_produto,
    t.nm_produto,
    isnull(replace(cast(cast(t.qt_planejada_processo as decimal(15,4)) as varchar),'.',','),'') as qt_planejada_processo,
    isnull(replace(cast(cast(isnull(t.qt_horas_apontadas,0) as decimal(15,4)) as varchar),'.',','),'') as qt_horas_apontadas,
    isnull(replace(cast(cast(t.vl_horas as decimal(15,4)) as varchar),'.',','),'') as vl_horas,
    isnull(replace(cast(cast(t.vl_encargos as decimal(15,4)) as varchar),'.',','),'') as vl_encargos,
    ofi.cd_mascara_operacao,
    isnull(replace(cast(cast(isnull(t.vl_horas,0) + isnull(t.vl_encargos,0) as decimal(15,4)) as varchar),'.',','),'') as vl_total
  from
    #Total 		t                                     left outer join
    Processo_Producao 	pp  on t.cd_processo = pp.cd_processo left outer join
    Pedido_Venda_Item   pvi on pp.cd_pedido_venda = pvi.cd_pedido_venda and pp.cd_pedido_venda = pvi.cd_pedido_venda left outer join
    Nota_Saida_Item     nsi on pvi.cd_pedido_venda = nsi.cd_pedido_venda and pvi.cd_pedido_venda = nsi.cd_pedido_venda left outer join
    Nota_Saida		ns  on nsi.cd_nota_saida = ns.cd_nota_saida left outer join
    Operacao_Fiscal     ofi on ns.cd_operacao_fiscal = ofi.cd_operacao_fiscal
  order by 
    1

