
CREATE VIEW vw_cat3296_reg86
------------------------------------------------------------------------------------
--sp_helptext vw_cat3296_reg86
------------------------------------------------------------------------------------
--GBS - Global Business Solution	                                       2010
------------------------------------------------------------------------------------
--Stored Procedure	: Microsoft SQL Server 2000
--Autor(es)             : David Becker
--                        Carlos Cardoso Fernandes
--Banco de Dados	: EGISSQL 
--
--Objetivo	        : Portaria Cat 3296 - Registro 86
--                        Exportação

--                      : 
--Data                  : 17.03.2010
--Atualização           : 23.03.2010 - Desenvolvimento
--
------------------------------------------------------------------------------------
as

select 
  RECEBTOSAIDA,
  '86'                                           as 'Tipo',
  cast(e.cd_registro_exportacao as varchar(12))  as 'Registro_Exportacao',
  e.dt_registro_exportacao                       as 'Data_Registro',--Data

  CNPJ                                           as 'CNPJ',
  IE                                             as 'IE',

--     em.cd_cgc_empresa  as CNPJ,
--     em.cd_iest_empresa as IE,

  UF                                             as 'UF',
  NUMERO                                         as 'Nota_Fiscal',
  RECEBTOSAIDA                                   as 'Data_Emissao',--Data
  MODELO                                         as 'Modelo',
  SERIE                                          as 'Serie',
  PRODUTO                                        as 'Codigo_Produto',
  QUANTIDADE                                     as 'Quantidade',
  ROUND(VALORPRODUTO/QUANTIDADE,2)               as 'Valor_Unitario',
  VALORPRODUTO                                   as 'Valor_Produto',
  cast('0' as varchar(1))                        as 'Relacionamento',
  cast('' as varchar(5))                         as 'Brancos'

from
  vw_produto_registro_geral vw
  inner join embarque_complemento e     on e.cd_nota_saida          = vw.NUMERO
  left outer join Pais p                on p.cd_pais                = e.cd_pais
  left outer join Natureza_exportacao n on n.cd_natureza_exportacao = e.cd_natureza_exportacao  
  left outer join Tipo_Conhecimento tc  on tc.cd_tipo_conhecimento  = e.cd_tipo_conhecimento
  left outer join egisadmin.dbo.empresa em on em.cd_empresa = dbo.fn_empresa()

