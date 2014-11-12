
CREATE procedure pr_pedido_venda_pcp

@ic_parametro         int, -- 1 = Pedido , 2 = Pedido+Item
@cd_pedido_venda      int,
@cd_item_pedido_venda int

as

  Select
    a.cd_pedido_venda             as 'Pedido',
    a.dt_pedido_venda             as 'Emissao',
    a.cd_vendedor                 as 'CodVendedor',
    a.cd_vendedor_interno         as 'CodVendInterno',
    b.cd_item_pedido_venda        as 'Item',
    b.qt_item_pedido_venda        as 'Qtde',
    b.qt_saldo_pedido_venda       as 'Saldo',
    b.vl_unitario_item_pedido     as 'ValorUnitario',
   (b.qt_item_pedido_venda*
    b.vl_unitario_item_pedido)    as 'ValorTotal',
    b.dt_entrega_vendas_pedido    as 'Comercial',
    b.dt_entrega_fabrica_pedido   as 'Fabrica',
    b.dt_reprog_item_pedido       as 'Reprogramacao',
    b.ic_controle_pcp_pedido      as 'Pcp',
    b.ic_reserva_item_pedido      as 'Reservado',
    b.ic_fatura_item_pedido       as 'LibFat',
    b.cd_os_tipo_pedido_venda     as 'OS',
    b.cd_posicao_item_pedido      as 'Posicao',
    b.cd_pdcompra_item_pedido     as 'PedidoCompra',
    b.qt_bruto_item_pedido        as 'PesoBruto', 
    b.qt_liquido_item_pedido      as 'PesoLiquido',
    Descricao =
    Case when a.cd_tipo_pedido = 1 then
      (Select max(nm_produto) from produto where cd_produto = b.CD_PRODUTO)
         when a.cd_tipo_pedido = 2 then  
      (Select max(nm_produto_pedido_venda) from pedido_venda_item_especial 
              where cd_pedido_venda = b.CD_PEDIDO_VENDA and
                    cd_item_pedido_venda = b.CD_ITEM_PEDIDO_VENDA)
    else Null end,
    MascaraProduto =
    Case when a.cd_tipo_pedido = 1 then
      (Select max(cd_mascara_produto) from produto where cd_produto = b.CD_PRODUTO)
         when a.cd_tipo_pedido = 2 then  
      (cast(b.cd_grupo_produto as char(2)) + '9999999')
    else Null end,
    a.cd_cliente                as 'CodCliente',
    c.nm_fantasia_cliente       as 'Cliente',
    d.nm_fantasia_vendedor      as 'Setor',
    e.nm_fantasia_vendedor      as 'VendedorInterno', 
    f.nm_fantasia_usuario       as 'UsuarioAlt',
    b.dt_usuario                as 'DtUsuarioAlt', 
    Arvore =
    case when a.cd_tipo_pedido = 1 then
       case when Exists (Select g.cd_produto from Produto_Composicao g
                         Where g.cd_produto = b.cd_produto) then 'S' else 'N' end
         when a.cd_tipo_pedido = 2 then
       case when Exists (Select h.cd_pedido_venda from Pedido_Venda_Composicao h
                         Where h.cd_pedido_venda = a.cd_pedido_venda and
                               h.cd_item_pedido_venda = b.cd_item_pedido_venda) then 'S' else 'N' end
    else '' end,
    nm_observacao_fabrica1 as 'Obs1',
    nm_observacao_fabrica2 as 'Obs2',
    sg_status_pedido       as 'Status',
    -- Campos para serem alimentados posteriormente
    0 as 'Processo',
    Null as 'DataProcesso',
    0 as 'Previa',
    Null as 'DataPrevia',
    0 as 'Requisicao',
    Null as 'DataRequisicao',
    -- Na tabela de produto
    Null as 'PrevEntradaMaterial',
    -- Data abaixo virá da tabela CADCESP->DTFIMPRO
    -- Se houver data, o label será : Comp. Especiais LIBERADO em :
    -- caso contrário               : Comp. Especiais PRODUÇÃO em :
    Null as 'CompEspLiberado'

  into #TmpItensGeral

  From
    Pedido_Venda a

    Left Outer Join Pedido_Venda_Item b on
      a.cd_pedido_venda = b.cd_pedido_venda
    Left Outer Join Cliente c on
      a.cd_cliente = c.cd_cliente
    Left Outer Join Vendedor d on
      a.cd_vendedor = d.cd_vendedor
    Left Outer Join Vendedor e on
      a.cd_vendedor_interno = e.cd_vendedor
    Left Outer Join EgisAdmin.Dbo.Usuario f on
      b.cd_usuario = f.cd_usuario
    Left Outer Join Status_Pedido g on
      a.cd_status_pedido = g.cd_status_pedido

  Where
    a.cd_pedido_venda = @cd_pedido_venda and
    b.dt_cancelamento_item is null       and  
    a.ic_consignacao_pedido = 'N'        and
    b.cd_item_pedido_venda < 80          and
   (b.qt_item_pedido_venda *
    b.vl_unitario_item_pedido) > 0 

--------------------------------------------------------------------------------------------
if @ic_parametro = 1
--------------------------------------------------------------------------------------------
begin
   select * 
   from #TmpItensGeral 
   order by Item
end
else
--------------------------------------------------------------------------------------------
if @ic_parametro = 2
--------------------------------------------------------------------------------------------
begin
   select * 
   from #TmpItensGeral 
   where Item = @cd_item_pedido_venda
end

