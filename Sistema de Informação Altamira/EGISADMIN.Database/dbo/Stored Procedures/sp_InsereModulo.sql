
CREATE procedure sp_InsereModulo
@cd_modulo int output,
@nm_modulo varchar (40) output,
@sg_modulo char (10) output,
@ic_liberado char (1) output,
@nm_imagem_apresentacao_modulo varchar (40) output,
@ds_modulo text output,
@cd_imagem int output,
@cd_help int output,
@nm_executavel varchar(100) output,
@cd_ordem_modulo int output,
@nm_local_origem_modulo varchar(70) output,
@cd_cadeia_valor int output,
@ic_vincular_cadeia_valor char(1) output,
@nm_help_modulo varchar(100),
@ic_alteracao char(1),
@qt_acesso_modulo int,
@cd_usuario int,
@dt_usuario datetime,
@cd_versao_modulo varchar(15),
@cd_versao_cliente_modulo varchar(15),
@qt_hora_implantacao_modulo int,
@nm_fluxo_modulo as varchar(100),
@ic_fluxo_modulo as char(1),
@nm_modelagem_modulo as	varchar(100),
@nm_manual_modulo	as varchar(100),
@ic_web_modulo   as char(1) = 'N',
@nm_logo_web_modulo  as varchar(100) = '',
@nm_video_modulo     as varchar(100) = '',
@ic_moeda_modulo     as char(1) = 'N',
@ic_venfat_modulo    as char(1) = 'N',
@cd_tipo_versao int =0

AS
BEGIN
  --inicia a transaçao
  BEGIN TRANSACTION
  -- gerar codigo e executa travamento
  SELECT @cd_modulo = ISNULL(MAX(cd_modulo),0) + 1 FROM Modulo TABLOCK
  INSERT INTO Modulo(cd_modulo,
                     nm_modulo,
                     sg_modulo,
                     ic_liberado,
                     nm_imagem_apresentacao_modulo,
                     ds_modulo,
                     cd_imagem,
                     cd_help,
                     nm_executavel,
                     cd_ordem_modulo,
                     nm_local_origem_modulo,
                     cd_cadeia_valor,
		                 ic_vincular_cadeia_valor,
                     nm_help_modulo,
                     ic_alteracao,
                     qt_acesso_modulo,
                     cd_usuario,
                     dt_usuario,
                     cd_versao_modulo,
                     cd_versao_cliente_modulo,
                     qt_hora_implantacao_modulo,
                     nm_fluxo_modulo,
                     ic_fluxo_modulo,
                     nm_modelagem_modulo,
                     nm_manual_modulo,
                     ic_web_modulo,
                     nm_logo_web_modulo,
                     nm_video_modulo,
                     ic_moeda_modulo,
                     ic_venfat_modulo,
							cd_tipo_versao    )
     VALUES (@cd_modulo,
             @nm_modulo,
             @sg_modulo,
             @ic_liberado,
             @nm_imagem_apresentacao_modulo,
             @ds_modulo,
             @cd_imagem,
             @cd_help,
             @nm_executavel,
             @cd_ordem_modulo,
             @nm_local_origem_modulo,
             @cd_cadeia_valor,
  	          @ic_vincular_cadeia_valor,
             @nm_help_modulo,
             @ic_alteracao,
             @qt_acesso_modulo,
             @cd_usuario,
             @dt_usuario,
             @cd_versao_modulo,
             @cd_versao_cliente_modulo,
             @qt_hora_implantacao_modulo,
             @nm_fluxo_modulo,
             @ic_fluxo_modulo,
             @nm_modelagem_modulo,
             @nm_manual_modulo,
             @ic_web_modulo,
             @nm_logo_web_modulo,
             @nm_video_modulo,
             @ic_moeda_modulo,
             @ic_venfat_modulo,
             @cd_tipo_versao )
  if @@ERROR = 0
    COMMIT TRAN
  else
  begin
  --RAISERROR @@ERROR
    ROLLBACK TRAN
  end
end
SET QUOTED_IDENTIFIER  OFF    SET ANSI_NULLS  ON


