
CREATE PROCEDURE pr_documento_receber_cancelado

@dt_inicial datetime,
@dt_final datetime,
@cd_tipo_documento int

AS

  if (isnull(@cd_tipo_documento, 0) = 0)
    select
      d.cd_identificacao 		as 'Documento',
      d.cd_cliente		as 'CodCliente',
      c.nm_fantasia_cliente	as 'NomeCliente',
      d.dt_emissao_documento	as 'Emissao',
      d.dt_vencimento_documento	as 'Vencimento',
      d.vl_documento_receber	as 'Valor',
      d.nm_cancelamento_documento	as 'Historico',
      d.dt_cancelamento_documento as 'Cancelamento'
    from
      Documento_Receber d left outer join Cliente c
    on
      d.cd_cliente = c.cd_cliente
    where
      d.dt_cancelamento_documento between @dt_inicial and @dt_final
    order by
      d.dt_cancelamento_documento
  else
    select
      d.cd_identificacao 	as 'Documento',
      d.cd_cliente		as 'CodCliente',
      c.nm_fantasia_cliente	as 'NomeCliente',
      d.dt_emissao_documento	as 'Emissao',
      d.dt_vencimento_documento	as 'Vencimento',
      d.vl_documento_receber	as 'Valor',
      d.nm_cancelamento_documento	as 'Historico',
      d.dt_cancelamento_documento as 'Cancelamento'
    from
      Documento_Receber d left outer join Cliente c
    on
      d.cd_cliente = c.cd_cliente
    where
      d.cd_tipo_documento = @cd_tipo_documento
      and d.dt_cancelamento_documento between @dt_inicial and @dt_final
    order by
      d.dt_cancelamento_documento

