
create procedure pr_consulta_previsao_pagamento_importacao

@dt_inicial  datetime,
@dt_final    datetime,
@cd_pedido_imp int


as

select

  f.nm_fantasia_fornecedor     as 'Fornecedor',   
 fe.nm_forma_entrega           as 'FormaEntrega',
  p.cd_pedido_importacao       as 'Pedido',
  p.dt_pedido_importacao       as 'Data',
  p.vl_pedido_importacao       as 'ValorPedido',
  p.dt_prev_emb_ped_imp        as 'EmbarquePrevisto',
  p.nm_emb_ped_imp             as 'DocumentoEmbarque',
  pa.nm_pais                   as 'Pais',
  tc.sg_termo_comercial        as 'Incoterm',
  mo.sg_moeda                  as 'Moeda',
  t.nm_fantasia                as 'Transportadora',
  co.nm_comprador              as 'Comprador',
  p.dt_canc_pedido_importacao  as 'Cancelamento',
  p.nm_canc_pedido_importacao  as 'Motivo'
from
  Pedido_Importacao p left outer join
  Fornecedor        f on   p.cd_fornecedor        = f.cd_fornecedor left outer join
  Pais             pa on   p.cd_Origem_pais       = pa.cd_pais      left outer join
  Termo_Comercial  tc on   p.cd_termo_comercial   = tc.cd_termo_comercial left outer join
  Moeda            mo on   p.cd_moeda             = mo.cd_moeda left outer join
  Comprador        co on   p.cd_comprador         = co.cd_comprador left outer join
  Transportadora   t  on   p.cd_transportadora    = t.cd_transportadora left outer join
  Forma_Entrega    fe on   p.cd_forma_entrega     = fe.cd_forma_entrega             

where
  ( (@cd_pedido_imp = 0 and p.dt_pedido_importacao between @dt_inicial and @dt_final) or
    (p.cd_pedido_importacao = @cd_pedido_imp))
 
 


