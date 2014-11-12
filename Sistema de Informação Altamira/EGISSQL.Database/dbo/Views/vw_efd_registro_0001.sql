
CREATE VIEW vw_efd_registro_0001
------------------------------------------------------------------------------------
--sp_helptext vw_efd_registro_0001
------------------------------------------------------------------------------------
--GBS - Global Business Solution	                                       2009
------------------------------------------------------------------------------------
--Stored Procedure	: Microsoft SQL Server 2000
--Autor(es)             : 
--Banco de Dados	: EGISSQL 
--
--Objetivo	        : Escrituração Fiscal Digital - EFD
--                        Registro 0001
--                        Abertura do Bloco 0
--
--Data                  : 11.12.2008
--Atualização           : 
--
------------------------------------------------------------------------------------

as

--select * from egisadmin.dbo.empresa

select
  '0001'                                    as 'REG',
  ''                                        as 'IND_MOV'    
from
  egisadmin.dbo.empresa e

where
  cd_empresa = dbo.fn_empresa()
  

--select * from cidade

 
