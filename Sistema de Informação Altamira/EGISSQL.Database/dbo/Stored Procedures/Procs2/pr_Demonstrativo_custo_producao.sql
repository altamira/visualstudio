
create procedure pr_Demonstrativo_custo_producao
-----------------------------------------------------------------
--pr_Demonstrativo_custo_producao
-----------------------------------------------------------------
--Global Business Solution Ltda                             2004
-----------------------------------------------------------------                                                           
--Stored Procedure     : SQL Servecr Microsoft 2000  
--Autor                : Danilo Ribeiro da Silva
--Objetivo             : Demostrativo de Custo de Produção
--Data                 : 16.10.2003
--Atualizado           : 28/11/2003 - Remodelagem/Otimização da SP - DANIEL DUELA
--                     : 01/12/2003 - Acertos nos campos referentes a Movimentação de Estoque  - DANIEL DUELA
--                     : 10/12/2003 - Desenvolvimento do Resumo - DANIEL DUELA
--                     : 16/12/2003 - Acerto na SP conforme documento enviado por Johnny - DANIEL DUELA
--                     : 03.03.2004 - Correção do Cálculo do Valor do DGF e Valores de Arredondamento de Horas - Fabio/Duela
--                     : 21.06.2004 - Cálculo para o tempo de ociosidade da produção. Igor Gama
--                     : 04/01/2005 - Acerto do Cabeçalho - Sérgio Cardoso
----------------------------------------------------------------------------------------------------------
@ic_tipo_consulta int,
@cd_processo int, 
@dt_inicial  datetime, 
@dt_final datetime
as 

  set @cd_processo = isnull(@cd_processo,0)
  set @dt_inicial = isnull(@dt_inicial,'')
  set @dt_final = isnull(@dt_final,'')

  declare
    @vl_despesa int,
    @qt_hora_diaria_agenda float,
    @qt_hora_mes_agenda float,
    @qt_capacidade float

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
   
-------------------------------------------------------------------------------
if @ic_tipo_consulta = 1 -- 'Mão de Obra'
-------------------------------------------------------------------------------
begin
  select 
    pp.cd_processo,
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
      left outer join 
    Operador o 
      on o.cd_operador=ppa.cd_operador
  where 
    pp.cd_processo = @cd_processo
  group by 
    pp.cd_processo,
    o.nm_operador,
    o.vl_hora_operador,
    o.vl_encargo_operador

  select 
    temp1.*,
    temp1.Total_Horas+Total_Encargos as 'Total_Operador'
  from #Temp1 temp1

  drop table #Temp1
end

-------------------------------------------------------------------------------
if @ic_tipo_consulta = 2 -- 'Matéria Prima'
-------------------------------------------------------------------------------
begin
  select distinct 
    pp.cd_processo,
    ppc.cd_componente_processo,
    p.nm_fantasia_produto,
    p.nm_produto,
    um.sg_unidade_medida, 
    ppc.qt_comp_processo,
    me.vl_custo_contabil_produto as 'vl_unitario_movimento',
    ppc.qt_comp_processo * me.vl_custo_contabil_produto as 'Custo_Total'
  from 
    Processo_Producao pp
      inner join 
    Processo_Producao_Composicao pps 
      on pp.cd_processo = pps.cd_processo
      left outer join 
    Processo_Producao_Componente ppc 
      on ppc.cd_processo = pps.cd_processo
      left outer join 
    Movimento_Estoque me 
      on me.cd_movimento_estoque = ppc.cd_movimento_estoque
      left outer join 
    Produto p 
      on ppc.cd_produto = p.cd_produto
      left outer join 
    Unidade_Medida um 
      on ppc.cd_unidade_medida = um.cd_unidade_medida      
  where	 
    pp.cd_processo = @cd_processo
end

