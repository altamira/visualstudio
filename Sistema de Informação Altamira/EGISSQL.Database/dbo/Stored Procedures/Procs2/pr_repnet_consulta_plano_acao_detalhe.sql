
CREATE PROCEDURE pr_repnet_consulta_plano_acao_detalhe
--pr_repnet_consulta_plano_acao_detalhe
---------------------------------------------------
-- GBS - Global Business Solution	       2002
-- Stored Procedure: Microsoft SQL Server       2000
-- Autor(es): Rafael M. Santiago
-- Banco de Dados: EgisSql
-- Objetivo: Consultar Plano de Acao Detalhe
-- Data: 25/11/2003
-- Alterado:
---------------------------------------------------
@cd_plano_acao as int,
@cd_usuario as int

AS
SELECT 
  pav.cd_plano_acao_vendedor,
	pav.dt_plano_acao_vendedor,
  pav.cd_vendedor,
  v.nm_vendedor,
  c.nm_fantasia_cliente,
  pav.pc_1ano_partic_vendedor,
  pav.vl_1ano_partic_vendedor,
  pav.pc_2ano_partic_vendedor,
  pav.vl_2ano_partic_vendedor,
  pav.pc_3ano_partic_vendedor,
  pav.vl_3ano_partic_vendedor,
  Cast(pav.ds_plano_acao_vendedor as Varchar (8000)) as ds_plano_acao_vendedor,
	pav.vl_ano_plano_acao_vend,
  cv.nm_criterio_visita
	
    

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
  LEFT OUTER JOIN
  Criterio_Visita cv
  ON
	pav.cd_criterio_visita = cv.cd_criterio_visita  

WHERE
  pav.cd_plano_acao_vendedor = @cd_plano_acao
  AND
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
  

