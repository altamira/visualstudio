
CREATE procedure pr_mapa_compra_placas

@cd_parametro       int,
@cd_grupo_produto   int,
@nm_filtro          varchar(80),
@ic_saldos_zerados  char(1),
@cd_tipo_mercado    int,
@cd_dias_consumo    int,
@ic_tipo_filtro     char(1)

as

declare @data_inicial datetime
declare @data_final   datetime 
set @data_inicial = DateAdd(Day, @cd_dias_consumo*-1, GETDATE() )
set @data_final   = GETDATE()

declare @cd_meses int
set @cd_meses = DateDiff(Month, @data_inicial, @Data_final)


declare @Mascara_Limpa varchar(30)

set @Mascara_Limpa = Replace(@nm_filtro,'.','')
set @Mascara_Limpa = Replace(@Mascara_Limpa,'-','')




--Carlos
--20/6/2003
--Temporariamente até o atributo correto ficar pronto na tabela Produto_PCP
--Atributo : qt_consumo_mes_produto

declare @cd_fase_produto int
set @cd_fase_produto = 3           --Acabado

----------------------------
-- Saldos do próprio produto
----------------------------
  Select

    p.cd_produto                as 'CodProduto',
    p.nm_fantasia_produto       as 'Produto',
    p.cd_mascara_produto        as 'MascaraProduto',
    p.cd_grupo_produto          as 'GrupoProduto',
    c.nm_grupo_produto          as 'DescricaoGrupoProduto',
    p.qt_espessura_produto      as 'Espessura',
    p.qt_largura_produto        as 'Largura',
    p.qt_comprimento_produto    as 'Comprimento',
    p.cd_categoria_produto      as 'CodCategoriaProduto',
 -- p.cd_materia_prima          as 'CodMatPrima',
    1                           as 'CodMatPrima',
--  p.qt_consumo_mensal_produto as 'ConsumoProduto',
    30                          as 'ConsumoProduto',

    Bruto =
    isnull((select sum(a.qt_saldo_atual_produto) from Produto_Saldo a
            Left outer join Fase_Produto b on a.cd_fase_produto = b.cd_fase_produto
            where a.cd_produto = p.cd_produto and a.cd_fase_produto = 1),0), 
    Processo =
    isnull((select sum(a.qt_saldo_atual_produto) from Produto_Saldo a
            Left outer join Fase_Produto b on a.cd_fase_produto = b.cd_fase_produto
            where a.cd_produto = p.cd_produto and a.cd_fase_produto = 2),0), 
    Acabado =
    isnull((select sum(a.qt_saldo_atual_produto) from Produto_Saldo a
            Left outer join Fase_Produto b on a.cd_fase_produto = b.cd_fase_produto
            where a.cd_produto = p.cd_produto and a.cd_fase_produto = 3),0), 
    Terceiros =
    isnull((select sum(a.qt_saldo_atual_produto) from Produto_Saldo a
            Left outer join Fase_Produto b on a.cd_fase_produto = b.cd_fase_produto
            where a.cd_produto = p.cd_produto and a.cd_fase_produto = 4),0), 
    Montado = 
    isnull((select sum(a.qt_saldo_atual_produto) from Produto_Saldo a
            Left outer join Fase_Produto b on a.cd_fase_produto = b.cd_fase_produto
            where a.cd_produto = p.cd_produto and a.cd_fase_produto = 5),0), 
    Fabricacao2 =     
    isnull((select sum(a.qt_saldo_atual_produto) from Produto_Saldo a
            Left outer join Fase_Produto b on a.cd_fase_produto = b.cd_fase_produto
            where a.cd_produto = p.cd_produto and a.cd_fase_produto = 6),0), 
    Torno =
    isnull((select sum(a.qt_saldo_atual_produto) from Produto_Saldo a
            Left outer join Fase_Produto b on a.cd_fase_produto = b.cd_fase_produto
            where a.cd_produto = p.cd_produto and a.cd_fase_produto = 7),0), 

    isnull(b.qt_saldo_reserva_produto,0) as 'SaldoReserva',
    isnull(b.qt_saldo_atual_produto,0)   as 'SaldoAtual',
    isnull(b.qt_req_compra_produto,0)    as 'SaldoEmRequisicao',
    isnull(b.qt_pd_compra_produto,0)     as 'SaldoEmPedido',
    isnull(b.qt_minimo_produto,0)        as 'SaldoMinimo',

    --Carlos Cardoso Fernandes
    --20/6/2003

    --isnull((select sum(me.qt_movimento_estoque)/@cd_meses 
    --        from movimento_estoque me
    --        where (me.cd_produto = p.cd_produto) and
    --              (me.dt_movimento_estoque between @data_inicial and 
    --                                               @data_final) and
    --              (me.ic_mov_movimento = 'S')),0) as 'ConsumoMensal',

    isnull((select qt_consumo_produto from produto_saldo 
             where cd_produto = p.cd_produto and cd_fase_produto = @cd_fase_produto),0) as 'ConsumoMensal',
     
    isnull((select qt_lote_fabricacao_prod from produto_pcp
            where cd_produto = p.cd_produto),0) as 'LoteFabricacao'

  into #TmpSaldosProduto

  From
    Produto p

  Left Outer Join Produto_Saldo b on
    p.cd_produto = b.cd_produto

  Inner Join Grupo_Produto c on
    p.cd_grupo_produto = c.cd_grupo_produto

  Where
   IsNull(p.cd_produto_baixa_estoque,0) = 0 and
    c.ic_mapa_placa_grupo = 'S' and
    b.cd_fase_produto = 3 and
    IsNull(p.cd_grupo_produto,0) = ( case when @cd_grupo_produto = 0 
                                     then IsNull(p.cd_grupo_produto,0)
                                     else @cd_grupo_produto end ) and
    ( case when @ic_tipo_filtro = 'C' then
        IsNull(p.cd_mascara_produto,'') 
      when @ic_tipo_filtro = 'F' then
        IsNull(p.nm_fantasia_produto,'')
      else
        IsNull(p.nm_produto,'') end ) like ( case when @ic_tipo_filtro = 'C' then
                                              @Mascara_Limpa 
                                                  else @nm_filtro end ) + '%'
    
