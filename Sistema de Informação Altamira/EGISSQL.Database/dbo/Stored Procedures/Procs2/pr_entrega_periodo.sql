
create procedure pr_entrega_periodo
---------------------------------------------------
--GBS Global Business Solution Ltda            2002
------------------------------------------------------------------------------------------------------
--Stored Procedure: Microsoft SQL Server       2000
--Autor(es): Elias P. Silva
--Banco de Dados: EgisSql
--Objetivo: Listar as Entregas p/ Período
--Data: 08/04/2002
--Atualizado: Igor Gama - 22/07/2002
--          : Daniel C. neto - 13/08/20002 - Pegar nome fantasia do vendedor.
--          : Daniel C. Neto - 05/05/2003 - Pegar nm_fantasia_destinatario no campo Destinatario.
-- 12.10.2010 - Número da Nota Fiscal / Identificação - Carlos Fernandes
------------------------------------------------------------------------------------------------------

-- @cd_nota_saida int,
@dt_inicial    datetime,
@dt_final      datetime
as

  select
    n.dt_saida_nota_saida        as 'Saida',
--    n.cd_nota_saida             as 'NF',
    case when isnull(n.cd_identificacao_nota_saida,0)<>0 then
      n.cd_identificacao_nota_saida
    else
        n.cd_nota_saida                              
    end                           as 'NF',

    n.dt_nota_saida               as 'Emissao',
--    n.nm_fantasia_nota_saida    as 'Destinatario',
    n.nm_fantasia_destinatario    as 'Destinatario',
		td.nm_tipo_destinatario     as 'TipoDestinatario',
    v.nm_fantasia_vendedor      as 'FantasiaVendedor',
		v.nm_vendedor								as 'Vendedor',
    n.vl_frete                  as 'Frete',
    n.vl_total                  as 'Valor',
    t.nm_transportadora         as 'Transportadora',
    n.ic_entrega_nota_saida     as 'Entregue',
    n.dt_entrega_nota_saida     as 'DataEntrega',
    e.nm_entregador             as 'Entregador',
    n.nm_obs_entrega_nota_saida as 'Observacao'

  from
    Nota_Saida n
  left outer join
    Vendedor v
  on
    n.cd_vendedor = v.cd_vendedor
  left outer join
    transportadora t
  on
    n.cd_transportadora = t.cd_transportadora
  left outer join
    Entregador e
  on
    n.cd_entregador = e.cd_entregador
  left outer join
    Tipo_Destinatario td
      on n.cd_tipo_destinatario = td.cd_tipo_destinatario
  where
    n.dt_saida_nota_saida between @dt_inicial and @dt_final and
--     ((n.cd_nota_saida = @cd_nota_saida) or (@cd_nota_saida = 0)) and
    n.dt_nota_dev_nota_saida is null and
    n.dt_cancel_nota_saida is null
  order by
    n.dt_saida_nota_saida desc
