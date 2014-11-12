

create procedure pr_atualiza_inst_bco_remessa
@cd_identificacao varchar(15),
@cd_banco         int

as

  -- Atualiza a Instrução Bancária

  update 
    Documento_Instrucao_Bancaria
  set
    ic_emissao_instrucao_banc = 'S',
    ic_envio_instrucao_banco  = 'S'
  from 
    documento_instrucao_bancaria dib,
    documento_receber dr
  where
    dib.cd_documento_receber = dr.cd_documento_receber and
    dr.cd_identificacao = @cd_identificacao

