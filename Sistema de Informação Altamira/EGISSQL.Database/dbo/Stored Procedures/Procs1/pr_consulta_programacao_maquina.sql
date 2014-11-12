
CREATE PROCEDURE pr_consulta_programacao_maquina
-----------------------------------------------------------------------------
--GBS - Global Business Solution	       2002
-----------------------------------------------------------------------------
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
-- 31/08/2004 - Acerto Daniel  C. Neto.
-- 10/09/2004 - Modificado esquema de cálculo de horas disponíveis - Daniel C. neto.
-- 08.02.2005 - 
-- 11.06.2005 - Colocado os Dados do Projeto - Carlos Fernandes
-- 19.06.2005 - Cliente Referente ao Lançamento da Reserva - Carlos Fernandes;
-- 27.08.2005 - Data de Entrega do Comercial no Pedido de Venda - Carlos Fernandes.
-- 04.09.2007 - Mostrar os dados do Produto - Carlos Fernandes
-- 01.11.2007 - Verificação da Ordem de Programação - Carlos Fernandes
-- 22.01.2010 - Novas Colunas de Código/Fantasia/Descrição do Produto - Carlos Fernandes
-- 15.03.2010 - Não Mostrar Op's Canceladas e Encerradas - Carlos Fernandes

--------------------------------------------------------------------------------------------
-- Obs: - Cuidado ao tirar campos desta procedure, pois a mesma
-- é utilizada na tela de programação de produção.
--      - Daniel C. Neto
--------------------------------------------------------------------------------------------
-- Conceitos referentes a somatória dos valores dos Campos:
-- Programadas: - Total de Horas programadas que a máquina recebeu naquele dia.
-- independente se já foram baixadas ou não, já que as horas baixadas já foram perdidas
-- não ficando novamente disponíveis.
-- Disponível: - Total de Capacidade das Horas menos as Programadas.
-- Produzida : - Total de Horas de Processo que tem fim de produção preenchidas.
-- Capacidade: - Total de HOras que a Máquina pode receber naquele dia ( tabela Programacao)
-- ou a somatória da Máquina_Turno.
--- Modificado de Tipo_Maquina para Maquina_Tipo - Daniel C. Neto.
-- 15.03.2010 - Não Mostrar OP's canceladas e Op's Encerradas - Carlos Fernandes/Luis
-- 29.11.2010 - Prazo de Entrega do Pedido de Venda ou OP - Carlos Fernandes
---------------------------------------------------------------------------------------------

@cd_maquina    int,
@dt_base       datetime

AS

--select * from processo_producao_composicao

	SELECT     
	  --Máquina
	  m.cd_maquina,
	  m.nm_fantasia_maquina,
	  m.nm_maquina,
	
	  --Operação
	  o.nm_fantasia_operacao, 
	
	  --Processo
	  pp.cd_identifica_processo, 
    isnull(pp.cd_pedido_venda,ppc.cd_pedido_venda)             as cd_pedido_venda, 
    isnull(pp.cd_item_pedido_venda,ppc.cd_item_pedido_venda)   as cd_item_pedido_venda, 
	  isnull(c.nm_fantasia_cliente,cr.nm_fantasia_cliente) as nm_fantasia_cliente, 
	  ppc.cd_processo, 
	  p.qt_hora_disp_simulacao,
          procpc.cd_seq_processo,
	  ppc.qt_hora_prog_operacao, 
	  ppc.dt_fim_prod_operacao, 
	  ppc.nm_obs_operacao, 
    ( case when IsNull(ppc.ic_antecipada_operacao,'N') = 'S' then 1 else 0 end ) as ic_antecipada_op_tratada,
    ( case when IsNull(ppc.ic_cnc_operacao,'N') = 'S' then 1 else 0 end )        as ic_cnc_operacao_tratada,
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
	  isnull(pvi.nm_produto_pedido,prod.nm_produto) as nm_produto_pedido,
          ppc.cd_reserva_programacao,
          --Carlos 11.06.2005
          --Dados do Projeto
          pj.cd_interno_projeto        as 'Projeto',
          pjc.nm_projeto_composicao,
          pjm.cd_projeto_material,
          pjm.nm_desenho_material,
          pjc.nm_item_desenho_projeto  as 'Composicao',
          pjc.nm_item_desenho_projeto +'/'+cast(pjm.cd_projeto_material as varchar)+'-'+pjm.nm_esp_projeto_material
                                       as 'Material',
       trm.nm_tipo_reserva_maquina     as 'TipoReserva',

          pvi.dt_entrega_vendas_pedido  as EntregaComercial,
          pvi.dt_entrega_fabrica_pedido as EntregaPCP,

          prod.cd_mascara_produto,
          prod.nm_fantasia_produto,
          prod.nm_produto,
          um.sg_unidade_medida,
          pp.qt_planejada_processo,       --Quantidade de Peças da Ordem de Produção / Processo

          --Quantidade de Producao-----------------------------------------------------------
          case when isnull(ppc.qt_item_programacao,0) > 0 then
            ppc.qt_item_programacao
          else
            pp.qt_planejada_processo
          end                           as qt_producao,
   
         pp.dt_canc_processo,
         pp.cd_status_processo,
         pp.dt_entrega_processo

