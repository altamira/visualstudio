
CREATE procedure sp_AlteraCadeiaValor
--dados depois da execuçao (novos)
@cd_cadeia_valor int output,
@nm_cadeia_valor varchar (40),
@sg_cadeia_valor char (10),
@ic_cadeia_valor_liberada char (1),
@nm_imagem_cadeia_valor varchar (40),
@ds_cadeia_valor text,
@cd_imagem int,
@cd_help int,
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
  --gera código e executa travamento
  UPDATE Cadeia_Valor SET
         nm_cadeia_valor              = @nm_cadeia_valor,
         sg_cadeia_valor              = @sg_cadeia_valor,
         ic_cadeia_valor_liberada     = @ic_cadeia_valor_liberada,
         nm_imagem_cadeia_valor       = @nm_imagem_cadeia_valor,
         ds_cadeia_valor              = @ds_cadeia_valor,
         cd_imagem                    = @cd_imagem,
         cd_help                      = @cd_help,
         nm_executavel                = @nm_executavel,
         cd_ordem_cadeia_valor        = @cd_ordem_cadeia_valor,
         nm_local_origem_cadeia_valor = @nm_local_origem_cadeia_valor,
         cd_usuario                   = @cd_usuario,
         dt_usuario                   = @dt_usuario,
         ic_alteracao               = @ic_alteracao
     WHERE
         cd_cadeia_valor = @cd_cadeia_valor
  if @@ERROR = 0
    COMMIT TRAN
  else
  begin
  --RAISERROR @@ERROR
    ROLLBACK TRAN
  end
end
SET QUOTED_IDENTIFIER  OFF    SET ANSI_NULLS  ON

