
-------------------------------------------------------------------------------
--sp_helptext pr_baixa_automatica_documento_implantacao
-------------------------------------------------------------------------------
--pr_baixa_automatica_documento_implantacao
-------------------------------------------------------------------------------
--GBS Global Business Solution Ltda                                        2008
-------------------------------------------------------------------------------
--Stored Procedure : Microsoft SQL Server 2000
--Autor(es)        : Carlos Cardoso Fernandes
--Banco de Dados   : Egissql
--Objetivo         : Baixa de Documentos a Receber
--Data             : 29.07.2008
--Alteração        : 
--
--
------------------------------------------------------------------------------
create procedure pr_baixa_automatica_documento_implantacao
@dt_inicial datetime = '',
@dt_final   datetime = ''

as

--documento_receber_pagamento
--select * from documento_receber

select
  d.cd_documento_receber,
  1                              as cd_item_documento_receber,
  d.dt_vencimento_documento      as dt_pagamento_documento,
  d.vl_documento_receber         as vl_pagamento_documento,
  0.00                           as vl_juros_pagamento,
  0.00                           as vl_desconto_documento,
  0.00                           as vl_abatimento_documento,
  0.00                           as vl_despesa_bancaria,
  null                           as cd_recibo_documento,
  null                           as ic_tipo_abatimento,
  null                           as ic_tipo_liquidacao,
  0.00                           as vl_reembolso_documento,
  0.00                           as vl_credito_pendente,
  null                           as ic_desconto_comissao,
  4                              as cd_usuario,
  getdate()                      as dt_usuario,
  'Baixa Automática Implantação' as nm_obs_documento,
  null                           as dt_fluxo_doc_rec_pagament,
  null                           as dt_fluxo_doc_rec_pagto,
  null                           as dt_pagto_contab_documento,
  3                              as cd_tipo_liquidacao,
  null                           as cd_banco,
  null                           as cd_conta_banco,
  null                           as cd_lancamento,
  null                           as cd_tipo_caixa,
  null                           as cd_lancamento_caixa

into
  #documento_receber_pagamento
from
  documento_receber d
where
  d.dt_emissao_documento between @dt_inicial and @dt_final

insert into
  documento_receber_pagamento
select
  *
from
  #documento_receber_pagamento

update
  documento_receber
set
  vl_saldo_documento = 0.00
where
  dt_emissao_documento between @dt_inicial and @dt_final


