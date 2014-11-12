Create Procedure pr_consulta_produto_saldo_sem_movimento
---------------------------------------------------
--GBS - Global Business Solution	       2002
-- Stored Procedure: Microsoft SQL Server       2000
-- Autor(es)     : Igor gama
-- Banco de Dados: EgisSQL
-- Objetivo      : Consulta de Produtos que não tiveram movimentação no estoque
-- Data          : 16/01/2003
-- Alterações    : 
---------------------------------------------------
@cd_produto      int = -1,
@cd_fase_produto int,
@dt_inicial	 datetime,
@dt_final	 datetime
as

 select 
   p.cd_mascara_produto,
   p.nm_fantasia_produto,
   p.nm_produto,
   gp.cd_mascara_grupo_produto,
   gp.nm_grupo_produto,
   un.sg_unidade_medida,
   sp.nm_status_produto,
   IsNull(ps.vl_fob_produto, 0.00)            as vl_fob_produto,
   IsNull(ps.vl_custo_contabil_produto, 0.00) as vl_custo_contabil_produto,
   IsNull(ps.vl_fob_convertido, 0.00)         as vl_fob_convertido,
   ps.qt_saldo_reserva_produto,
   ps.qt_saldo_atual_produto,

   (Select MAX(pvi.dt_item_pedido_venda)
    From Pedido_Venda_Item pvi
    Where pvi.cd_produto = p.cd_produto) as dt_ult_venda,

   (Select MAX(pci.dt_item_pedido_compra)
    From Pedido_Compra_Item pci
    Where pci.cd_produto = p.cd_produto) as dt_ult_compra,

    p.vl_produto as vl_produto,
    ABS(p.vl_produto * ps.qt_saldo_reserva_produto) as vl_total_produto,
    pc.vl_custo_produto,
    ABS(pc.vl_custo_produto * ps.qt_saldo_reserva_produto) as vl_custo_total_produto
  From
    Produto 		p  Left Outer Join
    Grupo_Produto 	gp on p.cd_grupo_produto = gp.cd_grupo_produto Left Outer Join
    Produto_Saldo 	ps on p.cd_produto = ps.cd_produto Left Outer Join
    Unidade_Medida 	un on p.cd_unidade_medida = un.cd_unidade_medida Left Outer Join
    Status_Produto      sp on p.cd_status_produto = sp.cd_status_produto left outer join
    Produto_Custo       pc on p.cd_produto = pc.cd_produto
  Where   
    ( (-1) = (@cd_produto) or ps.cd_produto = (@cd_produto)) and
    ps.cd_produto not in (select cd_produto 
                          from movimento_estoque 
                          where dt_movimento_estoque between @dt_inicial and @dt_final) and
    ps.cd_fase_produto = @cd_fase_produto and
    ps.qt_saldo_atual_produto > 0
