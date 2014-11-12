
CREATE PROCEDURE pr_consulta_ficha_medida

@ic_parametro         int,
@cd_ficha_medida      int, 
@cd_pedido_venda      int,
@cd_item_pedido_venda int

as

-------------------------------------------------------------------------------
if @ic_parametro = 1    -- Consulta de uma ficha de medida específica ou todas
-------------------------------------------------------------------------------
begin
  select 
    distinct
    fm.cd_ficha_medida             as 'FichaMedida',
    fm.dt_ficha_medida             as 'EmissaoFM', 
    fm.cd_requisicao_compra        as 'Requisicao',
    rc.dt_emissao_req_compra       as 'EmissaoRC',
    fm.cd_pedido_venda             as 'Pedido',
    fm.cd_item_pedido_venda        as 'ItemPV',
    pv.dt_pedido_venda             as 'EmissaoPV',
    c.nm_fantasia_cliente          as 'Cliente',
    pv.cd_vendedor                 as 'CodVendedor', 
    v.nm_fantasia_vendedor         as 'Setor'
  from Ficha_Medida fm
  left outer join Pedido_Venda pv on
    fm.cd_pedido_venda = pv.cd_pedido_venda 
  left outer join Pedido_Venda_Item pvi on
    fm.cd_pedido_venda = pvi.cd_pedido_venda and
    fm.cd_item_pedido_venda = pvi.cd_item_pedido_venda 
  left outer join Requisicao_Compra_Item rci on
    fm.cd_pedido_venda = rci.cd_pedido_venda and
    fm.cd_item_pedido_venda = rci.cd_item_pedido_venda 
  left outer join Requisicao_Compra rc on
    rci.cd_requisicao_compra = rc.cd_requisicao_compra
  left outer join Cliente c on
    pv.cd_cliente = c.cd_cliente
  left outer join Vendedor v on
    pv.cd_vendedor = v.cd_vendedor 
  where 
    (@cd_ficha_medida = 0 or fm.cd_ficha_medida = @cd_ficha_medida)
  order by 
    fm.cd_ficha_medida
end

-------------------------------------------------------------------------------
if @ic_parametro = 2    -- Consulta de ficha de medida por pedido de venda
-------------------------------------------------------------------------------
begin
  select
    distinct
    fm.cd_ficha_medida             as 'FichaMedida',
    fm.dt_ficha_medida             as 'EmissaoFM', 
    rci.cd_requisicao_compra       as 'Requisicao',
    rc.dt_emissao_req_compra       as 'EmissaoRC',
    rci.cd_pedido_venda            as 'Pedido',
    rci.cd_item_pedido_venda       as 'ItemPV',
    pv.dt_pedido_venda             as 'EmissaoPV',
    c.nm_fantasia_cliente          as 'Cliente',
    pv.cd_vendedor                 as 'CodVendedor', 
    v.nm_fantasia_vendedor         as 'Setor'
  from Requisicao_Compra_Item rci
  left outer join requisicao_compra rc on
    rci.cd_requisicao_compra = rc.cd_requisicao_compra     
  inner join pedido_venda_item pvi on
    rci.cd_pedido_venda = pvi.cd_pedido_venda and
    rci.cd_item_pedido_venda = pvi.cd_item_pedido_venda 
  inner join pedido_venda pv on
    pvi.cd_pedido_venda = pv.cd_pedido_venda 
  left outer join Cliente c on
    pv.cd_cliente = c.cd_cliente
  left outer join Vendedor v on
    pv.cd_vendedor = v.cd_vendedor 
  left outer join Ficha_Medida fm on
    rci.cd_pedido_venda = fm.cd_pedido_venda and
    rci.cd_item_pedido_venda = fm.cd_item_pedido_venda and
    rci.cd_requisicao_compra = fm.cd_requisicao_compra 
  where 
    rci.cd_pedido_venda = @cd_pedido_venda and
    rci.cd_item_pedido_venda = @cd_item_pedido_venda
  order by 
    fm.cd_ficha_medida,
    rci.cd_requisicao_compra
end

