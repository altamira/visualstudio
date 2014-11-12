
CREATE PROCEDURE pr_consulta_log_arquivo_magnetico_receber

  @dt_inicial             datetime,
  @dt_final               datetime,
  @cd_documento_magnetico int

as

  select
     dac.nm_documento_magnetico,
     a.dt_proc_arq_magnetico,
     a.nm_local_arq_magnetico,
     a.nm_arquivo_magnetico,
     u.nm_fantasia_usuario
  from
     Arquivo_Magnetico a, 
     Documento_arquivo_magnetico dac,
     egisadmin.dbo.Usuario u
  where
     a.cd_documento_magnetico = @cd_documento_magnetico and
     a.dt_proc_arq_magnetico between @dt_inicial and @dt_final and
     a.cd_documento_magnetico = dac.cd_documento_magnetico and
     a.cd_usuario *= u.cd_usuario
 
