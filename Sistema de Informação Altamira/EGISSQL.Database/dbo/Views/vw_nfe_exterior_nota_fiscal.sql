
CREATE VIEW vw_nfe_exterior_nota_fiscal
------------------------------------------------------------------------------------
--sp_helptext vw_nfe_exterior_nota_fiscal
------------------------------------------------------------------------------------
--GBS - Global Business Solution	                                       2004
------------------------------------------------------------------------------------
--Stored Procedure	: Microsoft SQL Server 2000
--Autor(es)             : Carlos Cardoso Fernandes
--Banco de Dados	: EGISSQL 
--
--Objetivo	        : Informações do Comércio Exterior
--                        para o sistema de emissão da Nota Fiscal Eletrônica
--
--Data                  : 06.11.2008
--Atualização           : 27.09.2010 - Ajuste para novo lay-out v2.00 - Carlos Fernandes
-- 08.12.2010 - Ajuste da View após nova versão - Carlos Fernandes
------------------------------------------------------------------------------------
as


select
  ns.cd_nota_saida,
  ns.cd_identificacao_nota_saida,
  'ZA01'                                                        as 'exporta',
  cast(nse.sg_local_embarque as varchar(02))                    as 'UFEmbarq',
  cast(nse.nm_local_embarque as varchar(60))                    as 'xLocEmbarq'  

from
  nota_saida ns                      with (nolock) 
  inner join operacao_fiscal opf     on opf.cd_operacao_fiscal = ns.cd_operacao_fiscal
  inner join Nota_Saida_Embarque nse on nse.cd_nota_saida      = ns.cd_identificacao_nota_saida

where
  isnull(opf.ic_exportacao_op_fiscal,'N')='S'


--select * from operacao_fiscal

--select * from nota_saida

