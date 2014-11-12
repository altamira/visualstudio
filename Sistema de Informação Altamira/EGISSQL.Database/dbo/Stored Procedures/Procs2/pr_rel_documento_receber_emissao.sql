

/****** Object:  Stored Procedure dbo.pr_rel_documento_receber_emissao    Script Date: 13/12/2002 15:08:40 ******/

CREATE PROCEDURE pr_rel_documento_receber_emissao
--pr_rel_documento_receber_emissao
-------------------------------------------------------------------
--Polimold Industrial S/A                                      2001
--Stored Procedure: Microsoft SQL Server                       2000
--Autor(es): Igor Gama
--Banco de Dados: SapSql
--Objetivo: Relatório de Dupl. por Emissão
--Data: 11/04/2002
--Atualizado: 
-------------------------------------------------------------------
@cd_portador int,
@dt_inicial datetime,
@dt_final datetime
AS


if (isnull(@cd_portador, 0) = 0)
  select
    d.cd_portador             as 'CodPortador',   
    p.nm_portador             as 'Portador',
    d.cd_identificacao        as 'Duplicata',
    c.nm_fantasia_cliente     as 'Cliente',
    d.dt_emissao_documento    as 'Emissao',
    d.dt_vencimento_documento as 'Vencimento',
    d.vl_documento_receber    as 'Valor',
    cast(str(d.vl_saldo_documento,25,2) as decimal(25,2))      as 'Saldo',
    isnull((select sum(x.vl_abatimento_documento)
           from Documento_Receber_Pagamento x
           where x.cd_documento_receber = d.cd_documento_receber), 0) 
                              as 'Abatimento',
    cast(d.dt_vencimento_documento - isnull(d.dt_emissao_documento, getDate()) as int) 
                              as 'Dias'
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
    d.dt_emissao_documento Between @dt_inicial and @dt_final and
    cast(str(d.vl_saldo_documento,25,2) as decimal(25,2)) > 0.00
  order by
    d.cd_portador,
    d.dt_vencimento_documento
else
  select  
    d.cd_portador             as 'CodPortador',   
    p.nm_portador             as 'Portador',
    d.cd_identificacao        as 'Duplicata',
    c.nm_fantasia_cliente     as 'Cliente',
    d.dt_emissao_documento    as 'Emissao',
    d.dt_vencimento_documento as 'Vencimento',
    d.vl_documento_receber    as 'Valor',
    cast(str(d.vl_saldo_documento,25,2) as decimal(25,2))      as 'Saldo',
    isnull((select sum(x.vl_abatimento_documento)
           from Documento_Receber_Pagamento x
           where x.cd_documento_receber = d.cd_documento_receber), 0) 
                              as 'Abatimento',
    cast(d.dt_vencimento_documento - isnull(d.dt_emissao_documento, getDate()) as int) 
                              as 'Dias'
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
    d.dt_emissao_documento Between @dt_inicial and @dt_final and
    d.cd_portador = @cd_portador and
    cast(str(d.vl_saldo_documento,25,2) as decimal(25,2)) > 0.00
  order by    
    d.dt_vencimento_documento



