
CREATE PROCEDURE pr_consulta_vendedor_regiao
--pr_consulta_vendedor_regiao
---------------------------------------------------
-- GBS - Global Business Solution	       2002
-- Stored Procedure: Microsoft SQL Server       2000
-- Autor(es): Rafael M. Santiago
-- Banco de Dados: EgisSql
-- Objetivo: Consultar Vendedores por Região
-- Data: 20/01/2004
-- Alterado:
---------------------------------------------------
@cd_regiao_venda as int

AS

SELECT DISTINCT
  vwbi.cd_regiao_venda,
	rv.nm_regiao_venda,
	vwbi.cd_vendedor,
	vwbi.nm_vendedor_externo,
	v.cd_ddd_vendedor,
	v.cd_telefone_vendedor,
	v.nm_email_vendedor,
	ISNULL((SELECT Count(c.cd_vendedor) FROM Cliente c WHERE c.cd_vendedor = vwbi.cd_vendedor),0) as qt_clientes,
	ISNULL(vr.vl_pot_vendedor_regiao,0) as vl_pot_vendedor_regiao
	

FROM
  vw_venda_bi vwbi
  LEFT OUTER JOIN
	Regiao_Venda rv
  ON
	vwbi.cd_regiao_venda = rv.cd_regiao_venda
	LEFT OUTER JOIN
	Vendedor v
	ON
	vwbi.cd_vendedor = v.cd_vendedor
	LEFT OUTER JOIN
	Vendedor_Regiao vr
	ON
	vwbi.cd_regiao_venda = vr.cd_regiao_venda AND
	vwbi.cd_vendedor     = vr.cd_vendedor

WHERE 
	((@cd_regiao_venda = 0) OR (vwbi.cd_regiao_venda = @cd_regiao_venda))

