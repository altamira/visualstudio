


CREATE   procedure sp_InsereIndice_atributo
@cd_tabela int output,
@cd_indice int output,
@cd_atributo int output,
@cd_sequencia int output,
@cd_usuario int,
@dt_usuario datetime,
@ic_alteracao char(1)
AS
BEGIN
  --inicia a transaçao
  BEGIN TRANSACTION

  -- gerar codigo e executa travamento
  SELECT @cd_sequencia = ISNULL(MAX(cd_sequencia),0) + 1
  FROM Indice_Atributo TABLOCK
  WHERE cd_tabela = @cd_tabela AND cd_indice = @cd_indice

  INSERT INTO Indice_atributo
     (cd_tabela, cd_indice, cd_atributo, cd_sequencia, cd_usuario, dt_usuario, ic_alteracao)
  VALUES
     (@cd_tabela, @cd_indice, @cd_atributo, @cd_sequencia, @cd_usuario, @dt_usuario, @ic_alteracao)

--  Select 
--         @cd_tabela = cd_tabela,
--         @cd_indice = cd_indice,
--         @cd_atributo = cd_atributo
--  From Indice_atributo

  if @@ERROR = 0
    COMMIT TRAN
  else
  begin
  --RAISERROR @@ERROR
    ROLLBACK TRAN
  end
end
SET QUOTED_IDENTIFIER  OFF    SET ANSI_NULLS  ON



