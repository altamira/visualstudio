

CREATE PROCEDURE pr_consumo_categoria_especial
@ic_parametro         int,
@dt_inicial           datetime,    --Data Inicial
@dt_final             datetime,    --Data Final
@cd_categoria_produto int,
@cd_grupo_categoria   int,
@cd_pedido_venda      int

as

declare
@soma_valor_total  float

----------------------------------------------------
if @ic_parametro = 1 --Resumo Geral
----------------------------------------------------
begin
  select
    cp.cd_categoria_produto,
    cp.nm_categoria_produto, 
    gc.cd_grupo_categoria,
    gc.nm_grupo_categoria, 
    sum(isnull(nei.qt_pesbru_nota_entrada,0)) as 'Peso',
    sum(isnull(nsi.qt_item_nota_saida,0)) as 'Qtd_Total', 
    sum(isnull(nsi.vl_unitario_item_nota,0)*isnull(nsi.qt_item_nota_saida,0)) as 'Valor_Total',
    0 as 'Qtd_Mat_Prima'
  into #t1
  from Nota_Saida_Item nsi 
  inner join Nota_Saida ns on 
    nsi.cd_nota_saida = ns.cd_nota_saida
  left outer join Pedido_Venda_Item pvi on
    nsi.cd_pedido_venda = pvi.cd_pedido_venda AND 
    nsi.cd_item_pedido_venda = pvi.cd_item_pedido_venda 
  left outer join Pedido_Compra_item  pci on
    pci.cd_pedido_venda = nsi.cd_pedido_venda AND 
    pci.cd_item_pedido_venda = nsi.cd_item_pedido_venda
  left outer join Nota_Entrada_item  nei on
    nei.cd_pedido_compra = pci.cd_pedido_compra AND 
    nei.cd_item_pedido_compra = pci.cd_item_pedido_compra 
  inner join Categoria_Produto cp on
    pvi.cd_categoria_produto = cp.cd_categoria_produto 
  inner join Grupo_Categoria gc on
    cp.cd_grupo_categoria = gc.cd_grupo_categoria 
  inner join Operacao_Fiscal ofi on
    ofi.cd_operacao_fiscal = ns.cd_operacao_fiscal
  where 
    ns.dt_nota_saida between @dt_inicial and @dt_final             and
    ns.cd_status_nota <> 7                                         and
   (nsi.dt_restricao_item_nota is null or nsi.dt_restricao_item_nota > @dt_final) and
    isnull(ofi.ic_comercial_operacao,'N') = 'S'                    and
    ns.vl_total > 0
  group by
    cp.cd_categoria_produto, cp.nm_categoria_produto, gc.cd_grupo_categoria, gc.nm_grupo_categoria

  set @soma_valor_total= (select sum(valor_total) from #t1)

  select
    cd_categoria_produto,
    nm_categoria_produto,
    cd_grupo_categoria,
    nm_grupo_categoria,
    Peso,
    qtd_total,
    valor_total,
    (valor_total*100)/@soma_valor_total as 'Perc',
    qtd_mat_prima
  from #t1

end

----------------------------------------------------
if @ic_parametro = 2 --Matéria-Prima Resumo Geral
----------------------------------------------------
begin
  select
    dbo.fn_formata_mascara(gp.cd_mascara_grupo_produto, p.cd_mascara_produto) as 'Codigo',
    p.nm_fantasia_produto as 'Materia_Prima',
    sum(isnull(nei.qt_pesbru_nota_entrada,0)) as 'Peso',
    sum(isnull(nsi.qt_item_nota_saida,0)) as 'Qtd_Total', 
    sum(isnull(nsi.vl_unitario_item_nota,0)*isnull(nsi.qt_item_nota_saida,0)) as 'Valor_Total',
    isnull(p.vl_produto,0) as 'Valor_Unitário'
  into #t2
  from Nota_Saida_Item nsi 
  inner join Nota_Saida ns on 
    nsi.cd_nota_saida = ns.cd_nota_saida
  left outer join Pedido_Venda_Item pvi on
    nsi.cd_pedido_venda = pvi.cd_pedido_venda AND 
    nsi.cd_item_pedido_venda = pvi.cd_item_pedido_venda 
  left outer join Pedido_Compra_item  pci on
    pci.cd_pedido_venda = nsi.cd_pedido_venda AND 
    pci.cd_item_pedido_venda = nsi.cd_item_pedido_venda
  left outer join Nota_Entrada_item  nei on
    nei.cd_pedido_compra = pci.cd_pedido_compra AND 
    nei.cd_item_pedido_compra = pci.cd_item_pedido_compra 
  left outer join Produto p on
    p.cd_produto= nsi.cd_produto
  left outer join Grupo_Produto gp on
    gp.cd_grupo_produto=p.cd_grupo_produto
  inner join Categoria_Produto cp on
    pvi.cd_categoria_produto = cp.cd_categoria_produto 
  inner join Grupo_Categoria gc on
    cp.cd_grupo_categoria = gc.cd_grupo_categoria 
  inner join Operacao_Fiscal ofi on
    ofi.cd_operacao_fiscal = ns.cd_operacao_fiscal
  where 
    cp.cd_categoria_produto=@cd_categoria_produto      and
    gc.cd_grupo_categoria=@cd_grupo_categoria          and
    ns.dt_nota_saida between @dt_inicial and @dt_final and
    ns.cd_status_nota <> 7                             and
   (nsi.dt_restricao_item_nota is null or nsi.dt_restricao_item_nota > @dt_final) and
    isnull(ofi.ic_comercial_operacao,'N') = 'S'        and
    ns.vl_total > 0
  group by
    p.cd_mascara_produto, gp.cd_mascara_grupo_produto, p.nm_fantasia_produto, p.vl_produto

  set @soma_valor_total= (select sum(valor_total) from #t2)

  select
    Codigo,
    Materia_Prima, 
    Peso,
    qtd_total,
    valor_total,
    (valor_total*100)/@soma_valor_total as 'Perc'
  from #t2

end

----------------------------------------------------
else if @ic_parametro = 3 --Analítico Geral
----------------------------------------------------
begin
  select 
    cp.cd_categoria_produto,
    cp.nm_categoria_produto, 
    gc.cd_grupo_categoria,
    gc.nm_grupo_categoria,
    c.nm_fantasia_cliente, 
    nsi.cd_pedido_venda, 
    sum(isnull(nei.qt_pesbru_nota_entrada,0)) as 'Peso',
    sum(isnull(nsi.qt_item_nota_saida,0)) as 'Qtd_Total', 
    sum(isnull(nsi.vl_unitario_item_nota,0)*isnull(nsi.qt_item_nota_saida,0)) as 'Valor_Total',
    (select distinct count(cd_pedido_venda) 
     from Pedido_Venda_Composicao where cd_pedido_venda=nsi.cd_pedido_venda) as 'Qtd_Mat_Prima'
  into #t3
  from Nota_Saida_Item nsi 
  inner join Nota_Saida ns on 
    nsi.cd_nota_saida = ns.cd_nota_saida
  left outer join Pedido_Venda_Item pvi on
    nsi.cd_pedido_venda = pvi.cd_pedido_venda AND 
    nsi.cd_item_pedido_venda = pvi.cd_item_pedido_venda 
  left outer join Pedido_Compra_item  pci on
    pci.cd_pedido_venda = nsi.cd_pedido_venda AND 
    pci.cd_item_pedido_venda = nsi.cd_item_pedido_venda
  left outer join Nota_Entrada_item  nei on
    nei.cd_pedido_compra = pci.cd_pedido_compra AND 
    nei.cd_item_pedido_compra = pci.cd_item_pedido_compra 
  inner join Cliente c on
    ns.cd_cliente = c.cd_cliente 
  inner join Categoria_Produto cp on
    pvi.cd_categoria_produto = cp.cd_categoria_produto 
  inner join Grupo_Categoria gc on
    cp.cd_grupo_categoria = gc.cd_grupo_categoria 
  inner join Operacao_Fiscal ofi on
    ofi.cd_operacao_fiscal = ns.cd_operacao_fiscal
  where 
    ns.dt_nota_saida between @dt_inicial and @dt_final and
    cp.cd_categoria_produto=@cd_categoria_produto      and
    gc.cd_grupo_categoria=@cd_grupo_categoria          and
    ns.cd_status_nota <> 7                             and
   (nsi.dt_restricao_item_nota is null or nsi.dt_restricao_item_nota > @dt_final) and
    isnull(ofi.ic_comercial_operacao,'N') = 'S'        and
    ns.vl_total > 0
  group by
    cp.cd_categoria_produto, cp.nm_categoria_produto, gc.cd_grupo_categoria, gc.nm_grupo_categoria,
    c.nm_fantasia_cliente, nsi.cd_pedido_venda

  set @soma_valor_total= (select sum(valor_total) from #t3)

  select
    cd_categoria_produto,
    nm_categoria_produto,
    cd_grupo_categoria,
    nm_grupo_categoria,
    nm_fantasia_cliente,
    cd_pedido_venda,
    Peso,
    qtd_total,
    valor_total,
    (valor_total*100)/@soma_valor_total as 'Perc',
    qtd_mat_prima
  from #t3

end

----------------------------------------------------
if @ic_parametro = 4 --Matéria-Prima Resumo Geral
----------------------------------------------------
begin
  select
    dbo.fn_formata_mascara(gp.cd_mascara_grupo_produto, p.cd_mascara_produto) as 'Codigo',
    p.nm_fantasia_produto as 'Materia_Prima',
    sum(isnull(nei.qt_pesbru_nota_entrada,0)) as 'Peso',
    sum(isnull(nsi.qt_item_nota_saida,0)) as 'Qtd_Total', 
    sum(isnull(nsi.vl_unitario_item_nota,0)*isnull(nsi.qt_item_nota_saida,0)) as 'Valor_Total',
    isnull(p.vl_produto,0) as 'Valor_Unitário'
  into #t4
  from Nota_Saida_Item nsi 
  inner join Nota_Saida ns on 
    nsi.cd_nota_saida = ns.cd_nota_saida
  left outer join Pedido_Venda_Item pvi on
    nsi.cd_pedido_venda = pvi.cd_pedido_venda AND 
    nsi.cd_item_pedido_venda = pvi.cd_item_pedido_venda 
  left outer join Pedido_Compra_item  pci on
    pci.cd_pedido_venda = nsi.cd_pedido_venda AND 
    pci.cd_item_pedido_venda = nsi.cd_item_pedido_venda
  left outer join Nota_Entrada_item  nei on
    nei.cd_pedido_compra = pci.cd_pedido_compra AND 
    nei.cd_item_pedido_compra = pci.cd_item_pedido_compra 
  left outer join Produto p on
    p.cd_produto= nsi.cd_produto
  left outer join Grupo_Produto gp on
    gp.cd_grupo_produto=p.cd_grupo_produto
  inner join Categoria_Produto cp on
    pvi.cd_categoria_produto = cp.cd_categoria_produto 
  inner join Grupo_Categoria gc on
    cp.cd_grupo_categoria = gc.cd_grupo_categoria 
  inner join Operacao_Fiscal ofi on
    ofi.cd_operacao_fiscal = ns.cd_operacao_fiscal
  where 
    nsi.cd_pedido_venda=@cd_pedido_venda        and
    ns.cd_status_nota <> 7                      and
   (nsi.dt_restricao_item_nota is null or nsi.dt_restricao_item_nota > @dt_final) and
    isnull(ofi.ic_comercial_operacao,'N') = 'S' and
    ns.vl_total > 0
  group by
    p.cd_mascara_produto, gp.cd_mascara_grupo_produto, p.nm_fantasia_produto, p.vl_produto

  set @soma_valor_total= (select sum(valor_total) from #t4)

  select
    Codigo,
    Materia_Prima, 
    Peso,
    qtd_total,
    valor_total,
    (valor_total*100)/@soma_valor_total as 'Perc'
  from #t4

end


