
CREATE procedure pr_mapa_fabricacao_pinos

@cd_grupo_produto  int,
@dt_base_final     datetime,
@cd_meses          int,
@cd_total_desejado int

as

declare @cd_mes_inicial_consumo int
declare @cd_ano_inicial_consumo int
declare @cd_mes_final_consumo   int
declare @cd_ano_final_consumo   int

-- Média de consumo = Somatória dos últimos @cd_meses / @cd_meses (Todos os Produtos)
declare @qt_media_total_consumo float

-- Estoque máximo desejado informado no parâmetro / Média de todos os produtos
declare @pc_fator               float

declare @dt_base_final_date datetime
set @dt_base_final_date = cast(@dt_base_final as datetime)

-- Mes de consumo final = Mês informado na data base - 1
set @cd_mes_final_consumo = Month( DateAdd(month,-1,@dt_base_final_date)  )
set @cd_ano_final_consumo = Year(  DateAdd(month,-1,@dt_base_final_date) )

-- Mes de consumo inicial - Nro. de meses informado no parâmetro
set @cd_mes_inicial_consumo = Month( DateAdd(month,@cd_meses*(-1),@dt_base_final_date) )
set @cd_ano_inicial_consumo = Year(  DateAdd(month,@cd_meses*(-1),@dt_base_final_date) )

-- Média de consumo = Somatória dos últimos @cd_meses / @cd_meses (Por Produto)
-- ConsumoMedio

-- Média por produto * @cd_meses (Desejado para se ter em estoque)
-- PrevisaoSaida

-- Saldo atual - previsão de saída
-- SaldoPrevisto

-- Média por produto * Fator
-- Desejado

-- Estoque máximo desejado informado no parâmetro - saldo atual
-- Produzir

-- Saldo atual / Média por produto
-- Duracao

  -----------------------------------------------
  -- Seleção de dados do próprio produto e saldos
  -----------------------------------------------
  select c.cd_produto,
         c.nm_produto,
         c.nm_fantasia_produto,
         c.cd_mascara_produto,
         isnull(c.qt_espessura_produto,0)      as 'Espessura',
         d.nm_grupo_produto,

         isnull(ps.qt_saldo_atual_produto,0)   as 'SaldoAtual',
         isnull(ps.qt_saldo_reserva_produto,0) as 'SaldoReserva',
         isnull(ps.qt_req_compra_produto,0)    as 'SaldoEmRequisicao',
         isnull(ps.qt_pd_compra_produto,0)     as 'SaldoEmPedido',

         Bruto =
         isnull((select sum(a.qt_saldo_atual_produto) from Produto_Saldo a
                 Left outer join Fase_Produto b on a.cd_fase_produto = b.cd_fase_produto
                 where a.cd_produto = c.cd_produto and a.cd_fase_produto = 1),0), 
         Processo =
         isnull((select sum(a.qt_saldo_atual_produto) from Produto_Saldo a
                 Left outer join Fase_Produto b on a.cd_fase_produto = b.cd_fase_produto
                 where a.cd_produto = c.cd_produto and a.cd_fase_produto = 2),0), 
         Terceiros =
         isnull((select sum(a.qt_saldo_atual_produto) from Produto_Saldo a
                 Left outer join Fase_Produto b on a.cd_fase_produto = b.cd_fase_produto
                 where a.cd_produto = c.cd_produto and a.cd_fase_produto = 4),0), 
         Montado = 
         isnull((select sum(a.qt_saldo_atual_produto) from Produto_Saldo a
                 Left outer join Fase_Produto b on a.cd_fase_produto = b.cd_fase_produto
                 where a.cd_produto = c.cd_produto and a.cd_fase_produto = 5),0), 
         Fabricacao2 =     
         isnull((select sum(a.qt_saldo_atual_produto) from Produto_Saldo a
                 Left outer join Fase_Produto b on a.cd_fase_produto = b.cd_fase_produto
                 where a.cd_produto = c.cd_produto and a.cd_fase_produto = 6),0), 
         Torno =
         isnull((select sum(a.qt_saldo_atual_produto) from Produto_Saldo a
                 Left outer join Fase_Produto b on a.cd_fase_produto = b.cd_fase_produto
                 where a.cd_produto = c.cd_produto and a.cd_fase_produto = 7),0)

  -------
  into #ProdutoTotal
  -------

  from Produto c

  Inner Join Grupo_Produto d on
  c.cd_grupo_produto = d.cd_grupo_produto

  Inner Join Produto_Pcp f on
  c.cd_produto = f.cd_produto

  Left Outer Join Produto_Saldo ps on 
  c.cd_produto = ps.cd_produto

  where
    isnull(c.cd_produto_baixa_estoque,0) = 0 and
    f.ic_mapa_fabricacao_pinos = 'S' and
    d.cd_grupo_produto = @cd_grupo_produto and
    isnull(ps.cd_fase_produto,3) = 3

