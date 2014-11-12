
CREATE PROCEDURE pr_consulta_credito_pendente_documento_receber

AS

select 
  c.nm_fantasia_cliente     as 'Cliente',
  drp.vl_credito_pendente   as 'CreditoPendente',
  d.cd_identificacao        as 'Documento',
  d.dt_emissao_documento    as 'Emissão',
  d.dt_vencimento_documento as 'Vencimento',
  d.vl_documento_receber    as 'Valor',
  d.vl_saldo_documento      as 'Saldo'
from
  Cliente c,Documento_Receber d, Documento_receber_pagamento drp
where
  c.cd_cliente = d.cd_cliente and
  d.cd_documento_receber = drp.cd_documento_receber and
  drp.vl_credito_pendente > 0

