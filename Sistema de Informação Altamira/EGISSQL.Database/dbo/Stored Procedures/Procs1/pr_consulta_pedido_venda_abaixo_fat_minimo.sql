
create procedure pr_consulta_pedido_venda_abaixo_fat_minimo
@cd_pedido_venda int,
@dt_inicial      datetime,
@dt_final        datetime
as

--Busca o Faturamento Mínimo

declare @vl_faturamento_minimo float
set @vl_faturamento_minimo = 0

select 
   @vl_faturamento_minimo = vl_fat_minimo_empresa
from
   Parametro_Faturamento
where
   cd_empresa = dbo.fn_empresa()

 
--Seleciona os pedidos de Venda por data de Emissão de Pedido

--Periodo
if @cd_pedido_venda = 0 
begin
  select
   c.nm_fantasia_cliente    as 'Cliente',
   pv.cd_pedido_venda       as 'Pedido',
   pv.dt_pedido_venda       as 'Emissao',
   pv.vl_total_pedido_venda as 'Valor',
   v.nm_fantasia_vendedor   as 'Vendedor',
   nm_condicao_pagamento    as 'CondicaoPagamento' ,
   case when pv.dt_lib_fat_min_pedido is null then 'N'
   else 'S' end as 'Liberado'
from
  Pedido_Venda pv, Cliente c, Vendedor v, Condicao_Pagamento cp
where
  pv.dt_pedido_venda between @dt_inicial and @dt_final and
  pv.dt_cancelamento_pedido is null                    and
  pv.cd_cliente = c.cd_cliente                         and
  pv.cd_vendedor = v.cd_vendedor                       and
  pv.cd_condicao_pagamento = cp.cd_condicao_pagamento  and
  pv.vl_total_pedido_venda < @vl_faturamento_minimo
end
else
--Pedido de Venda
begin
  select
   c.nm_fantasia_cliente    as 'Cliente',
   pv.cd_pedido_venda       as 'Pedido',
   pv.dt_pedido_venda       as 'Emissao',
   pv.vl_total_pedido_venda as 'Valor',
   v.nm_fantasia_vendedor   as 'Vendedor',
   nm_condicao_pagamento    as 'CondicaoPagamento',
   case when pv.dt_lib_fat_min_pedido is null then 'N'
   else 'S' end as 'Liberado'

from
  Pedido_Venda pv, Cliente c, Vendedor v, Condicao_Pagamento cp
where
  pv.cd_pedido_venda = @cd_pedido_venda                and
  pv.dt_cancelamento_pedido is null                    and
  pv.cd_cliente  = c.cd_cliente                        and
  pv.cd_vendedor = v.cd_vendedor                       and
  pv.cd_condicao_pagamento = cp.cd_condicao_pagamento  and
  pv.vl_total_pedido_venda < @vl_faturamento_minimo
end

