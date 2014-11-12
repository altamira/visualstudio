
CREATE VIEW vw_cat3296_reg53
------------------------------------------------------------------------------------
--sp_helptext vw_cat3296_reg53
------------------------------------------------------------------------------------
--GBS - Global Business Solution	                                       2010
------------------------------------------------------------------------------------
--Stored Procedure	: Microsoft SQL Server 2000
--Autor(es)         : David Becker
--                 
--Banco de Dados	  : EGISSQL 
--
--Objetivo	        : Portaria Cat 32/96 - Registro 53
--
--Data              : 17.03.2010
--Atualização       : 
--
------------------------------------------------------------------------------------
as
 
select
  RECEBTOSAIDA,
  '53'                                                 as 'Tipo',
  CNPJ                                                 as 'CNPJ',
  IE                                                   as 'Inscricao_Estadual',
  EMISSAO                                              as 'Data_Emissao',
  UF                                                   as 'UF',
  MODELO                                               as 'Modelo',
  SERIE                                                as 'Serie',
  NUMERO,
  CFOP                                                 as 'CFOP',
  EMITENTE                                             as 'Emitente',
  case when Situacao = 'S' then 0.00 else BCICMSST end as 'BCICMSST',	
  case when Situacao = 'S' then 0.00 else ICMSST   end as 'ICMS_Retido',
  0.00                                                 as 'Despesas_Acessorias',
  SITUACAO                                             as 'Situacao',
  cast('1' as int)                                     as 'Codigo_Atencipacao',
  cast('' as varchar(50))                              as 'Brancos'

from 
  vw_livro_registro_geral_reg50

where
  --isnull(BCICMSST,0) > 0 AND isnull(ICMSST,0) > 0
  CFOP = '5401' OR 
  CFOP = '5403' OR
  CFOP = '6401' OR
  CFOP = '6403' 

-- select * from   vw_livro_registro_geral_reg50