UNION

  -----------------------------------------------------------
  -- Seleção de dados de produtos com baixa em OUTRO e saldos
  -----------------------------------------------------------
  select c.cd_produto,
         c.nm_produto,
         c.nm_fantasia_produto,
         c.cd_mascara_produto,
         isnull(c.qt_espessura_produto,0)      as 'Espessura',
         e.nm_grupo_produto,

         isnull(ps.qt_saldo_atual_produto,0)   as 'SaldoAtual',
         isnull(ps.qt_saldo_reserva_produto,0) as 'SaldoReserva',
         isnull(ps.qt_req_compra_produto,0)    as 'SaldoEmRequisicao',
         isnull(ps.qt_pd_compra_produto,0)     as 'SaldoEmPedido',

         Bruto =
         isnull((select sum(a.qt_saldo_atual_produto) from Produto_Saldo a
                 Left outer join Fase_Produto b on a.cd_fase_produto = b.cd_fase_produto
                 where a.cd_produto = c.cd_produto and a.cd_fase_produto = 1),0), 
         Processo =
         isnull((select sum(a.qt_saldo_atual_produto) from Produto_Saldo a
                 Left outer join Fase_Produto b on a.cd_fase_produto = b.cd_fase_produto
                 where a.cd_produto = c.cd_produto and a.cd_fase_produto = 2),0), 
         Terceiros =
         isnull((select sum(a.qt_saldo_atual_produto) from Produto_Saldo a
                 Left outer join Fase_Produto b on a.cd_fase_produto = b.cd_fase_produto
                 where a.cd_produto = c.cd_produto and a.cd_fase_produto = 4),0), 
         Montado = 
         isnull((select sum(a.qt_saldo_atual_produto) from Produto_Saldo a
                 Left outer join Fase_Produto b on a.cd_fase_produto = b.cd_fase_produto
                 where a.cd_produto = c.cd_produto and a.cd_fase_produto = 5),0), 
         Fabricacao2 =     
         isnull((select sum(a.qt_saldo_atual_produto) from Produto_Saldo a
                 Left outer join Fase_Produto b on a.cd_fase_produto = b.cd_fase_produto
                 where a.cd_produto = c.cd_produto and a.cd_fase_produto = 6),0), 
         Torno =
         isnull((select sum(a.qt_saldo_atual_produto) from Produto_Saldo a
                 Left outer join Fase_Produto b on a.cd_fase_produto = b.cd_fase_produto
                 where a.cd_produto = c.cd_produto and a.cd_fase_produto = 7),0)

  -------
  from Produto c
  -------

  Inner Join Produto d on
  c.cd_produto_baixa_estoque = d.cd_produto

  Inner Join Grupo_Produto e on
  c.cd_grupo_produto = e.cd_grupo_produto

  Inner Join Produto_Pcp g on
  c.cd_produto = g.cd_produto

  Left Outer Join Produto_Saldo ps on 
  c.cd_produto = ps.cd_produto

  where
    isnull(c.cd_produto_baixa_estoque,0) > 0  and
    g.ic_mapa_fabricacao_pinos = 'S' and
    c.cd_grupo_produto = @cd_grupo_produto and
    isnull(ps.cd_fase_produto,3) = 3

  --
  -- Movimentação de produtos nos últimos X meses
  -- Produtos que estão na seleção anterior
  --
  Select
    p.cd_produto,
    a.dt_movimento_estoque,
    a.qt_movimento_estoque as 'Qtde'
  -------
  into #TmpMovimentoProduto
  -------
  From
    #ProdutoTotal p
  
  Inner Join Movimento_Estoque a on
  p.cd_produto = a.cd_produto 
  
  Inner Join Nota_Saida_Item nsi on
  a.cd_documento_movimento = nsi.cd_nota_saida and
  a.cd_item_documento = nsi.cd_item_nota_saida
  
  Inner Join Nota_Saida ns on
  nsi.cd_nota_saida = ns.cd_nota_saida
  
  Inner Join Operacao_Fiscal op on
  ns.cd_operacao_fiscal = op.cd_operacao_fiscal
  
  Inner Join Tipo_Movimento_Estoque tme on
  a.cd_tipo_movimento_estoque = tme.cd_tipo_movimento_estoque
  
  Where
  ((@cd_ano_final_consumo = @cd_ano_inicial_consumo) and
   (year(a.dt_movimento_estoque) = @cd_ano_final_consumo) and 
   (month(a.dt_movimento_estoque) between @cd_mes_inicial_consumo and @cd_mes_final_consumo)) or
  ((@cd_ano_final_consumo > @cd_ano_inicial_consumo) and
   (year(a.dt_movimento_estoque) = @cd_ano_final_consumo and month(a.dt_movimento_estoque) between 1 and @cd_mes_final_consumo) or
   (year(a.dt_movimento_estoque) = @cd_ano_inicial_consumo and month(a.dt_movimento_estoque) between @cd_mes_inicial_consumo and 12)) and

   (ns.cd_status_nota <> 7 and
    nsi.cd_status_nota <> 7) and
    tme.ic_mov_tipo_movimento = 'S' and -- Saídas
    op.ic_comercial_operacao  = 'S' 

