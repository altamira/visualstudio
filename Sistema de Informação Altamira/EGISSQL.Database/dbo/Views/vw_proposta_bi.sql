
--select * from consulta_itens

CREATE VIEW vw_proposta_bi
AS 
  select
    c.cd_consulta,
    c.dt_consulta,
    c.cd_cliente,
    c.cd_vendedor,
    c.vl_total_consulta,
    c.ic_consignacao_consulta,
   ci.cd_item_consulta,
   ci.qt_item_consulta,
   ci.vl_unitario_item_consulta,
   ci.qt_item_consulta * ci.vl_unitario_item_consulta as TotalItem,
   ci.cd_produto,
   ci.cd_grupo_produto,
   ci.cd_categoria_produto,
   ci.cd_pedido_venda,
   ci.dt_perda_consulta_itens,
   ci.pc_desconto_item_consulta   
  from
    Consulta  c    inner join
    Consulta_Itens ci on c.cd_consulta = ci.cd_consulta 

