
CREATE VIEW vw_cat3296_reg76
------------------------------------------------------------------------------------
--sp_helptext vw_cat3296_reg76
------------------------------------------------------------------------------------
--GBS - Global Business Solution	                                       2010
------------------------------------------------------------------------------------
--Stored Procedure	: Microsoft SQL Server 2000
--Autor(es)             : David Becker
--                        Carlos Cardoso Fernandes
--Banco de Dados	: EGISSQL 
--
--Objetivo	        : Portaria Cat 3296 - Registro 76
--                        
--                      : 
--Data                  : 17.03.2010
--Atualização           : 19.03.2010
--
------------------------------------------------------------------------------------
as

select 
  RECEBTOSAIDA,
  '76'                                                 as 'Tipo',
  CNPJ,
  IE,                                                   
  --MODELO                                               as 'Modelo',
  '21'                                                 as Modelo,
  SERIE                                                as 'Serie',
  cast('' as varchar(2))                               as 'SubSerie',
  NUMERO                                               as 'Numero',
  CFOP                                                 as 'CFOP',
  --1-->Própria
  --2-->Terceiras
  cast('1' as varchar(1))                              as 'Tipo_Receita',
  EMISSAO                                              as 'Data_Emissao', 
  UF                                                   as 'UF',
  vlrContabil                                          as 'Valor_Total',
  case when Situacao = 'S' then 0.00 else BCICMS end   as 'BaseICMS',
  ICMS                                                 as 'Valor_ICMS',
  ICMSIsento                                           as 'Isenta',
  ICMSOutras                                           as 'Outras',
  case when Situacao = 'S' then 0.00 else AliqICMS end as 'ALIQ_ICMS',
  SITUACAO                                             as 'Situacao'

from 
  vw_livro_registro_geral_reg50

--where
--
  --Apenas as Notas de Modelo 21/22


-- select * from vw_livro_registro_geral_reg50   

