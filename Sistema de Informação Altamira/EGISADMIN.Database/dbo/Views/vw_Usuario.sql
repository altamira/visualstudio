
/****** Object:  View dbo.vw_Usuario    Script Date: 17/9/2002 09:46:29 ******/

create  VIEW dbo.vw_Usuario
AS
SELECT 
  u.cd_usuario,   
  u.nm_usuario,   
  u.nm_fantasia_usuario,   
  u.cd_usuario_atualiza,   
  u.dt_usuario_atualiza,   
  ISNULL(u.ic_ass_eletronica_usuario, 'N') AS ic_ass_eletronica_usuario,  
  ISNULL(u.ic_ocorrencia_usuario, 'N')     AS ic_ocorrencia_usuario,
  d.nm_departamento,  
  ce.nm_cargo_empresa,
  u.nm_email_usuario,
  u.cd_telefone_usuario,
  u.nm_ramal_usuario,
  u.cd_celular_usuario,
  case when isnull(u.ic_ativo,'A')='A' 
  then
    'Ativo'
  else
    'Inativo'
  end                                      as nm_status_usuario   
 
FROM Usuario u                  with (nolock) 
     LEFT OUTER JOIN
     EGISSQL.dbo.Departamento d   ON d.cd_departamento  =  u.cd_departamento
     LEFT OUTER JOIN
     EGISSQL.dbo.Cargo_Empresa ce ON u.cd_cargo_empresa = ce.cd_cargo_empresa

