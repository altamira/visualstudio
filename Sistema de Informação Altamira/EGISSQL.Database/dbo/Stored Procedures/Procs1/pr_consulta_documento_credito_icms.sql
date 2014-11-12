
CREATE PROCEDURE pr_consulta_documento_credito_icms
@cd_documento_receber varchar(10),
@dt_inicial           dateTime,
@dt_final             dateTime

AS

select 
  d.cd_documento_receber,
  d.cd_identificacao,
  td.nm_tipo_destinatario,
  vw.nm_fantasia as nm_fantasia_cliente,
  d.dt_emissao_documento,
  d.dt_vencimento_documento,
  d.vl_documento_receber,
  max(p.dt_pagamento_documento) as dt_pagamento_documento,
  sum(p.vl_pagamento_documento) as vl_pagamento_documento
from
  Documento_Receber d
  left outer join Documento_Receber_Pagamento p on
    d.cd_documento_receber = p.cd_documento_receber
  left outer join vw_Destinatario vw on
    d.cd_cliente=vw.cd_destinatario and d.cd_tipo_destinatario=vw.cd_tipo_destinatario
  left outer join Tipo_Destinatario td on
    td.cd_tipo_destinatario= d.cd_tipo_destinatario
where
  (d.cd_identificacao=@cd_documento_receber or @cd_documento_receber=0) and
  d.dt_emissao_documento between @dt_inicial and @dt_final and
  isnull(d.ic_credito_icms_documento,'N')='S'
group by 
  d.cd_documento_receber, d.cd_identificacao, td.nm_tipo_destinatario, 
  vw.nm_fantasia, d.dt_emissao_documento, d.dt_vencimento_documento, d.vl_documento_receber
