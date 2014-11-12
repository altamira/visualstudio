
CREATE PROCEDURE pr_mapa_aberto_vendedor
-------------------------------------------------------------------------------
--pr_mapa_aberto_vendedor
-------------------------------------------------------------------------------
--GBS - Global Business Solution Ltda                                      2004
-------------------------------------------------------------------------------
--Stored Procedure	: Microsoft SQL Server 2000
--Autor(es)		: Daniel Carrasco Neto
--Banco de Dados	: EGISSQL
--Objetivo		: Consulta Mapa em Aberto por Vendedor
--Data			: 19/07/2002
--Desc. Alteração	: 
-- Observação           : - Baseado no pr_mapa_pedidos_aberto_vendedor
-- Alterado por         : Igor Gama - 08.03.2004
--                        - Nas colunas de saldo e de vl_aberto, estavam sendo calculados errados
--                          Pois para saber a quantidade de um item que esta em aberto, basta somente
--                          mostra a coluna de saldo de um pedido de venda daquele vendedor e para se 
--                          ter uma prévia do valor que esta em aberto, basta pegar esta quantidade do
--                          saldo e multiplicar pelo saldo em aberto e isso mostrará o valor em aberto.  
--                      : 20/12/2004 - Acerto do Cabeçalho -  Sérgio Cardoso 
--                      : 30.05.2006 - Categoria de Produto - Carlos Fernandes
--------------------------------------------------------------------------------------------------------
  @cd_categoria_produto  int = 0,
  @cd_grupo_categoria    int = 0,
  @cd_vendedor           int = 0,
  @dt_base               datetime     --Data Base

AS

select distinct *
from

(

SELECT                
  gc.nm_grupo_categoria, 
  cp.nm_categoria_produto, 
  cp.sg_categoria_produto,
  c.nm_fantasia_cliente, 
  v.nm_fantasia_vendedor, 
  pvi.dt_entrega_vendas_pedido,
  pvi.dt_item_pedido_venda, 
  pvi.ic_libpcp_item_pedido,
  pvi.vl_lista_item_pedido,
  pvi.qt_item_pedido_venda,
  pvi.qt_item_pedido_venda * pvi.vl_unitario_item_pedido AS vl_venda, 
  pvi.nm_produto_pedido,
  nsi.cd_pedido_venda, 
  nsi.cd_item_pedido_venda, 
  IsNull(pvi.qt_saldo_pedido_venda,0) as 'Saldo',
  (IsNull(pvi.qt_saldo_pedido_venda,0) * pvi.vl_unitario_item_pedido) as 'VlAberto'

FROM                  
  Grupo_Categoria gc LEFT OUTER JOIN
  Pedido_Venda_Item pvi LEFT OUTER JOIN
  Pedido_Venda pv ON pv.cd_pedido_venda = pv.cd_pedido_venda RIGHT OUTER JOIN
  Nota_Saida_Item nsi ON nsi.cd_pedido_venda = pvi.cd_pedido_venda AND nsi.cd_item_pedido_venda = pvi.cd_item_pedido_venda left outer join
  Nota_Saida ns ON ns.cd_nota_saida = nsi.cd_nota_saida LEFT OUTER JOIN
  Categoria_Produto cp ON pvi.cd_categoria_produto = cp.cd_categoria_produto ON gc.cd_grupo_categoria = cp.cd_grupo_categoria LEFT OUTER JOIN
  Vendedor v ON pv.cd_vendedor = v.cd_vendedor LEFT OUTER JOIN
  Cliente c ON ns.cd_cliente = c.cd_cliente LEFT OUTER JOIN
  Operacao_Fiscal ofi on ofi.cd_operacao_fiscal = ns.cd_operacao_fiscal

WHERE     
  pvi.cd_categoria_produto = case when @cd_categoria_produto = 0 then pvi.cd_categoria_produto else @cd_categoria_produto end and
  pvi.dt_item_pedido_venda <= @dt_base and
  IsNull(pv.cd_vendedor,0) = ( case when @cd_vendedor = 0 then 
                                 IsNull(pv.cd_vendedor,0) else
                                @cd_vendedor end ) and
  IsNull(pvi.cd_grupo_categoria,0) = ( case when @cd_grupo_categoria = 0 then
                                         IsNull(pvi.cd_grupo_categoria,0) else
                                        @cd_grupo_categoria end ) and
  IsNull(ofi.ic_comercial_operacao,'N') = 'S'                    and
  -- Só trazer pedidos de venda com saldo = 0 ou em com o item > saldo ( Pedidos de venda com saldos negativos não irá trazer.)
  IsNull(pvi.qt_saldo_pedido_venda,0) = ( case when IsNull(pvi.qt_saldo_pedido_venda,0) = 0 then
                                            IsNull(pvi.qt_saldo_pedido_venda,0) 
                                            when IsNull(pvi.qt_saldo_pedido_venda,0) > 0 and 
                                                       ( pvi.qt_item_pedido_venda > pvi.qt_saldo_pedido_venda ) then
                                              IsNull(pvi.qt_saldo_pedido_venda,0) else
                                              IsNull(pvi.qt_saldo_pedido_venda,0) + 1 end ) AND 
   -- Pedido Faturado Total ou Parcial apos o periodo
  (ns.dt_cancel_nota_saida IS NULL) AND 
  IsNull(ns.cd_status_nota,0) <> 7 and
  isNull(pvi.ic_smo_item_pedido_venda,'N') = 'N' and
  pvi.dt_cancelamento_item is null and
  ( IsNull(pvi.qt_item_pedido_venda,0) * IsNull(pvi.vl_unitario_item_pedido,0)) > 0 and		
  cp.cd_grupo_categoria is not null                 and
  ns.dt_nota_saida > @dt_base                       and
  isnull(nsi.cd_status_nota,0) <> 7         

) a union

