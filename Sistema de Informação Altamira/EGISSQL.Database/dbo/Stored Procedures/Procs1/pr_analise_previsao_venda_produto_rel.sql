
CREATE PROCEDURE pr_analise_previsao_venda_produto_rel

@cd_vendedor int = 0,
@cd_cliente  int = 0,
@cd_pais     int = 0,
@cd_produto  int = 0

AS

SELECT
pv.cd_previsao_venda,
pv.cd_vendedor,
v.nm_fantasia_vendedor,
pv.cd_cliente,
c.nm_fantasia_cliente,
pv.cd_grupo_produto,
gp.nm_fantasia_grupo_produto,
pv.cd_categoria_produto,
cp.sg_categoria_produto,
case
  when isnull(pv.cd_produto,0) > 0 then
    p.nm_fantasia_produto
  when isnull(pv.cd_produto_desenv,0) > 0 then
    pd.nm_produto_desenv
end as nm_produto_previsao,
pv.dt_ultima_compra_cliente,
isnull(pv.qt_anterior_previsao,0) as qt_anterior_previsao,
isnull(pv.qt_produto_previsao_venda,0) as qt_produto_previsao_venda,
isnull(pv.qt_potencial_previsao,0) as qt_potencial_previsao,
isnull(pv.qt_programado_previsao,0) as qt_programado_previsao,
isnull(((pv.qt_programado_previsao / case 
  when (SELECT 
                                        SUM(a.qt_programado_previsao) 
                                      FROM 
                                        Previsao_Venda a 
                                      WHERE (
   														isnull(a.cd_vendedor,0) = case when @cd_vendedor = 0 then isnull(a.cd_vendedor,0) else @cd_vendedor end and
   														isnull(a.cd_cliente,0)  = case when @cd_cliente  = 0 then isnull(a.cd_cliente,0)  else @cd_cliente end and
   														isnull(a.cd_pais,0)     = case when @cd_pais     = 0 then isnull(a.cd_pais,0)     else @cd_pais end
                                            )
                                       ) = 0
    then 1 else (SELECT 
                                        SUM(a.qt_programado_previsao) 
                                      FROM 
                                        Previsao_Venda a 
                                      WHERE (
   														isnull(a.cd_vendedor,0) = case when @cd_vendedor = 0 then isnull(a.cd_vendedor,0) else @cd_vendedor end and
   														isnull(a.cd_cliente,0)  = case when @cd_cliente  = 0 then isnull(a.cd_cliente,0)  else @cd_cliente end and
   														isnull(a.cd_pais,0)     = case when @cd_pais     = 0 then isnull(a.cd_pais,0)     else @cd_pais end
                                            )
                                       ) end
) * 100),0) as 'participacao',

pv.cd_usuario,
pv.dt_usuario,
isnull(pv.qt_ranking_cliente,0) as qt_ranking_cliente,
ra.nm_ramo_atividade
FROM 
  Previsao_Venda pv
  LEFT OUTER JOIN
  Vendedor v
  ON pv.cd_vendedor = v.cd_vendedor
  LEFT OUTER JOIN
  Cliente c
  ON pv.cd_cliente = c.cd_cliente
  LEFT OUTER JOIN
  Grupo_Produto gp
  ON pv.cd_grupo_produto = gp.cd_grupo_produto
  LEFT OUTER JOIN 
  Categoria_Produto cp
  ON 
  pv.cd_categoria_produto = cp.cd_categoria_produto
  LEFT OUTER JOIN 
  Produto p
  ON
  pv.cd_produto = p.cd_produto
  LEFT OUTER JOIN
  Produto_Desenvolvimento pd
  ON
  pv.cd_produto_desenv = pd.cd_produto_desenv
  LEFT OUTER JOIN
  Ramo_Atividade ra
  ON
  c.cd_ramo_atividade = ra.cd_ramo_atividade
WHERE
   isnull(pv.cd_vendedor,0) = case when @cd_vendedor = 0 then isnull(pv.cd_vendedor,0) else @cd_vendedor end and
   isnull(pv.cd_cliente,0)  = case when @cd_cliente  = 0 then isnull(pv.cd_cliente,0)  else @cd_cliente end and
   isnull(pv.cd_pais,0)     = case when @cd_pais     = 0 then isnull(pv.cd_pais,0)     else @cd_pais end and 
   isnull(p.cd_produto,0)   = case when @cd_produto  = 0 then isnull(p.cd_produto,0)   else @cd_produto end 

ORDER BY
  nm_produto_previsao,
  c.nm_fantasia_cliente
