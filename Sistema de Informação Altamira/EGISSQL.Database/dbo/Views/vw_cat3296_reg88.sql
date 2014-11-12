
CREATE VIEW vw_cat3296_reg88
------------------------------------------------------------------------------------
--sp_helptext vw_cat3296_reg88
------------------------------------------------------------------------------------
--GBS - Global Business Solution	                                       2010
------------------------------------------------------------------------------------
--Stored Procedure	: Microsoft SQL Server 2000
--Autor(es)             : David Becker
--                        Carlos Cardoso Fernandes
--Banco de Dados	: EGISSQL 
--
--Objetivo	        : Portaria Cat 3296 - Registro 88
--                      : ECF --> Equipamentos
--                      : 
--Data                  : 17.03.2010
--Atualização           : 19.03.2010
--
------------------------------------------------------------------------------------
as

--select * from produto_ecf

select 

  RECEBTOSAIDA,
  '88'                                           as 'Tipo',
  cast('ECF' as varchar(11))                     as 'SubTipo',
  cast(CNPJ as varchar(14))                      as 'CNPJ',
  MODELO                                         as 'Modelo',
  SERIE                                          as 'Serie',
  NUMERO                                         as 'Numero',
  CFOP                                           as 'CFOP',
  CST                                            as 'CST',
  ITEM                                           as 'Item',
  PRODUTO                                        as 'Codigo_Produto',
  case when isnull(ecf.cd_numero_serie_produto,'')<>'' then
     ecf.cd_numero_serie_produto
  else
     cast(i.cd_numero_serie_produto as varchar(20))
  end                                            as 'Numero_Serie',
  cast('' as varchar(52))                        as 'Brancos'

from
  vw_produto_registro_geral vw
  inner join nota_saida_item i on i.cd_nota_saida      = vw.numero AND 
                                  i.cd_item_nota_saida = vw.ITEM
  inner join produto_ecf ecf   on ecf.cd_produto       = i.cd_produto

--select * from nota_saida_item  

--select * from egisadmin.dbo.empresa  
--select * from vw_produto_registro_geral vw where numero = 201

