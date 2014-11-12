
CREATE PROCEDURE pr_consulta_pedido_compra_documento_pagar

@cd_documento_pagar int

as

select 
  distinct(pc.cd_pedido_compra)  as 'Pedido',
  pc.dt_pedido_compra            as 'Emissao',
  f.nm_fantasia_fornecedor       as 'Fornecedor',
  pc.vl_total_pedido_compra      as 'TotalPedido',
  cp.nm_condicao_pagamento       as 'CondicaoPagamento',
  co.nm_fantasia_comprador       as 'Comprador',
  pc.dt_cancel_ped_compra        as 'Cancelamento',
  pc.ds_cancel_ped_compra        as 'Motivo'


from
  Documento_Pagar    dp inner join
  Nota_Entrada       ne on   dp.cd_nota_fiscal_entrada = ne.cd_nota_entrada       and
 			     dp.cd_fornecedor          = ne.cd_fornecedor inner join
  Nota_Entrada_Item  nei on  ne.cd_nota_entrada        = nei.cd_nota_entrada and 
			     dp.cd_fornecedor          = ne.cd_fornecedor inner join
  Pedido_Compra      pc  on  nei.cd_pedido_compra      = pc.cd_pedido_compra left outer join
  Condicao_Pagamento cp  on  pc.cd_condicao_pagamento  = cp.cd_condicao_pagamento left outer join
  Comprador          co  on  pc.cd_comprador           = co.cd_comprador          left outer join
  Fornecedor         f   on  pc.cd_fornecedor          = f.cd_fornecedor
where
  @cd_documento_pagar       = dp.cd_documento_pagar and
  nei.cd_fornecedor         = dp.cd_fornecedor


--sp_help documento_pagar
--sp_help nota_entrada
--sp_help nota_entrada_item
--sp_help pedido_compra
