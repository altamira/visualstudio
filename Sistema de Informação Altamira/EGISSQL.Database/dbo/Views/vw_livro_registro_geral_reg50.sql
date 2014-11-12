
------------------------------------------------------------------------------------------
-- vw_livro_registro_geral_reg50
------------------------------------------------------------------------------------------
-- GBS - Global Business Solution                                                    2002
-- Stored Procedure: Microsoft SQL Server 2000
-- Autor(es): Elias P. Silva
-- Banco de Dados: EgisSql
-- Objetivo   : Lista o Livro de Entradas e de Saídas utilizado nos Arquivos Magnéticos
-- Data       : 19/03/2004
-- Atualizado : 12/04/2004 - COMENTADO CASE DO CAMPO MODELO - ELIAS
--            : 29.06.2007 - Acertos Diversos - Carlos Fernandes
-- 02.02.2008 - Quebra por Alíquota de ICMS - Carlos Fernandes
-- 18.06.2009 - Nota de Entrada de Importação no Faturamento - Carlos Fernandes
-- 08.11.2009 - duplicidade de nota - carlos Fernandes
-- 18.03.2010 - Complemento de informações - Carlos Fernandes
-----------------------------------------------------------------------------------------
-- 
create view vw_livro_registro_geral_reg50
as

  select 

    ENTRADASAIDA,
    RECEBTOSAIDA,
    ESPECIE,

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
--     end as
    MODELO,
    EMITENTE,
    NUMERO,
    EMISSAO,
    UF,
    CNPJ,
    IE,
    VlrContabil,
    CFOP,
    BCICMS,	
    AliqICMS,
    ICMS,
    ICMSIsento,
    ICMSOutras,
    BCICMSST,
    ICMSST,
    Situacao  

  from 
    vw_livro_registro_entrada_reg50

  union all

  select
    ENTRADASAIDA,
    RECEBTOSAIDA,
    ESPECIE,

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
--     end as 

    MODELO,
    EMITENTE,
    NUMERO,
    EMISSAO,
    UF,
    CNPJ,
    IE,
    VlrContabil,
    CFOP,
    BCICMS,	
    AliqICMS,
    ICMS,
    ICMSIsento,
    ICMSOutras,
    BCICMSST,
    ICMSST,
    Situacao  

  from 
    vw_livro_registro_saida_reg50

  union all

  select
    ENTRADASAIDA,
    RECEBTOSAIDA,
    ESPECIE,

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
--     end as 

    MODELO,
    EMITENTE,
    NUMERO,
    EMISSAO,
    UF,
    CNPJ,
    IE,
    VlrContabil,
    CFOP,
    BCICMS,	
    AliqICMS,
    ICMS,
    ICMSIsento,
    ICMSOutras,
    BCICMSST,
    ICMSST,
    Situacao  

  from 
    vw_livro_registro_saida_reg50_entrada


