
CREATE PROCEDURE [sp_InsereHistoricoSenha]
@dt_troca_senha datetime,
@cd_usuario int,
@cd_senha_usuario char(10)
 AS
  INSERT INTO Historico_Senha_Usuario (dt_troca_senha, cd_usuario, cd_senha_usuario)
      VALUES (@dt_troca_senha, @cd_usuario, @cd_senha_usuario);

