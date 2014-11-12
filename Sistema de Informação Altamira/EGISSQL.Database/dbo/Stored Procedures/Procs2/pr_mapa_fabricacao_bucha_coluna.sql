
-- Somente produtos PCP
-- Produtos com mapa fabricacao de pinos <> 'S'
-- Inner join com Diametro e Left Outer com Tipo Forma MP (Só participam produtos com diâmetro e forma MP)
-- Existe um diferença entre Mercados Interno e Externo
-- Se @ic_saldos_zerados = 'N', "tirar" Consumo Mensal=0 ou Lote de Fabricacao=0
-- Ordenar por Diametro e Materia Prima (para quebra no relatório)

CREATE procedure pr_mapa_fabricacao_bucha_coluna

@ic_parametro        int,     -- 1 = Mapa de Bucha e Coluna, 2 = Mapa de fabricação 
@cd_grupo_produto    int,
@cd_produto          int,
@cd_serie_produto    int,
@cd_tipo_mercado     int,
@cd_meses_fabricacao int,     -- Meses a fabricar
@ic_saldos_zerados   char(1), -- Se lista também produtos sem saldo
@cd_dias_consumo     int      -- Dias de Consumo Médio 

as

declare @data_inicial datetime
declare @data_final   datetime 

set @data_inicial = DateAdd(Day, @cd_dias_consumo*-1, GETDATE() )
set @data_final   = GETDATE()

declare @cd_meses int
set @cd_meses = DateDiff(Month, @data_inicial, @Data_final)

----------------------------
-- Saldos do próprio produto
----------------------------
  Select

    p.cd_produto                  as 'CodProduto',
    p.nm_fantasia_produto         as 'Produto',
    p.nm_produto                  as 'Descricao',
    p.cd_mascara_produto          as 'MascaraProduto',
    p.cd_grupo_produto            as 'CodGrupoProduto',
    pcp.qt_lote_fabricacao_prod   as 'LoteFabricacao',
    pcp.cd_diametro_material_comp as 'CodDiametro',
    pcp.cd_tipo_forma_mat_prima   as 'CodFormaMP',
    pcp.qt_comprimento_material   as 'ComprimentoMP',
    d.sg_diametro_material_comp   as 'Diametro',
    d.qt_diametro_material_comp   as 'DiametroMM',  -- Diâmetro em milímetros
    e.sg_tipo_forma_mat_prima     as 'FormaMP',
    d.sg_diametro_material_comp   as 'Quebra',
 -- p.nm_fantasia_produto+
 -- d.sg_diametro_material_comp   as 'Quebra',

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
    ConsumoMensal =
    isnull(pcp.qt_consumo_mes_produto,
       isnull((select qt_consumo_produto from produto_saldo
                where cd_produto = p.cd_produto and cd_fase_produto = 3),0))

  into #TmpSaldosProduto

  From
    Produto p

  Inner Join Produto_Pcp pcp on
  p.cd_produto = pcp.cd_produto

  Left Outer Join Produto_Saldo b on
  p.cd_produto = b.cd_produto

  Inner Join Grupo_Produto c on
  p.cd_grupo_produto = c.cd_grupo_produto

  Inner Join Diametro_Material_Componente d on
  pcp.cd_diametro_material_comp = d.cd_diametro_material_comp

  Left Outer Join Tipo_Forma_Materia_Prima e on
  pcp.cd_tipo_forma_mat_prima = e.cd_tipo_forma_mat_prima

  Where
   (@cd_grupo_produto = 0 or p.cd_grupo_produto = @cd_grupo_produto) and
   (@cd_produto = 0 or p.cd_produto = @cd_produto) and
   (@cd_serie_produto = 0 or p.cd_serie_produto = @cd_serie_produto) and
   (p.cd_produto_baixa_estoque is null or
    p.cd_produto_baixa_estoque = 0) and
    p.ic_controle_pcp_produto = 'S' and
    b.cd_fase_produto = 3 and
    pcp.ic_mapa_fabricacao_pinos <> 'S' and
   (@cd_tipo_mercado = 0 or isnull(pcp.cd_tipo_mercado,1) = @cd_tipo_mercado)

