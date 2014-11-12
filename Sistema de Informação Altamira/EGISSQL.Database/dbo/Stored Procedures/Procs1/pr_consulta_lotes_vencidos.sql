
-------------------------------------------------------------------------------
--pr_consulta_lotes_vencidos
-------------------------------------------------------------------------------
--GBS Global Business Solution Ltda                                        2004
-------------------------------------------------------------------------------
--Stored Procedure : Microsoft SQL Server 2000
--Autor(es)        : Márcio Rodrigues Adão
--Banco de Dados   : Egissql
--Objetivo         : Consulta de Lotes Vencidos
--Data             : 17/05/2005
--Alteração        : 
------------------------------------------------------------------------------
create procedure pr_consulta_lotes_vencidos
   @dt_inicial                 datetime, 
   @dt_final                   datetime
as
SELECT  	
      lp.dt_final_lote_produto as Vencimento, 
    	day('05-18-2005') - day(lp.dt_final_lote_produto) as Dias,
      lp.cd_lote_produto,
	   lp.nm_lote_produto  as Lote,
		dbo.fn_mascara_produto(p.cd_Produto) as Codigo,
      p.nm_fantasia_produto as Produto,
		p.nm_produto as Descricao,
		Um.nm_unidade_medida as UM,
  		lpi.qt_produto_lote_produto as Quantidade,
  		lps.qt_saldo_atual_lote     as Saldo
FROM Lote_Produto lp
	  LEFT OUTER JOIN Lote_Produto_Item lpi ON  lp.cd_lote_produto = lpi.cd_lote_produto
	  LEFT OUTER JOIN Lote_Produto_Saldo lps ON  lp.cd_lote_produto = lps.cd_lote_produto and lps.cd_produto = lpi.cd_produto
     LEFT OUTER JOIN Produto p ON  p.cd_produto = lpi.cd_produto
     LEFT OUTER JOIN Unidade_Medida um ON  um.cd_unidade_medida = p.cd_unidade_medida
WHERE
	  lp.dt_final_lote_produto between @dt_inicial and @dt_Final
ORDER BY
	  1,3


