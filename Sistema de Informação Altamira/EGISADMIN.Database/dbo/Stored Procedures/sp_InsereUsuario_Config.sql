
CREATE PROCEDURE [sp_InsereUsuario_Config] 
@cd_usuario int,
@nm_origem varchar(200),
@nm_destino varchar(200),
@nm_arquivo varchar(30),
@sg_tipo char(1),
@cd_modulo int
AS
  INSERT INTO Usuario_Config (cd_usuario, 
                              nm_origem, 
                              nm_destino, 
                              nm_arquivo, 
                              sg_tipo, 
                              cd_modulo)
     VALUES (@cd_usuario, 
             @nm_origem, 
             @nm_destino, 
             @nm_arquivo, 
             @sg_tipo, 
             @cd_modulo)

