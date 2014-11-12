
CREATE PROCEDURE pr_exportador_geral
@ic_parametro     int      = 1, 
@dt_inicial       datetime = '',
@dt_final         datetime = '',
@cd_exportador    int      = 0,
@cd_ano           int      = 0,
@cd_vendedor      int      = 0

AS

-- select * from vw_venda_bi
-- select * from vw_faturamento_bi

-------------------------------------------------------------------------------
if @ic_parametro = 1    -- Resumo de exportadores (Filtrado por Período) 
-------------------------------------------------------------------------------
begin
  select
    pv.cd_exportador,
    ex.nm_fantasia,
    isnull(pv.cd_vendedor_pedido,0)         as cd_vendedor_pedido,
    isnull(v.nm_fantasia_vendedor,'')       as nm_fantasia_vendedor,
    isnull(sum(pv.vl_total_pedido_venda),0) as 'Total_Vendas',
    max(pv.dt_pedido_venda)                 as 'Utima_Venda',
    count(distinct pv.cd_pedido_venda)      as 'Qtd_Pedidos'
  into 
    #Resumo
  from 
    vw_venda_bi pv
    left outer join Exportador ex on ex.cd_exportador = pv.cd_exportador
    left outer join Vendedor v    on v.cd_vendedor    = pv.cd_vendedor_pedido
  where 
    (pv.dt_pedido_venda between @dt_inicial and @dt_final) and
     pv.dt_cancelamento_pedido is null
  group by 
    ex.nm_fantasia, 
    pv.cd_exportador, 
    v.nm_fantasia_vendedor, 
    pv.cd_vendedor_pedido
  order by 
    Total_Vendas desc

  declare @qt_total_exportador int
  declare @vl_total_exportador float

  -- Total de Cliente
  set @qt_total_exportador = @@rowcount

  -- Total de Vendas Geral
  set @vl_total_exportador = 0
  select 
    @vl_total_exportador = @vl_total_exportador + Total_Vendas
  from
    #Resumo

  select 
    identity(int, 1,1) as 'Posicao',
    res.*,
    cast(((Total_Vendas/@vl_total_exportador)*100) as decimal (15,2)) as 'Perc_Total'
  into 
    #TotalResumo
  from 
    #Resumo res
  Order by 
    Total_Vendas desc

  select * from #TotalResumo

  drop table #Resumo
  drop table #TotalResumo
end

-------------------------------------------------------------------------------
if @ic_parametro = 2 -- Consulta de Pedido de Venda (Filtrado por Exportador e Período)
-------------------------------------------------------------------------------
begin
  select 
    pv.cd_pedido_venda, 
    pv.dt_pedido_venda, 
    pv.cd_item_pedido_venda, 
    pv.qt_item_pedido_venda,
    dbo.fn_mascara_produto(pv.cd_produto) as 'cd_mascara_produto',
    IsNull(pv.nm_fantasia_produto, s.nm_servico) as 'nm_fantasia_produto',
    IsNull(pv.nm_produto, s.nm_servico) as 'nm_produto',
   (pv.qt_item_pedido_venda * pv.vl_unitario_item_pedido) as 'total',
    pv.dt_entrega_vendas_pedido,
    pv.qt_saldo_pedido_venda,
    pv.vl_unitario_item_pedido
  from
    vw_venda_bi pv 
    --left outer join Pedido_venda_item pvi on a.cd_pedido_venda = b.cd_pedido_compra 
    left outer join Servico s             on s.cd_servico = pv.cd_servico
  where
    isnull(pv.cd_exportador,0) = isnull(@cd_exportador,0) and
    pv.dt_cancelamento_pedido is null and
   (pv.dt_pedido_venda between @dt_inicial and @dt_final) and
    isnull(pv.cd_vendedor_pedido,0) = isnull(@cd_vendedor,0)
  order by 
    total desc
end

-------------------------------------------------------------------------------
if @ic_parametro = 3    -- Resumo Anual (Filtrado por Fornecedor e Ano) 
-------------------------------------------------------------------------------
begin
  select 
    ex.nm_fantasia                 as 'Exportador',
    month(vw.dt_pedido_venda)      as 'Mes', 
    sum(vw.vl_total_pedido_venda)  as 'Total'
  into 
    #VendaExportadorMes
  from
    vw_venda_bi vw 
    left outer join Exportador ex on ex.cd_exportador = vw.cd_exportador
  where
    isnull(vw.cd_exportador,0) = isnull(@cd_exportador,0) and
    isnull(vw.cd_vendedor,0)   = isnull(@cd_vendedor,0)   and
    year(vw.dt_pedido_venda)   = @cd_ano                  and
    vw.dt_cancelamento_pedido is null   
  group by 
    vw.cd_exportador,
    month(vw.dt_pedido_venda), 
    ex.nm_fantasia
  order by 
    2 desc

  --Mostra tabela ao usuário com Resumo Mensal

  select 
    vw.Exportador,
    sum( vw.total )                                    as 'TotalVenda', 
    sum( case vw.mes when 1  then vw.total else 0 end ) as 'Jan',
    sum( case vw.mes when 2  then vw.total else 0 end ) as 'Fev',
    sum( case vw.mes when 3  then vw.total else 0 end ) as 'Mar',
    sum( case vw.mes when 4  then vw.total else 0 end ) as 'Abr',
    sum( case vw.mes when 5  then vw.total else 0 end ) as 'Mai',
    sum( case vw.mes when 6  then vw.total else 0 end ) as 'Jun',
    sum( case vw.mes when 7  then vw.total else 0 end ) as 'Jul',
    sum( case vw.mes when 8  then vw.total else 0 end ) as 'Ago',
    sum( case vw.mes when 9  then vw.total else 0 end ) as 'Set',
    sum( case vw.mes when 10 then vw.total else 0 end ) as 'Out',
    sum( case vw.mes when 11 then vw.total else 0 end ) as 'Nov',
    sum( case vw.mes when 12 then vw.total else 0 end ) as 'Dez' 
  from 
    #VendaExportadorMes vw
  group by 
    vw.Exportador
end

