

/****** Object:  Stored Procedure dbo.pr_proposta_comercial_produto    Script Date: 13/12/2002 15:08:39 ******/

CREATE PROCEDURE pr_proposta_comercial_produto

@nm_fantasia_produto varchar(30),
@dt_inicial datetime,
@dt_final datetime

AS

--------------------------------------------------------------------------------------------  
If @nm_fantasia_produto = '' -- Lista todos os produtos
--------------------------------------------------------------------------------------------  

begin

select 
  ci.nm_fantasia_produto  as 'Produto',
  ci.nm_produto_consulta  as 'Descricao',
  cli.nm_fantasia_cliente as 'Cliente',
  c.cd_vendedor,
 (Select nm_fantasia_vendedor From Vendedor Where cd_vendedor = c.cd_vendedor) as 'nm_vendedor_externo',
  c.cd_vendedor_interno,
 (Select nm_fantasia_vendedor From Vendedor Where cd_vendedor = c.cd_vendedor_interno) as 'nm_vendedor_interno',
  ci.dt_item_consulta  as 'Emissao',
  c.ic_fatsmo_consulta as 'Status',
  ci.cd_consulta       as 'Proposta',
  ci.cd_item_consulta as 'Item',
  ci.qt_item_consulta as 'Qtd',
  ci.pc_desconto_item_consulta as '%Descto',
  ci.vl_lista_item_consulta as 'PreçoLista',
  (Select vl_unitario_item_pedido from Pedido_Venda_Item where cd_pedido_venda = ci.cd_pedido_venda and cd_item_pedido_venda = ci.cd_item_pedido_venda ) as 'Preço_Venda'

from
  Consulta_itens ci
inner join
  Consulta c
on
  c.cd_consulta = ci.cd_consulta

left outer join
  Cliente cli
on
  c.cd_cliente = cli.cd_cliente

where 
  ci.dt_item_consulta between @dt_inicial and @dt_final

order by Produto, Emissão    

end

--------------------------------------------------------------------------------------------
else
--------------------------------------------------------------------------------------------  

begin

select 
  ci.nm_fantasia_produto  as 'Produto',
  ci.nm_produto_consulta  as 'Descricao',
  cli.nm_fantasia_cliente as 'Cliente',
  c.cd_vendedor,
 (Select nm_fantasia_vendedor From Vendedor Where cd_vendedor = c.cd_vendedor) as 'nm_vendedor_externo',
  c.cd_vendedor_interno,
 (Select nm_fantasia_vendedor From Vendedor Where cd_vendedor = c.cd_vendedor_interno) as 'nm_vendedor_interno',
  ci.dt_item_consulta          as 'Emissao',
  c.ic_fatsmo_consulta         as 'Status',
  ci.cd_consulta               as 'Proposta',
  ci.cd_item_consulta          as 'Item',
  ci.qt_item_consulta          as 'Qtd',
  ci.pc_desconto_item_consulta as '%Descto',
  ci.vl_lista_item_consulta as 'PreçoLista',
  ci.vl_unitario_item_consulta as 'Preço_Venda'

from
  Consulta_itens ci
inner join
  Consulta c
on
  c.cd_consulta = ci.cd_consulta

left outer join
  Cliente cli
on
  c.cd_cliente = cli.cd_cliente

where 
  ci.nm_fantasia_produto like @nm_fantasia_produto + '%' and
  ci.dt_item_consulta between @dt_inicial and @dt_final

order by Produto, Emissão    

end


