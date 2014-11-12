
CREATE PROCEDURE pr_fornecedor_importacao
@ic_parametro     int, 
@dt_inicial       datetime,
@dt_final         datetime,
@cd_fornecedor    int,
@cd_categoria_produto int,
@cd_ano           int

AS

declare @qt_total_categoria int
declare @vl_total_categoria float

-------------------------------------------------------------------------------
if @ic_parametro = 1    -- Resumo de Fornecedor Importacao (Filtrado por Período) 
-------------------------------------------------------------------------------
begin
  select
    pei.cd_fornecedor,
    f.nm_fantasia_fornecedor,
    pei.cd_comprador,
    c.nm_fantasia_comprador,
    isnull(sum(pei.vl_pedido_importacao),0) as 'Total_Compras',
    max(pei.dt_pedido_importacao)       as 'Utima_Compra',
    count(distinct pei.cd_pedido_importacao)     as 'Qtd_Pedidos'
  into #Resumo
  from Pedido_Importacao pei
  left outer join Fornecedor f
    on f.cd_fornecedor=pei.cd_fornecedor
  left outer join Comprador c
    on c.cd_comprador=pei.cd_comprador
   where 
     (pei.dt_pedido_importacao between @dt_inicial and @dt_final) and
      pei.dt_canc_pedido_importacao is null
  group by 
    f.nm_fantasia_fornecedor, 
    pei.cd_fornecedor, 
    c.nm_fantasia_comprador, 
    pei.cd_comprador
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
    isnull(cast(((Total_Compras/@vl_total_fornecedor)*100) as decimal (15,2)),0) as 'Perc_Total'
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
Select  cp.cd_categoria_produto,
	coalesce(cp.nm_categoria_produto,'Sem Categoria') as nm_categoria_produto,
        sum(pii.qt_item_ped_imp * pii.vl_item_ped_imp) as 'Total_Compras',
	sum(pii.qt_item_ped_imp) as 'qtd'

into 	#Categoria

From 	Pedido_importacao_item pii Left Join
	Produto P On p.cd_produto = pii.cd_produto Left Join
	Categoria_Produto cp On cp.cd_categoria_produto = p.cd_categoria_produto
where 
     	pii.cd_pedido_Importacao in (	Select pc.cd_pedido_Importacao 
					from Pedido_Importacao pc
					Where pc.cd_fornecedor = @cd_fornecedor and
    					(pc.dt_pedido_importacao between @dt_inicial and @dt_final) and
     					pc.dt_canc_pedido_importacao is null 
				    )	
   
group by
	cp.cd_categoria_produto,
	cp.nm_categoria_produto

order by 
	Total_Compras desc

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
   a.cd_pedido_importacao, 
   a.dt_pedido_importacao, 
   b.cd_item_ped_imp, 
   b.qt_item_ped_imp, 
   dbo.fn_mascara_produto(b.cd_produto) as 'cd_mascara_produto',
   b.nm_fantasia_produto as 'nm_fantasia_produto',
   b.nm_produto_pedido as 'nm_produto',
   b.qt_item_ped_imp * b.vl_item_ped_imp as 'total',
   b.dt_entrega_ped_imp,
   b.qt_saldo_item_ped_imp,
   b.vl_item_ped_imp
	
from
   Pedido_importacao a left outer join 
   Pedido_importacao_item b on a.cd_pedido_importacao = b.cd_pedido_importacao Left Join
   Produto p On p.cd_produto = b.cd_produto 

where
   a.cd_fornecedor = @cd_fornecedor and
   a.dt_canc_pedido_importacao is null and
   (a.dt_pedido_importacao between @dt_inicial and @dt_final) and
   isnull(p.cd_categoria_produto,0) = isnull(@cd_categoria_produto,0)

  order by total desc
end

-------------------------------------------------------------------------------
if @ic_parametro = 4    -- Consulta de Nota de Entrada (Filtrado por Fornecedor e Período) 
-------------------------------------------------------------------------------
begin
  select ns.cd_nota_saida, 
       ns.dt_nota_saida,
       nsi.cd_item_nota_saida, 
       nsi.qt_item_nota_saida,
       nsi.nm_fantasia_produto,
       (nsi.qt_item_nota_saida*nsi.vl_unitario_item_nota) as 'total',
       nsi.cd_pedido_Importacao,
       nsi.cd_item_ped_imp
  from
    Nota_Saida ns left outer join 
    Nota_Saida_Item nsi on nsi.cd_nota_saida = ns.cd_nota_saida left outer join 
    Pedido_Importacao_Item pci on  pci.cd_pedido_importacao = nsi.cd_pedido_importacao and
                                   pci.cd_item_ped_imp = nsi.cd_item_ped_imp left outer join 
    Operacao_Fiscal op on  op.cd_operacao_fiscal = ns.cd_operacao_fiscal left join 
    Pedido_Importacao pei on pci.cd_pedido_importacao = pei.cd_pedido_importacao
  where
    (ns.dt_nota_saida between @dt_inicial and @dt_final)  and
    pei.cd_fornecedor = @cd_fornecedor                       and
    op.ic_comercial_operacao   = 'S'                        and
    (nsi.qt_item_nota_saida*nsi.vl_unitario_item_nota)>0
  order by total desc
end

-------------------------------------------------------------------------------
if @ic_parametro = 5    -- Resumo Anual (Filtrado por Fornecedor e Ano) 
-------------------------------------------------------------------------------
begin
-- Geração da Tabela Auxiliar de Vendas por Cliente
  select 
    f.nm_fantasia_fornecedor       as 'Fornecedor',
    month(a.dt_pedido_importacao)    as 'Mes',
    sum(a.vl_pedido_importacao) as 'Total'
  into #importacaoFornecedorMes
  from
    Pedido_importacao a left outer join
    Fornecedor f on f.cd_fornecedor = a.cd_fornecedor
 

  where
     a.cd_fornecedor = @cd_fornecedor   and
     year(a.dt_pedido_importacao) = @cd_ano and
     a.dt_canc_pedido_importacao is null   
  group by a.cd_fornecedor,month(a.dt_pedido_importacao), f.nm_fantasia_fornecedor
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
  from #importacaoFornecedorMes a
  group by a.Fornecedor
end

