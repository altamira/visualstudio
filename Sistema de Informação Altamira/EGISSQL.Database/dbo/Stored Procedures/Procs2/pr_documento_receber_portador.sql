
CREATE PROCEDURE pr_documento_receber_portador
@cd_portador int,
@dt_inicial datetime,
@dt_final datetime
AS


if (isnull(@cd_portador, 0) = 0)
  select
    d.cd_identificacao as 'Duplicata',
    c.nm_fantasia_cliente as 'Cliente',
    d.dt_emissao_documento as 'Emissao',
    d.dt_vencimento_documento as 'Vencimento',
    isnull(d.vl_documento_receber,0) as 'Valor',
    isnull(d.vl_saldo_documento-d.vl_abatimento_documento,0) as 'Saldo',
    isnull(d.vl_abatimento_documento,0) as 'Abatimento',
    cast(d.dt_vencimento_documento - cast(cast(getDate() as float) as int) as int) as 'Dias',
    p.cd_portador,
    p.nm_portador as 'Portador'
  from
    Documento_Receber d
  left outer join
    Cliente c
  on
    d.cd_cliente = c.cd_cliente
  left outer join
    Portador p
  on
    d.cd_portador = p.cd_portador
  where
    d.dt_vencimento_documento between @dt_inicial and @dt_final
    and cast(str(d.vl_saldo_documento,25,2) as decimal(25,2)) > 0.00
  order by
    p.cd_portador,
    d.dt_vencimento_documento,
    d.cd_identificacao
else
  select
    d.cd_identificacao as 'Duplicata',
    c.nm_fantasia_cliente as 'Cliente',
    d.dt_emissao_documento as 'Emissao',
    d.dt_vencimento_documento as 'Vencimento',
    isnull(d.vl_documento_receber,0) as 'Valor',
    isnull(d.vl_saldo_documento-d.vl_abatimento_documento,0) as 'Saldo',
    isnull(d.vl_abatimento_documento,0) as 'Abatimento',
    cast(d.dt_vencimento_documento - cast(cast(getDate() as float) as int) as int) as 'Dias',
    p.cd_portador,
    p.nm_portador as 'Portador'

  from
    Documento_Receber d
  left outer join
    Cliente c
  on
    d.cd_cliente = c.cd_cliente
  left outer join
    Portador p
  on
    d.cd_portador = p.cd_portador
  where
    d.cd_portador = @cd_portador
    and d.dt_vencimento_documento between @dt_inicial and @dt_final
    and cast(str(d.vl_saldo_documento,25,2) as decimal(25,2)) > 0.00
  order by
    p.nm_portador,
    d.dt_vencimento_documento,
    d.cd_identificacao    

