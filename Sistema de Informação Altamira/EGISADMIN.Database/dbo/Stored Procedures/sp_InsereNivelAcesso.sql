
CREATE procedure sp_InsereNivelAcesso
@cd_nivel_acesso int output,
@nm_nivel_acesso varchar (40) output,
@ic_menu_visivel char (1) output,
@ic_senha_acesso char (1) output,
@ic_inclusao char (1) output,
@ic_alteracao char (1) output,
@ic_consulta char (1) output,
@ic_exclusao char (1) output,
@ic_relatorio char (1) output
AS
BEGIN
  --inicia a transaçao
  BEGIN TRANSACTION
  -- gerar codigo e executa travamento
  SELECT @cd_nivel_acesso = ISNULL(MAX(cd_nivel_acesso),0) + 1 FROM NivelAcesso TABLOCK
  INSERT INTO NivelAcesso( cd_nivel_acesso,nm_nivel_acesso,ic_menu_visivel,ic_senha_acesso,ic_inclusao,ic_alteracao,ic_consulta,ic_exclusao,ic_relatorio)
     VALUES (@cd_nivel_acesso,@nm_nivel_acesso,@ic_menu_visivel,@ic_senha_acesso,@ic_inclusao,@ic_alteracao,@ic_consulta,@ic_exclusao,@ic_relatorio)
  if @@ERROR = 0
    COMMIT TRAN
  else
  begin
  --RAISERROR @@ERROR
    ROLLBACK TRAN
  end
end
SET QUOTED_IDENTIFIER  OFF    SET ANSI_NULLS  ON 

