
-------------------------------------------------------------------------------
--sp_helptext pr_consulta_cond_pagamento_pedido_compra
-------------------------------------------------------------------------------
--pr_consulta_cond_pagamento_pedido_compra
-------------------------------------------------------------------------------
--GBS Global Business Solution Ltda                                        2007	
-------------------------------------------------------------------------------
--Stored Procedure : Microsoft SQL Server 2000
--Autor(es)        : Carlos Cardoso Fernandes
--Banco de Dados   : Egissql
--Objetivo         : 
--Data             : 28.05.2007
--Alteração        : Consulta de Pedidos por Condição de Pagamento
------------------------------------------------------------------------------
create procedure pr_consulta_cond_pagamento_pedido_compra
@ic_parametro          int      = 0,
@cd_condicao_pagamento int      = 0,
@dt_inicial            datetime = '',
@dt_final              datetime = ''

as

  --select * from condicao_pagamento
  --select * from pedido_venda


------------------------------------------------------------------------------
--Resumo
------------------------------------------------------------------------------
--select * from pedido_compra

if @ic_parametro= 1
begin

   select
     cp.nm_condicao_pagamento                 as CondicaoPagamento,
     max(cp.sg_condicao_pagamento)            as Sigla,
     count(pc.cd_comprador)                   as Comprador,
     count(pc.cd_pedido_compra)               as Pedido,
     count(pc.cd_fornecedor)                  as Fornecedor,
     sum(isnull(pc.vl_total_pedido_compra,0)) as Total
   into
     #ResumoCP
   from
     condicao_pagamento cp 
     left outer join pedido_compra pc with (nolock) on pc.cd_condicao_pagamento = cp.cd_condicao_pagamento
   where
     pc.dt_pedido_compra between @dt_inicial and @dt_final and
     pc.cd_condicao_pagamento = case when @cd_condicao_pagamento = 0 then pc.cd_condicao_pagamento else @cd_condicao_pagamento end and
     pc.dt_cancel_ped_compra is null
   group by
     cp.nm_condicao_pagamento 
   order by
     cp.nm_condicao_pagamento

   declare @vl_total decimal(25,2)

   select
     @vl_total = sum( Total )
   from
     #ResumoCP

   select 
     *,
     Perc = (Total/@vl_total)*100
   from
     #ResumoCP
   order by
     CondicaoPagamento

end

------------------------------------------------------------------------------
--Analítico
------------------------------------------------------------------------------

if @ic_parametro = 2
begin

   --select * from pedido_compra_item

   select 
     cp.nm_condicao_pagamento       as CondicaoPagamento,
     c.nm_fantasia_comprador        as Comprador,
     f.nm_fantasia_fornecedor       as Fornecedor,
     pc.cd_pedido_compra            as Pedido,
     pc.dt_pedido_compra            as Emissao,
     pci.cd_item_pedido_compra      as Item,
     pci.qt_item_pedido_compra      as Qtd,
     pci.vl_item_unitario_ped_comp  as Unitario,
     pci.qt_item_pedido_compra *
     pci.vl_item_unitario_ped_comp  as Total,
     pci.nm_produto                 as Descricao

   from
     condicao_pagamento cp 
     left outer join pedido_compra pc       with (nolock) on pc.cd_condicao_pagamento = cp.cd_condicao_pagamento
     left outer join fornecedor      f      with (nolock) on f.cd_fornecedor          = pc.cd_fornecedor
     left outer join comprador     c        with (nolock) on c.cd_comprador           = pc.cd_comprador
     left outer join pedido_compra_item pci with (nolock) on pci.cd_pedido_compra     = pc.cd_pedido_compra
     
   where
     pc.dt_pedido_compra between @dt_inicial and @dt_final and
     pc.cd_condicao_pagamento = case when @cd_condicao_pagamento = 0 then pc.cd_condicao_pagamento else @cd_condicao_pagamento end and
     pc.dt_cancel_ped_compra is null
 

end

