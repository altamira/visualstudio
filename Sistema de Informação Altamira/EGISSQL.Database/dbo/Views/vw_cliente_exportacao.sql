
CREATE VIEW vw_cliente_exportacao
------------------------------------------------------------------------------------
--vw_cliente_exportacao
------------------------------------------------------------------------------------
--GBS - Global Business Solution	                                       2006
------------------------------------------------------------------------------------
--Stored Procedure	: Microsoft SQL Server 2000
--Autor(es)             : Carlos Fernandes 
--Banco de Dados	: EGISSQL 
--Objetivo	        : Montagem do Arquivo Texto para exportação de Cliente
--                        
--Data                  : 29.03.2006
--Atualização           : 
------------------------------------------------------------------------------------
as

--select * from cliente

select
  cd_cliente              as CODIGO,
  nm_razao_social_cliente as RAZAOSOCIAL,
  nm_fantasia_cliente     as FANTASIA,
  dt_cadastro_cliente 
from
  Cliente
 	
