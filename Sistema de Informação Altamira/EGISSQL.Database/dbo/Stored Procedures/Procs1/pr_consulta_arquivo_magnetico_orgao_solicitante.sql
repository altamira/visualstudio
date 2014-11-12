
CREATE   PROCEDURE pr_consulta_arquivo_magnetico_orgao_solicitante
  @cd_orgao_solicitante int
AS
begin

  Select 
    os.nm_orgao_solicitante,
    dam.nm_documento_magnetico,
    IsNull(dam.ic_obrigatorio_documento,'N') as ic_obrigatorio_documento,
    IsNull(dam.ic_multa_documento,'N') as ic_multa_documento,
    dam.nm_obs_documento,
    am.dt_proc_arq_magnetico,
    (Select top 1 nm_usuario from EgisAdmin.dbo.Usuario where cd_usuario = am.cd_usuario) as nm_usuario
  from
    Documento_Arquivo_Magnetico dam
    inner join Orgao_Solicitante os
      on dam.cd_orgao_solicitante = os.cd_orgao_solicitante
    left outer join
      Arquivo_Magnetico am
    on (Select top 1 cd_arquivo_magnetico 
       from Arquivo_magnetico 
       where cd_documento_magnetico = dam.cd_documento_magnetico
       order by dt_proc_arq_magnetico desc ) = am.cd_arquivo_magnetico
  where
    ( ( @cd_orgao_solicitante <> 0 ) and dam.cd_orgao_solicitante = @cd_orgao_solicitante ) or
    ( @cd_orgao_solicitante = 0 )   
  
end

