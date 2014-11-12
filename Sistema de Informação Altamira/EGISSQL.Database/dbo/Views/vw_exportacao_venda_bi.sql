
CREATE VIEW vw_exportacao_venda_bi
AS 
  select
    pv.cd_pedido_venda,
    pv.dt_pedido_venda,
    pv.cd_cliente,
	  pv.cd_condicao_pagamento,
    c.nm_fantasia_cliente,
    pv.cd_vendedor,
    ve.nm_vendedor as 'nm_vendedor_externo',
    pv.cd_vendedor_interno,
    vi.nm_vendedor as 'nm_vendedor_interno',
    pvi.cd_item_pedido_venda,
    isnull(pvi.cd_produto,0) as cd_produto,
    pvi.nm_fantasia_produto,
    pvi.qt_item_pedido_venda,
		pvi.qt_saldo_pedido_venda,
    pvi.dt_entrega_vendas_pedido,
		case 
			when(pvi.dt_cancelamento_item is null) then  
			 (vl_unitario_item_pedido) 
			else 0 
    end vl_unitario_item_pedido,
    pvi.vl_lista_item_pedido,
    pvi.pc_ipi,
    pvi.pc_icms,
    pvi.pc_reducao_base_item,
    pv.cd_destinacao_produto,
    cp.cd_grupo_categoria,
    gc.nm_grupo_categoria,
    pvi.cd_categoria_produto,
    cp.nm_categoria_produto,
    c.cd_estado,
    c.cd_pais,
    vr.cd_regiao_venda,
    pvi.cd_servico,
    pv.cd_loja
  from
    Pedido_Venda 	pv  left outer join
    Cliente	 	c   on pv.cd_cliente            = c.cd_cliente            left outer join
    Pedido_Venda_Item	pvi on pv.cd_pedido_venda       = pvi.cd_pedido_venda     left outer join
    Categoria_Produto   cp  on pvi.cd_categoria_produto = cp.cd_categoria_produto left outer join
    Grupo_Categoria	gc  on cp.cd_grupo_categoria    = gc.cd_grupo_categoria   left outer join
    Vendedor		ve  on pv.cd_vendedor		= ve.cd_vendedor	  left outer join
    Vendedor		vi  on pv.cd_vendedor_interno	= vi.cd_vendedor	  left outer join
    Vendedor_Regiao     vr  on pv.cd_vendedor           = vr.cd_vendedor          left outer join
    Tipo_Mercado        tm  on tm.cd_tipo_mercado       = c.cd_tipo_mercado    
  where
    isnull(month(pv.dt_cancelamento_pedido),month(pv.dt_pedido_venda) + 1) >  month(pv.dt_pedido_venda)  and
    isnull(month(pvi.dt_cancelamento_item), month(pv.dt_pedido_venda) + 1) >  month(pv.dt_pedido_venda)  and
    isnull(pv.ic_consignacao_pedido,'N') 			    	   <> 'S' 			 and
    pvi.qt_item_pedido_venda * pvi.vl_unitario_item_pedido 	           >  0                          and
    isnull(tm.ic_exportacao_tipo_mercado,'N')='S'
