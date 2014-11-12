
CREATE PROCEDURE pr_documento_receber_aberto_grupo_cliente
@cd_grupo_cliente   int = 0,
@dt_inicial    datetime = '',
@dt_final      datetime = '' 
AS

--select * from plano_financeiro

    select
      dr.cd_identificacao		as 'Documento',
      td.sg_tipo_documento      	as 'Tipo',
      dr.dt_emissao_documento   	as 'Emissao',
      dr.dt_vencimento_documento	as 'Vencimento',
      cast(round(dr.vl_documento_receber,2) as decimal(25,2)) as 'Valor',
      cast(round(dr.vl_saldo_documento,2)   as decimal(25,2)) as 'Saldo',
      por.sg_portador		   	as 'Portador',
      ven.nm_fantasia_vendedor     	as 'Vendedor',
      cob.sg_tipo_cobranca	   	as 'Cobranca',
      dr.ic_emissao_documento	   	as 'Emitido',
      cg.nm_cliente_grupo               as 'GrupoCliente',
      cl.nm_fantasia_cliente            as 'Cliente',
      pf.cd_mascara_plano_financeiro,
      pf.nm_conta_plano_financeiro,
      vwc.conta
    from
      Documento_Receber dr with (nolock) 
      left outer join Portador por        with (nolock) on por.cd_portador        = dr.cd_portador
      left outer join Tipo_Documento td   with (nolock) on td.cd_tipo_documento   = dr.cd_tipo_documento
      left outer join Tipo_Cobranca cob   with (nolock) on dr.cd_tipo_cobranca    = cob.cd_tipo_cobranca
      left outer join Vendedor ven        with (nolock) on dr.cd_vendedor         = ven.cd_vendedor
      left outer join Cliente cl          with (nolock) on dr.cd_cliente          = cl.cd_cliente
      left outer join Cliente_Grupo cg    with (nolock) on cl.cd_cliente_grupo    = cg.cd_cliente_grupo
      left outer join Plano_Financeiro pf with (nolock) on pf.cd_plano_financeiro = dr.cd_plano_financeiro
      left outer join vw_conta_corrente vwc           with (nolock) on vwc.cd_conta_banco       = dr.cd_conta_banco_remessa

    WHERE     
     cl.cd_cliente_grupo = case when @cd_grupo_cliente = 0 then cl.cd_cliente_grupo else @cd_grupo_cliente end and
     dr.dt_vencimento_documento between @dt_inicial and @dt_final and
     cast(round(dr.vl_saldo_documento,2) as decimal(25,2)) > 0 and
     dr.dt_cancelamento_documento is null and
     dr.dt_devolucao_documento    is null
    ORDER BY
      cg.nm_cliente_grupo,
      dr.dt_vencimento_documento,
      dr.cd_identificacao

