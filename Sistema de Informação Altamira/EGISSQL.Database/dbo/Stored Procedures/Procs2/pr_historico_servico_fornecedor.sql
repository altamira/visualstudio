
create procedure pr_historico_servico_fornecedor

@dt_inicial datetime,
@dt_final datetime,
@cd_fornecedor int,
@cd_servico int

as

select
  pc.cd_fornecedor as Fornecedor, 
  pci.dt_item_pedido_compra as Data,
  pci.cd_pedido_compra as Pedido,
  pci.cd_item_pedido_compra as Item,
  pci.qt_item_pedido_compra as Qtd,
  pci.vl_item_unitario_ped_comp as ValorUnitario,
  pci.vl_total_item_pedido_comp as ValorTotal,
  pci.pc_item_descto_ped_compra as Perc_Desc,
  (pci.vl_total_item_pedido_comp * pci.pc_item_descto_ped_compra / 100) as Desconto,
  pci.vl_total_item_pedido_comp - (pci.vl_total_item_pedido_comp * pci.pc_item_descto_ped_compra / 100) as Liquido,
  pci.pc_ipi as Perc_Ipi,
  opc.nm_opcao_compra as Opcao_Compra
  
from
  pedido_compra_item pci
left outer join pedido_compra pc
on pci.cd_pedido_compra = pc.cd_pedido_compra
left outer join opcao_compra opc
on pc.cd_opcao_compra = opc.cd_opcao_compra

where pc.dt_pedido_compra between @dt_inicial and @dt_final 
  and pc.cd_fornecedor = @cd_fornecedor 
  and pci.cd_servico = @cd_servico 

