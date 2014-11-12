
CREATE PROCEDURE pr_documento_receber_tipo_liquidacao
@ic_parametro       int = 0,
@cd_tipo_liquidacao int = 0,
@dt_inicial         datetime,
@dt_final           datetime 

as

--select cd_tipo_liquidacao from documento_receber

  select
    t.nm_tipo_liquidacao        as 'TipoLiquidacao',
    d.cd_identificacao		as 'Documento',
    d.dt_emissao_documento	as 'Emissao',
    d.dt_vencimento_documento	as 'Vencimento',
    d.dt_pagto_document_receber as 'Pagamento',
    d.dt_cancelamento_documento as 'Cancelamento',
    d.dt_devolucao_documento    as 'Devolucao',
    d.vl_documento_receber	as 'Valor',
    d.vl_saldo_documento	as 'Saldo',
    p.sg_portador		as 'Portador',
    p.nm_portador		as 'NomePortador',
    c.nm_fantasia_cliente	as 'Cliente',
    cg.nm_cliente_grupo         as 'GrupoCliente',
    vwc.conta    


  from
    Documento_Receber d with (nolock) 
  left outer join
    Portador p
  on
    d.cd_portador = p.cd_portador
  left outer join
    Cliente c
  on
    d.cd_cliente = c.cd_cliente
  left outer join
    Tipo_Liquidacao t
  on
    d.cd_tipo_liquidacao = t.cd_tipo_liquidacao
  left outer join Cliente_Grupo cg on cg.cd_cliente_grupo = c.cd_cliente_grupo
  left outer join vw_conta_corrente vwc          with (nolock) on vwc.cd_conta_banco    = d.cd_conta_banco_remessa

  where
    d.cd_tipo_liquidacao = case when @cd_tipo_liquidacao = 0 then d.cd_tipo_liquidacao else @cd_tipo_liquidacao end and
    d.dt_emissao_documento between @dt_inicial and @dt_final 
  order by
    d.dt_vencimento_documento

