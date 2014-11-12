
CREATE PROCEDURE pr_consulta_programacao_maquina
-----------------------------------------------------------------------------
--GBS - Global Business Solution	       2002
--Stored Procedure: Microsoft SQL Server       2000
--Autor(es)     : Daniel Carrasco Neto
--Banco de Dados: EgisSQL
--Objetivo      : Consultar Programação de Uma máquina Escolhida.
--Data          : 30/04/2004
--                21/05/2004 - Mudado campo de Disponibilidade da máquina
--                           - Daniel C. Neto.
--                04/06/2004 - Acerto no cálculo de horas antecipadas
--                           - Daniel C. Neto.
--
--                20.06.2004 - Colocados novos atributos na consulta ( Carlos )
--                21/06/2004 - Colocado mais um atributo - Daniel C. Neto.
-- 06/08/2004 - Mudado forma de cálculo de horas programadas - Daniel C. Neto
-- 16/08/2004 - Tirado filtro de Processo, para mostrar reserva - Daniel C. neto
-- 25/08/2004 - Modificado campo de pedido de venda - Daniel C. Neto.
-------------------------------------------------------------------------------
-- Obs: - Cuidado ao tirar campos desta procedure, pois a mesma
-- é utilizada na tela de programação de produção.
--      - Daniel C. Net.
--------------------------------------------------------------------------------
@cd_maquina    int,
@dt_base       datetime

AS

	SELECT     
	  --Máquina
	  m.cd_maquina,
	  m.nm_fantasia_maquina,
	  m.nm_maquina,
	
	  --Operação
	  o.nm_fantasia_operacao, 
	
	  --Processo
	  pp.cd_identifica_processo, 
    isnull(pp.cd_pedido_venda,ppc.cd_pedido_venda) as cd_pedido_venda, 
    isnull(pp.cd_item_pedido_venda,ppc.cd_item_pedido_venda) as cd_item_pedido_venda, 
	  c.nm_fantasia_cliente, 
	  ppc.cd_processo, 
	  p.qt_hora_disp_simulacao,
    procpc.cd_seq_processo,
	
	  ppc.qt_hora_prog_operacao, 
	  ppc.dt_fim_prod_operacao, 
	  ppc.nm_obs_operacao, 
	  ppc.ic_antecipada_operacao, 
	  ppc.cd_ordem_fab, 
	  ppc.ic_cnc_operacao, 
	  ppc.dt_lanc_mapa_programacao,
	  tm.nm_tipo_maquina,
	  gm.nm_grupo_maquina,
	  p.dt_programacao,
	  p.cd_programacao,
	  ppc.cd_item_programacao,
	  pp.dt_fimprod_processo,
	  pvi.nm_produto_pedido
	into 
	  #Temp
	
	FROM 
	  Maquina m 
      left outer join
	  Grupo_Maquina gm
      on gm.cd_grupo_maquina = m.cd_grupo_maquina 
      left outer join
	  Tipo_maquina tm
      on tm.cd_tipo_maquina = m.cd_tipo_maquina 
      left outer join
	  Programacao p
      on p.cd_maquina = m.cd_maquina and 
         dt_programacao = @dt_base
      left outer join
	  Programacao_Composicao ppc 
	    on p.cd_programacao = ppc.cd_programacao
      left outer join
    Processo_Producao_Composicao procpc
      on ppc.cd_processo = procpc.cd_processo and
         ppc.cd_item_processo = procpc.cd_item_processo
      left outer join
	  Operacao o
      on o.cd_operacao = ppc.cd_operacao 
      left outer join
	  Processo_Producao pp 
      on ppc.cd_processo = pp.cd_processo 
      left outer join
	  Pedido_Venda pv
      on ISNull(pp.cd_pedido_venda, ppc.cd_pedido_venda) = pv.cd_pedido_venda 
      left outer join
	  Cliente c
      on pv.cd_cliente = c.cd_cliente 
      left outer join
	  Pedido_Venda_Item pvi 
      on pvi.cd_pedido_venda = IsNull(pp.cd_pedido_venda,ppc.cd_pedido_venda) and
	       pvi.cd_item_pedido_venda = IsNull(pp.cd_item_pedido_venda, ppc.cd_item_pedido_venda)
	where
	  m.cd_maquina = @cd_maquina
	order by
	  cd_ordem_fab,
	  nm_fantasia_maquina

	-- Calculando Totais.
	declare @qt_hora_programada float
	declare @qt_hora_capacidade float
	declare @qt_hora_disponivel float
	declare @qt_hora_produzida  float
	declare @qt_hora_antecipada float
	declare @qt_turno integer

	select 
	  @qt_hora_capacidade = sum(qt_hora_operacao_maquina),
	  @qt_turno = count(qt_hora_operacao_maquina)
	from Maquina_Turno
	where 
	  cd_maquina = @cd_maquina and
	  ic_operacao='S'

 select
  @qt_hora_programada = sum(case when t.dt_fim_prod_operacao is null 
                           then IsNull(t.qt_hora_prog_operacao,0) else 0 end),
--  @qt_hora_disponivel = IsNull(@qt_hora_capacidade,0) - IsNull(@qt_hora_programada,0),
  @qt_hora_produzida = sum(case when t.dt_fim_prod_operacao is null 
                           then 0 else IsNull(t.qt_hora_prog_operacao,0) end),
  @qt_hora_antecipada = sum(case when (t.dt_fim_prod_operacao is not null) and 
                                      IsNull(t.ic_antecipada_operacao,'N') = 'S'
                           then IsNull(t.qt_hora_prog_operacao,0) else 0 end)
	from
	  #Temp t 

		select
		  distinct
		  t.*,
		  @qt_hora_programada as qt_hora_programada,
		  ((case when IsNull(p.qt_hora_operacao_maquina,0) = 0  then
         @qt_hora_capacidade else IsNull(p.qt_hora_operacao_maquina,0) end) - IsNull(@qt_hora_programada,0)) as qt_hora_disponivel,
		  @qt_hora_produzida  as qt_hora_produzida,
		  @qt_hora_antecipada as qt_hora_antecipada,
      (case when IsNull(p.qt_hora_operacao_maquina,0) = 0  then
         @qt_hora_capacidade else IsNull(p.qt_hora_operacao_maquina,0) end) as qt_hora_capacidade,
		
		  case when @qt_hora_capacidade = 0 then 0
		    else ( @qt_hora_programada / @qt_hora_capacidade ) * 100 end as qt_perc_programada,
		  case when @qt_hora_capacidade = 0 then 0
		    else ( @qt_hora_disponivel / @qt_hora_capacidade ) * 100 end as qt_perc_disponivel,
		  case when @qt_hora_capacidade = 0 then 0
		    else ( @qt_hora_produzida / @qt_hora_capacidade ) * 100  end as qt_perc_produzida,
		  case when @qt_hora_capacidade = 0 then 0
		    else ( @qt_hora_antecipada  / @qt_hora_capacidade ) * 100 end as qt_perc_antecipada,
		  @qt_turno as qt_turno
		from
		  #Temp t left outer join
      Programacao p on p.cd_programacao = t.cd_programacao
		order by
		  t.cd_ordem_fab  
	
