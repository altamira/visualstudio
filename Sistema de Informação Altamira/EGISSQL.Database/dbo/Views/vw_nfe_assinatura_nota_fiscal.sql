
CREATE VIEW vw_nfe_assinatura_nota_fiscal
------------------------------------------------------------------------------------
--sp_helptext vw_nfe_assinatura_nota_fiscal
------------------------------------------------------------------------------------
--GBS - Global Business Solution	                                       2004
------------------------------------------------------------------------------------
--Stored Procedure	: Microsoft SQL Server 2000
--Autor(es)             : Carlos Cardoso Fernandes
--Banco de Dados	: EGISSQL 
--
--Objetivo	        : Assinatura Digital
--                        para o sistema de emissão da Nota Fiscal Eletrônica
--
--Data                  : 06.11.2008
--Atualização           : 
------------------------------------------------------------------------------------
as


select
  ns.cd_nota_saida,
  'ZC01'                                                      as 'signature'

from
  nota_saida ns                           with (nolock) 

--select * from nota_saida

