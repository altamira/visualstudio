
CREATE FUNCTION fn_ultimo_preco_pedido

(@ic_servico char(1), @cd_cliente int, @cd_prod_serv int)        	

RETURNS float

AS
BEGIN

  declare @vl_venda float

  select top 1 
    @vl_venda = isnull(ci.vl_unitario_item_pedido,0) 
  from 
    Pedido_Venda_Item ci      with (nolock)  
    inner join Pedido_Venda c with (nolock)on c.cd_pedido_venda = ci.cd_pedido_venda
  where 
    c.cd_cliente = @cd_cliente and
    (case when @ic_servico = 'S' then ci.cd_servico
         else ci.cd_produto end ) = @cd_prod_serv
  order by 
     --c.cd_pedido_venda desc
     c.dt_pedido_venda desc, c.cd_pedido_venda desc

  RETURN (isnull(@vl_venda, 0))

END


-------------------------------------------------------------------------------------------
--Example to execute function
-------------------------------------------------------------------------------------------
--Select * form  
