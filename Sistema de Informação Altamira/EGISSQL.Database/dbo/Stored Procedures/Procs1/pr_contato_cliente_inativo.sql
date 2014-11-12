
-------------------------------------------------------------------------------
--pr_contato_cliente_inativo
-------------------------------------------------------------------------------
--GBS Global Business Solution Ltda                                        2004
-------------------------------------------------------------------------------
--Stored Procedure : Microsoft SQL Server 2000
--Autor(es)        : André Seolin Fernandes
--Banco de Dados   : EgisSql
--Objetivo         : Consulta de Contatos de Clientes Inativos
--Data             : 19/05/2005
--Alteração        : 
------------------------------------------------------------------------------
create procedure pr_contato_cliente_inativo
AS
SELECT 
  CC.cd_cliente,
  CC.nm_contato_cliente, 
  CC.cd_ddd_contato_cliente, 
  CC.cd_telefone_contato, 
  CC.cd_celular, 
  CC.cd_email_contato_cliente, 
  CC.ic_status_contato, 
  CC.dt_status_contato, 
  C.nm_fantasia_cliente  
FROM 
  Cliente_Contato CC
  LEFT JOIN 
  Cliente C on (C.cd_cliente = CC.cd_cliente)
WHERE 
  CC.ic_status_contato = 'I'
ORDER BY 
  CC.dt_status_contato desc

