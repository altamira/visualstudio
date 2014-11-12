
CREATE PROCEDURE pr_consulta_pedido_por_vendedor
  @dt_inicial 	        datetime,
  @dt_final 	        datetime,
  @cd_vendedor	        int,
  @cd_vendedor_final	int = @cd_vendedor,
  @cd_tipo_vendedor	int,
  @cd_status_pedido     int = 0
AS

--select * from status_pedido

---------------------------------------
	if @cd_tipo_vendedor = 1 
---------------------------------------
	begin

	  select     
	    v.cd_vendedor, 
	    v.nm_fantasia_vendedor, 
	    v.cd_tipo_vendedor,
	    vi.cd_vendedor as cd_vendedor_interno,
	    vi.nm_fantasia_vendedor as nm_vendedor_interno,
	    pv.cd_pdcompra_pedido_venda,
	    pv.cd_pedido_venda, 
	    pv.dt_pedido_venda, 
	    tp.sg_tipo_pedido, 
	    c.nm_fantasia_cliente, 
	    cc.nm_categoria_cliente, 
	    ve.nm_fantasia_vendedor,
	    sum(pvi.vl_unitario_item_pedido * pvi.qt_item_pedido_venda) as vl_total_pedido,
	    cg.nm_cliente_grupo,
            sp.sg_status_pedido 	    
	  from         
	    pedido_venda pv 
	  left outer join pedido_venda_item pvi 
	    on pv.cd_pedido_venda = pvi.cd_pedido_venda 
	  left outer join vendedor v 
	    on pv.cd_vendedor = v.cd_vendedor
	  left outer join vendedor vi
	    on vi.cd_vendedor = pv.cd_vendedor_interno 
	  left outer join cliente c 
	    on pv.cd_cliente = c.cd_cliente 
	  left outer join tipo_pedido tp 
	    on pv.cd_tipo_pedido = tp.cd_tipo_pedido 
	  left outer join categoria_cliente cc 
	    on c.cd_categoria_cliente = cc.cd_categoria_cliente
	  left outer join vendedor ve 
	    on pv.cd_vendedor_interno = ve.cd_vendedor
	  left outer join cliente_grupo cg
	    on c.cd_cliente_grupo = cg.cd_cliente_grupo
	  left outer join status_pedido sp on sp.cd_status_pedido = pv.cd_status_pedido 
	  where pv.dt_cancelamento_pedido is null 
	    and pv.cd_status_pedido not in (6,7) 
	    and pvi.dt_cancelamento_item is null 
	    and pv.cd_vendedor_interno between 	case when isnull(@cd_vendedor,0) = 0
						then
							pv.cd_vendedor_interno
						else
							@cd_vendedor
						end 
					and	case when isnull(@cd_vendedor_final,0) = 0
						then
							pv.cd_vendedor_interno
						else
							@cd_vendedor
						end 
	    and pv.dt_pedido_venda between @dt_inicial and @dt_final
	    and vi.cd_tipo_vendedor = case when isnull(@cd_tipo_vendedor,0) = 0
					then
						isnull(v.cd_tipo_vendedor,0)
					else
						@cd_tipo_vendedor
					end 
	    and pv.cd_status_pedido = case when @cd_status_pedido=0 then pv.cd_status_pedido else @cd_status_pedido end
	  group by 
	    v.cd_vendedor, 
	    v.nm_fantasia_vendedor, 
	    v.cd_tipo_vendedor,
	    pv.cd_pedido_venda, 
	    pv.dt_pedido_venda, 
	    tp.sg_tipo_pedido, 
	    c.nm_fantasia_cliente, 
	    pv.cd_pdcompra_pedido_venda,
	    cc.nm_categoria_cliente, ve.nm_fantasia_vendedor, pv.dt_cancelamento_pedido,
	    cg.nm_cliente_grupo,
	    vi.cd_vendedor,
 	    vi.nm_fantasia_vendedor,
	    sp.sg_status_pedido   
	  order by 
	    v.cd_vendedor, 
	    pv.cd_pedido_venda

---------------------------------------	
	end
---------------------------------------
	else if @cd_tipo_vendedor = 2 
---------------------------------------
	begin
