-- 
-- vw_cat3296_reg70
-- ---------------------------------------------------------------------------------------
-- GBS - Global Business Solution                                                    2002
-- Stored Procedure: Microsoft SQL Server 2000
-- Autor(es): Elias P. Silva
-- Banco de Dados: EgisSql
-- Objetivo: Lista o Livro de Entradas e de Saídas utilizado nos Arquivos Magnéticos
-- Data: 19/03/2004
-- Atualizado: 
-- ---------------------------------------------------------------------------------------
-- 
create view vw_cat3296_reg70
as

  select 
    ENTRADASAIDA,
    RECEBTOSAIDA,
    CNPJ,
    IE,
    UF,
    MODELO,
    SERIE,
    cast('00' as char(2)) as SUBSERIE,
    NUMERO,
    CFOP,
    VlrContabil,
    BCICMS,	
    ICMS,
    ICMSIsento,
    ICMSOutras,
    cast('1' as char(1)) as CIFFOB,
    Situacao
  from 
    vw_livro_registro_geral_reg51
  where
    (CFOP >= 1350 and CFOP <= 1356) or
    (CFOP >= 2350 and CFOP <= 2356) or
    (CFOP >= 3350 and CFOP <= 3356)

--select top 20 * from vw_cat3296_reg70 WHERE SERIE = '.'
