
CREATE PROCEDURE pr_consulta_op_sem_apontamento
@dt_inicial 			datetime,
@dt_final 			datetime
AS

  select
    pp.cd_processo		as Processo,
    convert(char,pp.dt_processo,3) as DataProcesso,
    ppo.cd_item_processo 	as Operacao,
    p.nm_fantasia_produto	as Produto,
    cast(pp.qt_planejada_processo as decimal(15,4))	as Qtd,
    c.nm_fantasia_cliente	as Cliente
  from
    Processo_Producao 			pp  left outer join
    Processo_Producao_Composicao 	ppo on pp.cd_processo = ppo.cd_processo  left outer join
    Processo_Producao_Apontamento       ppa on pp.cd_processo = ppa.cd_processo and ppo.cd_item_processo = ppa.cd_item_processo left outer join
    Produto 	    			p   on pp.cd_produto = p.cd_produto left outer join
    Pedido_Venda			pv  on pp.cd_pedido_venda = pv.cd_pedido_venda left outer join
    Cliente				c   on pv.cd_cliente = c.cd_cliente
  where
    pp.dt_fimprod_processo between @dt_inicial and @dt_final and
    pp.cd_status_processo <> 6 and --Cancelada
    ppa.cd_item_processo is null
  order by
    pp.cd_processo,
    ppo.cd_item_processo

--    not exists (select distinct ppa.cd_processo from Processo_Producao_Apontamento ppa where pp.cd_processo = ppa.cd_processo)
--    select *from Processo_Producao_Apontamento
