
CREATE PROCEDURE pr_curva_abc_produto_venda

@ic_parametro 			int,
@dt_inicial 			datetime,
@dt_final 			datetime,
@cd_grupo_categoria		int,
@cd_categoria_produto		int

AS

  select
    gc.nm_grupo_categoria,
    cp.nm_categoria_produto,
    pvi.cd_categoria_produto,
    case IsNull(ic_pedido_venda_item, 'P')
    when 'S' then
	  (select top 1 nm_servico from servico where cd_servico = IsNull(pvi.cd_servico,0))
    else
       pvi.nm_fantasia_produto
    end as nm_fantasia_produto,
    --Buscando nome do produto
    case IsNull(ic_pedido_venda_item, 'P')
    when 'S' then
	  (select top 1 cast(ds_servico as varchar(50)) from servico where cd_servico = IsNull(pvi.cd_servico,0))
    else
       pvi.nm_produto_pedido
    end as nm_produto,
    sum(qt_item_pedido_venda) as qt_vendida,
    sum(qt_item_pedido_venda * vl_unitario_item_pedido) as vl_venda,

    --Calculando percentual de participação em quantidade do produto na categoria
    cast(((select 
             sum(a.qt_item_pedido_venda)
           from
             pedido_venda_item a left outer join
             categoria_produto b on a.cd_categoria_produto = b.cd_categoria_produto
           where
             a.dt_item_pedido_venda between @dt_inicial and @dt_final and
             b.ic_vendas_categoria = 'S' and
             a.nm_fantasia_produto  = pvi.nm_fantasia_produto and 
             a.dt_cancelamento_item is null) * 100 /
          (select 
             sum(a.qt_item_pedido_venda)
           from
             pedido_venda_item a left outer join
             categoria_produto b on a.cd_categoria_produto = b.cd_categoria_produto
           where
             a.dt_item_pedido_venda between @dt_inicial and @dt_final and
             b.ic_vendas_categoria = 'S' and
             a.cd_categoria_produto = pvi.cd_categoria_produto and
             a.dt_cancelamento_item is null)) as decimal(10,4)) as pc_part_qtd_cat,

    --Calculando percentual de participação em quantidade do produto em função de todas as vendas
    cast(((select 
             sum(a.qt_item_pedido_venda)
           from
             pedido_venda_item  a left outer join
             categoria_produto b on a.cd_categoria_produto = b.cd_categoria_produto
           where
             a.dt_item_pedido_venda between @dt_inicial and @dt_final and
             b.ic_vendas_categoria = 'S' and
             a.nm_fantasia_produto  = pvi.nm_fantasia_produto and
             a.dt_cancelamento_item is null) * 100 /
          (select 
             sum(a.qt_item_pedido_venda)
           from
             pedido_venda_item a left outer join
             categoria_produto b on a.cd_categoria_produto = b.cd_categoria_produto
           where
             a.dt_item_pedido_venda between @dt_inicial and @dt_final and
             b.ic_vendas_categoria = 'S' and
             a.dt_cancelamento_item is null)) as decimal(10,4)) as pc_part_qtd_geral,

    --Calculando percentual de participação em valor do produto na categoria
    cast(((select 
             sum(a.qt_item_pedido_venda * a.vl_unitario_item_pedido)
           from
             pedido_venda_item a left outer join
             categoria_produto b on a.cd_categoria_produto = b.cd_categoria_produto
           where
             a.dt_item_pedido_venda between @dt_inicial and @dt_final and
             b.ic_vendas_categoria = 'S' and
             a.nm_fantasia_produto  = pvi.nm_fantasia_produto and 
             a.dt_cancelamento_item is null) * 100 /
          (select 
             sum(a.qt_item_pedido_venda * a.vl_unitario_item_pedido)
           from
             pedido_venda_item a left outer join
             categoria_produto b on a.cd_categoria_produto = b.cd_categoria_produto
           where
             a.dt_item_pedido_venda between @dt_inicial and @dt_final and
             b.ic_vendas_categoria = 'S' and
             a.cd_categoria_produto = pvi.cd_categoria_produto and
             a.dt_cancelamento_item is null)) as decimal(10,4)) as pc_part_vlr_cat,

    --Calculando percentual de participação em valor do produto em função de todas as vendas
    cast(((select 
             sum(a.qt_item_pedido_venda * a.vl_unitario_item_pedido)
           from
             pedido_venda_item  a left outer join
             categoria_produto b on a.cd_categoria_produto = b.cd_categoria_produto
           where
             a.dt_item_pedido_venda between @dt_inicial and @dt_final and
             b.ic_vendas_categoria = 'S' and
             a.nm_fantasia_produto  = pvi.nm_fantasia_produto and
             a.dt_cancelamento_item is null) * 100 /
          (select 
             sum(a.qt_item_pedido_venda * a.vl_unitario_item_pedido)
           from
             pedido_venda_item a left outer join
             categoria_produto b on a.cd_categoria_produto = b.cd_categoria_produto
           where
             a.dt_item_pedido_venda between @dt_inicial and @dt_final and
             b.ic_vendas_categoria = 'S' and
             a.dt_cancelamento_item is null)) as decimal(10,4)) as pc_part_vlr_geral

  from
    pedido_venda_item pvi left outer join
    categoria_produto cp on  pvi.cd_categoria_produto = cp.cd_categoria_produto left outer join
    grupo_categoria gc on cp.cd_grupo_categoria = gc.cd_grupo_categoria
  where
    pvi.dt_item_pedido_venda between @dt_inicial and @dt_final and
    cp.ic_vendas_categoria = 'S'       and
    pvi.dt_cancelamento_item is null and
    (gc.cd_grupo_categoria = @cd_grupo_categoria or @cd_grupo_categoria = 0) and
    (cp.cd_categoria_produto = @cd_categoria_produto or @cd_categoria_produto = 0)
  group by
    gc.nm_grupo_categoria,
    cp.nm_categoria_produto,
    pvi.cd_categoria_produto,
    pvi.nm_fantasia_produto,
    IsNull(ic_pedido_venda_item, 'P'),
    pvi.nm_produto_pedido,
	IsNull(pvi.cd_servico,0)

