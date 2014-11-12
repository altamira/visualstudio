
CREATE PROCEDURE pr_consulta_documento_envio_remessa_banco

  @dt_inicial datetime,
  @dt_final   datetime

as
  select
    c.nm_fantasia_cliente,
    d.cd_identificacao,
    d.dt_emissao_documento,
    d.dt_vencimento_documento,
    d.vl_documento_receber,
    d.cd_portador,
    p.nm_portador
  from
    Documento_Receber d with (nolock)
    inner join Cliente c with (nolock, index(pk_cliente))
      on c.cd_cliente = d.cd_cliente
    inner join Portador p with (nolock)
      on p.cd_portador = d.cd_portador
  where
   dt_envio_banco_documento between @dt_inicial and @dt_final