--   (@cd_tipo_mercado = 0 or 
--    p.cd_origem_produto = @cd_tipo_mercado)

---------------------------------------------------
-- Saldos de produtos com baixa de estoque em outro
---------------------------------------------------

  Select

    o.cd_produto                as 'CodProduto',
    o.nm_fantasia_produto       as 'Produto',
    o.cd_mascara_produto        as 'MascaraProduto',
    o.cd_grupo_produto          as 'GrupoProduto',
    c.nm_grupo_produto          as 'DescricaoGrupoProduto',
    o.qt_espessura_produto      as 'Espessura',
    o.qt_largura_produto        as 'Largura',
    o.qt_comprimento_produto    as 'Comprimento',
    o.cd_categoria_produto      as 'CodCategoriaProduto',
--  o.cd_materia_prima          as 'CodMatPrima',
    1                           as 'CodMatPrima',  
--  o.qt_consumo_mensal_produto as 'ConsumoProduto',
    30                          as 'ConsumoProduto',  

    Bruto =
    isnull((select sum(a.qt_saldo_atual_produto) from Produto_Saldo a
            Left outer join Fase_Produto b on a.cd_fase_produto = b.cd_fase_produto
            where a.cd_produto = o.cd_produto and a.cd_fase_produto = 1),0), 
    Processo =
    isnull((select sum(a.qt_saldo_atual_produto) from Produto_Saldo a
            Left outer join Fase_Produto b on a.cd_fase_produto = b.cd_fase_produto
            where a.cd_produto = o.cd_produto and a.cd_fase_produto = 2),0), 
    Acabado =
    isnull((select sum(a.qt_saldo_atual_produto) from Produto_Saldo a
            Left outer join Fase_Produto b on a.cd_fase_produto = b.cd_fase_produto
            where a.cd_produto = o.cd_produto and a.cd_fase_produto = 3),0), 

    Terceiros =
    isnull((select sum(a.qt_saldo_atual_produto) from Produto_Saldo a
            Left outer join Fase_Produto b on a.cd_fase_produto = b.cd_fase_produto
            where a.cd_produto = o.cd_produto and a.cd_fase_produto = 4),0), 

    Montado = 
    isnull((select sum(a.qt_saldo_atual_produto) from Produto_Saldo a
            Left outer join Fase_Produto b on a.cd_fase_produto = b.cd_fase_produto
            where a.cd_produto = o.cd_produto and a.cd_fase_produto = 5),0), 
    Fabricacao2 =     
    isnull((select sum(a.qt_saldo_atual_produto) from Produto_Saldo a
            Left outer join Fase_Produto b on a.cd_fase_produto = b.cd_fase_produto
            where a.cd_produto = o.cd_produto and a.cd_fase_produto = 6),0), 
    Torno =
    isnull((select sum(a.qt_saldo_atual_produto) from Produto_Saldo a
            Left outer join Fase_Produto b on a.cd_fase_produto = b.cd_fase_produto
            where a.cd_produto = o.cd_produto and a.cd_fase_produto = 7),0), 

    isnull(b.qt_saldo_reserva_produto,0) as 'SaldoReserva',
    isnull(b.qt_saldo_atual_produto,0)   as 'SaldoAtual',
    isnull(b.qt_req_compra_produto,0)    as 'SaldoEmRequisicao',
    isnull(b.qt_pd_compra_produto,0)     as 'SaldoEmPedido',
    isnull(b.qt_minimo_produto,0)        as 'SaldoMinimo',

