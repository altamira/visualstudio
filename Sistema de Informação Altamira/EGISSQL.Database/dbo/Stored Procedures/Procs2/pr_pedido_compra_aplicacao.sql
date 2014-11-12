
CREATE PROCEDURE pr_pedido_compra_aplicacao
@cd_aplicacao_produto int,
@dt_inicial           datetime,
@dt_final             datetime

as

select 
  ap.nm_aplicacao_produto	as 'Aplicacao',
  pc.cd_pedido_compra       	as 'Pedido',
  pci.dt_item_pedido_compra     as 'DataPedido',
  f.nm_fantasia_fornecedor  	as 'Fornecedor',
  pci.vl_total_item_pedido_comp as 'Total',
  pc.dt_nec_pedido_compra   	as 'Necessidade',
  c.nm_comprador           	as 'Comprador',
  nei.cd_nota_entrada		as 'NotaEntrada',
  nei.cd_item_nota_entrada	as 'ItemNotaEntrada',
  nei.qt_item_nota_entrada	as 'QtdeItemNotaEntrada',
--  ne.dt_nota_entrada		as 'DataNotaEntrada',
  nei.dt_item_receb_nota_entrad as 'DataNotaEntrada',
  pci.cd_pedido_compra,
	pci.cd_item_pedido_compra,
	pci.qt_item_pedido_compra,
	pci.qt_saldo_item_ped_compra,

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

  case when pci.ic_pedido_compra_item='P'
       then pci.nm_produto
       else case when isnull(pci.cd_servico,0)>0 then s.nm_servico
                                                 else cast(pci.ds_item_pedido_compra as varchar(50)) end
      end as nm_produto,

      --pci.nm_produto,
	case when isnull(pci.cd_servico,0)>0 then s.nm_servico else pci.nm_fantasia_produto end as 'nm_fantasia_produto',
	
	pci.dt_item_ativ_ped_compra,
	pci.nm_item_ativ_ped_compra,

  case when isnull(pci.cd_produto,0)>0 then dbo.fn_mascara_produto(pci.cd_produto)
                                       else s.cd_mascara_servico end                            as 'cd_mascara_produto',
  plc.nm_plano_compra,
  plc.cd_mascara_plano_compra 

--select * from plano_compra

  from
     	Pedido_Compra 	pc                              with (nolock) 
	inner join Aplicacao_Produto 		ap 	with (nolock) on ap.cd_aplicacao_produto	= pc.cd_aplicacao_produto
	inner join Fornecedor 			f 	with (nolock) on pc.cd_fornecedor  		= f.cd_fornecedor 
	inner join Comprador 			c 	with (nolock) on pc.cd_comprador		= c.cd_comprador
	left outer join Plano_Compra 		plc 	with (nolock) on plc.cd_plano_compra 		= pc.cd_plano_compra
	inner join Pedido_compra_Item		pci 	with (nolock) on pci.cd_pedido_compra 	= pc.cd_pedido_compra 
	left outer join nota_entrada_item	nei	with (nolock) on nei.cd_item_pedido_compra	= pci.cd_item_pedido_compra and 
                                                                         nei.cd_pedido_compra	        = pci.cd_pedido_compra
        left outer join Servico                 s       with (nolock) on s.cd_servico                 = pci.cd_servico

                                                       --and nei.cd_produto               = pci.cd_produto
--	left outer join nota_entrada		ne	on ne.cd_nota_entrada		= nei.cd_nota_entrada and
  --                                                         ne.cd_fornecedor             = pc.cd_fornecedor 
  where
     pc.dt_pedido_compra  between @dt_inicial and @dt_final and
     pc.dt_cancel_ped_compra is null and
     IsNull(pc.cd_aplicacao_produto,0) = ( case when @cd_aplicacao_produto = 0 then
                                           IsNull(pc.cd_aplicacao_produto,0) else
                                                       @cd_aplicacao_produto end)
  order by
    ap.nm_aplicacao_produto,
    pc.dt_pedido_compra     desc

 
--sp_help pedido_compra
--select * from aplicacao_produto

