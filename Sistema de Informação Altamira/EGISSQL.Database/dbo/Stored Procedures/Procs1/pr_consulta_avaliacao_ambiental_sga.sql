
CREATE PROCEDURE pr_consulta_avaliacao_ambiental_sga
@dt_inicial datetime,
@dt_final datetime
AS

SELECT 
  aa.dt_avaliacao,
  saa.nm_status_avaliacao,
  a.nm_atividade,
  asa.nm_aspecto_ambiental,
  ia.nm_impacto_ambiental,
  sia.nm_situacao_impacto,
  ta.nm_temporalidade
FROM 
  Avaliacao_Ambiental aa 
  LEFT OUTER JOIN
  Status_Avaliacao_Ambiental saa ON aa.cd_status_avaliacao = saa.cd_status_avaliacao
  LEFT OUTER JOIN
  Atividade a ON aa.cd_atividade = a.cd_atividade
  LEFT OUTER JOIN
  Aspecto_Ambiental asa ON aa.cd_aspecto_ambiental = asa.cd_aspecto_ambiental
  LEFT OUTER JOIN
  Impacto_Ambiental ia ON aa.cd_impacto_ambiental = ia.cd_impacto_ambiental
  LEFT OUTER JOIN
  Situacao_Impacto_Ambiental sia ON aa.cd_situacao_impacto = sia.cd_situacao_impacto
  LEFT OUTER JOIN
  Temporalidade_Ambiental ta ON aa.cd_temporalidade = ta.cd_temporalidade

WHERE 
  aa.dt_avaliacao between @dt_inicial and @dt_final

