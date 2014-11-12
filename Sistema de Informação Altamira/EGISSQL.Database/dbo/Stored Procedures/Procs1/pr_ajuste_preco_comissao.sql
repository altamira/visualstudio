
-------------------------------------------------------------------------------
--pr_ajuste_preco_comissao
-------------------------------------------------------------------------------
--GBS Global Business Solution Ltda                                        2005
-------------------------------------------------------------------------------
--Stored Procedure : Microsoft SQL Server       2000
--Autor(es)        : Carlos Cardoso Fernandes
--Banco de Dados   : EgisSQL
--Objetivo         : Ajuste do preço de lista do item do Pedido de Venda
--
--Data             : 28/10/2005
--Atualizado       : 28/10/2005 
-- 18.12.2008 - Ajuste do Preço de Serviço - Carlos Fernandes
--------------------------------------------------------------------------------------------------
create procedure pr_ajuste_preco_comissao

as

--select * from pedido_venda_item

select
  ip.cd_pedido_venda,
  ip.cd_item_pedido_venda,
  ip.cd_produto,
  ip.vl_unitario_item_pedido,
  ip.vl_lista_item_pedido,
  p.vl_produto,
  case when isnull(ip.cd_produto,0)=0 and isnull(ip.vl_lista_item_pedido,0)=0 
       then 
         isnull(ip.vl_unitario_item_pedido,0)
       else 
         case when isnull(ip.vl_lista_item_pedido,0)=0 and isnull(ip.vl_unitario_item_pedido,0)<>isnull(p.vl_produto,0) and isnull(p.vl_produto,0)>0
              then isnull(p.vl_produto,0)
              else case when isnull(p.vl_produto,0)=0 then isnull(ip.vl_unitario_item_pedido,0) else isnull(ip.vl_unitario_item_pedido,0) end
         end 
       end as vl_lista_produto
into #AuxPreco
from
  pedido_venda_item ip      with (nolock) 
  left outer join Produto p with (nolock) on p.cd_produto = ip.cd_produto
where
  isnull(ip.vl_lista_item_pedido,0)=0

--select * from #AuxPreco
--select * from Servico

--------------------------------------------------------------------------------------------------
--Ajustado
--------------------------------------------------------------------------------------------------
declare @cd_pedido_venda      int
declare @cd_item_pedido_venda int
declare @vl_lista_item_pedido float

while exists ( select top 1 cd_pedido_venda from #AuxPreco )
begin
  select top 1 
    @cd_pedido_venda      = cd_pedido_venda,
    @cd_item_pedido_venda = cd_item_pedido_venda,
    @vl_lista_item_pedido = vl_lista_produto
  from
    #AuxPreco

  update
    Pedido_venda_item
  set
    vl_lista_item_pedido = @vl_lista_item_pedido
  where
    cd_pedido_venda      = @cd_pedido_venda and
    cd_item_pedido_venda = @cd_item_pedido_venda 

  delete from #AuxPreco where cd_pedido_venda      = @cd_pedido_venda and
                              cd_item_pedido_venda = @cd_item_pedido_venda

end


--------------------------------------------------------------------------------------------------
--Automático com Preço de Venda
--------------------------------------------------------------------------------------------------
-- update
--   pedido_venda_item
-- set
--   vl_lista_item_pedido = isnull(vl_unitario_item_pedido,0)
-- where
--   isnull(vl_lista_item_pedido,0)=0



