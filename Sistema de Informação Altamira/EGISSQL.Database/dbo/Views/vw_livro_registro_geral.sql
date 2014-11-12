-- 
-- vw_livro_registro_geral
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
create view vw_livro_registro_geral
as

/*
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
    VlrContabil,
    CFOP,
    BCICMS,	
    AliqICMS,
    ICMS,
    ICMSIsento,
    ICMSOutras,
    BCIPI,
    IPI,
    IPIIsento,
    IPIOutras,
    Situacao  
  from 
    vw_livro_registro_entrada

  union all
*/
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
    VlrContabil,
    CFOP,
    BCICMS,	
    AliqICMS,
    ICMS,
    ICMSIsento,
    ICMSOutras,
    BCIPI,
    IPI,
    IPIIsento,
    IPIOutras,
    Situacao  
  from 
    vw_livro_registro_saida

--select top 100 * from vw_livro_registro_geral where numero = 064136
