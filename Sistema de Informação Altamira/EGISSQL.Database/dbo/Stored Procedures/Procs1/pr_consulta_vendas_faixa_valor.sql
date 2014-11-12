
create procedure pr_consulta_vendas_faixa_valor 

@ic_parametro int      = 0,
@cd_parametro int      = 0,
@dt_inicial   datetime = '',
@dt_final     datetime = ''


as

-----------------------------------------------------------
if @ic_parametro = 1 -- Resumo
-----------------------------------------------------------
begin
  declare @vl_total float

-- Verificação da tabela de Parâmetro de Análise 

  --select * from faixa_valor_pedido_venda

  select
    *
  into
    #Periodo
  from
    Faixa_Valor_Pedido_Venda

--Montagem do Arquivo com os Valores 

  select
    p.cd_pedido_venda,
    isnull(p.vl_total_pedido_venda,0) as Valor_Pedido,
    p.cd_vendedor,
    p.cd_cliente
  into
    #MovimentoPedido
  from
    pedido_venda p    with (nolock) 
  where
    p.dt_pedido_venda between @dt_inicial and @dt_final and
    p.dt_cancelamento_pedido is null                    and
    isnull(p.vl_total_pedido_venda,0)>0   

  select
    p.cd_faixa_valor,
    sum(d.Valor_Pedido)      as 'Valor_Pedido',
    count(d.cd_pedido_venda) as 'Qtd_Pedido',
    count(distinct d.cd_cliente)      as 'Qtd_Cliente',
    count(distinct d.cd_vendedor)     as 'Qtd_Vendedor'
  into #TempPedido
  from
    #Periodo p 
  inner join #MovimentoPedido d on d.Valor_Pedido between p.vl_inicial_faixa_valor and p.vl_final_faixa_valor
    
  group by
    p.cd_faixa_valor

  set @vl_total = (select sum(Qtd_Pedido) from #TempPedido)

  select 
    t.*,
    p.nm_faixa_valor,
    ((t.Qtd_Pedido * 100) / @vl_total ) as 'perc'
  from
    #TempPedido t
  left outer join #Periodo p on p.cd_faixa_valor = t.cd_faixa_valor
  order by
    p.qt_ordem_faixa_valor

end

----------------------------------------------
else -- Pedidos de Venda
----------------------------------------------
begin

  declare @vl_inicial_faixa_valor  float
  declare @vl_final_faixa_valor    float
  declare @nm_faixa_valor          varchar(40)

-- Verificação da tabela de Parâmetro de Análise do SCE

  select
    @vl_inicial_faixa_valor = isnull(vl_inicial_faixa_valor,0),
    @vl_final_faixa_valor   = isnull(vl_final_faixa_valor,0),
    @nm_faixa_valor         = isnull(nm_faixa_valor,'') 
  from
    Faixa_Valor_Pedido_Venda
  where
    cd_faixa_valor = @cd_parametro

--Montagem do Arquivo com os Valores 

  select
    @nm_faixa_valor                   as 'Faixa_Valor',
    p.cd_pedido_venda,
    p.dt_pedido_venda,
    isnull(p.vl_total_pedido_venda,0) as Valor_Pedido,
    p.cd_cliente,
    p.cd_vendedor,
    c.nm_fantasia_cliente,
    v.nm_fantasia_vendedor,
    cr.nm_cliente_regiao,
    cv.nm_criterio_visita    

  from
    pedido_venda p                     with (nolock) 
    inner join cliente c               with (nolock) on c.cd_cliente          = p.cd_cliente
    inner join vendedor v              with (nolock) on v.cd_vendedor         = p.cd_vendedor
    left outer join cliente_regiao cr  with (nolock) on cr.cd_cliente_regiao  = c.cd_regiao
    left outer join criterio_visita cv with (nolock) on cv.cd_criterio_visita = c.cd_criterio_visita
  where
    p.dt_pedido_venda between @dt_inicial and @dt_final and
    p.dt_cancelamento_pedido is null                    and
    isnull(p.vl_total_pedido_venda,0)>0                 and
    isnull(p.vl_total_pedido_venda,0) between @vl_inicial_faixa_valor and @vl_final_faixa_valor 
  order by
    c.nm_fantasia_cliente

end

