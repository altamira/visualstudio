

/****** Object:  Stored Procedure dbo.pr_consulta_documento_receber_cancelamento    Script Date: 13/12/2002 15:08:19 ******/

CREATE PROCEDURE pr_consulta_documento_receber_cancelamento
@dt_inicial datetime,
@dt_final   datetime

AS

select
    d.cd_identificacao          as 'Documento',
    d.dt_emissao_documento      as 'Emissao',
    d.dt_cancelamento_documento as 'Cancelamento',
    cast(str(d.vl_saldo_documento,25,2) as decimal(25,2)) as 'Saldo',
    cast(str(d.vl_documento_receber,25,2) as decimal(25,2)) as 'Valor',
    c.cd_cliente              as 'Codigo',
    c.nm_fantasia_cliente     as 'Fantasia'
  from
    documento_receber d,
    cliente c
  where
    d.dt_cancelamento_documento between @dt_inicial and @dt_final and
    d.cd_cliente = c.cd_cliente        and
    d.dt_cancelamento_documento is not null
  order by
    Documento
     
  --Write your procedures's statement here




