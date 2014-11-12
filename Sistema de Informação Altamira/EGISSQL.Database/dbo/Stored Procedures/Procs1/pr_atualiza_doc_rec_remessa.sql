

create procedure pr_atualiza_doc_rec_remessa
@cd_identificacao varchar(15)
as

  -- Atualiza o Documento Receber

  update 
    Documento_Receber
  set
    dt_envio_banco_documento = getDate(),
    ic_envio_documento       = 'N',
    ic_emissao_documento     = 'S'
  where
    cd_identificacao = @cd_identificacao

