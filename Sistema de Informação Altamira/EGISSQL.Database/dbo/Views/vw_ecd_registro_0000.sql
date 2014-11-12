
CREATE VIEW vw_ecd_registro_0000
------------------------------------------------------------------------------------
--sp_helptext vw_efd_registro_0000
------------------------------------------------------------------------------------
--GBS - Global Business Solution	                                       2009
------------------------------------------------------------------------------------
--Stored Procedure	: Microsoft SQL Server 2000
--Autor(es)             : 
--Banco de Dados	: EGISSQL 
--
--Objetivo	        : Escrituração Contábil Digital - ECD
--                        Registro 0000
--                        Abertura do Arquivo Digital e Identificação da Entidade
--
--Data                  : 11.12.2008
--Atualização           : 
--
------------------------------------------------------------------------------------

as

--select * from egisadmin.dbo.empresa

select
  '0000'                                                        as 'REG',
  'LECD'                                                        as 'LECD',
--  ''                                                            as 'COD_VER',
--  ''                                                            as 'COD_FIN',
  ''                                                            as 'DT_INI',
  ''                                                            as 'DT_FIN',
  cast(e.nm_empresa as varchar(60))                             as 'NOME',
  cast(e.cd_cgc_empresa as varchar(14))                         as 'CNPJ',
  ''                                                            as 'CPF',
  est.sg_estado                                                 as 'UF',
  e.cd_iest_empresa                                             as 'IE',
  cid.cd_cidade_ibge                                            as 'COD_MUN',
  e.nm_inscricao_municipal                                      as 'IM', 
  --e.cd_suframa_empresa                                          as 'SUFRAMA',
  --'A'                                                           as 'IND_PERFIL',
  --'0'                                                           as 'IND_ATIV'
  ''                                                            as 'IND_SIT_ESP'
    
from
  egisadmin.dbo.empresa e
  left outer join estado est on est.cd_estado = e.cd_estado
  left outer join cidade cid on cid.cd_cidade = e.cd_cidade

where
  cd_empresa = dbo.fn_empresa()
  

--select * from cidade

 
