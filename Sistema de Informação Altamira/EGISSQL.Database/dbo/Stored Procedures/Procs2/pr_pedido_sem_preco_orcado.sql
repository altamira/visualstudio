

/****** Object:  Stored Procedure dbo.pr_pedido_sem_preco_orcado    Script Date: 13/12/2002 15:08:38 ******/

CREATE PROCEDURE pr_pedido_sem_preco_orcado
  @cd_vendedor   int,
  @dt_inicial           datetime,
  @dt_final             datetime 

AS

---------------------------------------------------
if @cd_vendedor = 0 -- Seleciona todos os vendedores
---------------------------------------------------
begin

select  
         v.nm_fantasia_vendedor,
         c.nm_fantasia_cliente,
         pv.cd_pedido_venda,
         pv.dt_pedido_venda,
         pv.vl_total_pedido_venda,
         pvi.cd_item_pedido_venda,
         pvi.qt_item_pedido_venda,
         pvi.nm_fantasia_produto,
         pvi.nm_produto_pedido as 'nm_produto',
         pvi.vl_unitario_item_pedido
from
   Pedido_Venda pv inner join
   Pedido_Venda_Item pvi on pvi.cd_pedido_venda = pv.cd_pedido_venda left outer join
   Cliente c on c.cd_cliente = pv.cd_cliente left outer join
   Vendedor v on v.cd_vendedor = pv.cd_vendedor 
Where 
  pv.dt_pedido_venda between @dt_inicial and @dt_final and
  pv.dt_cancelamento_pedido is null and
  IsNull(pv.ic_fatsmo_pedido,'N') = 'N' and
  pvi.vl_lista_item_pedido = 0
  
order by pv.cd_pedido_venda desc

end

---------------------------
else
---------------------------
begin

select  
         v.nm_fantasia_vendedor,
         c.nm_fantasia_cliente,
         pv.cd_pedido_venda,
         pv.dt_pedido_venda,
         pv.vl_total_pedido_venda,
         pvi.cd_item_pedido_venda,
         pvi.qt_item_pedido_venda,
         pvi.nm_fantasia_produto,
         pvi.nm_produto_pedido as 'nm_produto',
         pvi.vl_unitario_item_pedido

from
   Pedido_Venda pv inner join
   Pedido_Venda_Item pvi on pvi.cd_pedido_venda = pv.cd_pedido_venda left outer join
   Cliente c on c.cd_cliente = pv.cd_cliente left outer join
   Vendedor v on v.cd_vendedor = pv.cd_vendedor 
Where 
  pv.cd_vendedor = @cd_vendedor and
  pv.dt_pedido_venda between @dt_inicial and @dt_final and
  pv.dt_cancelamento_pedido is null and
  IsNull(pv.ic_fatsmo_pedido,'N') = 'N' and
  IsNull(pvi.vl_lista_item_pedido,0) = 0
  
order by pv.cd_pedido_venda desc

end