---------------------------------------

	  select     
	    v.cd_vendedor, 
	    v.nm_fantasia_vendedor, 
	    v.cd_tipo_vendedor,
	    vi.cd_vendedor as cd_vendedor_interno,
	    vi.nm_fantasia_vendedor as nm_vendedor_interno,
	    pv.cd_pdcompra_pedido_venda,
	    pv.cd_pedido_venda, 
	    pv.dt_pedido_venda, 
	    tp.sg_tipo_pedido, 
	    c.nm_fantasia_cliente, 
	    cc.nm_categoria_cliente, 
	    ve.nm_fantasia_vendedor,
	    sum(pvi.vl_unitario_item_pedido * pvi.qt_item_pedido_venda) as vl_total_pedido,
	    cg.nm_cliente_grupo,
            sp.sg_status_pedido
	    
	  from         
	    pedido_venda pv 
	  left outer join pedido_venda_item pvi 
	    on pv.cd_pedido_venda = pvi.cd_pedido_venda 
	  left outer join vendedor v 
	    on pv.cd_vendedor = v.cd_vendedor
	  left outer join vendedor vi
	    on vi.cd_vendedor = pv.cd_vendedor_interno 
	  left outer join cliente c 
	    on pv.cd_cliente = c.cd_cliente 
	  left outer join tipo_pedido tp 
	    on pv.cd_tipo_pedido = tp.cd_tipo_pedido 
	  left outer join categoria_cliente cc 
	    on c.cd_categoria_cliente = cc.cd_categoria_cliente
	  left outer join vendedor ve 
	    on pv.cd_vendedor_interno = ve.cd_vendedor
	  left outer join cliente_grupo cg
	    on c.cd_cliente_grupo = cg.cd_cliente_grupo
	  left outer join status_pedido sp on sp.cd_status_pedido = pv.cd_status_pedido 
	   
	  where pv.dt_cancelamento_pedido is null 
	    and pv.cd_status_pedido not in (6,7) 
	    and pvi.dt_cancelamento_item is null 
	    and pv.cd_vendedor between 	case when isnull(@cd_vendedor,0) = 0
					then
						pv.cd_vendedor
					else
						@cd_vendedor
					end 
				and	case when isnull(@cd_vendedor_final,0) = 0
					then
						pv.cd_vendedor
					else
						@cd_vendedor
					end
 
	    and pv.dt_pedido_venda between @dt_inicial and @dt_final
	    and v.cd_tipo_vendedor = case when isnull(@cd_tipo_vendedor,0) = 0
					then
						isnull(v.cd_tipo_vendedor,0)
					else
						@cd_tipo_vendedor
					end
	    and pv.cd_status_pedido = case when @cd_status_pedido=0 then pv.cd_status_pedido else @cd_status_pedido end
	  
	  group by 
	    v.cd_vendedor, 
	    v.nm_fantasia_vendedor, 
	    v.cd_tipo_vendedor,
	    pv.cd_pedido_venda, 
	    pv.dt_pedido_venda, 
	    tp.sg_tipo_pedido, 
	    c.nm_fantasia_cliente, 
	    pv.cd_pdcompra_pedido_venda,
	    cc.nm_categoria_cliente, ve.nm_fantasia_vendedor, pv.dt_cancelamento_pedido,
	    cg.nm_cliente_grupo,
	    vi.cd_vendedor,
	    vi.nm_fantasia_vendedor,
            sp.sg_status_pedido
	  
	  order by 
	    v.cd_vendedor, 
	    pv.cd_pedido_venda

---------------------------------------
	end
---------------------------------------
	else
---------------------------------------
	begin
---------------------------------------

	  select     
	    v.cd_vendedor, 
	    v.nm_fantasia_vendedor, 
	    v.cd_tipo_vendedor,
	    vi.cd_vendedor as cd_vendedor_interno,
	    vi.nm_fantasia_vendedor as nm_vendedor_interno,
	    pv.cd_pdcompra_pedido_venda,
	    pv.cd_pedido_venda, 
	    pv.dt_pedido_venda, 
	    tp.sg_tipo_pedido, 
	    c.nm_fantasia_cliente, 
	    cc.nm_categoria_cliente, 
	    ve.nm_fantasia_vendedor,
	    sum(pvi.vl_unitario_item_pedido * pvi.qt_item_pedido_venda) as vl_total_pedido,
	    cg.nm_cliente_grupo,
            sp.sg_status_pedido
	    
	  from         
	    pedido_venda pv 
	  left outer join pedido_venda_item pvi 
	    on pv.cd_pedido_venda = pvi.cd_pedido_venda 
	  left outer join vendedor v 
	    on pv.cd_vendedor = v.cd_vendedor
	  left outer join vendedor vi
	    on vi.cd_vendedor = pv.cd_vendedor_interno 
	  left outer join cliente c 
	    on pv.cd_cliente = c.cd_cliente 
	  left outer join tipo_pedido tp 
	    on pv.cd_tipo_pedido = tp.cd_tipo_pedido 
	  left outer join categoria_cliente cc 
	    on c.cd_categoria_cliente = cc.cd_categoria_cliente
	  left outer join vendedor ve 
	    on pv.cd_vendedor_interno = ve.cd_vendedor
	  left outer join cliente_grupo cg
	    on c.cd_cliente_grupo = cg.cd_cliente_grupo
      	  left outer join status_pedido sp on sp.cd_status_pedido = pv.cd_status_pedido 
	   
	  where pv.dt_cancelamento_pedido is null 
	    and pv.cd_status_pedido not in (6,7) 
	    and pvi.dt_cancelamento_item is null 
	    and pv.dt_pedido_venda between @dt_inicial and @dt_final
	    and pv.cd_status_pedido = case when @cd_status_pedido=0 then pv.cd_status_pedido else @cd_status_pedido end
	  
	  group by 
	    v.cd_vendedor, 
	    v.nm_fantasia_vendedor, 
	    v.cd_tipo_vendedor,
	    pv.cd_pedido_venda, 
	    pv.dt_pedido_venda, 
	    tp.sg_tipo_pedido, 
	    c.nm_fantasia_cliente, 
	    pv.cd_pdcompra_pedido_venda,
	    cc.nm_categoria_cliente, ve.nm_fantasia_vendedor, pv.dt_cancelamento_pedido,
	    cg.nm_cliente_grupo,
	    vi.cd_vendedor,
	    vi.nm_fantasia_vendedor,
            sp.sg_status_pedido
	  
	  order by 
	    v.cd_vendedor, 
	    pv.cd_pedido_venda

---------------------------------------
	end
---------------------------------------	
