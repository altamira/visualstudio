
CREATE PROCEDURE pr_mapa_vendas

  @cd_parametro       int = 1 ,      -- Parâmetro de montagem das consultas
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
                      where (Month(dt_agenda) = Month(@dt_inicial)) and 
                            (Year(dt_agenda) = Year(@dt_inicial)) and 
                             ic_util = 'S')

set @cd_dias_decorridos = (select count('x')
                           from  agenda 
                           where dt_agenda between @dt_inicial and @dt_base_decorridos and ic_util = 'S')

if @cd_parametro = 1 -- Padrão Egis
begin

  select

     cp.cd_categoria_produto,
     max(cp.cd_grupo_categoria) as 'OrdemPai',
 
    --Selecionando a quantidade do saldo dos itens em carteira

     'qtdCarteira' =
    (select sum(qt_saldo_pedido_venda)
     from 
      vw_venda_bi vw
     where 
      vw.cd_categoria_produto = cp.cd_categoria_produto 
     group by 
      vw.cd_categoria_produto),

    --Selecionando o total do valor do saldo dos itens em carteira
     'vlrCarteira' =
    (select sum(qt_saldo_pedido_venda * vl_unitario_item_pedido)
     from vw_venda_bi vw
     where vw.cd_categoria_produto = cp.cd_categoria_produto 
     group by vw.cd_categoria_produto),

    --Selecionando a quantidade dos itens do dia

     'qtdVendaDia' = 
    (select sum(qt_item_pedido_venda)
     from vw_venda_bi vw
     where vw.dt_pedido_venda = @dt_venda_diaria and 
           vw.cd_categoria_produto = cp.cd_categoria_produto
     group by vw.cd_categoria_produto),

    --Selecionando o total do valor dos itens do dia

     'vlrVendaDia' =
    (select sum(qt_item_pedido_venda * vl_unitario_item_pedido)
     from vw_venda_bi vw
     where vw.cd_categoria_produto = cp.cd_categoria_produto and 
           vw.dt_pedido_venda = @dt_venda_diaria 
     group by vw.cd_categoria_produto),

     --Selecionando a quantidade de itens no período

      'qtdAcumulado' =
     (select sum(qt_item_pedido_venda)
      from vw_venda_bi vw
      where vw.cd_categoria_produto = cp.cd_categoria_produto and 
            vw.dt_pedido_venda between @dt_inicial and @dt_final 
      group by vw.cd_categoria_produto),

     --Selecionando o total do valor dos itens no período

      'vlrAcumulado' = 
     (select sum(qt_item_pedido_venda * vl_unitario_item_pedido)
      from vw_venda_bi vw
      where vw.cd_categoria_produto = cp.cd_categoria_produto and 
            vw.dt_pedido_venda between @dt_inicial and @dt_final 
      group by vw.cd_categoria_produto),

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
  into #TmpVendasAuxEgis
  -------

  from

    Categoria_Produto cp

  where cp.ic_vendas_categoria = 'S'

  group by cp.cd_categoria_produto


  --
  -- Cálculos de médias e projeções
  --

  select 

      a.cd_categoria_produto,
      a.ordempai, 
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
      cast(null as VarChar(15)) as 'cd_cor_relatorio_categ',
      cast(null as VarChar(06)) as 'lbl_acima_abaixo',
      cast(null as float)       as 'vl_acima_abaixo',
      cast(null as float)       as 'MediaPonderada',
      cast(null as float)       as 'PcProjecaoMeta',
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

     #TmpVendasAuxEgis a

     left outer join Categoria_Produto cp on
     a.cd_categoria_produto = cp.cd_categoria_produto

     left outer join Grupo_Categoria gc on 
     cp.cd_grupo_categoria = gc.cd_grupo_categoria

  where 
     cp.ic_vendas_categoria='S'

  order by gc.cd_grupo_categoria,
           cp.cd_mascara_categoria,
           cp.nm_categoria_produto

end



--***************************************************************************************
-- Parametro = 2 (Polimold)
--***************************************************************************************



