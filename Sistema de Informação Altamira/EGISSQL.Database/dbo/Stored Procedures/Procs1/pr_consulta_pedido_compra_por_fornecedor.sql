
CREATE PROCEDURE pr_consulta_pedido_compra_por_fornecedor
@ic_parametro_filtro    int,
@ic_parametro           int, 
@cd_status_pedido       int,
@nm_fantasia_fornecedor varchar(60),
@dt_inicial             datetime,
@dt_final               datetime

AS


 select distinct
    pc.cd_fornecedor,
    f.nm_fantasia_fornecedor       as 'Fornecedor',
    pci.dt_item_pedido_compra      as 'Data',
    pci.cd_pedido_compra           as 'Pedido',
    pci.cd_item_pedido_compra      as 'Item',
    --Nome Fantasia
    case when isnull(p.cd_produto,0)>0 
         then p.nm_fantasia_produto
         else case when isnull(pci.cd_servico,0)>0 
                   then s.nm_servico 
                   else
                       isnull(p.nm_fantasia_produto,'Compra Especial') end
     end
     as 'Produto',

    --Produto
    case when isnull(p.cd_produto,0)>0 
         then isnull(pci.nm_produto,p.nm_produto)
         else
              case when isnull(pci.cd_servico,0)>0 then case when cast(pci.ds_item_pedido_compra as varchar)<>'' then
                                                             isnull(cast(pci.ds_item_pedido_compra as varchar),s.nm_servico) else s.nm_servico end
                                                   else 'Descrição não informada no pedido.' end 
    end as 'Descricao',     

    cast(pci.ds_item_prodesp_ped_compr as varchar(30)) as 'DescricaoEsp',

    case when pci.cd_materia_prima is null then null else
         mp.nm_mat_prima end                 as 'Materia_Prima',
    pci.nm_medbruta_mat_prima,
    pci.nm_medacab_mat_prima,
    isnull(pci.qt_item_pedido_compra,0)      as 'Qtd',
    isnull(pci.qt_item_pesliq_ped_compra,0)  as 'PesoLiq',
    isnull(pci.qt_item_pesbr_ped_compra,0)   as 'PesoBruto',
    isnull(pci.vl_item_unitario_ped_comp,0)  as 'Unitario',
    isnull(pci.vl_total_item_pedido_comp,0)  as 'Total',
    pci.dt_item_nec_ped_compra               as 'Necessidade',
    nei.cd_nota_entrada                      as 'Nota',
    nei.cd_item_nota_entrada                 as 'NotaItem',
    isnull(nei.qt_item_nota_entrada,0)       as 'QtdRecebida',
    nei.dt_item_receb_nota_entrad            as 'DataRecebimento',
    isnull(pci.qt_saldo_item_ped_compra,0)   as 'Saldo',
    isnull(rii.qt_item_requisicao_compra,0)  as 'Requisicao',
    pci.cd_pedido_venda                      as 'PedidoVenda',
    case when isnull(p.cd_produto,0)>0 then dbo.fn_mascara_produto(p.cd_produto)
         else s.cd_mascara_servico end       as 'cd_mascara_produto',
    pci.dt_entrega_item_ped_compr,
    gp.cd_mascara_grupo_produto,
    um.sg_unidade_medida,
    pci.pc_ipi,
    isnull((pci.vl_total_item_pedido_comp * (pci.pc_ipi / 100)), 0) as vl_ipi,
    pci.pc_icms,
    c.nm_fantasia_comprador,
    plc.nm_plano_compra,
    cc.nm_centro_custo,
    isnull(pci.qt_area_produto,0) as qt_area_produto,
    isnull(pci.qt_area_produto,0) * isnull(pci.qt_item_pedido_compra,0) as qt_total_area,
    ap.nm_aplicacao_produto
  from 
    	Pedido_Compra pc 
	inner join 	Pedido_Compra_Item 	pci 	on pc.cd_pedido_compra			=	pci.cd_pedido_compra 
	left outer join Requisicao_Compra_Item 	rii 	on rii.cd_item_requisicao_compra	=	pci.cd_requisicao_compra_item
							and rii.cd_requisicao_compra 		= 	pci.cd_requisicao_compra 
	left outer join Nota_Entrada_Item 	nei 	on nei.cd_pedido_compra			=	pci.cd_pedido_compra 
							and nei.cd_item_pedido_compra		=	pci.cd_item_pedido_compra
	left outer join Nota_Entrada 		ne 	on nei.cd_nota_entrada			=	ne.cd_nota_entrada 
	left outer join Produto 		p 	on p.cd_produto				=	pci.cd_produto 
	left outer join Materia_Prima 		mp 	on mp.cd_mat_prima			=	pci.cd_materia_prima 
	left outer join Fornecedor 		f 	on f.cd_fornecedor 			= 	pc.cd_fornecedor 
	left outer join Grupo_Produto 		gp 	on gp.cd_grupo_produto 			= 	p.cd_grupo_produto 
	left outer join Unidade_Medida 		um 	on pci.cd_unidade_medida 		= 	um.cd_unidade_medida 
	left outer join Comprador 		c 	on c.cd_comprador 			=	pc.cd_comprador
        left outer join Servico                 s       on s.cd_servico                         =       pci.cd_servico    
        left outer join Centro_Custo 		cc 	on cc.cd_centro_custo                   = IsNull(pci.cd_centro_custo,pc.cd_centro_custo)   
        left outer join Plano_Compra 		plc 	on plc.cd_plano_compra                  = pci.cd_plano_compra
        left outer join Aplicacao_Produto       ap 	on ap.cd_aplicacao_produto              = pc.cd_aplicacao_produto

  where 
