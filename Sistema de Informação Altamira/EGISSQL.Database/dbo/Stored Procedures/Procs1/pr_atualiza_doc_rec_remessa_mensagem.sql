
--sp_helptext pr_atualiza_doc_rec_remessa_mensagem

create procedure pr_atualiza_doc_rec_remessa_mensagem
@cd_identificacao varchar(50) = '' 
as

-- Atualiza o Documento Receber

--documento_receber


if @cd_identificacao is not null and @cd_identificacao<>'' 
begin

  update 
    Documento_Receber
  set
    ic_emissao_documento     = 'S'
  where
--    cd_identificacao = @cd_identificacao
    cd_banco_documento_recebe = @cd_identificacao


end

