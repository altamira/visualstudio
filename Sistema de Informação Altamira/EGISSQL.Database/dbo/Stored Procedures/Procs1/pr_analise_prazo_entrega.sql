
create procedure pr_analise_prazo_entrega

@ic_parametro int,
@dt_inicial as dateTime,
@dt_final as dateTime

as

declare @vl_total float

-----------------------------------------------------------
if @ic_parametro = 1 -- VENDAS
-----------------------------------------------------------
begin

-- Verificação da tabela de Parâmetro de Análise do BI
  select
    qt_inicial_prazo,
    qt_final_prazo,
    cd_parametro_prazo,    
    nm_parametro_prazo,
    qt_ordem_prazo
  into
    #Periodo
  from
    Parametro_Analise_Prazo_Entrega

--Montagem do Arquivo com os Valores por Dia
  select
    cast((pvi.dt_entrega_vendas_pedido-pv.dt_pedido_venda) as integer) as 'DiasAtraso',
    sum(isnull(pvi.qt_item_pedido_venda,0)*isnull(pvi.vl_unitario_item_pedido,0)) as 'Valor'
  into #Temp
  from
    Pedido_Venda_Item pvi
  left outer join Pedido_Venda pv on
    pvi.cd_pedido_venda=pv.cd_pedido_venda
  where
    pvi.qt_saldo_pedido_venda > 0  and
    isnull(pvi.dt_entrega_vendas_pedido,'') <> '' and
    (pvi.dt_entrega_vendas_pedido between @dt_inicial and @dt_final)    
  group by 
    pvi.dt_entrega_vendas_pedido, pv.dt_pedido_venda
  order by
    1


  select
    p.cd_parametro_prazo,
    count('x') as 'Qtd',
    sum(t.Valor) as 'Valor'
  into #Temp_1
  from
    #Periodo p 
  inner join #Temp t on 
    t.DiasAtraso between p.qt_inicial_prazo and p.qt_final_prazo
  group by
    p.cd_parametro_prazo

  set @vl_total = ( select sum(Valor) from #Temp_1)

  select 
     t1.*,
     p.nm_parametro_prazo,
    ((t1.Valor * 100) / @vl_total ) as 'perc'
  from
    #Temp_1 t1 
  left outer join #Periodo p on 
    p.cd_parametro_prazo = t1.cd_parametro_prazo
  order by
    p.qt_ordem_prazo
end

-----------------------------------------------------------
if @ic_parametro = 2 -- FATURAMENTO
-----------------------------------------------------------
begin

-- Verificação da tabela de Parâmetro de Análise do BI
  select
    qt_inicial_prazo,
    qt_final_prazo,
    cd_parametro_prazo,    
    nm_parametro_prazo,
    qt_ordem_prazo
  into
    #Periodo_1
  from
    Parametro_Analise_Prazo_Entrega

--Montagem do Arquivo com os Valores por Dia
  select
    cast((ns.dt_saida_nota_saida-ns.dt_nota_saida) as integer) as 'DiasAtraso',
    sum(isnull(vl_total,0)) as 'Valor'
  into #Temp_2
  from
    Nota_Saida ns
  where
    isnull(ns.dt_saida_nota_saida,'') <> '' and
    ns.dt_saida_nota_saida between @dt_inicial and @dt_final
  group by 
    ns.dt_saida_nota_saida, ns.dt_nota_saida
  order by
    1

  select
    p1.cd_parametro_prazo,
    count('x') as 'Qtd',
    sum(t2.Valor) as 'Valor'
  into #Temp_3
  from
    #Periodo_1 p1 
  inner join #Temp_2 t2 on 
    t2.DiasAtraso between p1.qt_inicial_prazo and p1.qt_final_prazo
  group by
    p1.cd_parametro_prazo

  set @vl_total = ( select sum(Valor) from #Temp_3)

  select 
     t3.*,
     p1.nm_parametro_prazo,
    ((t3.Valor * 100) / @vl_total ) as 'perc'
  from
    #Temp_3 t3 
  left outer join #Periodo_1 p1 on 
    p1.cd_parametro_prazo = t3.cd_parametro_prazo
  order by
    p1.qt_ordem_prazo
end

