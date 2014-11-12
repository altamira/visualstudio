
CREATE VIEW vw_empresa_sispag2
------------------------------------------------------------------------------------
--vw_empresa_sispag
------------------------------------------------------------------------------------
--GBS - Global Business Solution	                                       2004
------------------------------------------------------------------------------------
--Stored Procedure	: Microsoft SQL Server 2000
--Autor(es)       :Márcio Rodrigues 
--Banco de Dados	: EGISSQL 
--Objetivo	      : Seleciona dados da empresa para o SAM
--Data            : 10.04.2006
--Atualização     : 
------------------------------------------------------------------------------------
as
Select
	e.cd_empresa,
   e.cd_cgc_empresa,
	B.cd_numero_banco,
	A.cd_numero_agencia_banco,
 	C.cd_dac_conta_banco,
 	C.nm_conta_banco,
	C.cd_conta_banco
	,E.nm_banco_empresa 
from
	EgisAdmin.dbo.Empresa E  , 
  	conta_agencia_banco c inner join 
	agencia_banco a on c.cd_agencia_banco = a.cd_agencia_banco inner join
  	banco b on c.cd_banco = b.cd_banco   