(

SELECT                
  gc.nm_grupo_categoria, 
  cp.nm_categoria_produto, 
  cp.sg_categoria_produto,
  c.nm_fantasia_cliente, 
  v.nm_fantasia_vendedor, 
  pvi.dt_entrega_vendas_pedido,
  pvi.dt_item_pedido_venda, 
  pvi.ic_libpcp_item_pedido,
  pvi.vl_lista_item_pedido,
  pvi.qt_item_pedido_venda,
  pvi.qt_item_pedido_venda * pvi.vl_unitario_item_pedido AS vl_venda, 
  pvi.nm_produto_pedido,
  nsi.cd_pedido_venda, 
  nsi.cd_item_pedido_venda, 
  IsNull(pvi.qt_saldo_pedido_venda,0) as 'Saldo',
  (IsNull(pvi.qt_saldo_pedido_venda,0) * pvi.vl_unitario_item_pedido) as 'VlAberto'

FROM                  
  Grupo_Categoria gc  with (nolock) 
  LEFT OUTER JOIN  Pedido_Venda_Item pvi 
  LEFT OUTER JOIN  Pedido_Venda pv        ON pv.cd_pedido_venda = pvi.cd_pedido_venda 
  RIGHT OUTER JOIN Nota_Saida_Item nsi    ON nsi.cd_pedido_venda = pvi.cd_pedido_venda AND nsi.cd_item_pedido_venda = pvi.cd_item_pedido_venda left outer join
  Nota_Saida ns ON ns.cd_nota_saida = nsi.cd_nota_saida  left outer join
  Categoria_Produto cp ON pvi.cd_categoria_produto = cp.cd_categoria_produto ON gc.cd_grupo_categoria = cp.cd_grupo_categoria LEFT OUTER JOIN
  Vendedor v ON pv.cd_vendedor = v.cd_vendedor LEFT OUTER JOIN
  Cliente c ON ns.cd_cliente = c.cd_cliente    
WHERE     
  pvi.cd_categoria_produto = case when @cd_categoria_produto = 0 then pvi.cd_categoria_produto else @cd_categoria_produto end and
  (pv.dt_pedido_venda <= @dt_base) and
  IsNull(pv.cd_vendedor,0) = ( case when @cd_vendedor = 0 then 
                                 IsNull(pv.cd_vendedor,0) else
                                 @cd_vendedor end )  and
  IsNull(pvi.cd_grupo_categoria,0) = ( case when @cd_grupo_categoria = 0 then
                                        IsNull(pvi.cd_grupo_categoria,0) else 
                                        @cd_grupo_categoria end ) and
  IsNull(pvi.qt_saldo_pedido_venda,0) * pvi.vl_unitario_item_pedido > 0 AND -- Pedido Faturado Total ou Parcial apos o periodo
  isNull(pvi.ic_smo_item_pedido_venda,'N') = 'N' and
  pvi.dt_cancelamento_item is null and
  ( IsNull(pvi.qt_item_pedido_venda,0) * IsNull(pvi.vl_unitario_item_pedido,0)) > 0 and		
  cp.cd_grupo_categoria is not null                 

)

order by 
  nm_grupo_categoria, 
  dt_entrega_vendas_pedido, 
  nm_fantasia_cliente

