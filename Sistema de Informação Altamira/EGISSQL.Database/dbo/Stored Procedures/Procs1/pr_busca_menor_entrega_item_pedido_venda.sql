
create procedure pr_busca_menor_entrega_item_pedido_venda
@cd_pedido_venda int

as

select
   case 
     when
        min( ip.dt_entrega_vendas_pedido ) = min(ip.dt_item_pedido_venda)
        then 'Imediato'
        else convert( varchar(10),min(ip.dt_entrega_vendas_pedido),103 ) end as 'Entrega'
from
   Pedido_Venda_item ip
where
  @cd_pedido_venda  = ip.cd_pedido_venda 


