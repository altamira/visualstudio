
CREATE PROCEDURE pr_documento_receber_pago_portador
@ic_parametro int,
@cd_portador  int,
@dt_inicial   datetime,
@dt_final     datetime 

AS

  select
    d.cd_identificacao		as 'Documento',
    d.dt_emissao_documento	as 'Emissao',
    d.dt_vencimento_documento	as 'Vencimento',

    case when d.dt_devolucao_documento is not null then
      d.dt_devolucao_documento
    else
      dp.dt_pagamento_documento end as 'Pagamento',

    case when d.dt_devolucao_documento is not null then
      d.vl_documento_receber
    else
    		dp.vl_pagamento_documento 
--                     - isnull(dp.vl_juros_pagamento,0)
--                     - isnull(dp.vl_despesa_bancaria,0) 
--                     - isnull(dp.vl_credito_pendente,0)
--                     - isnull(dp.vl_reembolso_documento,0)
--                     + isnull(dp.vl_desconto_documento,0) 
--                     + isnull(dp.vl_abatimento_documento,0)

--     cast(str(isnull(dp.vl_pagamento_documento, 0),25,2) as decimal(25,2))
--         - cast(str(isnull(dp.vl_juros_pagamento, 0),25,2) as decimal(25,2))
--         - cast(str(isnull(dp.vl_despesa_bancaria, 0),25,2) as decimal(25,2))
--         - cast(str(isnull(dp.vl_reembolso_documento, 0),25,2) as decimal(25,2))
--         - cast(str(isnull(dp.vl_credito_pendente, 0),25,2) as decimal(25,2))
--         + cast(str(isnull(dp.vl_desconto_documento, 0),25,2) as decimal(25,2))
--         + cast(str(isnull(dp.vl_abatimento_documento, 0),25,2) as decimal(25,2))

    end as 'Valor',


    c.nm_fantasia_cliente	          as 'Fantasia',
    v.nm_fantasia_vendedor                as 'Vendedor',
    p.nm_portador                         as 'Portador',
    isnull(dp.vl_juros_pagamento ,0)      as Juros,
    isnull(dp.vl_desconto_documento, 0)   as Desconto,
    isnull(dp.vl_abatimento_documento, 0) as Abatimento,
    isnull(dp.vl_despesa_bancaria, 0)     as DespesaBancaria,
    d.vl_documento_receber                as ValorPrincipal,
    cg.nm_cliente_grupo                   as GrupoCliente,
    tl.nm_tipo_liquidacao,
    tc.nm_tipo_caixa,
    vwc.conta    

--select * from documento_receber_pagamento

  from
    Documento_Receber d                          with (nolock)

  left outer join Documento_Receber_Pagamento dp on dp.cd_documento_receber=d.cd_documento_receber
  left outer join Cliente c                      on d.cd_cliente = c.cd_cliente
  left outer join Vendedor v                     on v.cd_vendedor=d.cd_vendedor
  left outer join Portador p                     on p.cd_portador=d.cd_portador
  left outer join Cliente_Grupo cg               on cg.cd_cliente_grupo = c.cd_cliente_grupo
  left outer join Tipo_Liquidacao tl             on tl.cd_tipo_liquidacao = dp.cd_tipo_liquidacao
  left outer join Tipo_Caixa      tc             on tc.cd_tipo_caixa      = dp.cd_tipo_caixa
  left outer join vw_conta_corrente vwc          on vwc.cd_conta_banco    = dp.cd_conta_banco

  where
    dp.dt_pagamento_documento  between @dt_inicial and @dt_final     and	  
    ( IsNull(d.dt_cancelamento_documento,@dt_final + 1) > @dt_final ) and
    ( IsNull(d.dt_devolucao_documento,@dt_final + 1) > @dt_final )    and
    ((d.cd_portador = @cd_portador) or (@cd_portador=0))
  order by
    d.dt_vencimento_documento,
    d.cd_identificacao

