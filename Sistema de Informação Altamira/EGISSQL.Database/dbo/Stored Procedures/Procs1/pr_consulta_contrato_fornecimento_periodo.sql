
CREATE  PROCEDURE pr_consulta_contrato_fornecimento_periodo
--GBS - Global Business Solution	       2002
--Stored Procedure: Microsoft SQL Server       2000
--Autor(es): Igor Gama - IT
--Banco de Dados: Egissql
--Objetivo: Lista os contratos de fornecimento no período solicitado
--Data: 22/10/2002
---------------------------------------------------
@dt_inicial  as DateTime,
@dt_final    as DateTime
AS

		Select
			cf.cd_contrato_fornecimento,
			cf.dt_contrato_fornecimento,
			cf.cd_contrato_interno,
			cf.cd_cliente,
		   c.nm_fantasia_cliente,
			cf.cd_contato,
			cf.ds_contrato,
			cf.cd_vendedor,
		   v.nm_fantasia_vendedor,
			cf.cd_status_contrato,
		  sc.nm_status_contrato,
			cf.cd_condicao_pagamento,
		  cp.sg_condicao_pagamento,
			cf.cd_destinacao_produto,
			dp.nm_destinacao_produto,
			cf.dt_inicial_contrato,
			cf.dt_final_contrato
		From 
		  Contrato_Fornecimento cf
		    Left Outer Join
		  Cliente c
		    on cf.cd_cliente = c.cd_cliente
		    Left Outer Join
		  Vendedor v
		    on cf.cd_vendedor = v.cd_vendedor
		    Left Outer Join
		  Status_Contrato sc
		    on cf.cd_status_contrato = sc.cd_status_contrato
		    Left Outer join
		  Condicao_Pagamento cp
		    on cf.cd_condicao_pagamento = cp.cd_condicao_pagamento
		    Left Outer Join
		  Destinacao_Produto dp
		    on cf.cd_destinacao_produto = dp.cd_destinacao_produto
		Where 
		  cf.dt_contrato_fornecimento between @dt_inicial and @dt_final


