
CREATE PROCEDURE pr_consulta_pedido_compra_nota_fiscal
@cd_fornecedor as int,
@cd_nota_entrada as int,
@cd_serie_nota_fiscal as int



AS

select
  distinct
  nei.cd_nota_entrada,
  nei.cd_fornecedor,
  ne.cd_serie_nota_fiscal,
  ne.nm_serie_nota_entrada,
  pci.cd_pedido_compra,
  pci.cd_item_pedido_compra,
  pci.qt_item_pedido_compra,
  pci.qt_saldo_item_ped_compra,
  pci.dt_item_nec_ped_compra,
  pci.dt_item_pedido_compra
from 
  Pedido_Compra_Item pci,
  Nota_Entrada ne,
  Nota_Entrada_Item nei
where
  ne.cd_fornecedor = @cd_fornecedor and
  ne.cd_nota_entrada = @cd_nota_entrada and
  ne.cd_serie_nota_fiscal = @cd_serie_nota_fiscal and

  ne.cd_fornecedor = nei.cd_fornecedor and
  ne.cd_nota_entrada = nei.cd_nota_entrada and
  pci.cd_pedido_compra = nei.cd_pedido_compra
order by
  pci.cd_pedido_compra,
  pci.cd_item_pedido_compra

