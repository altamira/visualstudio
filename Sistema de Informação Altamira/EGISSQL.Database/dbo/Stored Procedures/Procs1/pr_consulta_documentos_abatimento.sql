
CREATE PROCEDURE pr_consulta_documentos_abatimento

@ic_parametro int,
@dt_inicial   datetime,
@dt_final     datetime 

AS

  select
    d.cd_identificacao		as 'Documento',
    d.dt_emissao_documento	as 'Emissao',
    d.dt_vencimento_documento	as 'Vencimento',
    d.vl_documento_receber      as 'Valor',
    d.vl_saldo_documento	as 'Saldo',
    c.nm_fantasia_cliente	as 'Fantasia',
    v.nm_fantasia_vendedor      as 'Vendedor',
    p.nm_portador               as 'Portador',
    tm.nm_tipo_mercado          as 'TipoMercado',
    cg.nm_cliente_grupo         as 'GrupoCliente',
    d.vl_abatimento_documento   as 'Abatimento'
  from
    Documento_Receber d
    left outer join Cliente c        on d.cd_cliente        = c.cd_cliente
    left outer join Nota_Saida n     on n.cd_nota_saida     = d.cd_nota_saida
    left outer join Vendedor v       on v.cd_vendedor       = d.cd_vendedor
    left outer join Portador p       on p.cd_portador       = d.cd_portador
    left outer join Tipo_Mercado tm  on c.cd_tipo_mercado   = tm.cd_tipo_mercado
    left outer join Cliente_Grupo cg on cg.nm_cliente_grupo = c.cd_cliente_grupo
  where
    d.dt_cancelamento_documento is null and
    d.dt_devolucao_documento is null and
    IsNull(d.vl_abatimento_documento,0) > 0 and
    d.dt_emissao_documento between @dt_inicial and @dt_final
  order by
    d.dt_emissao_documento,
    d.cd_identificacao

