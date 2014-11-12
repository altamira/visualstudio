create procedure pr_demonstrativo_custo_projeto
----------------------------------------------------------------------
--Global Business Solution                                        2004
--SQL SERVER 2000
--Autor : Igor Gama
--Data : 27.07.2004
--Alteração: 22/09/2004 - Alterado para Dividir o Valor do Custo Total do Produto_Fechamento
--                        pela Quantidade para demonstrar o Custo Unitário - ELIAS
--Objetivo: Montar demostrativo de custo através dos projetos cadastrados
----------------------------------------------------------------------
@ic_parametro int,
@cd_projeto int,
@cd_item_projeto int,
@ic_procfab_projeto char(1) = 'N',
@ic_terceiro char(1) = 'N',
@dt_inicial  datetime, 
@dt_final datetime
as 

  set @dt_inicial = isnull(@dt_inicial,'')
  set @dt_final = isnull(@dt_final,'')
  Set @ic_procfab_projeto = isnull(@ic_procfab_projeto,'N')
  Set @ic_terceiro = isnull(@ic_terceiro,'N')

  declare
    @vl_despesa int,
    @qt_hora_diaria_agenda float,
    @qt_hora_mes_agenda float,
    @qt_capacidade float,
    @cd_fase_produto int

  --Seta a fase do produto
  select @cd_fase_produto = cd_fase_produto 
  from parametro_comercial 
  where cd_empresa = dbo.fn_empresa()

  --Pega a quantidade de horas no mês
  Select
    @qt_hora_diaria_agenda  = qt_hora_diaria_agenda,
    @qt_hora_mes_agenda = qt_hora_mes_agenda
  From
    Parametro_agenda
  Where 
    cd_empresa = dbo.fn_empresa()


  --Cálculo de Capacidade
  select @qt_capacidade = (dbo.fn_GetQtdDiaUtilPeriodo(@dt_inicial, @dt_final, 'U') * @qt_hora_diaria_agenda)
   
------------------------------------------------------------------------------
	if @ic_parametro = 1 -- 'Mão de Obra'
-------------------------------------------------------------------------------
	begin
	  select 
	    pc.cd_projeto,
	    o.nm_operador,
	    cast(o.vl_hora_operador as decimal(15,2)) as vl_hora_operador,
	    cast(o.vl_encargo_operador as decimal(15,2)) as vl_encargo_operador,      
	    cast(sum((o.vl_encargo_operador / 60) *
	            (datediff(n,convert(DateTime, ppa.hr_inicial_apontamento),
	                        convert(DateTime, ppa.hr_final_apontamento)))) as decimal(15,2)) as 'Total_Encargos',
	    cast(sum((o.vl_hora_operador / 60) *
	            (datediff(n,
	             convert(DateTime, ppa.hr_inicial_apontamento),
	             convert(DateTime, ppa.hr_final_apontamento)))) as decimal(15,2)) as 'Total_Horas',
	    sum(@qt_capacidade - ((cast(datepart(hh, cast(ppa.hr_final_apontamento as datetime)) as float) + 
	       (cast(datepart(mi, cast(ppa.hr_final_apontamento as datetime)) as float) /60)) -
	      (cast(datepart(hh, cast(ppa.hr_inicial_apontamento as datetime)) as float) + 
	       (cast(datepart(mi, cast(ppa.hr_inicial_apontamento as datetime)) as float) /60)))) as 'qt_ociosidade',
	    sum((@qt_capacidade - ((cast(datepart(hh, cast(ppa.hr_final_apontamento as datetime)) as float) + 
	       (cast(datepart(mi, cast(ppa.hr_final_apontamento as datetime)) as float) /60)) -
	      (cast(datepart(hh, cast(ppa.hr_inicial_apontamento as datetime)) as float) + 
	       (cast(datepart(mi, cast(ppa.hr_inicial_apontamento as datetime)) as float) /60)))) *  
	      isnull(o.vl_hora_operador,0)) as 'Valor_ociosidade',
	    sum(cast(ppa.qt_processo_apontamento as decimal(18,2))) as 'Tempo_Total',
	    cast(sum((O.vl_encargo_operador / 60) *
	            (datediff(n,convert(DateTime, ppa.hr_inicial_apontamento),
	                        convert(DateTime, ppa.hr_final_apontamento))) +
	            (O.vl_hora_operador / 60) *
	            (datediff(n,convert(DateTime, ppa.hr_inicial_apontamento),
	                        convert(DateTime, ppa.hr_final_apontamento)))) as decimal(15,2)) as 'Custo_Total' 
	  into #Temp1
	  from 
	    Processo_Producao pp
	      inner join 
	    Processo_Producao_Apontamento ppa 
	      on pp.cd_processo = ppa.cd_processo
	      inner join
      Projeto_composicao pc
	      on pp.cd_projeto = pc.cd_projeto and
	         pp.cd_item_projeto = pc.cd_item_projeto
	      left outer join 
	    Operador o 
	      on o.cd_operador = ppa.cd_operador
	  where 
	    pc.cd_projeto = @cd_projeto and
      pc.cd_item_projeto = case when @cd_item_projeto = 0 then pc.cd_item_projeto else @cd_item_projeto end
	  group by 
	    pc.cd_projeto,
	    o.nm_operador,
	    o.vl_hora_operador,
	    o.vl_encargo_operador

	  select 
	    temp1.*,
	    temp1.Total_Horas + Total_Encargos as 'Total_Operador'
	  from #Temp1 temp1
	
	  drop table #Temp1
  end
