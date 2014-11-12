

/****** Object:  Stored Procedure dbo.pr_consulta_componentes_especiais    Script Date: 13/12/2002 15:08:18 ******/

CREATE procedure pr_consulta_componentes_especiais

@ic_parametro    int,      -- 1 = Por pedido, 2 = Por data de entrega Pcp
@cd_pedido_venda int,   
@dt_inicial      datetime, 
@dt_final        datetime

as

---------------------------------------------------------------------------------------------
if @ic_parametro = 1 -- Por pedido
---------------------------------------------------------------------------------------------
begin
  Select
    a.cd_pedido_venda           as 'Pedido',
    a.dt_pedido_venda           as 'Emissao',
    b.cd_item_pedido_venda      as 'Item',
    isnull(b.ic_controle_pcp_pedido,'N') as 'Pcp',
--  Pcp = 
--  Case when a.cd_tipo_pedido = 1 then
--    (Select max(ic_controle_pcp_produto) from produto where cd_produto = b.CD_PRODUTO)
--       when a.cd_tipo_pedido = 2 then  
--    (Select max(ic_controle_pcp_grupo) from grupo_produto
--            where cd_grupo_produto = b.CD_GRUPO_PRODUTO)
--  else Null end,
    a.cd_cliente                as 'CodCliente',
    c.nm_fantasia_cliente       as 'Cliente',
    d.nm_fantasia_vendedor      as 'Setor',
    e.cd_item_comp_especial     as 'ItemComponente',
    e.cd_processo               as 'Processo',
    e.qt_componente_especial    as 'QtdeComponente',
    e.nm_componente_especial    as 'DescricaoComponente',
    e.nm_obs_comp_especial      as 'ObsComponente',
    e.dt_producao_comp_especial as 'ProducaoComponente',
    e.dt_entrega_comp_especial  as 'PrazoPcp'

  From
    Pedido_Venda a
    Left Outer Join Pedido_Venda_Item b on
      a.cd_pedido_venda = b.cd_pedido_venda
    Left Outer Join Cliente c on
      a.cd_cliente = c.cd_cliente
    Left Outer Join Vendedor d on
      a.cd_vendedor = d.cd_vendedor
    Inner Join Componente_Especial e on
      b.cd_pedido_venda = e.cd_pedido_venda and
      b.cd_item_pedido_venda = e.cd_item_pedido_venda

  Where
      a.cd_pedido_venda = @cd_pedido_venda  and
      b.ic_controle_pcp_pedido = 'S'        and
      b.dt_cancelamento_item is null        and  
      b.cd_item_pedido_venda < 80           and
     (b.qt_item_pedido_venda *
      b.vl_unitario_item_pedido) > 0        and
      a.ic_consignacao_pedido = 'N'

end

---------------------------------------------------------------------------------------------
if @ic_parametro = 2 -- Por datas de entrega Pcp
---------------------------------------------------------------------------------------------
begin
  Select
    a.cd_pedido_venda           as 'Pedido',
    a.dt_pedido_venda           as 'Emissao',
    b.cd_item_pedido_venda      as 'Item',
    isnull(b.ic_controle_pcp_pedido,'N') as 'Pcp',
    a.cd_cliente                as 'CodCliente',
    c.nm_fantasia_cliente       as 'Cliente',
    d.nm_fantasia_vendedor      as 'Setor',
    e.cd_item_comp_especial     as 'ItemComponente',
    e.cd_processo               as 'Processo',
    e.qt_componente_especial    as 'QtdeComponente',
    e.nm_componente_especial    as 'DescricaoComponente',
    e.nm_obs_comp_especial      as 'ObsComponente',
    e.dt_producao_comp_especial as 'ProducaoComponente',
    e.dt_entrega_comp_especial  as 'PrazoPcp'

  From
    Pedido_Venda a
    Left Outer Join Pedido_Venda_Item b on
      a.cd_pedido_venda = b.cd_pedido_venda
    Left Outer Join Cliente c on
      a.cd_cliente = c.cd_cliente
    Left Outer Join Vendedor d on
      a.cd_vendedor = d.cd_vendedor
    Inner Join Componente_Especial e on
      b.cd_pedido_venda = e.cd_pedido_venda and
      b.cd_item_pedido_venda = e.cd_item_pedido_venda

  Where
      e.dt_entrega_comp_especial between @dt_inicial and 
                                         @dt_final and
      b.ic_controle_pcp_pedido = 'S'  and
      b.dt_cancelamento_item is null  and  
      b.cd_item_pedido_venda < 80     and
     (b.qt_item_pedido_venda *
      b.vl_unitario_item_pedido) > 0  and
      a.ic_consignacao_pedido = 'N'

end



