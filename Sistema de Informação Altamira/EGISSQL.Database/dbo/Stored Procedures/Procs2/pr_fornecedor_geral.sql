
CREATE PROCEDURE pr_fornecedor_geral
@ic_parametro     int, 
@dt_inicial       datetime,
@dt_final         datetime,
@cd_fornecedor    int,
@cd_mapa          int,
@cd_ano           int

AS

declare @qt_total_categoria int
declare @vl_total_categoria float

-------------------------------------------------------------------------------
if @ic_parametro = 1    -- Resumo de Fornecedor (Filtrado por Período) 
-------------------------------------------------------------------------------
begin
  select
    pc.cd_fornecedor,
    f.nm_fantasia_fornecedor,
    pc.cd_comprador,
    c.nm_fantasia_comprador,
    sum(pc.vl_total_pedido_compra) as 'Total_Compras',
    max(pc.dt_pedido_compra)       as 'Utima_Compra',
    count(distinct pc.cd_pedido_compra)     as 'Qtd_Pedidos'
  into #Resumo
  from Pedido_Compra pc
  left outer join Fornecedor f
    on f.cd_fornecedor=pc.cd_fornecedor
  left outer join Comprador c
    on c.cd_comprador=pc.cd_comprador
  where 
    (pc.dt_pedido_compra between @dt_inicial and @dt_final) and
     pc.dt_cancel_ped_compra is null
  group by 
    f.nm_fantasia_fornecedor, 
    pc.cd_fornecedor, 
    c.nm_fantasia_comprador, 
    pc.cd_comprador
  order by Total_Compras desc

  declare @qt_total_fornecedor int
  declare @vl_total_fornecedor float
  -- Total de Cliente
  set @qt_total_fornecedor = @@rowcount
  -- Total de Vendas Geral
  set @vl_total_fornecedor = 0
  select @vl_total_fornecedor = @vl_total_fornecedor + Total_Compras
  from
    #Resumo

  select 
    identity(int, 1,1) as 'Posicao',
    res.*,
    cast(((Total_Compras/@vl_total_fornecedor)*100) as decimal (15,2)) as 'Perc_Total'
  into #TotalResumo
  from #Resumo res
  Order by Total_Compras desc

  select * from #TotalResumo

  drop table #Resumo
  drop table #TotalResumo
end

-------------------------------------------------------------------------------
if @ic_parametro = 2    -- Resumo de Plano de Compra (Filtrado por Período) 
-------------------------------------------------------------------------------
begin
  select
    pc.cd_plano_compra,
    plc.nm_plano_compra,
    sum(pc.vl_total_pedido_compra) as 'Total_Compras',
    count(distinct pc.cd_pedido_compra)     as 'Qtd_Pedidos'
  into #Categoria
  from Pedido_Compra pc
  left outer join Plano_Compra plc
    on plc.cd_plano_compra=pc.cd_plano_compra
  where 
     pc.cd_fornecedor=@cd_fornecedor and
    (pc.dt_pedido_compra between @dt_inicial and @dt_final) and
     pc.dt_cancel_ped_compra is null
  group by 
    pc.cd_plano_compra, plc.nm_plano_compra
  order by Total_Compras desc

  -- Total de Cliente
  set @qt_total_categoria = @@rowcount
  -- Total de Vendas Geral
  set @vl_total_categoria = 0
  select @vl_total_categoria = @vl_total_categoria + Total_Compras
  from
    #Categoria

  select 
    c.*,
    cast(((Total_Compras/@vl_total_categoria)*100) as decimal (15,2)) as 'Perc_Total'
  from #Categoria c
  Order by Total_Compras desc

  drop table #Categoria
end

