

/****** Object:  Stored Procedure dbo.sp_HabilitaUsuario    Script Date: 13/12/2002 15:08:45 ******/
CREATE procedure sp_HabilitaUsuario
@nm_fantasia_usuario char (15),
@cd_senha_usuario varchar (10)
AS
BEGIN
  --inicia a transaçao
  BEGIN TRANSACTION
  -- adiciona o login do usuario ao servidor
--  EXEC SP_ADDLOGIN @nm_fantasia_usuario,@cd_senha_usuario,'master','Português'
  -- Após implementaçao da encriptografia da senha, o login no banco passou a 
  -- apresentar problemas. Soluçao paliativa: Utilizar senha fixa p/ logar no server
  EXEC SP_ADDLOGIN @nm_fantasia_usuario,'STANDARDPASSWORD','master','Português'
  -- adiciona usuario
  EXEC SP_GRANTDBACCESS @nm_fantasia_usuario
  EXEC SP_ADDROLEMEMBER 'db_owner', @nm_fantasia_usuario
 
  RETURN
end


