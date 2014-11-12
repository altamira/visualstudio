
CREATE PROCEDURE pr_consulta_consignacao_pedido_compra
---------------------------------------------------
--GBS - Global Business Solution	       2003
--Stored Procedure: Microsoft SQL Server       2000
--Autor(es)       : Igor Gama
--Banco de Dados  : EgisSQL
--Objetivo        : Consulta de Pedidos para Consignação
--Data            : 26/02/2003
--Atualizado      : 
---------------------------------------------------
@ic_parametro     int,
@cd_pedido_compra int,
@dt_inicial       datetime,
@dt_final         datetime

AS

If @ic_parametro = 1
Begin

  select
	  f.nm_fantasia_fornecedor,
	  tp.nm_tipo_pedido,
	  pc.cd_pedido_compra,
	  pc.dt_pedido_compra,
	  pc.vl_total_pedido_compra,
	  co.nm_fantasia_comprador,
	  cp.nm_condicao_pagamento,
    pc.dt_cancel_ped_compra,
    pc.ds_cancel_ped_compra,
    pc.dt_alteracao_ped_compra,
    pc.ds_alteracao_ped_compra,
    sp.nm_status_pedido
	From
	  Pedido_Compra pc
	    Left Outer Join
	  Fornecedor f
	    on pc.cd_fornecedor = f.cd_fornecedor
	    Left Outer Join
	  Tipo_Pedido tp
	    on pc.cd_tipo_pedido = tp.cd_tipo_pedido
	    Left Outer Join
    Status_Pedido sp
      on pc.cd_status_pedido = sp.cd_status_pedido
      Left Outer Join
	  Comprador co
	    on pc.cd_comprador = co.cd_comprador
	    Left Outer Join
	  Condicao_Pagamento cp
	    on pc.cd_condicao_pagamento = cp.cd_condicao_pagamento
	Where
	  ( @cd_pedido_compra = 0 or pc.cd_pedido_compra = @cd_pedido_compra) and
	  ( @cd_pedido_compra <> 0 or pc.dt_pedido_compra Between @dt_inicial and @dt_final)
	  and IsNull(pc.ic_consignacao_pedido, 'N') = 'S'

End

If @ic_parametro = 2
Begin

	select
		pci.cd_pedido_compra,
		pci.cd_item_pedido_compra,
		pci.qt_item_pedido_compra,
		pci.qt_saldo_item_ped_compra,

		pci.ds_item_prodesp_ped_compr,
		pci.vl_item_unitario_ped_comp,
		pci.pc_item_descto_ped_compra,
	
		pci.qt_item_pesliq_ped_compra,
		pci.qt_item_pesbr_ped_compra,
	
		pci.dt_item_canc_ped_compra,
                pci.nm_item_motcanc_ped_compr,
	
		pci.pc_ipi,
	
		pci.dt_item_nec_ped_compra,
		pci.qt_dia_entrega_item_ped,
		pci.dt_entrega_item_ped_compr,
	
		pci.nm_produto,
		pci.nm_fantasia_produto,
	
		pci.dt_item_ativ_ped_compra,
		pci.nm_item_ativ_ped_compra,
                dbo.fn_mascara_produto(pci.cd_produto) as 'cd_mascara_produto'
	
	From 
	  Pedido_compra_Item pci
	Where
	  pci.cd_pedido_compra = @cd_pedido_compra

End

