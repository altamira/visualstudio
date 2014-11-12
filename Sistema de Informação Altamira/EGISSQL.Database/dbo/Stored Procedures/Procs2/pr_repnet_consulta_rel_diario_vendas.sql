
CREATE PROCEDURE pr_repnet_consulta_rel_diario_vendas
--pr_repnet_consulta_rel_diario_vendas
---------------------------------------------------
-- GBS - Global Business Solution	       2002
-- Stored Procedure: Microsoft SQL Server       2000
-- Autor(es): Rafael M. Santiago
-- Banco de Dados: EgisSql
-- Objetivo: Consultar Relatorio Diário de Vendas
-- Data: 25/11/2003
-- Alterado:
---------------------------------------------------
@cd_usuario as int,
@dt_inicial as datetime,
@dt_final as datetime


AS
  SELECT
  rdv.cd_diario_venda,
  rdv.dt_diario_venda,
  v.nm_vendedor,
	c.nm_fantasia_cliente
FROM 
  Relatorio_Diario_Vendas rdv 
  LEFT OUTER JOIN
  Vendedor v
  ON
	rdv.cd_vendedor = v.cd_vendedor
  LEFT OUTER JOIN 
  Cliente c
	ON
  rdv.cd_cliente = c.cd_cliente
WHERE 
  rdv.cd_vendedor 
  IN 
  (SELECT 
     cd_vendedor 
   FROM 
     Vendedor 
   WHERE 
     cd_vendedor 
     IN (
       SELECT  
         cd_vendedor 
       FROM  
         EGISADMIN..Usuario
       WHERE 
       cd_usuario = @cd_usuario ))
  AND 
    rdv.dt_diario_venda BETWEEN @dt_inicial AND @dt_final

ORDER BY
  rdv.dt_diario_venda DESC

