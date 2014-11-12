
CREATE PROCEDURE [sp_DeletaUsuario_Config]
@cd_usuario int,
@nm_origem varchar(200),
@nm_destino varchar(200),
@nm_arquivo varchar(30),
@sg_tipo char(1)
AS
  DELETE FROM Usuario_Config
        WHERE cd_usuario  = @cd_usuario and
              nm_origem   = @nm_origem and
              nm_destino  = @nm_destino and
              nm_arquivo  = @nm_arquivo and
              sg_tipo     = @sg_tipo 

