
create procedure pr_consulta_documento_receber_devolvido
@dt_inicial datetime,
@dt_final   datetime

AS
select
    d.cd_identificacao          as 'Documento',
    d.dt_emissao_documento      as 'Emissao',
    d.dt_devolucao_documento    as 'Devolucao',
    ns.dt_nota_dev_nota_saida   as 'DevolucaoNF',
    cast(str(d.vl_saldo_documento,25,2)   as decimal(25,2)) as 'Saldo',
    cast(str(d.vl_documento_receber,25,2) as decimal(25,2)) as 'Valor',
    c.nm_fantasia_cliente       as 'Fantasia',
    d.nm_devolucao_documento    as 'Motivo_Devolucao',
    v.nm_fantasia_vendedor      as 'Vendedor',
    cg.nm_cliente_grupo         as 'GrupoCliente'
  from
    documento_receber d
  left outer join Cliente c on
    c.cd_cliente=d.cd_cliente
  left outer join Vendedor v on
    v.cd_vendedor=d.cd_vendedor
  left outer join Nota_Saida ns on
    ns.cd_nota_saida=d.cd_nota_saida
  left outer join Cliente_Grupo cg on cg.cd_cliente_grupo = c.cd_cliente_grupo
  where
    d.dt_devolucao_documento between @dt_inicial and @dt_final and
    d.dt_cancelamento_documento is null and
    (select max(dp.dt_pagamento_documento) from documento_receber_pagamento dp 
     where dp.cd_documento_receber = d.cd_documento_receber) is null
  order by
    d.dt_devolucao_documento,
    d.cd_identificacao
--------------------------------------------------------------------
--Testando a Stored Procedure
--------------------------------------------------------------------
--exec pr_consulta_documento_receber_devolvido
     




