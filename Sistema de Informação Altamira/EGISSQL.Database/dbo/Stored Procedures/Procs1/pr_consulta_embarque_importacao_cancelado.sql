
create procedure pr_consulta_embarque_importacao_cancelado
@data_inicial datetime,
@data_final datetime
as
-- Consulta de Embarques Cancelados
select distinct
       eimp.dt_cancelamento_embarque as Cancelamento, 
       eimp.nm_cancelamento_embarque as Motivo,       
       pimp.cd_fornecedor as Fornecedor,       
       pimp.cd_pedido_importacao as Pedido, 
       eimp.dt_embarque as Emissao, 
       eimp.cd_embarque as Embarque, 
       moe.sg_moeda as Moeda,
       tco.sg_termo_comercial as Termo,       
       eimp.vl_total_embarque as Valor, 
       eimp.vl_frete_embarque as Frete, 
       eimp.vl_cobertura_seguro as Seguro,       
       imp.nm_fantasia as Importador 

from embarque_importacao eimp 
left outer join pedido_importacao pimp on eimp.cd_pedido_importacao = pimp.cd_pedido_importacao
left outer join moeda moe              on moe.cd_moeda              = pimp.cd_moeda
left outer join termo_comercial tco    on tco.cd_termo_comercial    = pimp.cd_termo_comercial
left outer join importador imp         on imp.cd_importador         = pimp.cd_importador


where eimp.dt_cancelamento_embarque >= @data_inicial
  and eimp.dt_cancelamento_embarque <= @data_Final

order by eimp.dt_cancelamento_embarque asc

