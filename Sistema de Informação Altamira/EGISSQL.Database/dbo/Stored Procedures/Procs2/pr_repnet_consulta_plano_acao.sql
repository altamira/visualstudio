
CREATE PROCEDURE pr_repnet_consulta_plano_acao
--pr_repnet_consulta_plano_acao
---------------------------------------------------
-- GBS - Global Business Solution	       2002
-- Stored Procedure: Microsoft SQL Server       2000
-- Autor(es): Rafael M. Santiago
-- Banco de Dados: EgisSql
-- Objetivo: Consultar Planos de Ação
-- Data: 26/02/2004
-- Alterado:
---------------------------------------------------
@cd_usuario as int,
@dt_inicial as datetime,
@dt_final as datetime


AS
  SELECT
  pav.cd_plano_acao_vendedor,
  pav.dt_plano_acao_vendedor,
  v.nm_vendedor,
	c.nm_fantasia_cliente
FROM 
  Plano_Acao_Vendedor pav 
  LEFT OUTER JOIN
  Vendedor v
  ON
	pav.cd_vendedor = v.cd_vendedor
  LEFT OUTER JOIN 
  Cliente c
	ON
  pav.cd_cliente = c.cd_cliente
WHERE 
  pav.cd_vendedor 
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
    pav.dt_plano_acao_vendedor BETWEEN @dt_inicial AND @dt_final

ORDER BY
  pav.dt_plano_acao_vendedor DESC

