
CREATE VIEW vw_importacao_bi
AS 

select
     pei.cd_pedido_Importacao,
     pei.dt_pedido_Importacao,
     pei.cd_fornecedor,
 	  pei.cd_condicao_pagamento,
     f.nm_fantasia_fornecedor,
     pei.cd_comprador,
     co.nm_comprador,
     pii.cd_item_ped_imp,
     isnull(pii.cd_produto,0) as cd_produto,
     pii.nm_fantasia_produto,
     pii.qt_item_ped_imp,
  	  pii.qt_saldo_item_ped_imp,
     pii.dt_entrega_ped_imp,
     pii.cd_pedido_Venda,
     c.cd_cliente,
     c.nm_fantasia_cliente,
  	  case 
 			when(pii.dt_cancel_item_ped_imp is null) then  
 			 (vl_item_ped_imp) 
 			else 0 
     end vl_item_ped_imp,
     pii.pc_iimp_ped_imp,
     cp.cd_grupo_categoria,
     gc.nm_grupo_categoria,
     p.cd_categoria_produto,
     cp.nm_categoria_produto,
     pei.nm_canc_pedido_importacao,
     f.cd_estado,
     f.cd_pais
  from
    Pedido_Importacao 	pei  left outer join
    Fornecedor	 	f   on pei.cd_fornecedor = f.cd_fornecedor left outer join
    Pedido_Importacao_Item	pii on pei.cd_pedido_Importacao = pii.cd_pedido_Importacao     left outer join
    Produto p on p.cd_produto = pii.cd_produto left join
    Categoria_Produto   cp  on p.cd_categoria_produto = cp.cd_categoria_produto left outer join
    Grupo_Categoria	gc  on cp.cd_grupo_categoria    = gc.cd_grupo_categoria   left outer join
    Comprador		co  on pei.cd_comprador		= co.cd_comprador	  left join
    Pedido_Venda pv on pv.cd_pedido_venda = pii.cd_pedido_venda  left join
    Cliente c on c.cd_cliente =pv.cd_cliente 

  where
    isnull(month(pei.dt_canc_pedido_importacao),month(pei.dt_pedido_importacao) + 1) >  month(pei.dt_pedido_importacao)  and
    isnull(month(pii.dt_cancel_item_ped_imp), month(pei.dt_pedido_Importacao) + 1) >  month(pei.dt_pedido_Importacao)  and
--    isnull(pei.ic_consignacao_pedido,'N') 			    	   <> 'S' 			 and
    pii.qt_item_ped_imp * pii.vl_item_ped_imp >  0

