

/****** Object:  Stored Procedure dbo.pr_pedido_venda_componentes    Script Date: 13/12/2002 15:08:38 ******/

CREATE procedure pr_pedido_venda_componentes

@dt_inicial datetime,
@dt_final   datetime

as

  Select
    a.cd_pedido_venda           as 'Pedido',
    a.dt_pedido_venda           as 'Emissao',
    b.cd_item_pedido_venda      as 'Item',
    b.qt_item_pedido_venda      as 'Qtde',
   (b.qt_item_pedido_venda*
    b.vl_unitario_item_pedido)  as 'ValorTotal',
    b.dt_entrega_vendas_pedido  as 'Comercial',
    b.dt_entrega_fabrica_pedido as 'Fabrica',
    b.dt_reprog_item_pedido     as 'Reprogramacao',
    b.ic_controle_pcp_pedido    as 'Pcp',
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
    g.cd_item_comp_especial     as 'ItemComponente',
    g.cd_processo               as 'Processo',
    g.qt_componente_especial    as 'QtdeComponente',
    g.cd_requisicao_compra      as 'Requisicao',
    g.nm_componente_especial    as 'DescricaoComponente',
    g.nm_obs_comp_especial      as 'ObsComponente',
    g.dt_necessidade_comp_esp   as 'Necessidade',
    g.dt_atualizacao_comp_esp   as 'Atualizacao',
    g.dt_entrega_comp_especial  as 'EntregaComponente',
    g.dt_producao_comp_especial as 'ProducaoComponente'

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
    Left Outer Join SapAdmin.Dbo.Usuario f on
      b.cd_usuario = f.cd_usuario
    Inner Join Componente_Especial g on
      b.cd_pedido_venda = g.cd_pedido_venda and
      b.cd_item_pedido_venda = g.cd_item_pedido_venda

  Where
      g.dt_entrega_comp_especial between @dt_inicial and @dt_final and
      b.dt_cancelamento_item is null                               and  
      a.ic_consignacao_pedido = 'N'                                and
      b.cd_item_pedido_venda < 80                                  and
     (b.qt_item_pedido_venda *
      b.vl_unitario_item_pedido) > 0 

select * 
from #TmpItensGeral
where Pcp = 'S'