-------------------------------------------------------------------------------
if @ic_tipo_consulta = 3 -- Despesas Gerais
-------------------------------------------------------------------------------
begin

  declare @Hora_Processo float
  declare @Hora_Total_Gasto float

  select 
    @Hora_Processo = sum((datediff(n, convert(DateTime, ppa.hr_inicial_apontamento),
                                      convert(DateTime, ppa.hr_final_apontamento))))
  from 
    processo_producao_apontamento ppa
  where 
    cd_processo = @cd_processo

  select 
    @Hora_Total_Gasto = sum((datediff(n, convert(DateTime, ppa.hr_inicial_apontamento),
                                         convert(DateTime, ppa.hr_final_apontamento))))
  from 
    despesa_producao_valor dpv
      left join 
    processo_producao_apontamento ppa 
      on ppa.dt_processo_apontamento between dpv.dt_inicio_despesa_prod and dpv.dt_final_despesa_prod
      left join 
    despesa_producao dp 
      on dpv.cd_despesa_producao = dp.cd_despesa_producao
  where 
    @dt_inicial between dpv.dt_inicio_despesa_prod and dpv.dt_final_despesa_prod and 
    @dt_final between dpv.dt_inicio_despesa_prod and dpv.dt_final_despesa_prod

  select  
    dpv.cd_despesa_producao,
    dp.nm_despesa_producao,
    dpv.vl_despesa_producao as Valor_Total, 
    sum((datediff(n, convert(DateTime, ppa.hr_inicial_apontamento),
                     convert(DateTime, ppa.hr_final_apontamento)))) as Minutos,
    @Hora_Processo as Tempo,
    (dpv.vl_despesa_producao/ @Hora_Processo) * @Hora_Total_Gasto as Total
  from 
    despesa_producao_valor dpv
      left join 
    processo_producao_apontamento ppa 
      on ppa.dt_processo_apontamento between dpv.dt_inicio_despesa_prod and dpv.dt_final_despesa_prod
      left join 
    despesa_producao dp 
      on dpv.cd_despesa_producao = dp.cd_despesa_producao
  where 
    @dt_inicial between dpv.dt_inicio_despesa_prod and dpv.dt_final_despesa_prod and 
    @dt_final between dpv.dt_inicio_despesa_prod and dpv.dt_final_despesa_prod
  group by  
    dpv.cd_despesa_producao,
    dp.nm_despesa_producao,
    dpv.vl_despesa_producao
end