---------------------------------------------------
-- Saldos de produtos com baixa de estoque em outro
---------------------------------------------------

  Select

    p.cd_produto                  as 'CodProduto',
    p.nm_fantasia_produto         as 'Produto',
    p.nm_produto                  as 'Descricao',
    p.cd_mascara_produto          as 'MascaraProduto',
    p.cd_grupo_produto            as 'CodGrupoProduto',
    pcp.qt_lote_fabricacao_prod   as 'LoteFabricacao',
    pcp.cd_diametro_material_comp as 'CodDiametro',
    pcp.cd_tipo_forma_mat_prima   as 'CodFormaMP',
    pcp.qt_comprimento_material   as 'ComprimentoMP',
    d.sg_diametro_material_comp   as 'Diametro',
    d.qt_diametro_material_comp   as 'DiametroMM',  -- Diâmetro em milímetros
    e.sg_tipo_forma_mat_prima     as 'FormaMP',
    d.sg_diametro_material_comp   as 'Quebra',
 -- o.nm_fantasia_produto+
 -- d.sg_diametro_material_comp   as 'Quebra',

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
    ConsumoMensal =
    isnull(pcp.qt_consumo_mes_produto,
       isnull((select qt_consumo_produto from produto_saldo
                where cd_produto = p.cd_produto and cd_fase_produto = 3),0))

  into #TmpSaldosOutroProduto

  From
    Produto p

  Inner Join Produto o on
  p.cd_produto_baixa_estoque = o.cd_produto

  Inner Join Produto_Pcp pcp on
  p.cd_produto = pcp.cd_produto

  Left Outer Join Produto_Saldo b on
  p.cd_produto = b.cd_produto

  Inner Join Grupo_Produto c on
  p.cd_grupo_produto = c.cd_grupo_produto

  Inner Join Diametro_Material_Componente d on
  pcp.cd_diametro_material_comp = d.cd_diametro_material_comp

  Left Outer Join Tipo_Forma_Materia_Prima e on
  pcp.cd_tipo_forma_mat_prima = e.cd_tipo_forma_mat_prima

  Where
   (@cd_grupo_produto = 0 or p.cd_grupo_produto = @cd_grupo_produto) and
   (@cd_produto = 0 or p.cd_produto = @cd_produto) and
   (@cd_serie_produto = 0 or p.cd_serie_produto = @cd_serie_produto) and
    isnull(p.cd_produto_baixa_estoque,0) > 0 and
    p.ic_controle_pcp_produto = 'S' and
    pcp.ic_mapa_fabricacao_pinos <> 'S' and
   (@cd_tipo_mercado = 0 or 
    isnull(pcp.cd_tipo_mercado,1) = @cd_tipo_mercado) and
    b.cd_fase_produto = 3 and
   (p.cd_produto_baixa_estoque is null or
    p.cd_produto_baixa_estoque = 0)

------------------------
-- Junta as duas tabelas
------------------------

insert into #TmpSaldosProduto
select * from #TmpSaldosOutroProduto

-- Existe diferença entre Mercados Interno e Externo