-------------------------------------------------------------------------------
if @ic_parametro = 3    -- Consulta de Pedido de Compra (Filtrado por Fornecedor e Período)  
-------------------------------------------------------------------------------
begin
-- Geração da Tabela Auxiliar de Vendas por Cliente
select 
    a.cd_pedido_compra, 
    a.dt_pedido_compra, 
    b.cd_item_pedido_compra, 
    b.qt_item_pedido_compra, 
    dbo.fn_mascara_produto(b.cd_produto) as 'cd_mascara_produto',
    IsNull(b.nm_fantasia_produto, s.nm_servico) as 'nm_fantasia_produto',
    IsNull(b.nm_produto, s.nm_servico) as 'nm_produto',
    b.qt_item_pedido_compra * b.vl_item_unitario_ped_comp as 'total',
    b.dt_entrega_item_ped_compr,
    b.qt_saldo_item_ped_compra,
    b.vl_item_unitario_ped_comp
  from
    Pedido_Compra a left outer join 
    Pedido_Compra_item b on a.cd_pedido_compra = b.cd_pedido_compra left outer join
    Servico s on s.cd_servico = b.cd_servico
  where
   a.cd_fornecedor = @cd_fornecedor                      and
   a.dt_cancel_ped_compra is null                        and
   (a.dt_pedido_compra between @dt_inicial and @dt_final) and 
   a.cd_plano_compra = @cd_mapa                         

  order by total desc
end

-------------------------------------------------------------------------------
if @ic_parametro = 4    -- Consulta de Nota de Entrada (Filtrado por Fornecedor e Período) 
-------------------------------------------------------------------------------
begin
  select ne.cd_nota_entrada, 
       ne.dt_nota_entrada,
       nei.cd_item_nota_entrada, 
       nei.qt_item_nota_entrada,
       nei.nm_produto_nota_entrada,
       (nei.qt_item_nota_entrada*nei.vl_item_nota_entrada) as 'total',
       nei.cd_pedido_compra,
       nei.cd_item_pedido_compra
  from
    Nota_Entrada ne 
  left outer join Nota_Entrada_Item nei on 
    nei.cd_nota_entrada = ne.cd_nota_entrada
  left outer join Pedido_Compra_Item pci on 
    pci.cd_pedido_compra = nei.cd_pedido_compra and
    pci.cd_item_pedido_compra = nei.cd_item_pedido_compra
  left outer join Operacao_Fiscal op on 
    op.cd_operacao_fiscal = ne.cd_operacao_fiscal
  where
    (ne.dt_nota_entrada between @dt_inicial and @dt_final)  and
    ne.cd_fornecedor = @cd_fornecedor                       and
    op.ic_comercial_operacao   = 'S'                        and
    (nei.qt_item_nota_entrada*nei.vl_item_nota_entrada)>0
  order by total desc
end

-------------------------------------------------------------------------------
if @ic_parametro = 5    -- Resumo Anual (Filtrado por Fornecedor e Ano) 
-------------------------------------------------------------------------------
begin
-- Geração da Tabela Auxiliar de Vendas por Cliente
  select 
    f.nm_fantasia_fornecedor       as 'Fornecedor',
    month(a.dt_pedido_compra)    as 'Mes', 
    sum(a.vl_total_pedido_compra) as 'Total'
  into #CompraFornecedorMes
  from
    Pedido_Compra a 
  left outer join Fornecedor f on 
    f.cd_fornecedor = a.cd_fornecedor
  where
    a.cd_fornecedor=@cd_fornecedor   and
    year(a.dt_pedido_compra)=@cd_ano and
    a.dt_cancel_ped_compra is null   
  group by a.cd_fornecedor,month(a.dt_pedido_compra), f.nm_fantasia_fornecedor
  order by 2 desc

--Mostra tabela ao usuário com Resumo Mensal

  select 
    a.Fornecedor,
    sum( a.total )                                    as 'TotalCompra', 
    sum( case a.mes when 1  then a.total else 0 end ) as 'Jan',
    sum( case a.mes when 2  then a.total else 0 end ) as 'Fev',
    sum( case a.mes when 3  then a.total else 0 end ) as 'Mar',
    sum( case a.mes when 4  then a.total else 0 end ) as 'Abr',
    sum( case a.mes when 5  then a.total else 0 end ) as 'Mai',
    sum( case a.mes when 6  then a.total else 0 end ) as 'Jun',
    sum( case a.mes when 7  then a.total else 0 end ) as 'Jul',
    sum( case a.mes when 8  then a.total else 0 end ) as 'Ago',
    sum( case a.mes when 9  then a.total else 0 end ) as 'Set',
    sum( case a.mes when 10 then a.total else 0 end ) as 'Out',
    sum( case a.mes when 11 then a.total else 0 end ) as 'Nov',
    sum( case a.mes when 12 then a.total else 0 end ) as 'Dez' 
  from #CompraFornecedorMes a
  group by a.Fornecedor
end

