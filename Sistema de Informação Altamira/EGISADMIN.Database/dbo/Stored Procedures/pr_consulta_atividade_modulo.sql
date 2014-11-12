
CREATE  PROCEDURE pr_consulta_atividade_modulo  

@cd_modulo int

AS  
SELECT
  m.sg_modulo,
  ma.cd_ordem_modulo_atividade,
  ma.qt_hora_modulo_atividade,
  ma.nm_obs_modulo_atividade,
  ma.ds_modulo_atividade,
  ai.nm_atividade,
  gai.nm_grupo_atividade
FROM 
  Modulo_Atividade ma 
  LEFT OUTER JOIN
  Modulo m
  ON ma.cd_modulo = m.cd_modulo
  left outer join
  Atividade_Implantacao ai on ai.cd_atividade = ma.cd_atividade
  left outer join
  Grupo_Atividade_Implantacao gai on gai.cd_grupo_atividade = ai.cd_grupo_atividade

WHERE
  ((@cd_modulo = 0) OR (ma.cd_modulo = @cd_modulo))


--------------------------------------------------------
-- TESTANDO A PROCEDURE
--------------------------------------------------------
-- exec pr_consulta_atividade_modulo 0

