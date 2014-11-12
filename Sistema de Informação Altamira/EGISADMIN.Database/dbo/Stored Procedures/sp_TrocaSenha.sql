
CREATE PROCEDURE sp_TrocaSenha
@cd_usuario int,
@cd_senha_velha varchar(10),
@cd_senha_nova varchar(10)
AS
  DECLARE @nm_fantasia_usuario varchar(50),
          @qt_dias_troca int 
  /* valida a senha informada */
  IF exists(SELECT * 
              FROM Historico_Senha_Usuario 
             WHERE cd_usuario = @cd_usuario
               AND cd_senha_usuario = @cd_senha_nova)
  BEGIN
     GOTO TrataErro 
     RETURN
  END
  /* armazena o nome do usuário */
  SELECT @nm_fantasia_usuario = nm_fantasia_usuario 
    FROM Usuario
   WHERE cd_usuario = @cd_usuario
  /* armazena o num. de dias para troca da senha */
  SELECT @qt_dias_troca = qt_dias_troca
    FROM Usuario
   WHERE cd_usuario = @cd_usuario
  
  /* atualiza a tabela de usuário */
  BEGIN TRAN
  UPDATE Usuario SET
         cd_senha_usuario = @cd_senha_nova,
	 ic_alterar_primeiro_log = 'N',
         dt_validade_senha_usuario = GetDate() + @qt_dias_troca
   WHERE cd_usuario = @cd_usuario
     AND cd_senha_usuario = @cd_senha_velha
    /* Atualiza o Histórico de Senhas */
  INSERT INTO Historico_Senha_Usuario (dt_troca_senha, cd_usuario, cd_senha_usuario)
       VALUES (GetDate(),@cd_usuario,@cd_senha_nova)
  if @@ERROR = 0
    COMMIT TRAN
  else
  begin
  --RAISERROR @@ERROR
    ROLLBACK TRAN
  end
  -- O comando abaixo troca a senha no servidor. Porém, após a implementaçao
  -- da encriptografia da senha, o conteúdo gravado nao conferia com a senha
  -- do usuário no banco. Isto impedia o login. A soluçao paliativa foi colocar
  -- uma senha padrao, sendo que a senha utilizada pelo usuário serve apenas para
  -- conferência no SAPADMIN
  --  exec sp_password @cd_senha_velha, @cd_senha_nova, @nm_fantasia_usuario
RETURN
TRATAERRO:
  RAISERROR ('Esta senha já foi utilizada.',16,1)

