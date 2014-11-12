
CREATE procedure pr_dados_pedido_previa

@cd_pedido_venda       int,
@cd_item_pedido_venda  int

as

select 
       a.dt_credito_pedido_venda     as 'DataCredito',   -- Crédito liberado
       c.nm_fantasia_cliente         as 'Cliente',
       case when exists ( select top 1 x.cd_pedido_venda from Pedido_Venda_Item x
			  where
			    x.qt_saldo_pedido_venda > 0 and 
    			    x.dt_cancelamento_item is null and
    			    x.dt_desconto_item_pedido is null and 
    			    x.ic_desconto_item_pedido = 'S' and 
                            x.pc_desconto_item_pedido > 0 and
			    x.cd_pedido_venda = b.cd_pedido_venda and
			    x.cd_item_pedido_venda = b.cd_item_pedido_venda)
       then 'N' else 'S' end as 'Desconto',      -- Desconto liberado
       b.dt_cancelamento_item        as 'DataCancelado', -- Cancelado   
       case when b.ic_progfat_item_pedido = 'S' and 
		 b.qt_progfat_item_pedido >= b.qt_saldo_pedido_venda then 'S'
	    else 'N' end as 'Reservado',     -- Já está na previa
       b.qt_item_pedido_venda        as 'Qtde',
       b.qt_saldo_pedido_venda       as 'Saldo',
       b.ic_etiqueta_emb_pedido      as 'Etiqueta',
       case when b.cd_produto > 0 then
         p.qt_peso_liquido 
       else
         qt_liquido_item_pedido end as 'LiquidoItem',
       BrutoUnitario = 
       Case when (qt_bruto_item_pedido > 0) and (qt_item_pedido_venda > 0) then
          qt_bruto_item_pedido / qt_item_pedido_venda
       else 0 end,
       LiquidoUnitario = 
       Case when (qt_liquido_item_pedido > 0) and (qt_item_pedido_venda > 0) then
          qt_liquido_item_pedido / qt_item_pedido_venda
       else 0 end,
       case when b.cd_produto > 0 then
         p.qt_peso_bruto
       else
         qt_bruto_item_pedido end as 'BrutoItem',
       case when b.cd_produto > 0 then
         b.qt_saldo_pedido_venda * p.qt_peso_bruto 
       else
         b.qt_saldo_pedido_venda * qt_bruto_item_pedido end as 'BrutoSaldo',
  
       case when b.cd_produto > 0 then
         b.qt_saldo_pedido_venda * p.qt_peso_liquido 
       else
         b.qt_saldo_pedido_venda * qt_liquido_item_pedido end as 'LiquidoSaldo',
       b.vl_unitario_item_pedido     as 'VlrUnitario',
       b.nm_fantasia_produto,
       b.nm_produto_pedido,
       b.qt_progfat_item_pedido,
       b.qt_saldo_pedido_venda*
          b.vl_unitario_item_pedido  as 'VlrTotal'

from Pedido_Venda a inner join
     Pedido_Venda_Item b on b.cd_pedido_venda      = a.cd_pedido_venda left outer join
     Cliente c on a.cd_cliente = c.cd_cliente left outer join 
     Produto p on p.cd_produto = b.cd_produto


where b.cd_pedido_venda      = @cd_pedido_venda and
      b.cd_item_pedido_venda = @cd_item_pedido_venda


