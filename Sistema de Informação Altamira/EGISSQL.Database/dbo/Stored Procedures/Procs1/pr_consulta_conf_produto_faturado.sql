
CREATE PROCEDURE pr_consulta_conf_produto_faturado
---------------------------------------------------
--GBS - Global Business Solution	             2003
--Stored Procedure: Microsoft SQL Server       2000
--Autor(es): Igor Gama
--Banco de Dados: EgisSql
--Objetivo: Consulta para conferência de faturamento.
--Data: 06/01/2003
--Atualizado:
---------------------------------------------------
@cd_agrupamento_produto int,
@cd_serie_produto int,
@cd_mes_fiscal int,
@dt_inicial DateTime,
@dt_final   DateTime
as

--   Select
--     @cd_agrupamento_produto = 0,
--     @cd_serie_produto       = 0,
--     @cd_mes_fiscal          = 6,
--     @dt_inicial             = '2002-04-01',
--     @dt_final               = '2002-12-31'


  Declare
    @cd_dia int,
    @cd_mes int,
    @cd_ano int

  Select
    @cd_dia = day  (@dt_inicial), 
    @cd_mes = month(@dt_inicial),
    @cd_ano = year (@dt_inicial)


  If @cd_mes < @cd_mes_fiscal
    Set @cd_ano = (@cd_ano - 1)
  Else 
    Set @cd_ano = @cd_ano

  Set @dt_inicial = Str(@cd_ano) + '-' + str(@cd_mes_fiscal) + '-' + Str(@cd_dia)

  Print('Periodo de: ' + Convert(varchar, @dt_inicial, 103) + ' até ' + Convert(varchar, @dt_final, 103))


	Select
	   ap.cd_agrupamento_produto,
	   sp.nm_serie_produto,
	--    ns.cd_nota_saida,
	--   nsi.cd_item_nota_saida,
	--    ns.dt_nota_saida,
	  Sum(nsi.qt_item_nota_saida) qt_item_nota_saida,
	--   nsi.vl_unitario_item_nota,
	  sum(nsi.qt_item_nota_saida * nsi.vl_unitario_item_nota) as vl_total_nota_saida
	
	From
	  Nota_Saida ns
	    Left Outer Join
	  Nota_Saida_Item nsi
	    on ns.cd_nota_saida = nsi.cd_nota_saida
	    Left Outer Join
	  Produto p
	    on nsi.cd_produto = p.cd_produto
	    Left Outer Join
	  Agrupamento_produto ap
	    on p.cd_agrupamento_produto = ap.cd_agrupamento_produto
	    Left Outer Join
	  Serie_Produto sp
	    on p.cd_serie_produto = sp.cd_serie_produto
	
	Where
	  (ns.dt_cancel_nota_saida is null or
	   ns.cd_status_nota not in(3,4,7)) and
	  (nsi.dt_cancel_item_nota_saida is null or
	   nsi.cd_status_nota not in(3,4,7)) and
    p.cd_agrupamento_produto is not null and 
    p.cd_serie_produto is not null and
	  ns.dt_nota_saida between @dt_inicial and @dt_final and
	--   (@cd_produto = 0 or p.cd_produto = @cd_produto) and
	  (@cd_agrupamento_produto = 0 or ap.cd_agrupamento_produto = @cd_agrupamento_produto) and
	  (@cd_serie_produto = 0 or sp.cd_serie_produto = @cd_serie_produto)
	
	Group by
	   ap.cd_agrupamento_produto,
	   sp.nm_serie_produto
	Order by
	   ap.cd_agrupamento_produto,
	   sp.nm_serie_produto

