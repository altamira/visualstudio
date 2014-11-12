
CREATE procedure sp_InsereCadeiaValor
@cd_cadeia_valor int output,
@nm_cadeia_valor varchar (40) output,
@sg_cadeia_valor char (10) output,
@ic_cadeia_valor_liberada char (1) output,
@nm_imagem_cadeia_valor varchar (40) output,
@ds_cadeia_valor text output,
@cd_imagem int output,
@cd_help int output,
@nm_executavel varchar(70),
@cd_ordem_cadeia_valor int,
@nm_local_origem_cadeia_valor varchar(70),
@cd_usuario int,
@dt_usuario datetime,
@ic_alteracao char(1)
AS
BEGIN
  --inicia a transaçao
  BEGIN TRANSACTION
  -- gerar codigo e executa travamento
  SELECT @cd_cadeia_valor = ISNULL(MAX(cd_cadeia_valor),0) + 1 FROM Cadeia_Valor TABLOCK
  INSERT INTO Cadeia_Valor(cd_cadeia_valor,
                     nm_cadeia_valor,
                     sg_cadeia_valor,
                     ic_cadeia_valor_liberada,
                     nm_imagem_cadeia_valor,
                     ds_cadeia_valor,
                     cd_imagem,
                     cd_help,
                     nm_executavel,
                     cd_ordem_cadeia_valor,
                     nm_local_origem_cadeia_valor,
                     cd_usuario,
                     dt_usuario,
                     ic_alteracao)
     VALUES (@cd_cadeia_valor,
             @nm_cadeia_valor,
             @sg_cadeia_valor,
             @ic_cadeia_valor_liberada,
             @nm_imagem_cadeia_valor,
             @ds_cadeia_valor,
             @cd_imagem,
             @cd_help,
             @nm_executavel,
             @cd_ordem_cadeia_valor,
             @nm_local_origem_cadeia_valor,
             @cd_usuario,
             @dt_usuario,
             @ic_alteracao)
  if @@ERROR = 0
    COMMIT TRAN
  else
  begin
  --RAISERROR @@ERROR
    ROLLBACK TRAN
  end
end
SET QUOTED_IDENTIFIER  OFF    SET ANSI_NULLS  ON

