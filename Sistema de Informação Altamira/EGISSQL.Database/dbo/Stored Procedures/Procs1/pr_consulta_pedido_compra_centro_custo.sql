
CREATE PROCEDURE pr_consulta_pedido_compra_centro_custo

@cd_centro_custo int,
@dt_inicial      datetime,
@dt_final        datetime

AS

    select 
      IsNull(pci.cd_centro_custo,pc.cd_centro_custo) as cd_centro_custo,
      pc.dt_pedido_compra,
      f.nm_fantasia_fornecedor,
      c.nm_centro_custo,
      pci.dt_item_pedido_compra,
      pci.cd_pedido_compra,
      pci.cd_item_pedido_compra,
      pci.dt_item_canc_ped_Compra,
      pci.nm_item_motcanc_ped_compr,
      IsNull(p.nm_fantasia_produto, s.nm_servico)               as 'Produto',
--      cast(IsNull(p.ds_produto, s.ds_servico ) as varchar(260)) as 'Descricao',

      cast(case when pci.ic_pedido_compra_item='P'
           then pci.nm_produto
           else case when isnull(pci.cd_servico,0)>0 then s.nm_servico
                                                     else pci.ds_item_pedido_compra end
      end as varchar(260)) as Descricao,

      case when pci.cd_materia_prima is null then null else
        mp.nm_mat_prima end as 'Materia_Prima',
      pci.nm_medbruta_mat_prima,
      pci.nm_medacab_mat_prima,
      pci.qt_item_pedido_compra,
      pci.qt_item_pesliq_ped_compra,
      pci.qt_item_pesbr_ped_compra,
      pci.vl_item_unitario_ped_comp,
      pci.vl_custo_item_ped_compra,
      pci.dt_item_nec_ped_compra,
      nei.cd_nota_entrada,
      nei.cd_item_nota_entrada,
      nei.qt_item_nota_entrada,
--select * from nota_entrada_item
      nei.dt_item_receb_nota_entrad as dt_nota_entrada,
      pci.qt_saldo_item_ped_compra,
      rii.qt_item_requisicao_compra,
      pci.cd_pedido_venda,
      cast(isnull(pci.cd_produto, pci.cd_servico)as varchar(20)) as 'cd_mascara_produto',
      plc.nm_plano_compra,
      rii.cd_requisicao_compra,
      rii.cd_item_requisicao_compra
      
    from 
      Pedido_Compra_Item pci           with (nolock) 
      left outer join Pedido_Compra pc with (nolock) on pc.cd_pedido_compra = pci.cd_pedido_compra 
      left outer join Fornecedor f     with (nolock) on f.cd_fornecedor     = pc.cd_fornecedor         
      left outer join Centro_Custo c   with (nolock) on c.cd_centro_custo   = IsNull(pci.cd_centro_custo,pc.cd_centro_custo)   
      left outer join Produto p        with (nolock) on p.cd_produto        = pci.cd_produto
      left outer join Servico s        with (nolock) on s.cd_servico        = pci.cd_servico              
      left outer join Materia_Prima mp with (nolock) on mp.cd_mat_prima     = pci.cd_materia_prima
      left outer join Requisicao_Compra_Item rii with (nolock)  on rii.cd_requisicao_compra     =pci.cd_requisicao_compra and
                                                                   rii.cd_item_requisicao_compra=pci.cd_requisicao_compra_item 
      left outer join Nota_Entrada_Item nei with (nolock)       on nei.cd_pedido_compra      = pci.cd_pedido_compra and 
                                                                   nei.cd_item_pedido_compra = pci.cd_item_pedido_compra
      left outer join Plano_Compra plc with (nolock)            on plc.cd_plano_compra       = pci.cd_plano_compra
  where 
    ((IsNull(pci.cd_centro_custo,pc.cd_centro_custo) = @cd_centro_custo) or (@cd_centro_custo = 0)) and
    pci.dt_item_pedido_compra between @dt_inicial and @dt_final and
    pc.cd_centro_custo is not null

  order by
    c.nm_centro_custo,    
    pci.cd_pedido_compra,
    pci.dt_item_pedido_compra desc,
    pci.cd_item_pedido_compra    
      