select Diametro,
       FormaMP,
       CodProduto,
       Produto,
       Descricao,
       CodGrupoProduto,
       MascaraProduto,
       ComprimentoMP,  
       Quebra,
       Bruto,
       Processo               as 'Fabricacao',
       SaldoAtual             as 'Acabado',
       Terceiros,
       Fabricacao2            as 'Fabr2',
       Montado,
       Torno,
       SaldoEmRequisicao      as 'Requisicao',
       SaldoEmPedido          as 'PedCompra',
       Total = 
         (Processo+SaldoAtual+Torno),
       -- Alterado por solicitação do Roberto em 22/07/2003
       --(Bruto+Processo+SaldoReserva+Terceiros+Fabricacao2+Montado+SaldoEmRequisicao+SaldoEmPedido),
       ConsumoMensal =
       case when @cd_tipo_mercado = 1 then -- 1 = Interno, 2 = Externo
          ConsumoMensal
       else SaldoMinimo end,
       Duracao =
       case 
       when (ConsumoMensal > 0) and
          ((Processo+SaldoAtual+Torno) > 0) then 
          ((Processo+SaldoAtual+Torno)/ConsumoMensal)
       when (Processo+SaldoAtual+Torno) > 0 then 1 -- Como não têm consumo, no mínimo vai durar um mês
       -- (Processo+SaldoAtual+Torno)
       else 0 end,
       LoteFabricacao
-------
into #TmpFinal
-------
from #TmpSaldosProduto
-------

-- Seleção final

if @ic_parametro = 1 
begin

  if @ic_saldos_zerados = 'S' 
     select *
     from #TmpFinal
     order by MascaraProduto,
              Diametro
              
  else
     select *
     from #TmpFinal
     where ConsumoMensal > 0 and
           LoteFabricacao > 0
     order by MascaraProduto,
              Diametro
end

else

  if @ic_parametro = 2 
  begin
    if @ic_saldos_zerados = 'S'
    begin 
       select *,
            FabricarAux =
            case 
            when Total > 0 then
              case when (ConsumoMensal * @cd_meses_fabricacao - Total) > 0 then
                (ConsumoMensal * @cd_meses_fabricacao - Total)
              else 0 end
            when Total <= 0 then
              case when (ConsumoMensal * @cd_meses_fabricacao) > 0 then
                (ConsumoMensal * @cd_meses_fabricacao)
              else 0 end
            end
       into #TmpTermino 
       from #TmpFinal
       where (ConsumoMensal * @cd_meses_fabricacao - Abs(Total)) > 0

       select *,
              QtdeFabricar = 
              case when FabricarAux > cast(FabricarAux as int) then
                 cast(FabricarAux as int)+1
              else cast(FabricarAux as int) end,
              Barras = 
              case 
              when (FabricarAux <= 0) or (LoteFabricacao <= 0) then 0
              when (FabricarAux / LoteFabricacao) > (cast(FabricarAux / LoteFabricacao as int)) then
                 cast(FabricarAux / LoteFabricacao as int)+1
              else cast(FabricarAux / LoteFabricacao as int) end
       from #TmpTermino
       order by MascaraProduto,
                Diametro
                
    end
    
    else
    
    begin
       select *,
            FabricarAux =
            case 
            when Total > 0 then
              case when (ConsumoMensal * @cd_meses_fabricacao - Total) > 0 then
                (ConsumoMensal * @cd_meses_fabricacao - Total)
              else 0 end
            when Total <= 0 then
              case when (ConsumoMensal * @cd_meses_fabricacao) > 0 then
                (ConsumoMensal * @cd_meses_fabricacao)
              else 0 end
            end
       into #TmpTermino1
       from #TmpFinal
       where ConsumoMensal > 0 and
             LoteFabricacao > 0 and
         -- Linha incluída em 30/10/2003 : Lucio
             Duracao <= @cd_meses_fabricacao
         -- (ConsumoMensal * @cd_meses_fabricacao - Total) > 0 : Comentada em 30/10/2003
    
       select *,
              QtdeFabricar = 
              case when FabricarAux > cast(FabricarAux as int) then
                 cast(FabricarAux as int)+1
              else cast(FabricarAux as int) end,
              Barras = 
              case 
              when LoteFabricacao <= 0 then 0
              when (FabricarAux / LoteFabricacao) > (cast(FabricarAux / LoteFabricacao as int)) then
                 cast(FabricarAux / LoteFabricacao as int)+1
              else cast(FabricarAux / LoteFabricacao as int) end
       from #TmpTermino1
       order by MascaraProduto,
                Diametro
    end   
  end

