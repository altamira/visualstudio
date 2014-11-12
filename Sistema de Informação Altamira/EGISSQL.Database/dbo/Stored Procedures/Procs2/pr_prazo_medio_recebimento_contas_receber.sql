
create procedure pr_prazo_medio_recebimento_contas_receber
@dt_inicial datetime,
@dt_final   datetime
as

--Total de Vendas

declare @vl_total_venda float

set @vl_total_venda = 0

select  
  @vl_total_venda = sum( qt_item_pedido_venda * vl_unitario_item_pedido )
from 
  vw_venda_bi
where 
  dt_pedido_venda between @dt_inicial and @dt_final


--Total de Contas a Receber
declare @vl_total_receber float
set @vl_total_receber = 0 
select 
  @vl_total_receber = sum(vl_saldo_documento) 

from documento_receber
where 
 dt_vencimento_documento between @dt_inicial and @dt_final and
 dt_cancelamento_documento is null and
 dt_devolucao_documento is null


--Resultado
declare @vl_pmr float
set @vl_pmr = 0

select
  31 / ( @vl_total_venda / @vl_total_receber ) as 'PrazoMedioRecebimento'


