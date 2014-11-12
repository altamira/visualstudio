
CREATE VIEW vw_nfe_compra_nota_fiscal
------------------------------------------------------------------------------------
--sp_helptext vw_nfe_compra_nota_fiscal
------------------------------------------------------------------------------------
--GBS - Global Business Solution	                                       2004
------------------------------------------------------------------------------------
--Stored Procedure	: Microsoft SQL Server 2000
--Autor(es)             : Carlos Cardoso Fernandes
--Banco de Dados	: EGISSQL 
--
--Objetivo	        : Informações de Compras
--                        para o sistema de emissão da Nota Fiscal Eletrônica
--
--Data                  : 06.11.2008
--Atualização           : 
------------------------------------------------------------------------------------
as


select
  ns.cd_nota_saida,
  'ZB01'                                                      as 'compra',
  cast('' as varchar(17))                                     as 'xNEmp',
  cast('' as varchar(60))                                     as 'xPed',
  cast('' as varchar(60))                                     as 'xCont'

from
  nota_saida ns                           with (nolock) 

--select * from nota_saida

