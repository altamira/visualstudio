create procedure pr_consulta_produto_custo_contabil_zerado
---------------------------------------------------
--GBS - Global Business Solution	       2002
--Stored Procedure: Microsoft SQL Server       2000
--Autor(es): Igor Gama
--Banco de Dados: EgisSql
--Objetivo: Consulta das Notas de importacao sem invoice ou DI
--Data: 01.04.2004
---------------------------------------------------
@dt_base as DateTime
as

  --Movimentos de estoque sem custo contábil
  select
    distinct
    me.cd_produto,
    dbo.fn_mascara_produto(me.cd_produto) as cd_mascara_produto,
    p.nm_fantasia_produto,
    p.nm_produto,
    fp.sg_fase_produto
  from
    Movimento_Estoque me,
    Produto	    p,
    Fase_Produto	    fp,
    Tipo_Movimento_Estoque tme
  where
    me.cd_produto = p.cd_produto and
    me.cd_fase_produto = fp.cd_fase_produto and
    me.cd_tipo_movimento_estoque = tme.cd_tipo_movimento_estoque and
    tme.nm_atributo_produto_saldo = 'qt_saldo_atual_produto' and
    me.vl_custo_contabil_produto <= 0 and
    me.dt_movimento_estoque < @dt_base
  order by
    me.cd_produto