--    isnull((select sum(me.qt_movimento_estoque)/@cd_meses 
--            from movimento_estoque me
--            where (me.cd_produto = o.cd_produto) and
--                  (me.dt_movimento_estoque between @data_inicial and 
--                                                   @data_final) and
--                  (me.ic_mov_movimento = 'S')),0) as 'ConsumoMensal',

    --Carlos Cardoso Fernandes
    --20/6/2003

    isnull((select qt_consumo_produto from produto_saldo 
             where cd_produto = p.cd_produto and cd_fase_produto = @cd_fase_produto),0) as 'ConsumoMensal',

    isnull((select qt_lote_fabricacao_prod from produto_pcp
            where cd_produto = p.cd_produto),0) as 'LoteFabricacao'

  into #TmpSaldosOutroProduto

  From
    Produto p

  Inner Join Produto o on
  p.cd_produto_baixa_estoque = o.cd_produto

  Left Outer Join Produto_Saldo b on
  o.cd_produto = b.cd_produto

  Inner Join Grupo_Produto c on
  o.cd_grupo_produto = c.cd_grupo_produto

  Where
    isnull(p.cd_produto_baixa_estoque,0) > 0  and
    c.ic_mapa_placa_grupo = 'S' and
    b.cd_fase_produto = 3 and
    IsNull(p.cd_grupo_produto,0) = ( case when @cd_grupo_produto = 0 
                                     then IsNull(p.cd_grupo_produto,0)
                                     else @cd_grupo_produto end ) and
    ( case when @ic_tipo_filtro = 'C' then
        IsNull(p.cd_mascara_produto,'') 
      when @ic_tipo_filtro = 'F' then
        IsNull(p.nm_fantasia_produto,'')
      else
        IsNull(p.nm_produto,'') end ) like ( case when @ic_tipo_filtro = 'C' then
                                              @Mascara_Limpa 
                                                  else @nm_filtro end ) + '%'

------------------------
-- Junta as duas tabelas
------------------------

insert into #TmpSaldosProduto
select * from #TmpSaldosOutroProduto

-- Seleção final

select CodProduto,
       Produto,
       GrupoProduto,
       DescricaoGrupoProduto,
       MascaraProduto,
       Espessura,
       Largura,
       Comprimento,
       CodCategoriaProduto,
       CodMatPrima,
       ConsumoProduto,
       Bruto,
       Processo               as 'Fabricacao',
       SaldoReserva           as 'Reserva',
       Terceiros,
       Fabricacao2            as 'Fabr. II',
       Montado,
       SaldoEmRequisicao      as 'Requisicao',
       SaldoEmPedido          as 'Ped. Compra',
       Total = 
         (Bruto+Processo+SaldoReserva+Terceiros+Fabricacao2+Montado+SaldoEmRequisicao),
       round(ConsumoMensal,0) as 'Mensal', 
       round(SaldoMinimo,0)   as 'Minimo',
       SaldoAtual             as 'Atual',

       -- Duracao = Total Geral / Consumo Mensal * 30 (Dias)
       Duracao = 
       case when ((Bruto+Processo+SaldoReserva+Terceiros+Fabricacao2+Montado+SaldoEmRequisicao) <= 0) then 0
            when ConsumoMensal > 0 then
              round(((Bruto+Processo+SaldoReserva+Terceiros+Fabricacao2+Montado+SaldoEmRequisicao) /
                    ConsumoMensal) * 30, 0) 
            when ConsumoMensal = 0 then
              round((Bruto+Processo+SaldoReserva+Terceiros+Fabricacao2+Montado+SaldoEmRequisicao) * 30, 0)
       else 
          0 end, 

       --Carlos/Ludinei
       --20/6/2003
       --Verificação e Acerto da Quantidade a Comprar verificar qual é o Menor Valor
       --Comprar o Lote de Fabricação 

       qtdecomprar = 
--       case 
--       when @cd_tipo_mercado = 1 then -- Interno
--
          -- Se o consumo mensal > saldo total então a compra é o consumo-total
