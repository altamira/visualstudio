
CREATE VIEW vw_nfe_retirada_nota_fiscal
------------------------------------------------------------------------------------
--sp_helptext vw_nfe_retirada_nota_fiscal
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
--------------------------------------------------------------------------------------------
as

--select * from versao_nfe
--select * from forma_condicao_pagamento
--select * from vw_destinatario

select
  ns.cd_nota_saida,
  'F'                                                            as 'retirada',
  cast('00000000000000' as varchar(14))                          as 'CNPJ',
  cast('00000000000000' as varchar(14))                          as 'CPF',
  cast('' as varchar(60))                                        as 'xLgr',
  cast('' as varchar(60))                                        as 'nro',
  cast('' as varchar(60))                                        as 'xCpl',
  cast('' as varchar(60))                                        as 'xBairro',
  cast('' as varchar(7))                                         as 'cMun',
  cast('' as varchar(60))                                        as 'xMun',
  cast('' as varchar(2))                                         as 'UF'

from
  Nota_Saida ns with (nolock)

     


--select * from vw_destinatario

