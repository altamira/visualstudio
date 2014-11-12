
Create  procedure sp_AlteraModulo
--dados depois da execuçao (novos)
@cd_modulo int output,
@nm_modulo varchar (40),
@sg_modulo char (10),
@ic_liberado char (1),
@nm_imagem_apresentacao_modulo varchar (40),
@ds_modulo text,
@cd_imagem int,
@cd_help int,
@nm_executavel varchar(100),
@cd_ordem_modulo int,
@nm_local_origem_modulo varchar(70),
@cd_cadeia_valor int,
@ic_vincular_cadeia_valor  char(1),
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
@ic_web_modulo          as char(1) = 'N',
@nm_logo_web_modulo  as varchar(100) = '',
@nm_video_modulo     as varchar(100) = '',
@ic_moeda_modulo     as char(1) = 'N',
@ic_venfat_modulo    as char(1) = 'N',
@cd_tipo_versao int = 0
AS
BEGIN
  --inicia a transaçao
  BEGIN TRANSACTION
  --gera código e executa travamento
  UPDATE Modulo SET
         nm_modulo = @nm_modulo,
         sg_modulo = @sg_modulo,
         ic_liberado = @ic_liberado,
         nm_imagem_apresentacao_modulo = @nm_imagem_apresentacao_modulo,
         ds_modulo = @ds_modulo,
         cd_imagem = @cd_imagem,
         cd_help = @cd_help,
         nm_executavel = @nm_executavel,
         cd_ordem_modulo = @cd_ordem_modulo,       
         nm_local_origem_modulo = @nm_local_origem_modulo,
         cd_cadeia_valor = @cd_cadeia_valor,
	      ic_vincular_cadeia_valor = @ic_vincular_cadeia_valor,
         nm_help_modulo = @nm_help_modulo,
         ic_alteracao = @ic_alteracao,
         qt_acesso_modulo = @qt_acesso_modulo,
         cd_usuario = @cd_usuario,
         dt_usuario = @dt_usuario,
         cd_versao_modulo = @cd_versao_modulo,
         cd_versao_cliente_modulo = @cd_versao_cliente_modulo,
         qt_hora_implantacao_modulo = @qt_hora_implantacao_modulo,
         nm_fluxo_modulo = @nm_fluxo_modulo,
         ic_fluxo_modulo = @ic_fluxo_modulo,
         nm_modelagem_modulo = @nm_modelagem_modulo,
         nm_manual_modulo = @nm_manual_modulo,
         ic_web_modulo    = @ic_web_modulo,
         nm_logo_web_modulo = @nm_logo_web_modulo,
         nm_video_modulo = @nm_video_modulo,
         ic_moeda_modulo = @ic_moeda_modulo,     
         ic_venfat_modulo = @ic_venfat_modulo,
		   cd_tipo_versao   = @cd_tipo_versao
 
     WHERE
         cd_modulo = @cd_modulo
  if @@ERROR = 0
    COMMIT TRAN
  else
  begin
  --RAISERROR @@ERROR
    ROLLBACK TRAN
  end
end
SET QUOTED_IDENTIFIER  OFF    SET ANSI_NULLS  ON


