
-------------------------------------------------------------------------------
--sp_helptext pr_consulta_pedido_compra_motorista
-------------------------------------------------------------------------------
--pr_consulta_pedido_compra_motorista
-------------------------------------------------------------------------------
--GBS Global Business Solution Ltda                                        2008
-------------------------------------------------------------------------------
--Stored Procedure : Microsoft SQL Server 2000
--Autor(es)        : Douglas de Paula Lopes
--Banco de Dados   : Egissql
--Objetivo         : 
--Data             : 16.09.2008
--Alteração        : 17.09.2008 
--
--
------------------------------------------------------------------------------
create procedure pr_consulta_pedido_compra_motorista
@dt_inicial      datetime = '',  
@dt_final        datetime = '',
@cd_motorista    integer  = 0
as
      select
        m.cd_motorista, 
        m.nm_motorista,
        m.nm_fantasia_motorista,
        pc.dt_pedido_compra as dt_item_pedido_compra,
        f.nm_fantasia_fornecedor,
        pci.cd_pedido_compra,
        pci.cd_item_pedido_compra,
        pci.cd_mascara_produto,
        p.nm_fantasia_produto,
        p.nm_produto,
        um.sg_unidade_medida,
        pci.qt_item_pedido_compra,
        p.qt_peso_liquido,
        p.qt_peso_bruto,
        isnull(pci.qt_item_pedido_compra,0) *  isnull(p.qt_peso_liquido,0) as TotalPesoLiq,
        isnull(pci.qt_item_pedido_compra,0) *  isnull(p.qt_peso_bruto,0) as TotalPesoBruto,
        pci.vl_item_unitario_ped_comp,
        isnull(pci.qt_item_pedido_compra,0) * isnull(pci.vl_item_unitario_ped_comp,0) as ValorTotalPed,
        pcc.vl_custo_frete_produto as vl_custo_frete_produto,
        isnull(pci.qt_item_pedido_compra,0) * isnull(pcc.vl_custo_frete_produto,0) as ValorTotalFrete   
    from 
        pedido_compra                 pc  with(nolock)
        inner join pedido_compra_item pci with(nolock) on pci.cd_pedido_compra  = pc.cd_pedido_compra
        left outer join motorista     m   with(nolock) on m.cd_motorista        = pc.cd_motorista
        left outer join produto       p   with(nolock) on p.cd_produto          = pci.cd_produto
        left outer join produto_custo pcc with(nolock) on pcc.cd_produto        = pci.cd_produto 
        left outer join fornecedor    f   with(nolock) on f.cd_fornecedor       = pc.cd_fornecedor
        left outer join unidade_medida um with(nolock) on um.cd_unidade_medida  = pci.cd_unidade_medida
    where 
        pc.cd_motorista = case when @cd_motorista = 0 then pc.cd_motorista else @cd_motorista end and
        pci.dt_item_canc_ped_compra is null and  
        pc.dt_pedido_compra between @dt_inicial and @dt_final 
    order by
        pci.cd_pedido_compra,
        pci.cd_item_pedido_compra

