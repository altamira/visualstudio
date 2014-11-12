
CREATE PROCEDURE pr_consulta_pedido_importacao_emissao

@dt_inicial 			datetime,
@dt_final 			datetime

AS

select     
  pim.cd_pedido_importacao, 
  pii.cd_item_ped_imp, 
  f.nm_fantasia_fornecedor, 
  sp.sg_status_pedido, 
  p.nm_fantasia_produto, 
  p.nm_produto, 
  pii.qt_item_ped_imp, 
  pii.qt_saldo_item_ped_imp, 
  pii.vl_item_ped_imp, 
  pii.pc_desc_item_ped_imp, 
  (pii.qt_saldo_item_ped_imp * pii.vl_item_ped_imp) * (1 - isnull(pii.pc_desc_item_ped_imp,0)) as vl_total_item, 
  cp.nm_condicao_pagamento, 
  pii.dt_entrega_ped_imp, 
  pii.dt_prev_embarque_ped_imp, 
  pim.dt_pedido_importacao, 
  fab.nm_fantasia, 
  m.nm_moeda, 
  pa.nm_pais, 
  i.nm_idioma, 
  pii.vl_moeda_ped_imp, 
  pii.dt_moeda_ped_importacao,
  pii.dt_cancel_item_ped_imp, 
  mcp.nm_motivo_cancel_pedido, 
  pii.nm_motivo_cancel_item_ped,
  tc.nm_termo_comercial
from         
  produto p right outer join
  fabricante fab right outer join
  motivo_cancelamento_pedido mcp right outer join
  pedido_importacao_item pii on mcp.cd_motivo_cancel_pedido = pii.cd_motivo_cancel_pedido on fab.cd_fabricante = pii.cd_fabricante on p.cd_produto = pii.cd_produto right outer join
  condicao_pagamento cp right outer join
  moeda m right outer join
  pedido_importacao pim left outer join
  idioma i on pim.cd_idioma = i.cd_idioma left outer join 
  pais pa on pim.cd_origem_pais = pa.cd_pais on m.cd_moeda = pim.cd_moeda on cp.cd_condicao_pagamento = pim.cd_condicao_pagamento left outer join
  status_pedido sp on pim.cd_status_pedido = sp.cd_status_pedido left outer join
  fornecedor f on pim.cd_fornecedor = f.cd_fornecedor on pii.cd_pedido_importacao = pim.cd_pedido_importacao left outer join
  termo_comercial tc on pim.cd_termo_comercial = tc.cd_termo_comercial
where     
  pim.dt_pedido_importacao between @dt_inicial and @dt_final

