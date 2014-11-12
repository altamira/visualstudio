
CREATE PROCEDURE pr_documento_receber_aberto_vencimento
@ic_parametro int,
@dt_inicial   datetime,
@dt_final     datetime 

AS

  select
    d.cd_documento_receber,
    d.cd_identificacao		as 'Documento',
    d.dt_emissao_documento	as 'Emissao',
    d.dt_vencimento_documento	as 'Vencimento',
    d.vl_documento_receber      as 'Valor',
    d.vl_saldo_documento	as 'Saldo',
    c.nm_fantasia_cliente	as 'Fantasia',
    v.nm_fantasia_vendedor      as 'Vendedor',
    p.nm_portador               as 'Portador',
    tm.nm_tipo_mercado          as 'TipoMercado',
    cg.nm_cliente_grupo         as 'Cliente_grupo',

    cast(( select top 1
        cast(dh.ds_historico_documento as varchar(150))
      from
        documento_receber_historico dh
      where
        dh.cd_documento_receber = d.cd_documento_receber
      order by
        dt_historico_documento desc )  as varchar(150)) as 'nm_historico_documento',

    vwc.conta

--      isnull(ci.ic_credito_suspenso,'N')    as 'ic_credito_suspenso',
--      ci.nm_credito_suspenso                
--select * from documento_receber

    --select * from documento_receber_historico

  from
    Documento_Receber d                           with (nolock) 
    left outer join Cliente c                     with (nolock) on d.cd_cliente         = c.cd_cliente
    left outer join Nota_Saida n                  with (nolock) on n.cd_nota_saida      = d.cd_nota_saida
    left outer join Vendedor v                    with (nolock) on v.cd_vendedor        = d.cd_vendedor
    left outer join Portador p                    with (nolock) on p.cd_portador        = d.cd_portador
    left outer join Tipo_Mercado tm               with (nolock) on c.cd_tipo_mercado    = tm.cd_tipo_mercado
    left outer join Cliente cl                    with (nolock) on cl.cd_cliente        = d.cd_cliente
    left outer join Cliente_Grupo cg              with (nolock) on cg.cd_cliente_grupo  = cl.cd_cliente_grupo
    left outer join Status_Cliente sc             with (nolock) on sc.cd_status_cliente = c.cd_status_cliente
    left outer join vw_conta_corrente vwc         with (nolock) on vwc.cd_conta_banco   = d.cd_conta_banco_remessa

--    left outer join Cliente_Informacao_Credito ci with (nolock) on ci.cd_cliente = c.cd_cliente
--select * from cliente_informacao_credito

  where
    d.dt_cancelamento_documento is null and
    d.dt_devolucao_documento    is null and
    cast(d.vl_saldo_documento as decimal(25,2)) > 0 and
    d.dt_vencimento_documento between @dt_inicial and @dt_final

  order by
    d.dt_vencimento_documento,
    d.cd_identificacao