--

select @qt_media_total_consumo = Sum(Qtde) / @cd_meses
from #TmpMovimentoProduto

--

set @pc_fator = @cd_total_desejado / @qt_media_total_consumo

--
-- Seleção final
--

select p.cd_produto                as 'CodProduto',
       max(p.cd_mascara_produto)   as 'Mascara',
       max(p.nm_produto)           as 'Descricao', 
       max(p.nm_fantasia_produto)  as 'Produto',
       max(p.espessura)            as 'Espessura',
       max(p.nm_grupo_produto)     as 'GrupoProduto',
       min(a.dt_movimento_estoque) as 'LancMaisAntigo',
       max(a.dt_movimento_estoque) as 'LancMaisRecente',
       max(p.SaldoAtual)           as 'SaldoAtual',
       max(p.SaldoReserva)         as 'SaldoReserva',

       -- Claudio pediu alterações abaixo em 22/07/2003

       SaldoProducao = max(p.processo),
       -- max(p.bruto)+max(p.processo)+max(p.terceiros)+
       -- max(p.montado)+max(p.fabricacao2)+max(p.torno),

       SaldoTotal = max(p.saldoreserva)+max(p.processo),
       -- max(p.saldoreserva)+max(p.bruto)+max(p.processo)+max(p.terceiros)+
       -- max(p.montado)+max(p.fabricacao2)+max(p.torno),

       ConsumoMedio = 
          Sum(a.Qtde) / @cd_meses,
       Desejado =   
         (Sum(a.Qtde) / @cd_meses) * @pc_fator,
       Produzir =                                                -- Saldo total
          case when ( ((Sum(a.Qtde) / @cd_meses) * @pc_fator) - (max(p.saldoreserva)+max(p.processo)) ) < 0 then Null 
          else ((Sum(a.Qtde) / @cd_meses) * @pc_fator) - (max(p.saldoreserva)+max(p.processo)) end,

       -- Previsao de saida = Média de consumo * nro. de meses desejado
       PrevisaoSaida = 
         (Sum(a.Qtde) / @cd_meses) * @cd_meses,

       -- Previsto = Saldo atual - previsão de saída
       SaldoPrevisto = 
         (max(p.saldoreserva)+max(p.processo)) - ((Sum(a.Qtde) / @cd_meses) * @cd_meses),
       --(max(p.saldoreserva)+max(p.bruto)+max(p.processo)+max(p.terceiros)+
       -- max(p.montado)+max(p.fabricacao2)+max(p.torno) ) - ((Sum(a.Qtde) / @cd_meses) * @cd_meses),

       -- Duracao = Saldo total / Média de Consumo
       Duracao = 
         (max(p.saldoreserva)+max(p.processo)) / (Sum(a.Qtde) / @cd_meses),

       @cd_grupo_produto         as 'CodGrupo',
       @dt_base_final            as 'DataBase',
       @cd_meses                 as 'NroMeses',
       @cd_total_desejado        as 'EstoqueDesejado',
       @pc_fator                 as 'Fator',
       @qt_media_total_consumo   as 'TotalConsumo'

-------
from #ProdutoTotal p
-------

left outer join #TmpMovimentoProduto a on
p.cd_produto = a.cd_produto

group by p.cd_produto

order by max(p.cd_mascara_produto),
         max(p.espessura)

