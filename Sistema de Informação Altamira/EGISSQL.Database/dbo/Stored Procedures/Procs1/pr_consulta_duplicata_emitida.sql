

CREATE PROCEDURE pr_consulta_duplicata_emitida
  @dt_inicial datetime,
  @dt_final   datetime
AS

select     
  dr.dt_impressao_documento,
  dr.cd_identificacao, 
  dr.dt_emissao_documento, 
  dr.dt_vencimento_documento, 
  dr.vl_documento_receber, 
  vd.nm_fantasia

from         
  documento_receber dr

  left outer join vw_destinatario vd
  on   dr.cd_tipo_destinatario = vd.cd_tipo_destinatario and
       dr.cd_cliente = vd.cd_destinatario

where     
  (dr.dt_impressao_documento between @dt_inicial and @dt_final) and 
  (dr.dt_impressao_documento is not null) and 
  (dr.dt_cancelamento_documento is null)  and
  (dr.ic_emissao_documento is not null)

order by
  dr.dt_impressao_documento desc

