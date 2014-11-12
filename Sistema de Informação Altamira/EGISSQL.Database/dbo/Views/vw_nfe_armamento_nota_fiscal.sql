
CREATE VIEW vw_nfe_armamento_nota_fiscal
------------------------------------------------------------------------------------
--sp_helptext vw_nfe_armamento_nota_fiscal
------------------------------------------------------------------------------------
--GBS - Global Business Solution	                                       2004
------------------------------------------------------------------------------------
--Stored Procedure	: Microsoft SQL Server 2000
--Autor(es)             : Carlos Cardoso Fernandes
--Banco de Dados	: EGISSQL 
--
--Objetivo	        : Identificação do Local da Retirada da Nota Fiscal 
--                        para o sistema de emissão da Nota Fiscal Eletrônica
--
--Data                  : 05.11.2008
--Atualização           : 27.09.2010 - Ajuste para novo lay-out v2.00 - Carlos Fernandes
------------------------------------------------------------------------------------
as


select
  'L'                                                            as 'arma',
    ns.cd_identificacao_nota_saida,
    ns.cd_nota_saida
from
  nota_saida ns


