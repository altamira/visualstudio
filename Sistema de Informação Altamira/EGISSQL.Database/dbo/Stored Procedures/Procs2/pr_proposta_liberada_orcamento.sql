
CREATE PROCEDURE pr_proposta_liberada_orcamento

@dt_inicial datetime,
@dt_final datetime,
@cd_vendedor int = 0,
@cd_vendedor_externo int = 0

AS


select 
	ci.cd_consulta * cd_item_consulta as 'CampoUnico',
	vi.nm_vendedor as 'VendedorInterno',
	v.nm_vendedor as 'VendedorExterno',
	c.nm_fantasia_cliente as 'Cliente',
	ci.dt_orcamento_liberado_con as 'Data',
	ci.qt_dia_entrega_consulta as 'Dias',
	pv.cd_consulta as 'Proposta',
    ci.cd_item_consulta as 'Item',
    ci.nm_fantasia_produto as 'Fantasia',
	ci.nm_produto_consulta as 'Descrição',
	um.sg_unidade_medida as 'UnidadeMedida',
	ci.qt_item_consulta as 'Qtd',
	(ci.vl_unitario_item_consulta * ci.qt_item_consulta) as 'Valor',
	cp.nm_categoria_produto as 'Categoria'
	
	
from consulta_itens ci with (nolock)
left outer join consulta pv with (nolock) on pv.cd_consulta = ci.cd_consulta
left outer join vendedor vi with (nolock) on vi.cd_vendedor=pv.cd_vendedor_interno
left outer join vendedor v  with (nolock) on v.cd_vendedor=pv.cd_vendedor
left outer join cliente c   with (nolock) on c.cd_cliente=pv.cd_cliente
left outer join unidade_medida um with (nolock) on um.cd_unidade_medida=ci.cd_unidade_medida
left outer join grupo_produto gp  with (nolock) on gp.cd_grupo_produto=ci.cd_grupo_produto
left outer join categoria_produto cp with (nolock) on cp.cd_categoria_produto=gp.cd_categoria_produto
where ic_orcamento_consulta = 'S'
  and dt_orcamento_liberado_con between @dt_inicial and @dt_final
  and IsNull(ci.dt_fechamento_consulta,0)=0
  and vl_unitario_item_consulta > 0
  and IsNull(dt_perda_consulta_itens,0)=0
  and ((@cd_vendedor=0 or IsNull(@cd_vendedor,0)=0) or (pv.cd_vendedor_interno=@cd_vendedor))
  and ((@cd_vendedor_externo=0 or IsNull(@cd_vendedor_externo,0)=0) or (pv.cd_vendedor=@cd_vendedor_externo))

