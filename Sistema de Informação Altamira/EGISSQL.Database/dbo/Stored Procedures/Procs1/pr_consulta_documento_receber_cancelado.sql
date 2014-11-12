
create procedure pr_consulta_documento_receber_cancelado
@dt_inicial datetime,
@dt_final   datetime

AS

select
    d.cd_identificacao          as 'Documento',
    d.dt_emissao_documento      as 'Emissao',
    d.dt_cancelamento_documento as 'Cancelamento',
    cast(str(d.vl_saldo_documento,25,2) as decimal(25,2)) as 'Saldo',
    cast(str(d.vl_documento_receber,25,2) as decimal(25,2)) as 'Valor',
    c.nm_fantasia_cliente       as 'Fantasia',
    ns.nm_mot_cancel_nota_saida as 'Motivo_Cancelamento',
    v.nm_fantasia_vendedor      as 'Vendedor',
    p.nm_portador               as 'Portador',
    cg.nm_cliente_grupo         as 'GrupoCliente',
    d.cd_banco_documento_recebe
  from
    documento_receber d            with (nolock) 
  left outer join Cliente c        with (nolock) on    c.cd_cliente=d.cd_cliente
  left outer join Nota_Saida ns    with (nolock) on    ns.cd_nota_saida=d.cd_nota_saida
  left outer join Vendedor v       with (nolock) on    v.cd_vendedor=ns.cd_vendedor
  left outer join Portador p       with (nolock) on    p.cd_portador = d.cd_portador
  left outer join Cliente_Grupo cg with (nolock) on    cg.cd_cliente_grupo = c.cd_cliente_grupo
  where
    d.dt_cancelamento_documento between @dt_inicial and @dt_final and
    d.dt_cancelamento_documento is not null
  order by
    d.dt_cancelamento_documento,
    d.cd_identificacao
     
--select * from documento_receber


