
create procedure pr_consulta_embarque_exportacao_cancelado
@data_inicial datetime,
@data_final datetime
as
-- Consulta de Embarques Cancelados
select distinct
       emb.dt_cancelamento_embarque as Cancelamento, 
       emb.nm_cancelamento_embarque as Motivo,       
       cli.nm_fantasia_cliente as Cliente,       
       emb.cd_pedido_venda as Pedido, 
       emb.dt_embarque as Emissao, 
       emb.cd_embarque as Embarque, 
       moe.sg_moeda as Moeda,
       tco.sg_termo_comercial as Termo,       
       emb.vl_total_embarque as Valor, 
       emb.vl_frete_embarque as Frete, 
       emb.vl_cobertura_seguro as Seguro,       
       exr.nm_fantasia as Exportador 

from embarque emb 
left outer join pedido_venda pdv on pdv.cd_pedido_venda = emb.cd_pedido_venda
left outer join moeda moe on moe.cd_moeda = emb.cd_moeda
left outer join cliente cli on cli.cd_cliente = pdv.cd_cliente
left outer join pedido_venda_exportacao pde on pde.cd_pedido_venda = pdv.cd_pedido_venda
left outer join termo_comercial tco on tco.cd_termo_comercial = pde.cd_termo_comercial
left outer join exportador exr on exr.cd_exportador = pdv.cd_exportador

where emb.dt_cancelamento_embarque >= @data_inicial
  and emb.dt_cancelamento_embarque <= @data_Final

order by emb.dt_cancelamento_embarque

