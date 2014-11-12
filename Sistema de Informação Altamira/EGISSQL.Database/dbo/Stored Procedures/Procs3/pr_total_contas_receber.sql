
create procedure pr_total_contas_receber
@dt_inicial datetime,
@dt_final   datetime
as

select 
  sum(vl_saldo_documento) as 'TotalReceber'

from documento_receber
where 
 dt_vencimento_documento between @dt_inicial and @dt_final and
 dt_cancelamento_documento is null and
 dt_devolucao_documento is null



--Resultado

