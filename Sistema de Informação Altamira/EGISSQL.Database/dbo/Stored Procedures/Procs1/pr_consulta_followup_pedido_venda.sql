
CREATE procedure pr_consulta_followup_pedido_venda  
@cd_vendedor integer,  
@cd_categoria integer,  
@cd_cliente integer,
@cd_tipo_vendedor integer
as  
  
Select
     v.cd_vendedor,
     vi.cd_vendedor, 
     cl.cd_cliente,  
     cp.cd_categoria_produto,  
     c.cd_consulta,  
     ci.cd_item_consulta,  
     ci.nm_fantasia_produto,  
     ci.dt_item_consulta,  
     ci.qt_item_consulta,  
     ci.vl_unitario_item_consulta,  
     (ci.vl_unitario_item_consulta * ci.qt_item_consulta) as vl_total,  
     ci.cd_produto,  
     cl.nm_fantasia_cliente,  
     v.nm_fantasia_vendedor,  
     vi.nm_fantasia_vendedor as nm_fantasia_vendedor_interno,   
     cp.cd_mascara_categoria,  
     cp.nm_categoria_produto,  
     u.nm_fantasia_usuario  
  
from   
     consulta c left outer join  
     consulta_itens ci on ci.cd_consulta = c.cd_consulta left outer join  
     cliente cl on cl.cd_cliente = c.cd_cliente left outer join  
     vendedor v on v.cd_vendedor = c.cd_vendedor left outer join  
     vendedor vi on vi.cd_vendedor = c.cd_vendedor_interno left outer join  
     categoria_produto cp on cp.cd_categoria_produto = ci.cd_categoria_produto left outer join  
     usuario u on u.cd_usuario = c.cd_usuario

where   
     
     case when @cd_tipo_vendedor = 1 then
         c.cd_vendedor_interno 
       else
         c.cd_vendedor 
       end = @cd_vendedor
     
and


--      case when isnull(@cd_vendedor,0) = 0 then
--        isnull(v.cd_vendedor,0)
--      else
--        @cd_vendedor
--      end = isnull(v.cd_vendedor,0) and
--     
--      case when isnull(@cd_vendedor_interno,0) = 0 then
--        isnull(vi.cd_vendedor,0)
--      else
--        @cd_vendedor_interno
--      end = isnull(vi.cd_vendedor,0)  and 
    
     case when isnull(@cd_cliente,0) = 0 then
       isnull(cl.cd_cliente,0)
     else
       @cd_cliente
     end = isnull(cl.cd_cliente,0) and
    
     case when isnull(@cd_categoria,0) = 0 then
       isnull(cp.cd_categoria_produto,0)
     else
       @cd_categoria
     end = isnull(cp.cd_categoria_produto,0)
Order By c.cd_consulta, ci.cd_item_consulta

