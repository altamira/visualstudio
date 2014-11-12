
-- 
-- vw_cat3296_reg51
-- ---------------------------------------------------------------------------------------
-- GBS - Global Business Solution                                                    2002
-- Stored Procedure: Microsoft SQL Server 2000
-- Autor(es): Elias P. Silva
-- Banco de Dados: EgisSql
-- Objetivo: Lista o Livro de Entradas e de Saídas utilizado nos Arquivos Magnéticos
-- Data: 19/03/2004
-- Atualizado: 12/04/2004 - COMENTADO FILTRO PARA TRAZER TODAS AS CFOPS, MESMO DE OPERAÇÕES DE
--                          TRANSPORTE - ELIAS
--             12/04/2004 - CASO A NF ESTEJA CANCELADA, É RETORNADO ZERO NAS COLUNAS DE VALOR - ELIAS
-- 02.02.2008 - Descomentado o Código de Transporte - Carlos Fernandes.
-------------------------------------------------------------------------------------------
-- 

create view vw_cat3296_reg51
as

  select 
   
    ENTRADASAIDA,
    RECEBTOSAIDA,
    ESPECIE,
    SERIE,
    MODELO,
    EMITENTE,
    NUMERO,
    EMISSAO,
    UF,
    CNPJ,
    IE,
    case when Situacao = 'S' then 0 else VlrContabil end as VlrContabil,
    CFOP,
    case when Situacao = 'S' then 0 else BCIPI       end as BCIPI,
    case when Situacao = 'S' then 0 else IPI         end as IPI,
    case when Situacao = 'S' then 0 else IPIIsento   end as IPIIsento,
    case when Situacao = 'S' then 0 else IPIOutras   end as IPIOutras,
    Situacao  

  from 
    vw_livro_registro_geral_reg51

  where
    (CFOP not between 1350 and 1356) and
    (CFOP not between 2350 and 2356) and
    (CFOP not between 3350 and 3356)

