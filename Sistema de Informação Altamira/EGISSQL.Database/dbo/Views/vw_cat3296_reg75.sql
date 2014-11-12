
-----------------------------------------------------------------------------------------
-- vw_cat3296_reg75
-----------------------------------------------------------------------------------------
-- GBS - Global Business Solution                                                    2002
-- Stored Procedure: Microsoft SQL Server 2000
-- Autor(es): Alexandre Del Soldato
-- Banco de Dados : EgisSql
-- Objetivo       : Código de Produto e Serviços utilizado nos Arquivos Magnéticos
-- Data           : 22/03/2004
-- Atualizado     : 23.06.2009 - Ajustes Diversos - Carlos Fernandes
-- 24.03.2010 - Ajustes Diversos - Carlos Fernandes
-----------------------------------------------------------------------------------------
-- 

create view vw_cat3296_reg75

as

  select 
    distinct
    vw.RECEBTOSAIDA,
    vw.PRODUTO,
    cast(dbo.fn_limpa_mascara(isnull(cf.cd_mascara_classificacao,'00000000')) as char(9)) as CODNCM,
    vw.DESCRICAO,
    vw.UNIDADEMEDIDA,
    vw.SITUACAOTRIB,
    vw.ALIQIPI,
    vw.ALIQICMS,
    vw.REDICMS,
    vw.BCICMSSUBST
  from      
    vw_produto_registro_geral vw

  left outer join
    Classificacao_Fiscal cf
  on
    vw.CLASSFISCAL = cf.cd_classificacao_fiscal

  where
    isnull( vw.PRODUTO, '' ) <> '' and
    isnull( vw.DESCRICAO,'') <> ''
    and vw.DESCRICAO <> 'TRANSPORTE - CONHECIMENTO'

