
CREATE  PROCEDURE pr_tarefa_projeto

@cd_tarefa_projeto int

AS  
SELECT 
  tp.nm_tarefa_projeto,
  p.cd_interno_projeto,
  pc.nm_projeto_composicao,
  pa.qt_hora_projeto,
  pj.nm_projetista
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
pa.cd_tarefa_projeto = CASE 
                     WHEN @cd_tarefa_projeto = 0 THEN   
                       pa.cd_tarefa_projeto   
                     ELSE   
                       @cd_tarefa_projeto   
                     END
