-- 
-- vw_cadastro_bem
-- ---------------------------------------------------------------------------------------
-- GBS - Global Business Solution                                                    2002
-- Stored Procedure: Microsoft SQL Server 2000
-- Autor(es): Alexandre Del Soldato
-- Banco de Dados: EgisSql
-- Objetivo: Lista Arquivos Magnéticos
-- Data: 01/04/2004
-- Atualizado: 
-- ---------------------------------------------------------------------------------------
-- 
create view vw_cadastro_bem
as

  select
    b.cd_bem                   as BEM,
    1                          as Natureza,
    null                       as Agregado,
    b.nm_bem                   as Identificacao,
    pc.cd_mascara_conta        as ANALITICOBEM,
    pcd.cd_mascara_conta        as ANALDEPRACUMULADO,
    b.dt_aquisicao_bem         as DTAQUISICAO,
    'NFE'                      as TIPODOCUMENTO,
    b.cd_serie_nota_fiscal     as SERIE,
    b.cd_nota_entrada          as NUMERO,
    vb.vl_original_bem         as VALORORIGINAL,
    vb.vl_deprec_acumulada_bem as VALORREAIS,
    b.dt_inicio_uso_bem        as DTINICIO,
    vb.pc_deprec_acelerada_bem  as TAXADEPRECIACAO,
    vb.vl_deprec_acumulada_bem as DEPRECIACAO,
    null                       as DEPRECIACAOLANCADA,
    null                       as DTBAIXA
  from 
    Bem b
  LEFT OUTER JOIN 
    Valor_Bem vb
  on 
    b.cd_bem = vb.cd_bem
  LEFT OUTER JOIN 
    Plano_Conta pc
  on 
    b.cd_plano_conta = pc.cd_conta
  LEFT OUTER JOIN 
    Plano_Conta pcd
  on 
    vb.pc_plano_conta_depreciacao = pcd.cd_conta

