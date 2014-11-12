
CREATE PROCEDURE pr_documento_receber_aberto_portador
@ic_parametro int = 0,
@cd_portador  int = 0,
@dt_inicial   datetime,
@dt_final     datetime 

AS

  select
    d.cd_identificacao		as 'Documento',
    d.dt_emissao_documento	as 'Emissao',
    d.dt_vencimento_documento	as 'Vencimento',
    d.vl_documento_receber      as 'Valor',
    (d.vl_saldo_documento-isnull(d.vl_abatimento_documento,0)) as 'Saldo',
    c.nm_fantasia_cliente	as 'Fantasia',
    v.nm_fantasia_vendedor      as 'Vendedor',
    p.nm_portador               as 'Portador',
    d.vl_abatimento_documento   as 'Abatimento',
    (cast(d.dt_vencimento_documento as integer)- cast(getdate() as integer)+1) as 'Dias',
    (select  
       count(distinct dr.cd_cliente)
     from Documento_Receber dr
     where
       dr.dt_cancelamento_documento is null and
       dr.vl_saldo_documento > 0 and
       dr.cd_portador = @cd_portador and
       dr.dt_vencimento_documento between @dt_inicial and @dt_final) as QtdCli,
    cg.nm_cliente_grupo as 'GrupoCliente',
    max(vwc.conta)      as 'Conta'
  from
    Documento_Receber d with (nolock)
    left outer join Cliente c        with (nolock) on d.cd_cliente = c.cd_cliente
    left outer join Nota_Saida n     with (nolock) on n.cd_nota_saida=d.cd_nota_saida
    left outer join Vendedor v       with (nolock) on v.cd_vendedor=d.cd_vendedor
    left outer join Portador p       with (nolock) on p.cd_portador=d.cd_portador
    left outer join Cliente_Grupo cg with (nolock) on cg.cd_cliente_grupo = c.cd_cliente_grupo
    left outer join vw_conta_corrente vwc with (nolock) on vwc.cd_conta_banco = d.cd_conta_banco_remessa

  where
    d.cd_portador = case when @cd_portador = 0 then d.cd_portador else @cd_portador end and
    d.dt_cancelamento_documento is null and
    cast(str(d.vl_saldo_documento,25,2) as decimal(25,2)) > 0 and
    d.dt_vencimento_documento between @dt_inicial and @dt_final and
    d.dt_devolucao_documento is null
  group by
    d.cd_identificacao,
    d.dt_emissao_documento,
    d.dt_vencimento_documento,
    d.vl_documento_receber,
    d.vl_saldo_documento,
    c.nm_fantasia_cliente,
    v.nm_fantasia_vendedor,
    d.vl_abatimento_documento,
    d.cd_cliente,
    p.nm_portador,
    cg.nm_cliente_grupo
  order by
    p.nm_portador,
    d.dt_vencimento_documento,
    cg.nm_cliente_grupo,
    d.cd_identificacao

