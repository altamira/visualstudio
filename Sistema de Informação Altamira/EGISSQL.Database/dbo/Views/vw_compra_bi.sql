
--select cd_departamento,* from pedido_compra

CREATE VIEW vw_compra_bi
AS 
  select
    pc.cd_pedido_compra,
    pc.dt_pedido_compra,
    pc.cd_fornecedor,
    pc.cd_condicao_pagamento,
    f.nm_fantasia_fornecedor,
    pc.cd_comprador,
    pc.vl_total_pedido_compra,
    pc.cd_departamento,
    pc.cd_aplicacao_produto
  from
    Pedido_Compra pc with (nolock)
    left outer join Fornecedor f           on pc.cd_fornecedor = f.cd_fornecedor
    
  where
    pc.dt_cancel_ped_compra is null
