
CREATE PROCEDURE pr_consulta_rel_diario_vendas
--pr_consulta_rel_diario_vendas
---------------------------------------------------
-- GBS - Global Business Solution	       2002
-- Stored Procedure: Microsoft SQL Server       2000
-- Autor(es): Rafael M. Santiago
-- Banco de Dados: EgisSql
-- Objetivo: Consultar Relatorio Diário de Vendas
-- Data: 25/11/2003
-- Alterado:
---------------------------------------------------
@cd_diario_venda as int,
@dt_inicial as datetime,
@dt_final as datetime


AS
  SELECT
	rdv.cd_diario_venda,
	rdv.dt_diario_venda,
	rdv.cd_vendedor,
	v.nm_fantasia_vendedor,
	rdv.cd_cliente,
	c.nm_fantasia_cliente,
	rdv.cd_regiao_venda,
	rv.nm_regiao_venda,
	rdv.cd_nivel_cliente,
	nc.nm_nivel_cliente,
	rdv.cd_categoria_cliente,
	cc.nm_categoria_cliente, -- Segmento
	rdv.cd_cliente_foco,
	isnull(cf.ic_foco_cliente, 'N') as ic_foco_cliente,
	cf.nm_fantasia_cliente as nm_fantasia_cliente_foco,
	rdv.cd_cliente_oem,
	isnull(co.ic_oem_cliente, 'N') ic_oem_cliente,
	co.nm_fantasia_cliente as nm_fantasia_cliente_oem,
	rdv.cd_cliente_global,
	isnull(cg.ic_global_cliente, 'N') as ic_global_cliente,
	cg.nm_fantasia_cliente as nm_fantasia_cliente_global,
	isnull(rdv.ic_negocio_diario, 'N') as ic_negocio_diario,
	rdv.nm_ref_negocio_diario,
--	rdv.ds_diario_venda,
	rdv.nm_contato_diario_venda
  FROM
	Relatorio_Diario_Vendas rdv
	LEFT OUTER JOIN
	Cliente c ON rdv.cd_cliente = c.cd_cliente
	LEFT OUTER JOIN
	Vendedor v ON rdv.cd_vendedor = v.cd_vendedor
	LEFT OUTER JOIN
	Regiao_Venda rv ON rdv.cd_regiao_venda = rv.cd_regiao_venda
	LEFT OUTER JOIN
	Nivel_Cliente nc ON rdv.cd_nivel_cliente = nc.cd_nivel_cliente
	LEFT OUTER JOIN
	Categoria_Cliente cc ON rdv.cd_categoria_cliente = cc.cd_categoria_cliente
 	LEFT OUTER JOIN
	Cliente cf ON rdv.cd_cliente_foco = cf.cd_cliente
 	LEFT OUTER JOIN
	Cliente co ON rdv.cd_cliente_oem = co.cd_cliente
 	LEFT OUTER JOIN
	Cliente cg ON rdv.cd_cliente_global = cg.cd_cliente

  WHERE
	rdv.cd_diario_venda = @cd_diario_venda OR
	((@cd_diario_venda = 0) 
	AND
        rdv.dt_diario_venda BETWEEN @dt_inicial AND @dt_final)

ORDER BY
  rdv.dt_diario_venda DESC

