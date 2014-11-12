
------------------------------------------------------------------------------------------
-- vw_produto_registro_geral
------------------------------------------------------------------------------------------
-- GBS - Global Business Solution                                                    2002
-- Stored Procedure: Microsoft SQL Server 2000
-- Autor(es)      : Alexandre Del Soldato
-- Banco de Dados : EgisSql
-- Objetivo       : Lista o item do Livro de Entradas e de Saídas utilizado nos Arquivos Magnéticos
-- Data           : 22/03/2004
-- Atualizado     : 02.02.2008
-- Atualizado     : 23.06.2009 - Ajustes Diversos - Carlos Fernandes
-- 08.11.2009 - consistência para não permitir nota de entrada = nota de saída - Carlos Fernandes
--------------------------------------------------------------------------------------------------
-- 

create view vw_produto_registro_geral
as

  select
    DEBUG,
    cd_produto,
    ENTRADASAIDA,
    RECEBTOSAIDA,
    CNPJ,
    IE,
    UF,

    case when ((CFOP >= 1350 and CFOP <= 1356) or
               (CFOP >= 2350 and CFOP <= 2356) or
               (CFOP >= 3350 and CFOP <= 3356))
              and 
              substring(SERIE,1,1) in ('0','1','2','3','4','5','6','7','8','9') then 'U'

         when ( SERIE in ('1.','NFE','NFF') ) then '1'

         when ( SERIE in ('.') ) then ' '

         else SERIE
    end as SERIE,

--     case when ((CFOP >= 1350 and CFOP <= 1356) or
--                (CFOP >= 2350 and CFOP <= 2356) or
--                (CFOP >= 3350 and CFOP <= 3356)) then '08' -- Transporte Rodoviário
-- 
--          else MODELO
--     end as MODELO,

    MODELO,
    NUMERO,
    CFOP,
    CST,
    ITEM,
    PRODUTO,
    DESCRICAO,
    CLASSFISCAL,
    QUANTIDADE,
    VALORPRODUTO,
    DESCONTO,
    BCICMS,	
    BCTRIBUTARIA,
    IPI,
    ALIQICMS,
    ALIQIPI,
    REDICMS,
    BCICMSSUBST,
    UNIDADEMEDIDA,
    SITUACAOTRIB

  from
    vw_produto_entrada

  union all

  select
    DEBUG,
    cd_produto,
    ENTRADASAIDA,
    RECEBTOSAIDA,
    CNPJ,
    IE,
    UF,

    case when ((CFOP >= 1350 and CFOP <= 1356) or
               (CFOP >= 2350 and CFOP <= 2356) or
               (CFOP >= 3350 and CFOP <= 3356))
              and 
              substring(SERIE,1,1) in ('0','1','2','3','4','5','6','7','8','9') then 'U'

         when ( SERIE in ('1.','NFE','NFF') ) then '1'

         when ( SERIE in ('.') ) then ' '

         else SERIE
    end as SERIE,

--     case when ((CFOP >= 1350 and CFOP <= 1356) or
--                (CFOP >= 2350 and CFOP <= 2356) or
--                (CFOP >= 3350 and CFOP <= 3356)) then '08' -- Transporte Rodoviário
-- 
--          else MODELO
--     end as MODELO,

    MODELO,

    NUMERO,
    CFOP,
    CST,
    ITEM,
    PRODUTO,
    DESCRICAO,
    CLASSFISCAL,
    QUANTIDADE,
    VALORPRODUTO,
    DESCONTO,
    BCICMS,	
    BCTRIBUTARIA,
    IPI,
    ALIQICMS,
    ALIQIPI,
    REDICMS,
    BCICMSSUBST,
    UNIDADEMEDIDA,
    SITUACAOTRIB

  from
    vw_produto_saida

--select * from vw_produto_saida
    
  union all

  select
    DEBUG,
    cd_produto,
    ENTRADASAIDA,
    RECEBTOSAIDA,
    CNPJ,
    IE,
    UF,

    case when ((CFOP >= 1350 and CFOP <= 1356) or
               (CFOP >= 2350 and CFOP <= 2356) or
               (CFOP >= 3350 and CFOP <= 3356))
              and 
              substring(SERIE,1,1) in ('0','1','2','3','4','5','6','7','8','9') then 'U'

         when ( SERIE in ('1.','NFE','NFF') ) then '1'

         when ( SERIE in ('.') ) then ' '

         else SERIE
    end as SERIE,

--     case when ((CFOP >= 1350 and CFOP <= 1356) or
--                (CFOP >= 2350 and CFOP <= 2356) or
--                (CFOP >= 3350 and CFOP <= 3356)) then '08' -- Transporte Rodoviário
-- 
--          else MODELO
--     end as MODELO,

    MODELO,
    NUMERO,
    CFOP,
    CST,
    ITEM,
    PRODUTO,
    DESCRICAO,
    CLASSFISCAL,
    QUANTIDADE,
    VALORPRODUTO,
    DESCONTO,
    BCICMS,	
    BCTRIBUTARIA,
    IPI,
    ALIQICMS,
    ALIQIPI,
    REDICMS,
    BCICMSSUBST,
    UNIDADEMEDIDA,
    SITUACAOTRIB

  from
    vw_produto_saida_entrada

  union all

  select
    DEBUG,
    cd_produto,
    ENTRADASAIDA,
    RECEBTOSAIDA,
    CNPJ,
    IE,
    UF,

    case when ((CFOP >= 1350 and CFOP <= 1356) or
               (CFOP >= 2350 and CFOP <= 2356) or
               (CFOP >= 3350 and CFOP <= 3356))
              and 
              substring(SERIE,1,1) in ('0','1','2','3','4','5','6','7','8','9') then 'U'

         when ( SERIE in ('1.','NFE','NFF') ) then '1'

         when ( SERIE in ('.') ) then ' '

         else SERIE
    end as SERIE,

--     case when ((CFOP >= 1350 and CFOP <= 1356) or
--                (CFOP >= 2350 and CFOP <= 2356) or
--                (CFOP >= 3350 and CFOP <= 3356)) then '08' -- Transporte Rodoviário
-- 
--          else MODELO
--     end as MODELO,

    MODELO,
    NUMERO,
    CFOP,
    CST,
    ITEM,
    PRODUTO,
    DESCRICAO,
    CLASSFISCAL,
    QUANTIDADE,
    VALORPRODUTO,
    DESCONTO,
    BCICMS,	
    BCTRIBUTARIA,
    IPI,
    ALIQICMS,
    ALIQIPI,
    REDICMS,
    BCICMSSUBST,	
    UNIDADEMEDIDA,
    SITUACAOTRIB

  from
    vw_produto_saida_caixa