------------------------------------------------------------------------------
  if @ic_parametro = 2  --Retornar dados do Projeto
------------------------------------------------------------------------------
  begin
	  select 
		  p.cd_projeto,
		  p.dt_entrada_projeto,
		  p.cd_interno_projeto,
		  p.nm_produto_cliente,
		  p.ds_projeto,
		  p.cd_status_projeto,
		  p.nm_projeto,
		  p.cd_cliente,
		  p.nm_desenho_projeto,
		  p.dt_entrega_cliente,
-- 		  pc.cd_item_projeto,
-- 		  pc.nm_item_desenho_projeto,
		  c.nm_fantasia_cliente
		from  
		  projeto p
-- 		    left outer join
-- 		  projeto_composicao pc
-- 		    on p.cd_projeto = pc.cd_projeto
		    left outer join
		  cliente c
		    on p.cd_cliente = c.cd_cliente
		where 
		  p.cd_projeto = @cd_projeto --and
-- 		  pc.cd_item_projeto = case when @cd_item_projeto = 0 then pc.cd_item_projeto else @cd_item_projeto end

------------------------------------------------------------------------------
  end else if @ic_parametro = 3  --Trazer os dados de Comprados ou Fabricados
------------------------------------------------------------------------------
  begin

		select
		  pjcm.cd_projeto,
		  pjcm.cd_item_projeto,
	    sum(pjcm.qt_projeto_material) as 'qt_projeto_material',
		  u.sg_unidade_medida,
	    p.cd_produto,
	    p.nm_fantasia_produto,
	    p.nm_produto,
      ppc.cd_servico_especial,
      se.nm_servico_especial,
      se.vl_servico_especial
    into #Tb1
		from
		  Projeto_Composicao_Material pjcm
	      inner join 
	    Projeto_Composicao pjc 
	      on pjcm.cd_projeto = pjc.cd_projeto and
	         pjcm.cd_item_projeto = pjc.cd_item_projeto
	      left outer join 
	    Processo_Producao pp 
	      on pjcm.cd_projeto = pp.cd_projeto and
	         pjcm.cd_item_projeto = pp.cd_item_projeto and
	         pjcm.cd_projeto_material = pp.cd_projeto_material
	      left outer join 
      Processo_Producao_Composicao ppc
        on pp.cd_processo = ppc.cd_processo
        left outer join
	    Unidade_Medida u 
	      on pjcm.cd_unidade_medida = u.cd_unidade_medida
	      left outer join 
	    Tipo_Produto_Projeto tpj 
	      on pjcm.cd_tipo_produto_projeto = tpj.cd_tipo_produto_projeto
	      left outer join
	    Produto p
	      on pjcm.cd_produto = p.cd_produto
	      left outer join
      Servico_Especial se
        on ppc.cd_servico_especial = se.cd_servico_especial
		where
	    pjcm.cd_projeto = @cd_projeto and
	    pjcm.cd_item_projeto = case when @cd_item_projeto = 0 then pjcm.cd_item_projeto else @cd_item_projeto end and
	    isnull(tpj.ic_procfab_projeto,'N') = @ic_procfab_projeto and
      isnull(ppc.cd_servico_especial,0) = case when (@ic_terceiro = 'S') and (@ic_procfab_projeto = 'S') then se.cd_servico_especial else isnull(ppc.cd_servico_especial,0) end
    group by
      pjcm.cd_projeto,
      pjcm.cd_item_projeto,
      u.sg_unidade_medida,
      p.cd_produto,
      p.nm_fantasia_produto,
      p.nm_produto,
      ppc.cd_servico_especial,
      se.nm_servico_especial,
      se.vl_servico_especial
    order by
      pjcm.cd_item_projeto,
      p.nm_fantasia_produto

    select *,
      (select top 1 (vl_custo_prod_fechamento / (case when isnull(qt_atual_prod_fechamento,0) = 0 
                                                   then 1 else qt_atual_prod_fechamento end)) from Produto_Fechamento
       where cd_fase_produto = @cd_fase_produto and isnull(vl_custo_prod_fechamento,0) > 0 and
             cd_produto = t.cd_produto order by dt_produto_fechamento desc) as 'vl_custo',
      cast(0.00 as float) as 'vl_custo_total'
    into #Tabela
    from #Tb1 t

    update #Tabela
    set vl_custo = case When @ic_terceiro = 'S' then vl_servico_especial else vl_custo end,
        vl_custo_total = (qt_projeto_material * vl_custo)

    Select * from #Tabela
    order by
      cd_item_projeto,
      nm_fantasia_produto

  end
	-------------------------------------------------------------------------------
	if @ic_parametro = 4 -- Despesas Gerais
	-------------------------------------------------------------------------------
	begin
	
	  declare @Hora_Projeto float
	  declare @Hora_Total_Gasto float
	
	  select 
	    @Hora_Projeto = sum((datediff(n, convert(DateTime, ppa.hr_inicial_apontamento),
	                                      convert(DateTime, ppa.hr_final_apontamento))))
	  from 
	    processo_producao_apontamento ppa
        inner join
      processo_producao pp
        on ppa.cd_processo = pp.cd_processo
	  where 
	    pp.cd_projeto = @cd_projeto and
      pp.cd_item_projeto = case when @cd_item_projeto = 0 then pp.cd_item_projeto else @cd_item_projeto end
      
	  select 
	    @Hora_Total_Gasto = sum((datediff(n, convert(DateTime, ppa.hr_inicial_apontamento),
	                                         convert(DateTime, ppa.hr_final_apontamento))))
	  from 
	    despesa_producao_valor dpv
	      inner join
	    processo_producao_apontamento ppa 
	      on ppa.dt_processo_apontamento between dpv.dt_inicio_despesa_prod and dpv.dt_final_despesa_prod
	      inner join 
	    despesa_producao dp 
	      on dpv.cd_despesa_producao = dp.cd_despesa_producao
        inner join
      processo_producao pp
        on ppa.cd_processo = pp.cd_processo
	  where 
      pp.cd_projeto = @cd_projeto and
      pp.cd_item_projeto = case when @cd_item_projeto = 0 then pp.cd_item_projeto else @cd_item_projeto end and
	    @dt_inicial between dpv.dt_inicio_despesa_prod and dpv.dt_final_despesa_prod and 
	    @dt_final between dpv.dt_inicio_despesa_prod and dpv.dt_final_despesa_prod
	
	  select  
	    dpv.cd_despesa_producao,
	    dp.nm_despesa_producao,
	    dpv.vl_despesa_producao as Valor_Total, 
	    sum((datediff(n, convert(DateTime, ppa.hr_inicial_apontamento),
	                     convert(DateTime, ppa.hr_final_apontamento)))) as Minutos,
	    @Hora_Projeto as Tempo,
	    (dpv.vl_despesa_producao/ @Hora_Projeto) * @Hora_Total_Gasto as Total
	  from 
	    despesa_producao_valor dpv
	      inner join 
	    processo_producao_apontamento ppa 
	      on ppa.dt_processo_apontamento between dpv.dt_inicio_despesa_prod and dpv.dt_final_despesa_prod
	      inner join 
	    despesa_producao dp 
	      on dpv.cd_despesa_producao = dp.cd_despesa_producao
        inner join
      processo_producao pp
        on ppa.cd_processo = pp.cd_processo
	  where 
      pp.cd_projeto = @cd_projeto and
      pp.cd_item_projeto = case when @cd_item_projeto = 0 then pp.cd_item_projeto else @cd_item_projeto end and
	    @dt_inicial between dpv.dt_inicio_despesa_prod and dpv.dt_final_despesa_prod and 
	    @dt_final between dpv.dt_inicio_despesa_prod and dpv.dt_final_despesa_prod
	  group by  
	    dpv.cd_despesa_producao,
	    dp.nm_despesa_producao,
	    dpv.vl_despesa_producao
    order by
      dpv.cd_despesa_producao
	
	end