--          case when ConsumoMensal > (Bruto+Processo+SaldoReserva+Terceiros+Fabricacao2+Montado+SaldoEmRequisicao) then
--             Abs(round(ConsumoMensal,0)-(Bruto+Processo+SaldoReserva+Terceiros+Fabricacao2+Montado+SaldoEmRequisicao)) 
--          else '' end
--
--       when @cd_tipo_mercado = 2 then -- Externo

          -- Se o consumo mensal > saldo total então... Se o Total for < lote, compra o lote
          case 
          when (ConsumoMensal >= (Bruto+Processo+SaldoReserva+Terceiros+Fabricacao2+Montado+SaldoEmRequisicao) or
               (Bruto+Processo+SaldoReserva+Terceiros+Fabricacao2+Montado+SaldoEmRequisicao) < LoteFabricacao) then
             LoteFabricacao
               -- caso contrário, compra o consumo mensal

--          when (ConsumoMensal > (Bruto+Processo+SaldoReserva+Terceiros+Fabricacao2+Montado+SaldoEmRequisicao) and
--               (Bruto+Processo+SaldoReserva+Terceiros+Fabricacao2+Montado+SaldoEmRequisicao) >= LoteFabricacao) then
          else round(ConsumoMensal,0) end

--          else '' end

--       else '' end

into #TmpFinal
-------
from #TmpSaldosProduto
-------

--------------------
if @cd_parametro = 1
--------------------
begin
   if @ic_saldos_zerados = 'S'
      select *,
             novaduracao = 
             case when (qtdecomprar > 0 and mensal > 0) then
                   cast(round((qtdecomprar/mensal)*30,0) as varchar(5)) + ' du'
             else '' end
      from #TmpFinal
      order by GrupoProduto,
               MascaraProduto
   else
      select *,
             novaduracao = 
             case when (qtdecomprar > 0 and mensal > 0) then
                 cast(round((qtdecomprar/mensal)*30,0) as varchar(5)) + ' du'
             else '' end
      from #TmpFinal
      where total > 0
      order by GrupoProduto,
               MascaraProduto
end

else
  --------------------
  if @cd_parametro = 2
  --------------------
  begin
     if @ic_saldos_zerados = 'S'
        select CodProduto,
               Produto,
               GrupoProduto,
               DescricaoGrupoProduto,
               MascaraProduto,
               CodMatPrima,
               CodCategoriaProduto,
               Cast('' as VarChar(30)) as 'MedBruta',
               Cast('' as VarChar(30)) as 'MedAcab',
               Cast(0 as float)     as 'EspesBruta',
               Cast(0 as float)     as 'LargBruta',
               Cast(0 as float)     as 'CompBruto',
               round(Espessura,0)   as 'EspesAcab',
               round(Largura,0)     as 'LargAcab',
               round(Comprimento,0) as 'CompAcab',
               Cast(0 as float)     as 'PesoBruto',
               Cast(0 as float)     as 'PesoLiquido', 
               Cast(0 as float)     as 'PesoBrutoTotal',
               Cast(0 as float)     as 'PesoLiquidoTotal', 
               QtdeComprar,
               Necessidade = 
               case 
               when codmatprima <> 3 then
                  case when ((total/consumoproduto*30) <= 5) then 5 
                       when ((total/consumoproduto*30) between 6 and 15) then 7 
                  else 10 end
               when codmatprima = 3 then               
                  case when ((total/consumoproduto*30) <= 5) then 3 
                  else 5 end
               else Null end
        from #TmpFinal
        where QtdeComprar > 0
        order by GrupoProduto,
                 MascaraProduto

     else

        select CodProduto,
               Produto,
               GrupoProduto,
               DescricaoGrupoProduto,
               MascaraProduto,
               CodMatPrima,
               CodCategoriaProduto,
               Cast('' as VarChar(30)) as 'MedBruta',
               Cast('' as VarChar(30)) as 'MedAcab',
               Cast(0 as float)        as 'EspesBruta',
               Cast(0 as float)        as 'LargBruta',
               Cast(0 as float)        as 'CompBruto',
               round(Espessura,0)      as 'EspesAcab',
               round(Largura,0)        as 'LargAcab',
               round(Comprimento,0)    as 'CompAcab',
               Cast(0 as float)        as 'PesoBruto',
               Cast(0 as float)        as 'PesoLiquido', 
               Cast(0 as float)        as 'PesoBrutoTotal',
               Cast(0 as float)        as 'PesoLiquidoTotal', 
               QtdeComprar,
               Necessidade = 
               case 
               when codmatprima <> 3 then
                  case when ((total/consumoproduto*30) <= 5) then 5 
                       when ((total/consumoproduto*30) between 6 and 15) then 7 
                  else 10 end
               when codmatprima = 3 then               
                  case when ((total/consumoproduto*30) <= 5) then 3 
                  else 5 end
               else Null end
        from #TmpFinal
        where QtdeComprar > 0 and
              Total > 0
        order by GrupoProduto,
                 MascaraProduto
  end