if @cd_parametro = 2 -- Mapa Polimold
begin

  select

     cp.cd_categoria_produto,
 
    --Selecionando a quantidade do saldo dos itens em carteira

     'qtdCarteira' =
    (select sum(pvi.qt_saldo_pedido_venda)
     from 
      Pedido_Venda_item pvi, Pedido_Venda pv
     where 
      pvi.cd_categoria_produto = cp.cd_categoria_produto and 
     (pvi.dt_cancelamento_item is null or
      pvi.dt_cancelamento_item > @dt_final) and
      pvi.qt_saldo_pedido_venda > 0 and
      pvi.cd_item_pedido_venda < 80 and
      pvi.cd_pedido_venda = pv.cd_pedido_venda and
      --Somente a data final porque são "todos os pedidos em aberto"
      pv.dt_pedido_venda <= @dt_final and 
      pv.ic_consignacao_pedido <> 'S' and
      pv.cd_status_pedido in (1,2)

     group by 
      pvi.cd_categoria_produto),

    --Selecionando o total do valor do saldo dos itens em carteira

     'vlrCarteira' =
    (select sum(pvi.qt_saldo_pedido_venda * pvi.vl_unitario_item_pedido)
     from Pedido_Venda_Item pvi, Pedido_Venda pv
     where pvi.cd_categoria_produto = cp.cd_categoria_produto and 
          (pvi.dt_cancelamento_item is null or
           pvi.dt_cancelamento_item > @dt_final) and
           pvi.qt_saldo_pedido_venda > 0 and
           pvi.cd_item_pedido_venda < 80 and
           pvi.cd_pedido_venda = pv.cd_pedido_venda and
           pv.dt_pedido_venda <= @dt_final and
           pv.ic_consignacao_pedido <> 'S' and
           pv.cd_status_pedido in (1,2)

     group by pvi.cd_categoria_produto),

    --Selecionando a quantidade dos itens do dia

     'qtdVendaDia' = 
    isnull((select sum(pvi.qt_item_pedido_venda)
            from Pedido_Venda_Item pvi, Pedido_Venda pv
            where pvi.dt_item_pedido_venda = @dt_venda_diaria and 
                  pvi.cd_item_pedido_venda < 80 and
                  pvi.cd_categoria_produto = cp.cd_categoria_produto and 
                 (pvi.dt_cancelamento_item is null or
                  pvi.dt_cancelamento_item > @dt_final) and
                  pvi.cd_pedido_venda = pv.cd_pedido_venda and
                  pv.ic_consignacao_pedido <> 'S'
            group by pvi.cd_categoria_produto),0),

    --Selecionando o total do valor dos itens do dia

     'vlrVendaDia' =
    (select sum(pvi.qt_item_pedido_venda * pvi.vl_unitario_item_pedido)
     from Pedido_Venda_Item pvi, Pedido_Venda pv
     where pvi.cd_categoria_produto = cp.cd_categoria_produto and 
           pvi.cd_item_pedido_venda < 80 and
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
            pvi.cd_item_pedido_venda < 80 and
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
            pvi.cd_item_pedido_venda < 80 and
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
                                              @dt_final),

      --Buscando a Meta de vendas em valor do Período da categoria

      'vlrMeta' =
     (select sum(vl_ven_meta_categoria)
      from Meta_Categoria_Produto
      where cd_categoria_produto = cp.cd_categoria_produto and
            dt_inicial_meta_categoria between @dt_inicial and
                                              @dt_final)

  -------
  into #TmpVendasAux
  -------

  from
    Categoria_Produto cp

  where 
     cp.ic_vendas_categoria='S'

  group by cp.cd_categoria_produto

  --
  -- Busca valores em carteira de pedidos faturados após a database
  --

  select pvi.cd_categoria_produto,
         pvi.cd_pedido_venda,
         pvi.cd_item_pedido_venda,
         max(nsi.qt_item_nota_saida) as QtdSaldoFaturado,
         max((nsi.qt_item_nota_saida) * vl_unitario_item_pedido) as VlrSaldoFaturado
  -------
  into #TmpPedidosFaturados
  -------
  from Pedido_Venda pv, 
       Pedido_Venda_Item pvi, 
       Nota_Saida_Item nsi, 
       Nota_Saida ns, 
       Operacao_Fiscal op,
       Categoria_Produto cp
  where 
       pv.dt_pedido_venda <= @dt_final and
       pv.ic_consignacao_pedido <> 'S' and
       pv.cd_pedido_venda = pvi.cd_pedido_venda and
       pvi.cd_item_pedido_venda < 80 and
      (pvi.dt_cancelamento_item is null or
       pvi.dt_cancelamento_item > @dt_final) and
       -- Pedido Faturado Total ou Parcial apos o Periodo (Abaixo)
      (pvi.qt_saldo_pedido_venda = 0 or
       (pvi.qt_saldo_pedido_venda > 0 and
        pvi.qt_item_pedido_venda > pvi.qt_saldo_pedido_venda)) and
       pvi.cd_categoria_produto = cp.cd_categoria_produto and 
       cp.ic_vendas_categoria = 'S' and
       pvi.cd_pedido_venda = nsi.cd_pedido_venda and
       pvi.cd_item_pedido_venda = nsi.cd_item_pedido_venda and
       nsi.cd_status_nota <> 7 and
       nsi.cd_nota_saida = ns.cd_nota_saida and
       ns.dt_nota_saida > @dt_final and 
       ns.cd_operacao_fiscal = op.cd_operacao_fiscal and
       op.ic_comercial_operacao = 'S'

  group by 
       pvi.cd_categoria_produto,
       pvi.cd_pedido_venda,
       pvi.cd_item_pedido_venda

  --
  -- Agrupa VENDAS já faturadas por categoria (Para o total em aberto)
  --
  select b.cd_categoria_produto,
         sum(b.QtdSaldoFaturado)                        as 'QtdSaldoFaturado',
         sum(b.VlrSaldoFaturado)                        as 'VlrSaldoFaturado'
  -------
  into #TmpPedidosFaturadosCategoria
  -------
  from #TmpPedidosFaturados b

  group by b.cd_categoria_produto

  --
  -- Seleção de Prazo Médio de Pagamento (PMV do Relatório)
  --

  select
     pvi.cd_categoria_produto,
     pvi.cd_pedido_venda,
     pvi.cd_item_pedido_venda,
    (pvi.qt_item_pedido_venda * pvi.vl_unitario_item_pedido) as 'TotalItem',
     T1 = isnull(((pvi.qt_item_pedido_venda * pvi.vl_unitario_item_pedido) *
                   cpp.pc_condicao_parcela_pgto / 100) * cpp.qt_dia_cond_parcela_pgto,0)
  -------
  into #PrazoMedioTmp
  -------
  From
     Pedido_Venda_Item pvi, 
     Pedido_Venda pv, 
     Condicao_Pagamento cp,
     Condicao_Pagamento_Parcela cpp
  Where
     pvi.dt_item_pedido_venda between @dt_inicial and @dt_final and 
    (pvi.dt_cancelamento_item is null or 
     pvi.dt_cancelamento_item > @dt_final ) and
     pvi.cd_item_pedido_venda < 80 and
     pvi.cd_pedido_venda = pv.cd_pedido_venda and
     pv.ic_consignacao_pedido <> 'S' and
     pv.cd_condicao_pagamento = cp.cd_condicao_pagamento and
     cp.cd_condicao_pagamento = cpp.cd_condicao_pagamento

  --
  -- Agrupa Prazo Médio por Item do Pedido
  --

  select
     cd_pedido_venda,
     cd_item_pedido_venda,
     max(cd_categoria_produto) as cd_categoria_produto,
     Sum(isnull(T1,0))         as T1,
     Max(isnull(TotalItem,0))  as TotalItem
  -------
  into #PrazoMedioItemPedido
  -------
  from #PrazoMedioTmp a
  group by cd_pedido_venda,
           cd_item_pedido_venda 

  --
  -- Agrupa Prazo por Categoria
  --
  select
     a.cd_categoria_produto,
     case when sum(a.TotalItem) > 0 then
        sum(isnull(a.T1,0))/sum(isnull(a.TotalItem,0)) else 0 end  as 'MediaPonderada'
  --
  into #PrazoMedioCategoria
  --
  from #PrazoMedioItemPedido a
  group by a.cd_categoria_produto

  --
  -- Cálculos de médias e projeções
  --
  select 
      a.cd_categoria_produto,
      gc.cd_grupo_categoria,
      gc.nm_grupo_categoria,
      cp.nm_categoria_produto,
      cp.sg_categoria_produto,

      cast(isnull(a.qtdCarteira,0) as int)  as qtdCarteira,
      isnull(a.vlrCarteira,0)               as vlrCarteira,

      isnull(pf.qtdSaldoFaturado,0) 	       as qtdCarteiraFat,
      isnull(pf.vlrSaldoFaturado,0)         as vlrCarteiraFat,

      cast(a.qtdVendaDia as int)            as qtdVendaDia,
      a.vlrVendaDia,
      cast(a.qtdAcumulado as int)           as qtdAcumulado,
      a.vlrAcumulado,
      cast(a.qtdMeta as int)                as qtdMeta,
      a.vlrMeta,

      --Calculando a quantidade média em função dos dias úteis transcorridos no período

      qtdMedio = 
      case when @cd_dias_decorridos = 0 then qtdAcumulado else round( (qtdAcumulado / @cd_dias_decorridos),0,1 ) end,

      --Calculando o valor médio em função dos dias úteis transcorridos no período

      vlrMedio = 
      case when @cd_dias_decorridos = 0 then vlrAcumulado else (vlrAcumulado / @cd_dias_decorridos) end,

      --Calculando o percentual de quantidade atingido
 
      pcQtdMetaAtingido =
      case when qtdMeta = 0 then qtdAcumulado else (qtdAcumulado / qtdMeta * 100) end,

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

  -------
  into #TmpVendas
  -------
  from #TmpVendasAux a

  left outer join Categoria_Produto cp on
  a.cd_categoria_produto = cp.cd_categoria_produto

  left outer join Grupo_Categoria gc on 
  cp.cd_grupo_categoria = gc.cd_grupo_categoria

  left outer join #TmpPedidosFaturadosCategoria pf on
  cp.cd_categoria_produto = pf.cd_categoria_produto

  order by cp.cd_ordem_categoria

  --
  --
  -- Inicia montagem de nova disposição dos dados das categorias
  --
  --

  select 
     a.cd_grupo_categoria           as 'GrupoPai',
     a.cd_categoria_produto         as 'CategoriaPai',
     a.cd_grupo_categoria_mapa      as 'GrupoFilho',
     a.cd_categoria_produto_mapa    as 'CategoriaFilho',
     a.cd_cor_relatorio_categ       as 'CorPai',
     b.cd_mascara_categoria         as 'MascaraPai',
     cast(isnull(b.sg_resumo_categoria,
                 b.sg_categoria_produto) as char(20)) as 'SiglaPai',
     b.nm_categoria_produto         as 'NomeCategoriaPai',
     b.cd_soma_categoria            as 'SomaPai',
     b.cd_ordem_categoria           as 'OrdemPai'

  into #TmpMapaCategoriaPai

  from 
       Mapa_Categoria_Produto a,
       Categoria_Produto b 

  where a.cd_tipo_mapa_categoria = 1 and
        a.cd_grupo_categoria     = b.cd_grupo_categoria and
        a.cd_categoria_produto   = b.cd_categoria_produto and
        b.ic_impressao_categoria = 'S'

  order by b.cd_ordem_categoria

  --
  -- Liga novamente com categoria para buscar siglas e outros dados dos "filhos"
  --

  select a.GrupoPai,
         a.MascaraPai,
         a.SiglaPai,
         a.NomeCategoriaPai,
         a.SomaPai,
         a.OrdemPai,
         a.CorPai,
         b.cd_mascara_categoria         as 'MascaraFilho',
         cast(isnull(b.sg_resumo_categoria,
                     b.sg_categoria_produto) as char(20)) as 'SiglaFilho',
         b.cd_soma_categoria            as 'SomaFilho',
         b.cd_ordem_categoria           as 'OrdemFilho',
         b.cd_categoria_produto         as 'cd_categoria_filho',
         b.ic_impressao_categoria       as 'ImpressaoFilho',
         c.*,
         d.MediaPonderada                  as 'MediaPonderada',
         c.VlrAcumulado * d.MediaPonderada as 'TotalPonderado'

  into #TmpFinal

  from #TmpMapaCategoriaPai a,
       Categoria_Produto b,
       #TmpVendas c,
       #PrazoMedioCategoria d
 
  where a.GrupoFilho            = b.cd_grupo_categoria   and
        a.CategoriaFilho        = b.cd_categoria_produto and
        b.cd_categoria_produto  = c.cd_categoria_produto and
        b.cd_categoria_produto *= d.cd_categoria_produto
      
  order by a.OrdemPai

  --
  -- Query final
  --

  select SiglaPai                                             as sg_categoria_produto,
         Max(OrdemPai)                                        as OrdemPai, 
         Max(GrupoPai)                                        as cd_grupo_categoria,
         Max(MascaraPai)                                      as cd_mascara_categoria,
         Max(CorPai)                                          as cd_cor_relatorio_categ,
         Max(nm_grupo_categoria)                              as nm_grupo_categoria,
         Max(NomeCategoriaPai)                                as nm_categoria_produto,
         Sum(cast(qtdCarteira+qtdCarteiraFat as float))       as qtdCarteira,
         Sum(vlrCarteira+vlrCarteiraFat)                      as vlrCarteira,
         Sum(cast(qtdVendaDia as float))                      as qtdVendaDia,
         Sum(vlrVendaDia)                                     as vlrVendaDia,
         Sum(cast(qtdAcumulado as float))                     as qtdAcumulado,
         Sum(vlrAcumulado)                                    as vlrAcumulado,
         Sum(qtdMeta)                                         as qtdMeta,
         Sum(vlrMeta)                                         as vlrMeta,
         --Calculando a média de preço no período
         vlrMedioAcumulado =
         case when Sum(vlrAcumulado) = 0 then Sum(vlrAcumulado) else ( Sum(vlrAcumulado) / Sum(qtdAcumulado) ) end,
         Sum(vlrMedio)                                        as vlrMedio,
         Sum(cast(round(qtdMedio,0) as float))                as qtdMedio,
         Sum(cast(round(pcQtdMetaAtingido,0) as float))       as pcQtdMetaAtingido,
         --Calculando o percentual de valor acumulado atingido
         pcVlrMetaAtingido =
         case when Sum(vlrMeta) = 0 then 0 else (Sum(vlrAcumulado) / Sum(vlrMeta) * 100) end,
         Sum(cast(round(qtdProjecaoVendaPeriodo,0) as float)) as qtdProjecaoVendaPeriodo,
         Sum(vlrProjecaoVendaPeriodo)                         as vlrProjecaoVendaPeriodo,
         Sum(vlrVendaDiariaMeta)                              as vlrVendaDiariaMeta,
         tmp_vl_acima_abaixo = 
         case when (Max(SiglaPai) like 'TOTAL NAC%') and (Sum(VlrMeta)>0) and (Max(@cd_dias_uteis)>0) then
           ((Sum(VlrMeta)/Max(@cd_dias_uteis)) * @cd_dias_decorridos)-Sum(VlrAcumulado) else 0 end,
         Sum(TotalPonderado)                                  as TotalPonderado

  -------
  into #TmpTermino
  -------
  from #TmpFinal a
  -------
  group by a.SiglaPai

  --

  declare @vl_acima_abaixo float
  set @vl_acima_abaixo = 0

  select @vl_acima_abaixo = @vl_acima_abaixo + tmp_vl_acima_abaixo 
  from #TmpTermino

  select *,
         abs(@vl_acima_abaixo) as 'vl_acima_abaixo',
         lbl_acima_abaixo =
         case when @vl_acima_abaixo < 0 then 'ACIMA '
         else 'ABAIXO' end,
         PcProjecaoMeta = 
         case when (vlrProjecaoVendaPeriodo > 0) and (VlrMeta > 0) then 
            (vlrProjecaoVendaPeriodo/VlrMeta)*100
         else 0 end,
         MediaPonderada =
         case when (TotalPonderado > 0) and (VlrAcumulado > 0) then
            Round(TotalPonderado / VlrAcumulado,1) else 0 end
  -------
  from #TmpTermino
  -------
  order by OrdemPai

end