-------------------------------------------------------------------------------
if @ic_tipo_consulta = 4 -- Resumo
-------------------------------------------------------------------------------
begin

  select @vl_despesa = dpv.vl_despesa_producao 
  from 
    despesa_producao_valor dpv
  where 
    @dt_inicial between dpv.dt_inicio_despesa_prod and dpv.dt_final_despesa_prod and 
    @dt_final between dpv.dt_inicio_despesa_prod and dpv.dt_final_despesa_prod

  select 
    pp.cd_processo,
    p.nm_fantasia_produto,
    p.nm_produto,
    pp.qt_planejada_processo,
    u.sg_unidade_medida,    
    @vl_despesa as 'DGF',

    sum(@qt_capacidade - ((cast(datepart(hh, cast(ppa.hr_final_apontamento as datetime)) as float) + 
       (cast(datepart(mi, cast(ppa.hr_final_apontamento as datetime)) as float) /60)) -
      (cast(datepart(hh, cast(ppa.hr_inicial_apontamento as datetime)) as float) + 
       (cast(datepart(mi, cast(ppa.hr_inicial_apontamento as datetime)) as float) /60)))) as 'qt_ociosidade',

    sum((@qt_capacidade - ((cast(datepart(hh, cast(ppa.hr_final_apontamento as datetime)) as float) + 
       (cast(datepart(mi, cast(ppa.hr_final_apontamento as datetime)) as float) /60)) -
      (cast(datepart(hh, cast(ppa.hr_inicial_apontamento as datetime)) as float) + 
       (cast(datepart(mi, cast(ppa.hr_inicial_apontamento as datetime)) as float) /60)))) *  
      isnull(op.vl_operador,0)) as 'Valor_ociosidade',

    cast(dbo.fn_vl_liquido_venda('V',(pvi.qt_item_pedido_venda*pvi.vl_unitario_item_pedido),
                                 pvi.pc_icms_item, pvi.pc_ipi_item, pv.cd_destinacao_produto, @dt_inicial) as decimal(25,2)) as 'Total_PV',
    sum((isnull(cast(ppa.qt_processo_apontamento as decimal(18,2)),0)+ cast(isnull(ppa.qt_setup_apontamento,0) as decimal(18,2)))) as 'Tempo_Apontamento',
    sum((isnull(cast(ppa.qt_processo_apontamento as decimal(18,2)),0)+cast(isnull(ppa.qt_setup_apontamento,0) as decimal(18,2)))*
        isnull(op.vl_operador,0)) as 'Valor_Horas',
    sum((isnull(cast(ppa.qt_processo_apontamento as decimal(18,2)),0)+cast(isnull(ppa.qt_setup_apontamento,0) as decimal(18,2)))*
         isnull(op.vl_encargo_operador,0)) as 'Valor_Encargos'
  into #Temp_1
  from 
    Processo_Producao pp
      left outer join 
    Processo_Producao_Apontamento ppa 
      on pp.cd_processo = ppa.cd_processo
      left outer join 
    Operador_Valor op 
      on ppa.cd_operador = op.cd_operador and
        (op.dt_inicial_operador >= @dt_inicial and 
         op.dt_final_operador <= @dt_final)
      left outer join 
    Pedido_Venda pv
      on pp.cd_pedido_venda = pv.cd_pedido_venda
      left outer join
    Pedido_Venda_Item pvi 
      on pp.cd_pedido_venda = pvi.cd_pedido_venda and
         pp.cd_item_pedido_venda = pvi.cd_item_pedido_venda
      left outer join 
    Produto p 
      on pp.cd_produto = p.cd_produto
      left outer join 
    Unidade_Medida u 
      on p.cd_unidade_medida = u.cd_unidade_medida
  where
    pp.dt_fimprod_processo between @dt_inicial and @dt_final and
    pp.cd_status_processo = 5 --Status ENCERRADO
  group by
    pp.cd_processo, p.nm_fantasia_produto, p.nm_produto,
    qt_planejada_processo, u.sg_unidade_medida,
    pvi.pc_icms_item, pvi.qt_item_pedido_venda, pvi.vl_unitario_item_pedido, 
    pv.cd_destinacao_produto, pvi.pc_ipi_item

  select
    t1.*,
    sum((isnull(ppc.qt_comp_processo,0) * isnull(me.vl_custo_contabil_produto,0))) as 'Valor_Material',
    sum(((isnull(ppc.qt_comp_processo,0) * (isnull(ppc.pc_refugo_processo,0)/100) *
      isnull(me.vl_custo_contabil_produto,0)))) as 'Valor_Refugo'
  into #Temp_2
  from 
    #Temp_1 t1
      left outer join 
    Processo_Producao_Componente ppc 
      on t1.cd_processo = ppc.cd_processo
      left outer join 
    Movimento_Estoque me 
      on ppc.cd_movimento_estoque = me.cd_movimento_estoque
  group by
    t1.cd_processo, t1.nm_fantasia_produto, t1.nm_produto,
    t1.qt_ociosidade, t1.Valor_ociosidade,
    t1.qt_planejada_processo, t1.sg_unidade_medida,
    t1.DGF,t1.Total_PV,t1.Tempo_Apontamento,t1.Valor_Horas,t1.Valor_Encargos

  Select 
    cast(IsNull(sum(Valor_Horas),0) + IsNull(sum(Valor_Encargos),0) as decimal(18,2)) as Valor_Tempo_Total
   into
     #Valor_Total
  from
    #Temp_2

  select 
    *,
  cast( case when vt.Valor_Tempo_Total > 0 then
    ((Valor_Horas + Valor_Encargos) * DGF) / vt.Valor_Tempo_Total
  else
    0 end as decimal(18,4)) as 'Valor_DGF' 
  into #Temp_3
  from #Temp_2,#Valor_Total vt
  
  select 
    *,
    (isnull(Valor_Horas,0)+isnull(Valor_Encargos,0)+isnull(Valor_DGF,0)+
     isnull(Valor_Material,0)) as 'Valor_Proc'
  into #Temp_4
  from #Temp_3

  select 
  * ,
  (Total_PV-Valor_Proc) as 'Dif',
  case when (Valor_Proc)>0 then
    abs(100-(Total_PV*100)/Valor_Proc)
  else
    0 end as 'Margem'
  from #Temp_4


  drop table #Temp_1
  drop table #Temp_2
  drop table #Temp_3
  drop table #Temp_4
end

