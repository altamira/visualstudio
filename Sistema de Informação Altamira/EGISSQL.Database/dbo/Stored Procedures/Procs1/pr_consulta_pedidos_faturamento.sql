CREATE procedure pr_consulta_pedidos_faturamento

-------------------------------------------------------------------------------
-- pr_consulta_pedidos_faturamento 
-------------------------------------------------------------------------------
--GBS Global Business Solution Ltda                                        2004
-------------------------------------------------------------------------------
-- Stored Procedure : Microsoft SQL Server 2000
-- Autor(es)        : Carlos Cardoso Fernandes
-- Autor            : Fabio Cesar Magalhães
--
-- Consulta de Pedidos para faturamento por cliente
-- Data : 19.03.2003
-- 25.07.2008 - Ajuste da Quantidade Selecionada para Faturamento 
-------------------------------------------------------------------------------

@ic_parametro        int,
@cd_pedido_venda     int,
@Data_Inicial        Datetime,
@Data_Final          Datetime,
@cd_pedido_venda_esp int = 0

as
begin

declare
@cd_fase_produto integer


if @cd_pedido_venda_esp is null
  set @cd_pedido_venda_esp = 0

Select 
	top 1 @cd_fase_produto = isnull(cd_fase_produto,0)
from 
	Parametro_Comercial 
where 
  cd_empresa = dbo.fn_empresa()


if @cd_pedido_venda_esp = 0  --Verifica se seleciona por data
begin
  select 
     pv.dt_pedido_venda,   
     pv.cd_cliente,
     cl.nm_fantasia_cliente,
     pv.cd_vendedor,
     pv.cd_destinacao_produto,
     pv.cd_condicao_pagamento,
     pv.cd_tipo_entrega_produto, 
     isnull(ps.qt_saldo_atual_produto,0)                                   as qt_saldo_atual_produto,
     
	  IsNull(pvi.nm_produto_pedido,cast(s.ds_servico as varchar(240))) as nm_produto_servico,  
  	  IsNull(pvi.nm_fantasia_produto,s.nm_servico)                     as nm_fantasia_produto_servico,  
     pvi.*
  from 
     pedido_venda pv with (nolock) 
  left outer join Pedido_venda_item pvi
     on (pvi.cd_pedido_venda=pv.cd_pedido_venda)
  left outer join cliente cl
     on (cl.cd_cliente=pv.cd_cliente)
  left outer join produto_saldo ps
     on (ps.cd_produto=pvi.cd_produto and ps.cd_fase_produto=IsNull((select top 1 cd_fase_produto_baixa from produto where cd_produto = pvi.cd_produto), @cd_fase_produto))
  LEFT OUTER JOIN Servico s ON pvi.cd_servico = s.cd_servico 
  where
     pv.cd_cliente=(select top 1 cd_cliente from pedido_venda where cd_pedido_venda=@cd_pedido_venda) and 
     pv.dt_cancelamento_pedido is null and
     pvi.dt_cancelamento_item  is null and
     pv.cd_status_pedido = 1 and
     pvi.dt_entrega_vendas_pedido between @Data_Inicial and @Data_Final and
     isnull(pvi.qt_saldo_pedido_venda,0) > 0  and
     isNull(pvi.ic_sel_fechamento,IsNull(pv.ic_fechamento_total,'N')) = 'S'
  order by 
     pvi.dt_entrega_vendas_pedido,
     pv.cd_pedido_venda

end

else --Seleciona por Código do pedido

  select 
     pv.dt_pedido_venda,   
     pv.cd_cliente,
     cl.nm_fantasia_cliente,
     pv.cd_vendedor,
     pv.cd_destinacao_produto,
     pv.cd_condicao_pagamento,
     pv.cd_tipo_entrega_produto, 
     isnull(ps.qt_saldo_atual_produto,0)                                   as qt_saldo_atual_produto,
	  IsNull(pvi.nm_produto_pedido,cast(s.ds_servico as varchar(240))) as nm_produto_servico,  
  	  IsNull(pvi.nm_fantasia_produto,s.nm_servico)                     as nm_fantasia_produto_servico,  
     pvi.*
  from 
     pedido_venda pv                     with (nolock) 
  left outer join Pedido_venda_item pvi  with (nolock) 
     on (pvi.cd_pedido_venda=pv.cd_pedido_venda)
  left outer join cliente cl
     on (cl.cd_cliente=pv.cd_cliente)
  left outer join produto_saldo ps
     on (ps.cd_produto=pvi.cd_produto and ps.cd_fase_produto=IsNull((select top 1 cd_fase_produto_baixa from produto where cd_produto = pvi.cd_produto), @cd_fase_produto))
  LEFT OUTER JOIN Servico s ON pvi.cd_servico = s.cd_servico 
  where
     pv.cd_pedido_venda=@cd_pedido_venda and
     pv.dt_cancelamento_pedido is null and
     pvi.dt_cancelamento_item is null and
     pv.cd_status_pedido = 1 and
     isnull(pvi.qt_saldo_pedido_venda,0) > 0  and
     isNull(pvi.ic_sel_fechamento,IsNull(pv.ic_fechamento_total,'N')) = 'S'
  order by 
     pvi.dt_entrega_vendas_pedido,
     pv.cd_pedido_venda

end     

SET QUOTED_IDENTIFIER OFF 

