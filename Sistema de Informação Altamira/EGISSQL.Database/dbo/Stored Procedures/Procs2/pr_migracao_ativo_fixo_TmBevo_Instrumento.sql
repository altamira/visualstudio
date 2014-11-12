
CREATE PROCEDURE pr_migracao_ativo_fixo_TmBevo_Instrumento 
as

--select * from formula.dbo.veiculos

declare @cd_bem int

select @cd_bem = isnull( max(cd_bem),0)+1 from bem

select 
  identity(int,200,1)             as cd_bem,
  COD                             as nm_mascara_bem,
  CAST (DESCRICAO AS VARCHAR(60)) as nm_bem,
  DESCRICAO                       as ds_bem,
  3                               as cd_grupo_bem,
  LTRIM(RTRIM([NOTA FISCAL])) +' '+ LTRIM(RTRIM([DATA]))+' '+LTRIM(RTRIM(COD_FORNECEDOR)) as nm_obs_item,

  CONVERT(  DATETIME, (SUBSTRING([DATA],1,2) + '/'+SUBSTRING([DATA],4,2)+'/' +CASE WHEN 
                                                         CAST(SUBSTRING([DATA],7,2) AS INT) >= 60 AND CAST(SUBSTRING([DATA],7,2) AS INT) <= 99 
                                                         THEN '19' + SUBSTRING([DATA],7,2) 
                                                         ELSE '20' + SUBSTRING([DATA],7,2) 
                                                     END), 103 ) as dt_aquisicao_bem,


  0                               as cd_departamento,
  0                               as cd_centro_custo,
  1                               as cd_empresa,
  1                               as cd_status_bem,
  1                               as cd_localizacao_bem,

  CONVERT(  DATETIME, (SUBSTRING([DATA],1,2) + '/'+SUBSTRING([DATA],4,2)+'/' +CASE WHEN 
                                                         CAST(SUBSTRING([DATA],7,2) AS INT) >= 60 AND CAST(SUBSTRING([DATA],7,2) AS INT) <= 99 
                                                         THEN '19' + SUBSTRING([DATA],7,2) 
                                                         ELSE '20' + SUBSTRING([DATA],7,2) 
                                                     END), 103 ) as dt_inicio_uso_bem,
  1                               as cd_usuario,
  getdate()                       as dt_usuario 

into #Auxiliar 
from 
  formula.dbo.instrumento_medicao

select * from #Auxiliar

 insert Bem (
  cd_bem,
  nm_bem,
  cd_departamento,
  dt_aquisicao_bem,
  ds_bem,
  cd_grupo_bem,
  nm_mascara_bem,
  cd_status_bem,
  cd_localizacao_bem,
  dt_inicio_uso_bem,
  nm_obs_item,
  cd_empresa,
  cd_usuario,
  dt_usuario 
 )
select 
  cd_bem,
  nm_bem,
  cd_departamento,
  dt_aquisicao_bem,
  ds_bem,
  cd_grupo_bem,
  nm_mascara_bem,
  cd_status_bem,
  cd_localizacao_bem,
  dt_inicio_uso_bem,
  nm_obs_item,
  cd_empresa,
  cd_usuario,
  dt_usuario 
from 
  #Auxiliar  


--select * from formula.dbo.instrumento_medicao

