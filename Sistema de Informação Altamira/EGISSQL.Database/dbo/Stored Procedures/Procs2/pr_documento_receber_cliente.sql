

/****** Object:  Stored Procedure dbo.pr_documento_receber_cliente    Script Date: 13/12/2002 15:08:27 ******/

CREATE PROCEDURE pr_documento_receber_cliente
@cd_cliente int,
@dt_inicial datetime,
@dt_final   datetime

AS

  select
    d.cd_identificacao           as 'Documento',
    t.nm_tipo_documento          as 'Tipo',
    d.dt_emissao_documento       as 'Emissao',
    d.dt_vencimento_documento    as 'Vencimento',
    d.vl_documento_receber       as 'Valor',
    d.dt_cancelamento_documento  as 'Cancelamento',
    (select 
       max(r.dt_pagamento_documento) 
     from 
       documento_receber_pagamento r 
     where 
       r.cd_documento_receber = d.cd_documento_receber) as 'Pagamento',
    p.nm_portador                as 'Portador',
    c.nm_tipo_cobranca           as 'Cobranca'
  from
    documento_receber d,
    tipo_documento t,
    tipo_cobranca c,
    portador p
  where
    d.cd_tipo_documento = t.cd_tipo_documento and
    d.cd_portador       = p.cd_portador       and
    d.cd_tipo_cobranca  = c.cd_tipo_cobranca  and
    d.cd_cliente        = @cd_cliente         and
    d.dt_emissao_documento between @dt_inicial and @dt_final
  compute sum(d.vl_documento_receber), count(cd_identificacao)
               
--sp_help documento_receber_pagamento       
--sp_help documento_receber
--sp_help tipo_documento

  --Write your procedures's statement here


