
CREATE VIEW vw_nfe_fisco_emitente_nota_fiscal
------------------------------------------------------------------------------------
--sp_helptext vw_nfe_fisco_emitente_nota_fiscal
------------------------------------------------------------------------------------
--GBS - Global Business Solution	                                       2004
------------------------------------------------------------------------------------
--Stored Procedure	: Microsoft SQL Server 2000
--Autor(es)             : Carlos Cardoso Fernandes
--Banco de Dados	: EGISSQL 
--
--Objetivo	        : Identificação do Fisco Emitente da Nota Fiscal 
--                        para o sistema de emissão da Nota Fiscal Eletrônica
--
--Data                  : 05.11.2008
--Atualização           : 27.09.2010 - Ajuste para nova versão do lay-out v2.0
------------------------------------------------------------------------------------
as

--select * from versao_nfe
--select * from forma_condicao_pagamento

select
  'D'                                                           as 'TAG',
  cast('' as varchar(14))                                       as 'CNPJ',
  cast('' as varchar(60))                                       as 'xOrgao',
  cast('' as varchar(60))                                       as 'matr',
  cast('' as varchar(60))                                       as 'xAgente',
  cast('' as varchar(14))                                       as 'fone',
  cast('' as varchar(02))                                       as 'uf',
  cast('' as varchar(60))                                       as 'nDar',
  cast(null as datetime)                                        as 'dEmi',
  cast(0.00 as float)                                           as 'vDar',
  cast(''  as varchar(60))                                      as 'repEmi',
  cast(null as datetime)                                        as 'dPag'   


 
