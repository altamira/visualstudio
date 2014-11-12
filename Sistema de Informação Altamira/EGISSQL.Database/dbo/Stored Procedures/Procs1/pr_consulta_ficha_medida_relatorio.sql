
CREATE PROCEDURE pr_consulta_ficha_medida_relatorio


@ic_parametro         int,
@cd_ficha_medida      int,
@cd_pedido_venda      int,
@cd_item_pedido_venda int

as
-------------------------------------------------------------------------------
if @ic_parametro = 1    -- Consulta de uma ficha de medida específica ou todas
-------------------------------------------------------------------------------
begin
  select distinct
    fm.cd_ficha_medida                                           as 'NumeroFichaMedida' ,
    fm.cd_pedido_venda                                           as 'NumeroPedidoVenda' ,
    fm.cd_item_pedido_venda                                      as 'CdItemPedidoVenda' ,
    c.nm_fantasia_cliente                                        as 'NomeCliente'       ,
    rci.cd_requisicao_compra                                     as 'NumeroRequisicao'  ,
    pc.cd_mascara_plano_compra                                   as 'Classificacao'     ,
    fm.dt_ficha_medida                                           as 'DataFM'            , 
    pv.dt_pedido_venda                                           as 'DataPV'            ,
    pvi.dt_entrega_vendas_pedido                                 as 'DataEntrega'       ,
    pvi.dt_item_pedido_venda                                     as 'DataVenda'         ,
    (select top 1 dt_item_nec_req_compra
     from Requisicao_Compra_Item
     where
       cd_pedido_venda = fm.cd_pedido_venda and
       cd_item_pedido_venda = fm.cd_item_pedido_venda)           as 'DataEntrada'       ,
    convert( varchar(500),pvi.ds_produto_pedido_venda )          as 'Descricao'         ,
    rc.dt_emissao_req_compra                                     as 'EmissaoRC'         
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
  left outer join Plano_Compra pc on
    pc.cd_plano_compra = rc.cd_plano_compra
  where 
    (@cd_ficha_medida = 0 or fm.cd_ficha_medida = @cd_ficha_medida)
  order by 
    fm.cd_ficha_medida

end   

-------------------------------------------------------------------------------
if @ic_parametro = 2    -- Consulta de ficha de medida por pedido de venda
-------------------------------------------------------------------------------
begin
  select distinct
    fm.cd_ficha_medida                                           as 'NumeroFichaMedida' ,
    fm.cd_pedido_venda                                           as 'NumeroPedidoVenda' ,
    fm.cd_item_pedido_venda                                      as 'CdItemPedidoVenda' ,
    c.nm_fantasia_cliente                                        as 'NomeCliente'       ,
    rci.cd_requisicao_compra                                     as 'NumeroRequisicao'  ,
    pc.cd_mascara_plano_compra                                   as 'Classificacao'     ,
    fm.dt_ficha_medida                                           as 'DataFM'            , 
    pv.dt_pedido_venda                                           as 'DataPV'            ,
    pvi.dt_entrega_vendas_pedido                                 as 'DataEntrega'       ,
    pvi.dt_item_pedido_venda                                     as 'DataVenda'         ,
    (select top 1 dt_item_nec_req_compra
     from Requisicao_Compra_Item
     where
       cd_pedido_venda = fm.cd_pedido_venda and
       cd_item_pedido_venda = fm.cd_item_pedido_venda)           as 'DataEntrada'       ,
    convert( varchar(500),pvi.ds_produto_pedido_venda )          as 'Descricao'         ,
    rc.dt_emissao_req_compra                                     as 'EmissaoRC'         
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
  left outer join Plano_Compra pc on
    pc.cd_plano_compra = rc.cd_plano_compra
  where 
     rci.cd_pedido_venda = @cd_pedido_venda           and
     rci.cd_item_pedido_venda = @cd_item_pedido_venda
end
 
   
