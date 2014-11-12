
------------------------------------------------------------------------------------------------------
--pr_consulta_produto_pedido_compra
---------------------------------------------------
--GBS - Global Business Solution	       2002
------------------------------------------------------------------------------------------------------
--Stored Procedure: Microsoft SQL Server       2000
--Autor(es): ????
--Banco de Dados: EGISSQL
--Objetivo: Consulta de Produtos por Pedido de Compra
--Data: ????
--Atualizado: 16/08/2002 - Colocado Cabeçalho
--                       - Acertado por causa da Mudança na Modelagem
--                       - Daniel C. neto. 
--          : 21/02/2005 - Modificado o where para trazer tudo se o cd_produto = 0 - Clelson Camargo
--			 - Corrigido o drop/create procedure
-- 14.08.2006 - Acerto na Consulta de Pedidos de Serviços = Carlos Fernandes
------------------------------------------------------------------------------------------------------

create  PROCEDURE pr_consulta_produto_pedido_compra
@ic_parametro    int, 
@cd_produto      int

AS

-------------------------------------------------------------------------------
if @ic_parametro = 1    -- Consulta Produto nos Pedidos de Compra
-------------------------------------------------------------------------------
  begin
    select 
      pci.dt_item_pedido_compra as 'dt_pedido_compra',
      pci.cd_pedido_compra,
      pci.cd_item_pedido_compra,
      pci.qt_item_pedido_compra,
      pci.qt_item_pesliq_ped_compra,
      pci.qt_item_pesbr_ped_compra,
      pci.vl_item_unitario_ped_comp,
      pci.vl_custo_item_ped_compra,
      nei.cd_nota_entrada,
      nei.cd_item_nota_entrada,
      nei.qt_item_nota_entrada,
      ne.dt_nota_entrada,
      isnull(pci.qt_area_produto,0) as qt_area_produto,
      isnull(pci.qt_area_produto,0) * isnull(pci.qt_item_pedido_compra,0) as qt_total_area
    from Pedido_Compra_Item pci
    left outer join Pedido_Compra pc      on pc.cd_pedido_compra=pci.cd_pedido_compra
    left outer join Nota_Entrada_Item nei on (nei.cd_pedido_compra=pci.cd_pedido_compra) and 
                                             (nei.cd_item_pedido_compra=pci.cd_item_pedido_compra)
    left outer join Nota_Entrada ne       on (ne.cd_nota_entrada = nei.cd_nota_entrada)
  where
   (@cd_produto = 0) or (pci.cd_produto = @cd_produto) -- Clelson(21.02.2005)
  order by
   pci.dt_item_pedido_compra desc
  end
  

