
CREATE PROCEDURE pr_repnet_consulta_rel_diario_vendas_detalhe
--pr_repnet_consulta_rel_diario_vendas_detalhe
---------------------------------------------------
-- GBS - Global Business Solution	       2002
-- Stored Procedure: Microsoft SQL Server       2000
-- Autor(es): Rafael M. Santiago
-- Banco de Dados: EgisSql
-- Objetivo: Consultar Relatorio Diário de Vendas Detalhe
-- Data: 25/11/2003
-- Alterado:
---------------------------------------------------
@ic_parametro as int,
@cd_diario_venda as int

AS
IF @ic_parametro = 1 -- CABECALHO
BEGIN
SELECT 
  rdv.cd_diario_venda,
	rdv.dt_diario_venda,
  rdv.cd_vendedor,
  v.nm_vendedor,
  c.nm_fantasia_cliente,
  rv.nm_regiao_venda,
	nc.nm_nivel_cliente,
  cc.nm_categoria_cliente,
  CASE 
    WHEN isnull(cf.cd_cliente,0) = 0 THEN
      'Não'
    ELSE
      'Sim' 
  END AS ic_cliente_foco,
  cf.cd_cliente          as cd_cliente_foco,
  cf.nm_fantasia_cliente as nm_fantasia_cliente_foco,
  CASE 
    WHEN isnull(co.cd_cliente,0) = 0 THEN
      'Não'
    ELSE
      'Sim' 
  END AS ic_cliente_oem,
  co.cd_cliente          as cd_cliente_oem,
  co.nm_fantasia_cliente as nm_fantasia_cliente_oem,
  rdv.ds_diario_venda,
  CASE 
    WHEN isnull(cg.cd_cliente,0) = 0 THEN
      'Não'
    ELSE
      'Sim' 
  END AS ic_cliente_global,
  cg.cd_cliente          as cd_cliente_global,
  cg.nm_fantasia_cliente as nm_fantasia_cliente_global,
  rdv.nm_contato_diario_venda,
  CASE 
    WHEN ISNULL(rdv.ic_negocio_diario,'N') = 'S' THEN
      'Sim'
    ELSE
      'Não' 
  END AS ic_negocio_diario,
  rdv.nm_ref_negocio_diario
    

FROM
  Relatorio_Diario_Vendas rdv
	LEFT OUTER JOIN
  Vendedor v
  ON
	rdv.cd_vendedor = v.cd_vendedor
  LEFT OUTER JOIN
  Cliente c
  ON
	rdv.cd_cliente = c.cd_cliente
  LEFT OUTER JOIN
  Regiao_Venda rv
  ON
	rdv.cd_regiao_venda = rv.cd_regiao_venda
  LEFT OUTER JOIN
  Nivel_Cliente nc
  ON
  rdv.cd_nivel_cliente = nc.cd_nivel_cliente
  LEFT OUTER JOIN
  Categoria_Cliente cc
  ON 
  rdv.cd_categoria_cliente = cc.cd_categoria_cliente
  LEFT OUTER JOIN
  Cliente cf -- Cliente FOCO
  ON
	rdv.cd_cliente_foco = cf.cd_cliente
  LEFT OUTER JOIN
  Cliente co -- Cliente OEM
  ON
	rdv.cd_cliente_oem = co.cd_cliente
  LEFT OUTER JOIN
  Cliente cg -- Cliente GLOBAL
  ON
	rdv.cd_cliente_global = cg.cd_cliente
  
  
WHERE
  rdv.cd_diario_venda = @cd_diario_venda
END

-------------------------------------------------------------------------

IF @ic_parametro = 2 --TIPO INFORMACAO
BEGIN
  SELECT
	  cd_tipo_informacao,
    nm_tipo_informacao,
	  IsNull((Select top 1 'S' from DV_Tipo_Informacao where cd_diario_venda = @cd_diario_venda and cd_tipo_informacao = t.cd_tipo_informacao),'N') as ic_checado
  FROM
	  Tipo_Informacao t
  WHERE
	  ic_ativo_tipo_informacao = 'S'    
END

------------------------------------------------------------------------

IF @ic_parametro = 3 --PONTO CHAVE
BEGIN
SELECT
 	cd_pontos_chave_rel,
  nm_pontos_chave_rel,
	IsNull((Select top 1 'S' from DV_Ponto_Chave_Rel_Repnet where cd_diario_venda = @cd_diario_venda and cd_pontos_chave_rel = pc.cd_pontos_chave_rel),'N') as ic_checado
FROM
	Pontos_Chave_Relatorio_Repnet pc

END
------------------------------------------------------------------------------------------
IF @ic_parametro = 4 -- Produtos
BEGIN
SELECT
  cd_produtos_relatorio,
	nm_produtos_relatorio,
	IsNull((Select top 1 'S' from DV_Produtos_Relatorio_Repnet where cd_diario_venda = @cd_diario_venda and cd_produtos_relatorio = pr.cd_produtos_relatorio),'N') as ic_checado
FROM
	Produtos_Relatorio_Repnet pr

END
-----------------------------------------------------------------------------------------
IF @ic_parametro = 5 -- CANAIS
BEGIN
SELECT
	crp.cd_canais_relatorio,
  crp.nm_canais_relatorio,
	IsNull((Select top 1 'S' from DV_Canais_Rel_Repnet where cd_diario_venda = @cd_diario_venda and cd_canais_relatorio = crp.cd_canais_relatorio),'N') as ic_checado
FROM
	Canais_Relatorio_Repnet crp
END
--------------------------------------------------------------------------------
IF @ic_parametro = 6 -- Distribuicao
BEGIN
SELECT
  cd_distribuicao_diario, 
	(SELECT TOP 1 nm_departamento FROM Departamento where cd_departamento = dd.cd_departamento) as nm_departamento,
	IsNull((Select top 1 'S' from DV_Distribuicao_Diario where cd_diario_venda = @cd_diario_venda and cd_distribuicao_diario = dd.cd_distribuicao_diario),'N') as ic_checado

FROM 
	Distribuicao_Diario dd
END

