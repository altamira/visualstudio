
CREATE PROCEDURE pr_insere_registro_suporte
--@dt_registro_suporte as datetime, 
@cd_cliente_sistema as int, 
@cd_usuario_sistema as int, 
@cd_prioridade_suporte as int, 
@cd_modulo as int, 
@cd_versao_modulo as varchar(15), 
@dt_ocorrencia_suporte as datetime, 
@ds_ocorrencia_suporte as text, 
@ds_mensagem_suporte as text, 
@ds_observacao_suporte as text, 
@cd_menu_historico as int, 
@cd_usuario as int, 
@nm_doc_registro_suporte as varchar(100)
AS
DECLARE

@cd_registro_suporte as int
SELECT @cd_registro_suporte = (MAX(cd_registro_suporte) + 1) from Registro_Suporte 

INSERT INTO 
Registro_Suporte
(cd_registro_suporte,
dt_registro_suporte, 
cd_cliente_sistema, 
cd_usuario_sistema, 
cd_prioridade_suporte, 
cd_modulo, 
cd_versao_modulo, 
dt_ocorrencia_suporte, 
ds_ocorrencia_suporte, 
ds_mensagem_suporte, 
ds_observacao_suporte, 
cd_menu_historico, 
cd_usuario, 
dt_usuario, 
nm_doc_registro_suporte)
VALUES
(
@cd_registro_suporte,
GETDATE(), --@dt_registro_suporte, 
@cd_cliente_sistema, 
@cd_usuario_sistema, 
@cd_prioridade_suporte, 
@cd_modulo, 
@cd_versao_modulo, 
@dt_ocorrencia_suporte, 
@ds_ocorrencia_suporte, 
@ds_mensagem_suporte, 
@ds_observacao_suporte, 
@cd_menu_historico, 
@cd_usuario, 
GETDATE(), 
@nm_doc_registro_suporte)

