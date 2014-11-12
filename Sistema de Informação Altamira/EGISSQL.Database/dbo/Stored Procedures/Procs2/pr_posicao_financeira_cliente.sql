
CREATE PROCEDURE pr_posicao_financeira_cliente
  @cd_cliente Integer,
  @dt_inicial DateTime,
  @dt_final   DateTime

AS

--select * from documento_receber_pagamento

select 
  d.dt_emissao_documento,
  d.dt_vencimento_documento,
  d.cd_identificacao,
  d.cd_banco_documento_recebe as 'numero_bancario',
  d.vl_documento_receber,
  cast(str(d.vl_saldo_documento,25,2) as decimal(25,2)) as 'vl_saldo_documento',
  d.dt_cancelamento_documento,
  d.dt_devolucao_documento,
    d.cd_pedido_venda,
  p.dt_pagamento_documento,
  p.vl_pagamento_documento,
  (select nm_fantasia_vendedor from vendedor v
     where v.cd_vendedor=pv.cd_vendedor_interno) as vendedor_interno,
  (select nm_fantasia_vendedor from vendedor v
     where v.cd_vendedor=d.cd_vendedor) as vendedor_externo,
  pt.nm_portador as 'Portador',
  p.vl_juros_pagamento,
  p.vl_desconto_documento,
  p.vl_abatimento_documento,
  p.vl_despesa_bancaria,
  p.vl_reembolso_documento,
  p.vl_credito_pendente

from
  Documento_Receber d with (nolock) 
  left outer join Documento_Receber_Pagamento p with (nolock) on d.cd_documento_receber = p.cd_documento_receber
  left outer join Pedido_Venda pv with (nolock)               on pv.cd_pedido_venda=d.cd_pedido_venda
  left outer join Portador pt with (nolock)                   on pt.cd_portador=d.cd_portador
where
  d.cd_cliente = @cd_cliente and
  d.dt_emissao_documento between @dt_inicial and @dt_final


