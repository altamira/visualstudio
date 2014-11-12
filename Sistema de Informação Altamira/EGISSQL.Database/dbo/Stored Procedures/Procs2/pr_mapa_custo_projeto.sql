
CREATE  PROCEDURE pr_mapa_custo_projeto

@cd_projeto int

AS  

SELECT 
  p.cd_interno_projeto,
  p.dt_entrada_projeto,
  isnull(p.vl_total_projeto,0) as vl_total_projeto,
  isnull(p.qt_hora_estimada_projeto,0) as qt_hora_estimada_projeto,
  isnull(p.qt_hora_real_projeto,0) as qt_hora_real_projeto,
  isnull(((p.qt_hora_estimada_projeto / case when p.qt_hora_real_projeto <= 0 then 1 else p.qt_hora_real_projeto end) * 100 ),0) as pc_valoracao,
  isnull(p.vl_custo_estimado_projeto,0) as vl_custo_estimado_projeto, 
  isnull(p.vl_custo_real_projeto,0) as vl_custo_real_projeto,
  isnull(p.vl_total_compra_projeto,0) as vl_total_compra_projeto,
  isnull(p.vl_total_fab_projeto,0) as vl_total_fab_projeto,
  isnull(p.vl_total_projeto,0) as vl_total_geral_projeto
  
FROM 
  Projeto p
  
WHERE
p.cd_projeto = CASE 
                     WHEN @cd_projeto = 0 THEN   
                       p.cd_projeto
                     ELSE   
                       @cd_projeto
                     END
