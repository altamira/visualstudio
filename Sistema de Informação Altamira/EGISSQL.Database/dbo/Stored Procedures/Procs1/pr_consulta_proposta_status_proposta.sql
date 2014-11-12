
-------------------------------------------------------------------------------
--pr_consulta_proposta_status_proposta
-------------------------------------------------------------------------------
--GBS Global Business Solution Ltda                                        2005
-------------------------------------------------------------------------------
--Stored Procedure : Microsoft SQL Server       2000
--Autor(es)        : Carlos Cardoso Fernandes
--Banco de Dados   : EgisSQL
--Objetivo         : Na consulta de Proposta dentro do botão Abertas, chamada pelo 
--                   form : frmConsultaProposta, existe uma query fixa, qryConsulta_proposta,
--                   nesta sp contem os dados da query.
--
--Data             : 11/07/2005
--Atualizado       : 11/07/2005
--------------------------------------------------------------------------------------------------
create procedure pr_consulta_proposta_status_proposta
@cd_status_proposta int = 0
as

select distinct
  c.cd_consulta,
  i.cd_item_consulta, i.cd_consulta_representante, i.cd_item_consulta_represe,
  cli.nm_fantasia_cliente,
  c.dt_consulta, i.dt_entrega_consulta, i.dt_item_consulta, i.dt_perda_consulta_itens,
  case ic_consulta_item 
    when 'S'  then (Select top 1 sg_servico from Servico where cd_servico = i.cd_servico)
  else 
    i.nm_fantasia_produto 
  end as nm_fantasia_produto,
  case ic_consulta_item 
    when 'S'  then (Select top 1 nm_servico from Servico where cd_servico = i.cd_servico)
  else 
    i.nm_produto_consulta
  end as nm_produto_consulta,
  (Select top 1 nm_fantasia_vendedor 
   from Vendedor where cd_vendedor = c.cd_vendedor)
  as nm_vendedor,
  (Select top 1 nm_fantasia_vendedor 
   from Vendedor where cd_vendedor = c.cd_vendedor_interno)
  as nm_vendedor_int,
  i.qt_item_consulta,
  i.pc_desconto_item_consulta,
  i.vl_lista_item_consulta,
  i.vl_unitario_item_consulta, 
  (i.qt_item_consulta * i.vl_unitario_item_consulta) as vl_total_item_consulta,
  i.pc_ipi,
  i.pc_icms,
  i.qt_dia_entrega_consulta,
  c.ic_fatsmo_consulta,
  c.cd_destinacao_produto,
  u.nm_fantasia_usuario as nm_usuario, 
  c.nm_referencia_consulta,
 ( select top 1 x.cd_pedido_venda 
    from Pedido_Venda_Item x where x.cd_consulta = i.cd_consulta and
                                                       x.cd_item_consulta = i.cd_item_consulta
    order by cd_pedido_venda desc ) as 'cd_pedido_venda',
  ( select top 1 x.cd_item_pedido_venda
    from Pedido_Venda_Item x where x.cd_consulta = i.cd_consulta and
                                                       x.cd_item_consulta = i.cd_item_consulta
    order by cd_pedido_venda desc ) as 'cd_item_pedido_venda',
  ( select top 1 x.qt_item_pedido_venda
    from Pedido_Venda_Item x where x.cd_consulta = i.cd_consulta and
                                                       x.cd_item_consulta = i.cd_item_consulta
    order by cd_pedido_venda desc ) as 'qt_item_pedido_venda'
from
  Consulta c left outer join 
  Consulta_Itens i on c.cd_consulta = i.cd_consulta left outer join  
  EgisAdmin.dbo.Usuario u on c.cd_usuario_atendente = u.cd_usuario
 left outer join Cliente cli
 on  c.cd_cliente = cli.cd_cliente

where
1=1   
order by c.cd_consulta desc, i.cd_item_consulta

