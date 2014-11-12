

--pr_consulta_trans_estado
-------------------------------------------------------
--GBS Global Business Solution Ltda                2002
--Stored Procedure: Microsoft SQL Server           2000
--Autor(es): Daniel C. Neto
--Objetivo: Mostrar Todas as transportadoras por Estado de um país.
--Data: 17/12/2002
--Atualizado: 
-------------------------------------------------------


CREATE PROCEDURE pr_consulta_trans_estado
@cd_pais int,
@cd_estado int

AS


SELECT     t.nm_fantasia, 
	   t.cd_telefone, 
	   t.cd_ddd, 
	   e.sg_estado, 
	   c.nm_cidade

FROM       Transportadora t INNER JOIN
           Estado e ON t.cd_pais = e.cd_pais and t.cd_estado = e.cd_estado INNER JOIN
           Cidade c ON t.cd_pais = c.cd_pais AND t.cd_estado = c.cd_estado and c.cd_cidade = t.cd_cidade
where
	  t.cd_pais = @cd_pais and
	  (@cd_estado = 0) or (t.cd_estado = @cd_estado)			


