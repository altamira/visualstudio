
CREATE PROCEDURE pr_consulta_itens_pedido_sem_arvore

@dt_inicial datetime,
@dt_final   datetime

AS

-- Seleciona todos os pedido pela data de emissão
Select
  a.cd_cliente                as 'CodCliente',
  b.nm_fantasia_cliente       as 'Cliente',
  a.cd_pedido_venda           as 'Pedido',
  d.cd_item_pedido_venda      as 'Item',
  d.nm_fantasia_produto       as 'NomeFan',
  e.cd_mascara_produto        as 'CodPRod',
  a.dt_pedido_venda           as 'Emissao',
  d.qt_item_pedido_venda      as 'Qtde',
 (d.qt_item_pedido_venda*
  d.vl_unitario_item_pedido)  as 'Venda',
  d.dt_entrega_vendas_pedido  as 'Comercial',
  d.dt_entrega_fabrica_pedido as 'Fabrica',
  d.dt_reprog_item_pedido     as 'Reprogramacao',
  a.cd_vendedor               as 'CodVendedor',  
  c.nm_fantasia_vendedor      as 'Setor',
  Atraso =
  Case when Cast(d.dt_entrega_fabrica_pedido-(GetDate()-1) as Int) >= 0 then Null
       else Cast(d.dt_entrega_fabrica_pedido-(GetDate()-1) as Int)
  end,
  -- Tipo do Pedido : 1 = Normal, 2 = Especial
  TipoPedido = 
  Case when a.cd_tipo_pedido = 1 then 'PV' 
       when a.cd_tipo_pedido = 2 then 'PVE' 
  else Null end,
  d.ds_produto_pedido_venda as 'Descricao',
  /*Descricao =
  Case when a.cd_tipo_pedido = 1 then
    (Select max(nm_produto) from produto where cd_produto = d.CD_PRODUTO)
       when a.cd_tipo_pedido = 2 then  
    (Select max(nm_produto_pedido_venda) from pedido_venda_item_especial 
            where cd_pedido_venda = d.CD_PEDIDO_VENDA and
                  cd_item_pedido_venda = d.CD_ITEM_PEDIDO_VENDA)
  else Null end,*/
  d.ic_controle_pcp_pedido    as 'Pcp',
  d.cd_produto                as 'ProdutoPadrao',
  g.ic_composicao_grupo_prod  as 'Composicao'
-------
into #TmpItensPedidoGeral
-------
from
  Pedido_Venda a,
  Cliente b,
  Vendedor c,
  Pedido_Venda_Item d,
  produto e,
  Grupo_Produto g

where a.dt_pedido_venda between @dt_inicial and
                                @dt_final               and
      a.ic_consignacao_pedido = 'N'                     and
      a.cd_pedido_venda = d.cd_pedido_venda             and 
      d.dt_cancelamento_item is null                    and  
      d.cd_item_pedido_venda < 80                       and
     (d.qt_item_pedido_venda *
      d.vl_unitario_item_pedido) > 0                    and
      -- Liberado para faturamento / prévia
      d.ic_fatura_item_pedido = 'S'                     and
      a.cd_cliente *= b.cd_cliente                      and
      a.cd_vendedor *= c.cd_vendedor                    and
      d.cd_grupo_produto *= g.cd_grupo_produto          and
      d.nm_fantasia_produto *= e.nm_fantasia_produto    

-- Seleção dos pedidos sem árvore de produtos padrão
select * 
into #TmpSemArvorePadrao
from #TmpItensPedidoGeral a
where a.Pcp = 'S' and
      a.TipoPedido = 'PV' and
      a.Composicao = 'S' and
      Not Exists (Select b.cd_produto from Produto_Composicao b
                  Where b.cd_produto = a.ProdutoPadrao)

-- Seleção dos pedidos sem árvore de pedido especial
select * 
into #TmpSemArvorePedido
from #TmpItensPedidoGeral a
where a.Pcp = 'S' and
      a.TipoPedido = 'PVE' and
      Not Exists (Select b.cd_pedido_venda from Pedido_Venda_Composicao b
                  Where b.cd_pedido_venda = a.Pedido and
                        b.cd_item_pedido_venda = a.Item)

-- Inserindo...
insert into #TmpSemArvorePadrao
select * from #TmpSemArvorePedido

-- Resultado...
select * 
from #TmpSemArvorePadrao
order by Emissao,
         Comercial,
         Pedido

