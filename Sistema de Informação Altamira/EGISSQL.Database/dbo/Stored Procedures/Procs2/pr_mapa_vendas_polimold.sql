

CREATE PROCEDURE pr_mapa_vendas_polimold

  @dt_venda_diaria    datetime, -- Data da Venda Diária
  @dt_inicial         datetime, -- Data Inicial
  @dt_final           datetime  -- Data Final

as

declare @cd_dias_uteis      int
declare @cd_dias_decorridos int
declare @dt_base_decorridos datetime

set @dt_base_decorridos =
case when @dt_final < getdate() then @dt_final else getdate() end

set @cd_dias_uteis = (select count('x')
                      from  agenda 
                      where dt_agenda between @dt_inicial and @dt_final and ic_util = 'S')

set @cd_dias_decorridos = (select count('x')
                           from  agenda 
                           where dt_agenda between @dt_inicial and @dt_base_decorridos and ic_util = 'S')

select

   cp.cd_categoria_produto,
 
  --Selecionando a quantidade do saldo dos itens em carteira

   'qtdCarteira' =
  (select sum(pvi.qt_saldo_pedido_venda)
   from 
    Pedido_Venda_item pvi, Pedido_Venda pv
   where 
    pvi.cd_categoria_produto = cp.cd_categoria_produto and 
    pvi.dt_cancelamento_item is null and 
    pvi.qt_saldo_pedido_venda <> 0.00 and
    pvi.cd_pedido_venda = pv.cd_pedido_venda and
    pv.ic_consignacao_pedido <> 'S' 
   group by 
    pvi.cd_categoria_produto),

  --Selecionando o total do valor do saldo dos itens em carteira
   'vlrCarteira' =
  (select sum(pvi.qt_saldo_pedido_venda * pvi.vl_unitario_item_pedido)
   from Pedido_Venda_Item pvi, Pedido_Venda pv
   where pvi.cd_categoria_produto = cp.cd_categoria_produto and 
         pvi.dt_cancelamento_item is null and 
         pvi.qt_saldo_pedido_venda <> 0.00 and
         pvi.cd_pedido_venda = pv.cd_pedido_venda and
         pv.ic_consignacao_pedido <> 'S' 
   group by pvi.cd_categoria_produto),

  --Selecionando a quantidade dos itens do dia

   'qtdVendaDia' = 
  (select sum(pvi.qt_item_pedido_venda)
   from Pedido_Venda_Item pvi, Pedido_Venda pv
   where pvi.dt_item_pedido_venda = @dt_venda_diaria and 
         pvi.cd_categoria_produto = cp.cd_categoria_produto and 
        (pvi.dt_cancelamento_item is null or 
         pvi.dt_cancelamento_item > @dt_final ) and
         pvi.cd_pedido_venda = pv.cd_pedido_venda and
         pv.ic_consignacao_pedido <> 'S' 
   group by pvi.cd_categoria_produto),

  --Selecionando o total do valor dos itens do dia

   'vlrVendaDia' =
  (select sum(pvi.qt_item_pedido_venda * pvi.vl_unitario_item_pedido)
   from Pedido_Venda_Item pvi, Pedido_Venda pv
   where pvi.cd_categoria_produto = cp.cd_categoria_produto and 
         pvi.dt_item_pedido_venda = @dt_venda_diaria and 
        (pvi.dt_cancelamento_item is null or 
         pvi.dt_cancelamento_item > @dt_final ) and
         pvi.cd_pedido_venda = pv.cd_pedido_venda and
         pv.ic_consignacao_pedido <> 'S' 
   group by pvi.cd_categoria_produto),

   --Selecionando a quantidade de itens no período

    'qtdAcumulado' =
   (select sum(pvi.qt_item_pedido_venda)
    from Pedido_Venda_Item pvi, Pedido_Venda pv
    where pvi.cd_categoria_produto = cp.cd_categoria_produto and 
          pvi.dt_item_pedido_venda between @dt_inicial and @dt_final and 
         (pvi.dt_cancelamento_item is null or 
          pvi.dt_cancelamento_item > @dt_final ) and
          pvi.cd_pedido_venda = pv.cd_pedido_venda and
          pv.ic_consignacao_pedido <> 'S' 
    group by pvi.cd_categoria_produto),

   --Selecionando o total do valor dos itens no período

    'vlrAcumulado' = 
   (select sum(pvi.qt_item_pedido_venda * pvi.vl_unitario_item_pedido)
    from Pedido_Venda_Item pvi, Pedido_Venda pv
    where pvi.cd_categoria_produto = cp.cd_categoria_produto and 
          pvi.dt_item_pedido_venda between @dt_inicial and @dt_final and 
         (pvi.dt_cancelamento_item is null or 
          pvi.dt_cancelamento_item > @dt_final ) and
          pvi.cd_pedido_venda = pv.cd_pedido_venda and
          pv.ic_consignacao_pedido <> 'S' 
    group by pvi.cd_categoria_produto),

    --Buscando a Meta de vendas em quantidade do Período da categoria

    'qtdMeta' =
   (select sum(qt_ven_meta_categoria)
    from Meta_Categoria_Produto
    where cd_categoria_produto = cp.cd_categoria_produto and 
          dt_inicial_meta_categoria between @dt_inicial and 
          dt_final_meta_categoria),

    --Buscando a Meta de vendas em valor do Período da categoria

    'vlrMeta' =
   (select sum(vl_ven_meta_categoria)
    from Meta_Categoria_Produto
    where cd_categoria_produto = cp.cd_categoria_produto and
          dt_inicial_meta_categoria >= @dt_inicial and
          dt_final_meta_categoria <= @dt_final)