--select * from processo_producao
--select * from pedido_venda_item
         

	into 
	  #Temp
	
	FROM 
	  Maquina m  with (nolock)
      left outer join Grupo_Maquina gm on gm.cd_grupo_maquina = m.cd_grupo_maquina 
      left outer join maquina_tipo tm  on tm.cd_tipo_maquina = m.cd_tipo_maquina 
      left outer join Programacao p    on p.cd_maquina = m.cd_maquina and 
                                          dt_programacao = @dt_base
      left outer join Programacao_Composicao ppc   on p.cd_programacao = ppc.cd_programacao
      left outer join Processo_Producao_Composicao procpc on ppc.cd_processo = procpc.cd_processo and
                                                             ppc.cd_item_processo = procpc.cd_item_processo
      left outer join Operacao o            on o.cd_operacao = ppc.cd_operacao 
      left outer join Processo_Producao pp  on ppc.cd_processo = pp.cd_processo 
      left outer join Pedido_Venda pv       on ISNull(pp.cd_pedido_venda, ppc.cd_pedido_venda) = pv.cd_pedido_venda 

      --Reserva de Máquina
      left outer join Reserva_Programacao  rp         on rp.cd_reserva_programacao = ppc.cd_reserva_programacao
      left outer join Tipo_Reserva_maquina trm        on trm.cd_tipo_reserva_maquina = rp.cd_tipo_reserva_maquina

      left outer join Cliente c             on pv.cd_cliente = c.cd_cliente 
      left outer join Cliente cr            on rp.cd_cliente = cr.cd_cliente
      left outer join Pedido_Venda_Item pvi on pvi.cd_pedido_venda = IsNull(pp.cd_pedido_venda,ppc.cd_pedido_venda) and
                                 	       pvi.cd_item_pedido_venda = IsNull(pp.cd_item_pedido_venda, ppc.cd_item_pedido_venda)

      --Carlos 11.06.2005
      --Dados do Projeto
      left outer join Projeto pj                      on pj.cd_projeto       = pp.cd_projeto
      left outer join Projeto_Composicao pjc          on pjc.cd_projeto      = pp.cd_projeto and
                                                         pjc.cd_item_projeto = pp.cd_item_projeto
      left outer join Projeto_Composicao_Material pjm on pjm.cd_projeto      = pp.cd_projeto and
                                                         pjm.cd_item_projeto = pp.cd_item_projeto and
                                                         pjm.cd_projeto_material = pp.cd_projeto_material
      left outer join Produto prod                    on prod.cd_produto      = pp.cd_produto
      left outer join Unidade_Medida um               on um.cd_unidade_medida = prod.cd_unidade_medida
 	where
	  m.cd_maquina = @cd_maquina
	order by
	  cd_ordem_fab,
	  nm_fantasia_maquina

      --Deleta as Op's Canceladas e Encerradas

      delete from #Temp
      where
        cd_processo <> 0 and
        ( dt_canc_processo is not null or cd_status_processo = 5 )

--select * from processo_producao

	-- Calculando Totais.
	declare @qt_hora_programada float
	declare @qt_hora_capacidade float
	declare @qt_hora_disponivel float
	declare @qt_hora_produzida  float
	declare @qt_hora_antecipada float
	declare @qt_turno           integer

	select 
	  @qt_hora_capacidade = sum(isnull(qt_hora_operacao_maquina,0)),
	  @qt_turno           = count(qt_hora_operacao_maquina)
	from Maquina_Turno with (nolock) 
	where 
	  cd_maquina = @cd_maquina and
	  isnull(ic_operacao,'N')='S'

 select
--  @qt_hora_programada = sum(case when t.dt_fim_prod_operacao is null 
--                           then IsNull(t.qt_hora_prog_operacao,0) else 0 end),
--  @qt_hora_disponivel = IsNull(@qt_hora_capacidade,0) - IsNull(@qt_hora_programada,0),
--  @qt_hora_produzida = sum(case when t.dt_fim_prod_operacao is null 
--                           then 0 else IsNull(t.qt_hora_prog_operacao,0) end),
--  @qt_hora_antecipada = sum(case when (t.dt_fim_prod_operacao is not null) and 
--                                      IsNull(t.ic_antecipada_operacao,'N') = 'S'
--                           then IsNull(t.qt_hora_prog_operacao,0) else 0 end)

  @qt_hora_programada = sum(case when (t.dt_fim_prod_operacao is not null) and 
                                      IsNull(t.ic_antecipada_operacao,'N') = 'S'
                           then  0 else IsNull(t.qt_hora_prog_operacao,0) end),
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
		  ((case when IsNull(p.qt_hora_operacao_maquina,0) = 0 
                  then
                    @qt_hora_capacidade 
                  else
                    IsNull(p.qt_hora_operacao_maquina,0) end) - IsNull(@qt_hora_programada,0)) as qt_hora_disponivel,
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
	
