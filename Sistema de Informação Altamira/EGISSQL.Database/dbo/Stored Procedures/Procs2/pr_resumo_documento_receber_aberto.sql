
CREATE PROCEDURE pr_resumo_documento_receber_aberto
@dt_inicial datetime,
@dt_final   datetime

AS

  declare @vl_total float
  set     @vl_total = 0

  select
    dt_emissao_documento       as 'Data',
    count(cd_identificacao)    as 'Duplicatas',
    sum(vl_saldo_documento)    as 'ValorTotal',
    count(distinct cd_cliente) as 'Clientes'
  into
    #documento_receber
  from
    documento_receber
  where
    cast(str(vl_saldo_documento,25,2) as decimal(25,2)) > 0 and
    dt_emissao_documento between @dt_inicial and @dt_final and
    dt_cancelamento_documento is null and 
    dt_devolucao_documento    is null
--   cd_portador = 999
  group by
    dt_emissao_documento
  order by
    dt_emissao_documento

  select
    @vl_total = sum(ValorTotal)
  from
    #documento_receber

  select
    Data,
    Duplicatas,
    ValorTotal,
    (ValorTotal / @vl_total) * 100 as 'Perc',
    Clientes
  from
    #documento_receber
    
