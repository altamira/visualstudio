
CREATE  PROCEDURE pr_hora_projeto_projetista

@cd_projetista int

AS  
SELECT 
  pj.nm_projetista,  
  p.cd_interno_projeto,
  pc.nm_projeto_composicao,
  pa.dt_inicio_projeto,
  pa.dt_final_projeto,
  pa.qt_hora_projeto,
  pj.vl_hora_projetista,
  (pa.qt_hora_projeto * pj.vl_hora_projetista) as vl_custo_total,
  isnull(((pa.qt_hora_projeto * pj.vl_hora_projetista) / (select sum((a.qt_hora_projeto * b.vl_hora_projetista)) from Projeto_Apontamento a LEFT OUTER JOIN Projetista b ON a.cd_projetista = b.cd_projetista where a.cd_projetista = CASE 
                     WHEN @cd_projetista = 0 THEN   
                       a.cd_projetista
                     ELSE   
                       @cd_projetista
                     END) * 100),0) as pc_custo,
  tp.nm_tarefa_projeto
  
FROM 
  Projeto_Apontamento pa
  LEFT JOIN
  Tarefa_Projeto tp ON pa.cd_tarefa_projeto = tp.cd_tarefa_projeto
  LEFT OUTER JOIN 
  Projeto p ON pa.cd_projeto = p.cd_projeto
  LEFT OUTER JOIN
  Projeto_Composicao pc ON pa.cd_projeto = pc.cd_projeto and pa.cd_item_projeto = pc.cd_item_projeto
  LEFT OUTER JOIN
  Projetista pj ON pa.cd_projetista = pj.cd_projetista
WHERE
pa.cd_projetista = CASE 
                     WHEN @cd_projetista = 0 THEN   
                       pa.cd_projetista
                     ELSE   
                       @cd_projetista
                     END
