-- 
------------------------------------------------------------------------------------------
-- vw_cat3296_reg54
------------------------------------------------------------------------------------------
-- GBS - Global Business Solution                                                    2002
-- Stored Procedure: Microsoft SQL Server 2000
-- Autor(es)       : Alexandre Del Soldato
-- Banco de Dados  : EgisSql
-- Objetivo        : Lista o item do Livro de Entradas e de Saídas utilizado nos Arquivos Magnéticos
-- Data            : 22/03/2004
-- Atualizado      : 28.02.2008 - Ajuste do registros 993
-- 24.06.2009 - Entrada de Importação - Carlos Fernandes
------------------------------------------------------------------------------------------
-- 
create view vw_cat3296_reg54
as

  select
    ENTRADASAIDA,
  	RECEBTOSAIDA,
  	CNPJ,
  	MODELO,
  	SERIE,
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
    UNIDADEMEDIDA
  from
    vw_produto_registro_geral

  where
    (CFOP not between 1350 and 1356) and
    (CFOP not between 2350 and 2356) and
    (CFOP not between 3350 and 3356) and
    DEBUG <> 'MC'

--   order by
--     NUMERO