-------
into #TmpVendasAux
-------

from

  Categoria_Produto cp
where 
  cp.ic_vendas_categoria='S'
group by cp.cd_categoria_produto

--
-- Cálculos de médias e projeções
--

select 

    a.cd_categoria_produto,
    substring(cast((gc.cd_grupo_categoria+100000000)as char(10)),2,8)+' - '+gc.nm_grupo_categoria as nm_grupo_categoria, gc.cd_grupo_categoria, 
    cp.cd_mascara_categoria,
    cp.nm_categoria_produto,
    cp.sg_categoria_produto,

    a.qtdCarteira,
    a.vlrCarteira,
    a.qtdVendaDia,
    a.vlrVendaDia,
    a.qtdAcumulado,
    a.vlrAcumulado,
    a.qtdMeta,
    a.vlrMeta,

    --Calculando a média de preço no período

    vlrMedioAcumulado =
    case when qtdAcumulado = 0 then vlrAcumulado else ( vlrAcumulado / qtdAcumulado ) end,

    --Calculando a quantidade média em função dos dias úteis transcorridos no período

    qtdMedio = 
    case when @cd_dias_decorridos = 0 then qtdAcumulado else (qtdAcumulado / @cd_dias_decorridos) end,

    --Calculando o valor médio em função dos dias úteis transcorridos no período

    vlrMedio = 
    case when @cd_dias_decorridos = 0 then vlrAcumulado else (vlrAcumulado / @cd_dias_decorridos) end,
  
    --Calculando o percentual de quantidade atingido
 
    pcQtdMetaAtingido =
    case when qtdMeta = 0 then qtdAcumulado else (qtdAcumulado / qtdMeta * 100) end,

    --Calculando o percentual de valor acumulado atingido
    pcVlrMetaAtingido =
    case when vlrMeta = 0 then vlrAcumulado else (vlrAcumulado / vlrMeta * 100) end,

    --Calculando projeção de vendas do período em quantidade 
    --(Dias - Decorridos) * Media Diária + TotalVendas

    qtdProjecaoVendaPeriodo =
    case when qtdAcumulado > 0 then
       qtdAcumulado + (qtdAcumulado/@cd_dias_decorridos) * (@cd_dias_uteis-@cd_dias_decorridos)
    else 0 end,

    vlrProjecaoVendaPeriodo =
    case when vlrAcumulado > 0 then
       vlrAcumulado + (vlrAcumulado/@cd_dias_decorridos) * (@cd_dias_uteis-@cd_dias_decorridos)
    else 0 end,

    --Calculando a venda diária p/ meta

    vlrVendaDiariaMeta =
    case when (@cd_dias_decorridos < @cd_dias_uteis) and (vlrMeta > 0) and
              (vlrAcumulado > 0) and (vlrAcumulado < vlrMeta) then
       (vlrMeta - vlrAcumulado) / (@cd_dias_uteis - @cd_dias_decorridos) 
    else 0 end

from

   #TmpVendasAux a

   left outer join Categoria_Produto cp on
   a.cd_categoria_produto = cp.cd_categoria_produto

   left outer join Grupo_Categoria gc on 
   cp.cd_grupo_categoria = gc.cd_grupo_categoria
where 
   cp.ic_vendas_categoria='S'
order by gc.cd_grupo_categoria,
         cp.cd_mascara_categoria,
         cp.nm_categoria_produto