--    ((pc.cd_status_pedido = @cd_status_pedido) or (@cd_status_pedido = 0)) and
    f.nm_fantasia_fornecedor like @nm_fantasia_fornecedor + '%' and

     ( ( pci.dt_item_canc_ped_compra is not null  and
         @ic_parametro_filtro = 1 ) or  -- Filtro por pedidos cancelados.
       ( pci.qt_saldo_item_ped_compra > 0 and 
         pci.qt_saldo_item_ped_compra = pci.qt_item_pedido_compra and 
         pci.dt_item_canc_ped_compra is null and
         @ic_parametro_filtro = 2 ) or -- Filtro por pedidos em aberto.
       ( pci.qt_saldo_item_ped_compra = 0 and 
         pci.dt_item_canc_ped_compra is null and
         @ic_parametro_filtro = 3 ) or -- Filtro por pedidos recebidos.
       ( pci.qt_saldo_item_ped_compra > 0 and 
         pci.qt_saldo_item_ped_compra <> pci.qt_item_pedido_compra and 
         pci.dt_item_canc_ped_compra is null and
         @ic_parametro_filtro = 4 ) or -- Filtro por Pedido Parcialmente Recebido
       ( @ic_parametro_filtro = 5 and 
         pci.dt_item_canc_ped_compra is null ) ) and
    ( 
      ( 
	( @ic_parametro = 0) and
	( pc.dt_pedido_compra between @dt_inicial and @dt_final)
      ) 
      or
      ( 
	( @ic_parametro = 1) and 
        ( pci.dt_item_nec_ped_compra between @dt_inicial and @dt_final)
      ) 
      or
      ( 
	( @ic_parametro = 2) and 
        ( pci.dt_entrega_item_ped_compr between @dt_inicial and @dt_final)
      )
      or
      ( 
	( @ic_parametro = 3) and 
        ( nei.dt_item_receb_nota_entrad between @dt_inicial and @dt_final)
      )
    )

  order by    
    pci.cd_pedido_compra,
    pci.cd_item_pedido_compra,
    pci.dt_item_pedido_compra desc    


