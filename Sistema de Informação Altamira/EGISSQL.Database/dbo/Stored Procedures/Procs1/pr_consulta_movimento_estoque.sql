
CREATE PROCEDURE pr_consulta_movimento_estoque
--pr_consulta_movimento_estoque
---------------------------------------------------
--GBS - Global Business Solution	       2002
--Stored Procedure: Microsoft SQL Server       2000
--Autor(es)     : Daniel Duela
--Banco de Dados: EgisSQL
--Objetivo      : Consulta de Movimentação no Estoque por Produto
--Data          : 11/09/2002
--                22/04/2003 - Modificada a chamada a função fn_produto_localizacao
--                             que passa a receber também o código da fase - ELIAS
---------------------------------------------------
@ic_parametro               int, 
@dt_inicial                 datetime,
@dt_final                   datetime,
@cd_fase_produto            int,
@cd_produto                 int,
@cd_grupo_produto           int,
@cd_serie_produto           int

AS

declare 
@vl_saldo_inicial           float

set @vl_saldo_inicial       = 0

-------------------------------------------------------------------------------
-- Achando o Saldo Final do Mês Anterior 
-------------------------------------------------------------------------------
--  EXECUTE pr_saldo_inicial 
  --        1, @dt_inicial, @dt_final, @cd_produto, @cd_fase_produto, @vl_saldo_inicial=@vl_saldo_inicial output
--  print('Saldo Inicial Total: '+cast(@vl_saldo_inicial as varchar))

-------------------------------------------------------------------------------
if @ic_parametro = 1    -- Consulta Resumo Geral 
-------------------------------------------------------------------------------
begin
  select distinct    
    me.cd_produto,
    p.nm_fantasia_produto,
    dbo.fn_produto_localizacao(p.cd_produto,me.cd_fase_produto) as 'LOCALIZACAO',  -- 22/04/2003
    p.nm_produto,
    gp.nm_grupo_produto,
    sp.nm_serie_produto,
    @vl_saldo_inicial as 'Saldo_Anterior',
    (select isnull(sum(me1.qt_movimento_estoque),0.00)
     from Movimento_Estoque me1
     left outer join Tipo_Movimento_Estoque tme on
       tme.cd_tipo_movimento_estoque = me1.cd_tipo_movimento_estoque
     where
       tme.ic_mov_tipo_movimento = 'E' and
       me1.dt_movimento_estoque between @dt_inicial and @dt_final and
       me1.cd_produto = me.cd_produto and
       me1.cd_fase_produto = @cd_fase_produto) as 'Entrada',
    (select isnull(sum(me1.qt_movimento_estoque),0.00)
     from Movimento_Estoque me1
     left outer join Tipo_Movimento_Estoque tme on
       tme.cd_tipo_movimento_estoque = me1.cd_tipo_movimento_estoque
     where
       tme.ic_mov_tipo_movimento = 'S' and
       me1.dt_movimento_estoque between @dt_inicial and @dt_final and
       me1.cd_produto = me.cd_produto and
       me1.cd_fase_produto = @cd_fase_produto) as 'Saida',
    (select qt_saldo_reserva_produto from Produto_Saldo
     where cd_produto = me.cd_produto and cd_fase_produto = @cd_fase_produto) as 'Saldo_Atual',
    (select qt_saldo_atual_produto from Produto_Saldo
     where cd_produto = me.cd_produto and cd_fase_produto = @cd_fase_produto) as 'Saldo_Reserva',
    (select qt_consig_produto from Produto_Saldo
     where cd_produto = me.cd_produto and cd_fase_produto = @cd_fase_produto) as 'Saldo_Consignacao',
    (select qt_terceiro_produto from Produto_Saldo
     where cd_produto = me.cd_produto and cd_fase_produto = @cd_fase_produto) as 'Saldo_Terceiros'
  from 
    Movimento_Estoque me
      left outer join 
    Produto p 
      on p.cd_produto = me.cd_produto
      left outer join 
    Grupo_Produto gp 
      on gp.cd_grupo_produto = p.cd_grupo_produto
      left outer join 
    Serie_Produto sp 
      on sp.cd_serie_produto = p.cd_serie_produto
  where
    (p.cd_serie_produto = @cd_serie_produto or @cd_serie_produto = 0) and
    (p.cd_produto = @cd_produto or @cd_produto = 0) and
    (p.cd_grupo_produto = @cd_grupo_produto or @cd_grupo_produto = 0) and
    me.dt_movimento_estoque between @dt_inicial and @dt_final
  group by 
    me.cd_produto, 
    p.nm_fantasia_produto, 
    p.cd_produto,
    p.nm_produto, 
    gp.nm_grupo_produto, 
    sp.nm_serie_produto,
    me.cd_fase_produto -- 22/04/2003

  order by 
    p.nm_fantasia_produto
end

-------------------------------------------------------------------------------
if @ic_parametro = 2    -- Consulta Analítico Geral 
-------------------------------------------------------------------------------
begin

  select distinct    
    me.cd_movimento_estoque,
    me.dt_movimento_estoque,
    tme.ic_mov_tipo_movimento,
    me.cd_produto,
    dbo.fn_produto_localizacao(p.cd_produto,me.cd_fase_produto) as 'LOCALIZACAO', --22/04/2003
    p.nm_fantasia_produto,
    p.nm_produto,
    me.qt_movimento_estoque,
    me.nm_historico_movimento,
   tme.nm_tipo_movimento_estoque,
   tde.nm_tipo_documento_estoque,
   me.cd_documento_movimento,
   me.cd_item_documento,
   td.nm_tipo_destinatario,
   me.nm_destinatario
  from 
    Movimento_Estoque me
      left outer join 
    Tipo_Movimento_Estoque tme 
      on  tme.cd_tipo_movimento_estoque = me.cd_tipo_movimento_estoque
      left outer join 
    Tipo_Documento_Estoque tde 
      on tde.cd_tipo_documento_estoque = me.cd_tipo_documento_estoque
      left outer join 
    Tipo_Destinatario td
      on me.cd_tipo_destinatario = td.cd_tipo_destinatario
      Left Outer Join
    Produto p 
      on p.cd_produto = me.cd_produto
      left outer join 
    Grupo_Produto gp 
      on gp.cd_grupo_produto = p.cd_grupo_produto
      left outer join 
    Serie_Produto sp 
      on sp.cd_serie_produto = p.cd_serie_produto
  where
    (p.cd_serie_produto = @cd_serie_produto or @cd_serie_produto = 0) and
    (p.cd_produto       = @cd_produto       or @cd_produto       = 0) and
    (p.cd_grupo_produto = @cd_grupo_produto or @cd_grupo_produto = 0) and
    me.dt_movimento_estoque between @dt_inicial and @dt_final
  order by 
    me.cd_movimento_estoque desc

end

