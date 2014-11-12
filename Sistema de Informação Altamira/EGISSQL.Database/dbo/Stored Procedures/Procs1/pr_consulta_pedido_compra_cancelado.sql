

CREATE PROCEDURE pr_consulta_pedido_compra_cancelado
@ic_parametro        int,
@cd_pedido_compra    int,
@dt_inicial     datetime,
@dt_final       datetime

AS
----------------------------------------------------------------
if @ic_parametro = 1  -- Lista o Pedido de Compra Cancelado.
----------------------------------------------------------------
begin

    select 
      f.nm_fantasia_fornecedor,
      pc.dt_pedido_compra,
      pc.cd_pedido_compra,
      pc.vl_total_pedido_compra,
      po.nm_plano_compra,
      pc.dt_cancel_ped_compra,
      pc.ds_cancel_ped_compra,
      co.nm_fantasia_comprador
    from Pedido_Compra pc left outer join 
         Fornecedor f    on f.cd_fornecedor=pc.cd_fornecedor left outer join 
         Plano_Compra po on po.cd_plano_compra = pc.cd_plano_compra    left outer join 
         Comprador co    on co.cd_comprador = pc.cd_comprador

  where pc.dt_pedido_compra between @dt_inicial and @dt_final and
        ( ( pc.cd_pedido_compra = @cd_pedido_compra ) or (@cd_pedido_compra = 0 ) ) and
        pc.cd_status_pedido in ( 7, 14 ) -- Há dois códigos de Pedidos Cancelados na tabela Status_Pedido

  end

-------------------------------------------------------------------------------
if @ic_parametro = 2    -- Consulta Pedido de Compra por Fornecedor e Status do Pedido
-------------------------------------------------------------------------------
  begin
    select 
      pci.cd_item_pedido_compra      as 'Item',
      pci.dt_item_pedido_compra      as 'Data',
      p.nm_produto                   as 'Produto',
      pci.ds_item_pedido_compra      as 'Descricao',
      pci.qt_item_pedido_compra      as 'Qtd',
      pci.vl_item_unitario_ped_comp  as 'Unitario',
      pci.vl_custo_item_ped_compra   as 'Total',
      nei.cd_nota_entrada            as 'Nota',
      nei.cd_item_nota_entrada       as 'NotaItem',
      nei.qt_item_nota_entrada       as 'QtdRecebida',
      ne.dt_nota_entrada            as 'DataRecebimento'

    from Pedido_Compra_Item pci
    left outer join Pedido_Compra pc on pc.cd_pedido_compra=pci.cd_pedido_compra
    left outer join Produto p on p.cd_produto=pci.cd_produto    
    left outer join Nota_Entrada_Item nei on (nei.cd_pedido_compra=pci.cd_pedido_compra)
      and (nei.cd_item_pedido_compra=pci.cd_item_pedido_compra)
    left outer join Nota_Entrada ne on ne.cd_nota_entrada = nei.cd_nota_entrada

  where pci.cd_pedido_compra = @cd_pedido_compra
  end

  

