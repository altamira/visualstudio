

CREATE procedure sp_InsereFuncao
@cd_funcao int output,
@nm_funcao varchar (20) output,
@ds_funcao text,
@cd_usuario int,
@dt_usuario datetime,
@ic_alteracao char(1)
AS
BEGIN
  --inicia a transaçao
  BEGIN TRANSACTION
  -- gerar codigo e executa travamento
  SELECT @cd_funcao = ISNULL(MAX(cd_funcao),0) + 1 FROM Funcao TABLOCK
  INSERT INTO Funcao( cd_funcao,nm_funcao, ds_funcao, cd_usuario, dt_usuario, ic_alteracao)
     VALUES (@cd_funcao,@nm_funcao, @ds_funcao, @cd_usuario, @dt_usuario, @ic_alteracao)
  if @@ERROR = 0
    COMMIT TRAN
  else
  begin
  --RAISERROR @@ERROR
    ROLLBACK TRAN
  end
end
SET QUOTED_IDENTIFIER  OFF    SET ANSI_NULLS  ON



