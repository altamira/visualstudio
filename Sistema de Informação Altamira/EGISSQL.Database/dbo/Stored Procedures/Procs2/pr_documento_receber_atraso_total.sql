
CREATE PROCEDURE pr_documento_receber_atraso_total
@dt_base datetime


AS

declare @dt_inicial datetime

  select
    @dt_inicial = min(dt_emissao_documento)
  from
    documento_receber
  where
    cast(str(vl_saldo_documento,25,2) as decimal(25,2)) > 0
  

  select
    isnull(c.nm_fantasia_cliente,'')     as 'Cliente',
    d.cd_identificacao                   as 'Documento',
    d.dt_emissao_documento               as 'Emissao',
    d.dt_vencimento_documento            as 'Vencimento',
    cast(str(d.vl_saldo_documento,25,2) 
                       as decimal(25,2)) as 'Saldo',
    d.vl_documento_receber               as 'Valor',
    v.nm_fantasia_vendedor               as 'Vendedor',
    p.nm_portador                        as 'Portador',
    cg.nm_cliente_grupo                  as 'GrupoCliente',
    vwc.conta
  from 
    Documento_Receber d with (nolock) 
  left outer join cliente c on   c.cd_cliente = d.cd_cliente                                     
  left outer join Vendedor v on v.cd_vendedor=d.cd_vendedor
  left outer join Portador p on p.cd_portador=d.cd_portador
  left outer join Cliente cl on cl.cd_cliente = d.cd_cliente
  left outer join Cliente_Grupo cg on cg.cd_cliente_grupo = cl.cd_cliente_grupo 
  left outer join vw_conta_corrente vwc           with (nolock) on vwc.cd_conta_banco       = d.cd_conta_banco_remessa
  
  where
    cast(str(d.vl_saldo_documento,25,2) as decimal(25,2)) > 0       and
    d.dt_cancelamento_documento is null                             and
    --d.dt_vencimento_documento < @dt_base                            and
    d.dt_vencimento_documento between @dt_inicial and (@dt_base -1) and
    d.dt_devolucao_documento is null

order by
   Emissao,
   Cliente


   
