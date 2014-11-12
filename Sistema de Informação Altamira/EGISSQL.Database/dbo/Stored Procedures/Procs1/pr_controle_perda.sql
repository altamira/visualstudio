

/****** Object:  Stored Procedure dbo.pr_controle_perda    Script Date: 13/12/2002 15:08:25 ******/

CREATE PROCEDURE pr_controle_perda

@ic_parametro int,
@cd_cliente int,
@cd_consulta int,
@dt_inicial datetime,
@dt_final datetime

AS

--------------------------------------------------------------------------------------------
  If @ic_parametro = 1 -- Consulta por Cliente
--------------------------------------------------------------------------------------------  

begin

select 
  ci.cd_consulta,
  ci.dt_item_consulta,
  ci.cd_item_consulta,
  ci.dt_perda_consulta_itens,
  ci.nm_fantasia_produto,
  ci.qt_item_consulta,
  ci.vl_unitario_item_consulta,
  ci.vl_unitario_item_consulta * ci.qt_item_consulta as 'vl_total_item',
  ci.dt_entrega_consulta,
  ci.pc_desconto_item_consulta,
 (Select nm_fantasia_vendedor From Vendedor Where cd_vendedor = c.cd_vendedor) as 'nm_vendedor_externo',
 (Select nm_fantasia_vendedor From Vendedor Where cd_vendedor = c.cd_vendedor_interno) as 'nm_vendedor_interno',
  p.nm_fantasia_produto,
  p.nm_produto,
  c.cd_cliente,
  cli.nm_fantasia_cliente,
  cli.nm_razao_social_cliente,
  cli.cd_telefone,
  cli.cd_fax,
  cli.cd_ddd,
  cp.cd_concorrente,
  cp.dt_perda_consulta,
  cp.vl_perda_consulta,
  cp.ds_perda_consulta,
  cp.pc_perda_consulta,
  cp.cd_usuario,
  cp.dt_usuario,
  cp.cd_motivo_perda
from
  Consulta_itens ci
inner join
  Consulta c
on
  c.cd_consulta = ci.cd_consulta

left outer join
  Cliente cli
on
  cli.cd_cliente = c.cd_cliente

left outer join
  Produto p
on
  p.nm_fantasia_produto = ci.nm_fantasia_produto
left outer join
  Consulta_Item_Perda cp
on
  cp.cd_item_consulta = ci.cd_item_consulta
and cp.cd_consulta = ci.cd_consulta
where
  c.cd_cliente = @cd_cliente and
  ci.dt_item_consulta between @dt_inicial and @dt_final and
  ci.dt_fechamento_consulta is null

end

--------------------------------------------------------------------------------------------
else If @ic_parametro = 2 -- Consulta por Proposta
--------------------------------------------------------------------------------------------  

begin

select 
  ci.cd_consulta,
  ci.dt_item_consulta,
  ci.cd_item_consulta,
  ci.dt_perda_consulta_itens,
  ci.nm_fantasia_produto,
  ci.qt_item_consulta,
  ci.vl_unitario_item_consulta,
  ci.vl_unitario_item_consulta * ci.qt_item_consulta as 'vl_total_item',
  ci.dt_entrega_consulta,
  ci.pc_desconto_item_consulta,
 (Select nm_fantasia_vendedor From Vendedor Where cd_vendedor = c.cd_vendedor) as 'nm_vendedor_externo',
 (Select nm_fantasia_vendedor From Vendedor Where cd_vendedor = c.cd_vendedor_interno) as 'nm_vendedor_interno',
  p.nm_fantasia_produto,
  p.nm_produto,
  c.cd_cliente,
  cli.nm_fantasia_cliente,
  cli.nm_razao_social_cliente,
  cli.cd_telefone,
  cli.cd_fax,
  cli.cd_ddd,
  cp.cd_concorrente,
  cp.dt_perda_consulta,
  cp.vl_perda_consulta,
  cp.ds_perda_consulta,
  cp.pc_perda_consulta,
  cp.cd_usuario,
  cp.dt_usuario,
  cp.cd_motivo_perda
from
  Consulta_itens ci
inner join
  Consulta c
on
  c.cd_consulta = ci.cd_consulta

left outer join
  Cliente cli
on
  cli.cd_cliente = c.cd_cliente

left outer join
  Produto p
on
  p.nm_fantasia_produto = ci.nm_fantasia_produto
left outer join
  Consulta_Item_Perda cp
on
  cp.cd_item_consulta = ci.cd_item_consulta
and cp.cd_consulta = ci.cd_consulta
where
  ci.cd_consulta = @cd_consulta and
  ci.dt_item_consulta between @dt_inicial and @dt_final and
  ci.dt_fechamento_consulta is null


end


