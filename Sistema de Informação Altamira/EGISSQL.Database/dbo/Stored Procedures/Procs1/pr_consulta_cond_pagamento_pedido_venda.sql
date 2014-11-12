
-------------------------------------------------------------------------------
--sp_helptext pr_consulta_cond_pagamento_pedido_venda
-------------------------------------------------------------------------------
--pr_consulta_cond_pagamento_pedido_venda
-------------------------------------------------------------------------------
--GBS Global Business Solution Ltda                                        2007	
-------------------------------------------------------------------------------
--Stored Procedure : Microsoft SQL Server 2000
--Autor(es)        : Carlos Cardoso Fernandes
--Banco de Dados   : Egissql
--Objetivo         : 
--Data             : 28.05.2007
--Alteração        : Consulta de Pedidos por Condição de Pagamento
-- 12.05.2009 - Ajuste - Carlos Fernandes
------------------------------------------------------------------------------
create procedure pr_consulta_cond_pagamento_pedido_venda
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

if @ic_parametro= 1
begin

   select
     cp.cd_condicao_pagamento,
     cp.nm_condicao_pagamento                as CondicaoPagamento,
     Vendedor = (COUNT(distinct cd_vendedor) ),
     Cliente  = (COUNT(distinct cd_cliente) ),
     Pedido   = (COUNT(distinct cd_pedido_venda ) ),
     max(cp.sg_condicao_pagamento)           as Sigla,
     sum(isnull(pv.vl_total_pedido_venda,0)) as Total
   into
     #ResumoCP
   from
     condicao_pagamento cp           with (nolock) 
     left outer join pedido_venda pv with (nolock) on pv.cd_condicao_pagamento = cp.cd_condicao_pagamento
   where
     pv.dt_pedido_venda between @dt_inicial and @dt_final and
     isnull(pv.cd_condicao_pagamento,0) = case when isnull(@cd_condicao_pagamento,0) = 0 then isnull(pv.cd_condicao_pagamento,0) else @cd_condicao_pagamento end and
     pv.dt_cancelamento_pedido is null
   group by
     cp.nm_condicao_pagamento, 
     cp.cd_condicao_pagamento
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

   --select * from pedido_venda_item

   select 
     cp.cd_condicao_pagamento,
     cp.nm_condicao_pagamento    as CondicaoPagamento,
     v.nm_fantasia_vendedor      as Vendedor,
     c.nm_fantasia_cliente       as Cliente,
     pv.cd_pedido_venda          as Pedido,
     pv.dt_pedido_venda          as Emissao,
     pvi.cd_item_pedido_venda    as Item,
     pvi.qt_item_pedido_venda    as Qtd,
     pvi.vl_unitario_item_pedido as Unitario,
     pvi.qt_item_pedido_venda *
     pvi.vl_unitario_item_pedido as Total,
     pvi.nm_produto_pedido       as Descricao,
     fp.nm_forma_pagamento       as FormaPagamento,
     p.cd_mascara_produto,
     p.nm_fantasia_produto,
     p.nm_produto,     
     tp.nm_tabela_preco,
     tpp.vl_tabela_produto

   from
     condicao_pagamento cp                         with (nolock) 
     left outer join pedido_venda pv               with (nolock) on pv.cd_condicao_pagamento = cp.cd_condicao_pagamento
     left outer join cliente      c                with (nolock) on c.cd_cliente             = pv.cd_cliente
     left outer join vendedor     v                with (nolock) on v.cd_vendedor            = pv.cd_vendedor
     left outer join pedido_venda_item pvi         with (nolock) on pvi.cd_pedido_venda      = pv.cd_pedido_venda
     left outer join produto      p                with (nolock) on p.cd_produto             = pvi.cd_produto
     left outer join Cliente_Informacao_Credito ci with (nolock) on ci.cd_cliente            = pv.cd_cliente
     left outer join Forma_Pagamento fp            with (nolock) on fp.cd_forma_pagamento    = ci.cd_forma_pagamento
     left outer join Tabela_Preco    tp            with (nolock) on tp.cd_tabela_preco       = pvi.cd_tabela_preco
     left outer join Tabela_Preco_Produto tpp      with (nolock) on tpp.cd_tabela_preco      = pvi.cd_tabela_preco and
                                                                    tpp.cd_produto           = pvi.cd_produto

--select * from tabela_preco_produto
--select * from forma_pagamento
      
   where
     pv.dt_pedido_venda between @dt_inicial and @dt_final and
     isnull(pv.cd_condicao_pagamento,0) = case when isnull(@cd_condicao_pagamento,0) = 0 then isnull(pv.cd_condicao_pagamento,0) else @cd_condicao_pagamento end and
     pv.dt_cancelamento_pedido is null

   order by
     pv.cd_condicao_pagamento  

end

