-- 
------------------------------------------------------------------------------------------
-- vw_cat3296_reg50
------------------------------------------------------------------------------------------
-- GBS - Global Business Solution                                                    2002
-- Stored Procedure: Microsoft SQL Server 2000
-- Autor(es)       : Elias P. Silva
-- Banco de Dados  : EgisSql
-- Objetivo        : Lista o Livro de Entradas e de Saídas utilizado nos Arquivos Magnéticos
-- Data            : 19/03/2004
-- Atualizado      : NÃO FILTRAR PARA NÃO LISTAR AS CFOPS CONSIDERADAS DE TRANSPORTE - ELIAS
--                 : 29.06.2007 
-- 02.02.2008 - Acerto da Nota de Transporte - Carlos Fernandes
-- 22.10.2009 - Verificar de Op. fiscal - 5.403
-- 08.11.2009 - ajustes carlos fernandes
-- ---------------------------------------------------------------------------------------
-- 

create view vw_cat3296_reg50
as

  select 
    ENTRADASAIDA,
    RECEBTOSAIDA,
    ESPECIE,

    --SERIE,

    --MODELO,

    case when ((CFOP >= 1350 and CFOP <= 1356) or
               (CFOP >= 2350 and CFOP <= 2356) or
               (CFOP >= 3350 and CFOP <= 3356))
              and 
              substring(SERIE,1,1) in ('0','1','2','3','4','5','6','7','8','9') then 'U'

         when ( SERIE in ('1.','NFE','NFF') ) then '1'

         when ( SERIE in ('.') ) then ' '

         else SERIE
    end as SERIE,

    case when ((CFOP >= 1350 and CFOP <= 1356) or
               (CFOP >= 2350 and CFOP <= 2356) or
               (CFOP >= 3350 and CFOP <= 3356)) then '08' -- Transporte Rodoviário

         else MODELO
    end as MODELO,

    EMITENTE,
    NUMERO,
    EMISSAO,
    UF,
    CNPJ,
    IE,
    case when Situacao = 'S' then 0.00 else VlrContabil end as VlrContabil,
    CFOP,
    case when Situacao = 'S' then 0.00 else BCICMS      end as BCICMS,	
    --Alíquota de ICMS
    case when Situacao = 'S' then 0.00 else AliqICMS    end as AliqICMS,
    case when Situacao = 'S' then 0.00 else ICMS        end as ICMS,
    case when Situacao = 'S' then 0.00 else ICMSIsento  end as ICMSIsento,
    case when Situacao = 'S' then 0.00 else ICMSOutras  end as ICMSOutras,
    Situacao  
  from 
    vw_livro_registro_geral_reg50

  where
   (CFOP not between 1350 and 1356) and
   (CFOP not between 2350 and 2356) and
   (CFOP not between 3350 and 3356)

