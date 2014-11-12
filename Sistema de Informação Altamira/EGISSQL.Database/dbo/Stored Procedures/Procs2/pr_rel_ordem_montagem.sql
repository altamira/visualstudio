

/****** Object:  Stored Procedure dbo.pr_rel_ordem_montagem    Script Date: 13/12/2002 15:08:40 ******/

CREATE PROCEDURE pr_rel_ordem_montagem
@cd_om int

AS

 Select 
  om.dt_om,
   ( Select nm_fantasia_cliente from Cliente where cd_cliente = IsNull(pv.cd_cliente,c.cd_cliente)) as 'Cliente',
  IsNull(om.cd_pedido_venda, om.cd_consulta) as 'Numero',
  case om.cd_pedido_venda when null then 'S' else 'N' end as 'Pedido', -- Colocado pra saber se é consulta ou Pedido_Venda,
  p.nm_fantasia_produto,
  0 as 'Qtd',
  m.nm_om_motivo,
  om.nm_om,
  om_comp.cd_item_om,
  ( Select nm_fantasia_produto from Produto where om_comp.cd_produto = cd_produto) as 'ProdutoComp',
  om_comp.qt_item_om,
  'A Definir' as 'EndComp',
  om_dev.cd_item_om_devolucao,
  ( Select nm_fantasia_produto from Produto where cd_produto = om_dev.cd_produto) as 'ProdutoDev', 
  om_dev.qt_item_om_devolucao,
  'A Definir' as 'EndDev',
  v.nm_fantasia_vendedor,
  om.ds_obs_om

from
  OM om
left outer join
 Pedido_Venda pv
on
  pv.cd_pedido_venda = om.cd_pedido_venda
left outer join
  Consulta c
on
  c.cd_consulta = om.cd_consulta

left outer join
  OM_Motivo m
on
  m.cd_om_motivo = om.cd_om_motivo

left outer join
  OM_Composicao om_comp
on
  om_comp.cd_om = om.cd_om
left outer join
  OM_Devolucao om_dev
on
  om_dev.cd_om = om.cd_om
left outer join
  Produto p
on
  p.cd_produto = om.cd_produto

left outer join
  Vendedor v
on
  v.cd_vendedor = om.cd_vendedor_interno
  
where 
  om.cd_om = @cd_om

